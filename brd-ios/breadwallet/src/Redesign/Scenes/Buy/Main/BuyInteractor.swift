//
//  BuyInteractor.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

class BuyInteractor: NSObject, Interactor, BuyViewActions {

    typealias Models = BuyModels
    
    var presenter: BuyPresenter?
    var dataStore: BuyStore?
    
    // MARK: - BuyViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let currency = dataStore?.toAmount?.currency,
              dataStore?.paymentMethod != nil,
              dataStore?.supportedCurrencies?.isEmpty != false
        else { return }
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                ExchangeManager.shared.reload()

                self?.dataStore?.supportedCurrencies = currencies
                self?.presenter?.presentData(actionResponse: .init(item: Models.Item(amount: .zero(currency),
                                                                                     paymentCard: self?.dataStore?.selected,
                                                                                     type: self?.dataStore?.paymentMethod,
                                                                                     achEnabled: UserManager.shared.profile?.canUseAch)))
                self?.presenter?.presentAssets(actionResponse: .init(amount: self?.dataStore?.toAmount,
                                                                     card: self?.dataStore?.selected,
                                                                     type: self?.dataStore?.paymentMethod,
                                                                     quote: self?.dataStore?.quote))
                self?.getAch(viewAction: .init())
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.supportedCurrencies(error: error)))
            }
        }
    }
    
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction) {
        presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: dataStore?.cards ?? []))
    }
    
    func didGetAch(viewAction: AchPaymentModels.Get.ViewAction) {
        dataStore?.selected = dataStore?.paymentMethod == .buyAch ? dataStore?.ach : dataStore?.cards.first
        setAssets(viewAction: .init(card: dataStore?.selected))
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        guard let rate = dataStore?.quote?.exchangeRate,
              let toCurrency = dataStore?.toAmount?.currency else {
            presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noQuote(from: C.usdCurrencyCode,
                                                                                   to: dataStore?.toAmount?.currency.code)))
            return
        }
        
        let to: Amount
        
        dataStore?.values = viewAction
        
        if let value = viewAction.tokenValue,
           let crypto = ExchangeFormatter.current.number(from: value)?.decimalValue {
            to = .init(decimalAmount: crypto, isFiat: false, currency: toCurrency, exchangeRate: 1 / rate)
        } else if let value = viewAction.fiatValue,
                  let fiat = ExchangeFormatter.current.number(from: value)?.decimalValue {
            to = .init(decimalAmount: fiat, isFiat: true, currency: toCurrency, exchangeRate: 1 / rate)
        } else {
            presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                           card: dataStore?.selected,
                                                           type: dataStore?.paymentMethod,
                                                           quote: dataStore?.quote,
                                                           handleErrors: true))
            return
        }
        
        dataStore?.toAmount = to
        dataStore?.from = to.fiatValue
        
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.selected,
                                                       type: dataStore?.paymentMethod,
                                                       quote: dataStore?.quote))
    }
    
    func setAssets(viewAction: BuyModels.Assets.ViewAction) {
        if let value = viewAction.currency?.lowercased(),
           let currency = Store.state.currencies.first(where: { $0.code.lowercased() == value }) {
            dataStore?.toAmount = .zero(currency)
        } else if let value = viewAction.card {
            dataStore?.selected = value
        }
        
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.selected,
                                                       type: dataStore?.paymentMethod,
                                                       quote: dataStore?.quote))
        getExchangeRate(viewAction: .init())
            
    }
    
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction) {
        dataStore?.availablePayments = []
        let containsDebitCard = dataStore?.cards.first(where: { $0.cardType == .debit }) != nil
        
        if dataStore?.selected?.cardType == .credit,
            containsDebitCard {
            dataStore?.availablePayments.append(.buyCard)
        }
        if dataStore?.selected?.cardType == .debit,
           dataStore?.paymentMethod == .buyCard,
           dataStore?.ach != nil,
           dataStore?.toAmount?.currency.code == C.USDC {
            dataStore?.availablePayments.append(.buyAch)
        }
        
        presenter?.presentOrderPreview(actionResponse: .init(availablePayments: dataStore?.availablePayments))
    }
    
    func navigateAssetSelector(viewAction: BuyModels.AssetSelector.ViewAction) {
        presenter?.presentNavigateAssetSelector(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    func selectPaymentMethod(viewAction: BuyModels.PaymentMethod.ViewAction) {
        dataStore?.paymentMethod = viewAction.method
        switch viewAction.method {
        case .buyAch:
            guard let currency = Store.state.currencies.first(where: { $0.code == C.USDC }) else {
                presenter?.presentUSDCMessage(actionResponse: .init())
                return
            }
            dataStore?.toAmount = .zero(currency)
            dataStore?.selected = dataStore?.ach
            
        case .buyCard:
            if dataStore?.autoSelectDefaultPaymentMethod == true {
                dataStore?.selected = dataStore?.cards.first
            }
        }
        
        getExchangeRate(viewAction: .init())
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.selected,
                                                       type: dataStore?.paymentMethod,
                                                       quote: dataStore?.quote))
    }
    
    func retryPaymentMethod(viewAction: BuyModels.RetryPaymentMethod.ViewAction) {
        dataStore?.paymentMethod = viewAction.method
        
        switch viewAction.method {
        case .buyAch:
            dataStore?.selected = dataStore?.ach
            
            presenter?.presentMessage(actionResponse: .init(method: viewAction.method))
            
        case .buyCard:
            if dataStore?.autoSelectDefaultPaymentMethod == true {
                if dataStore?.availablePayments.contains(.buyCard) == true {
                    dataStore?.selected = dataStore?.cards.first(where: { $0.cardType == .debit })
                } else {
                    dataStore?.selected = dataStore?.cards.first
                }
            }
            presenter?.presentMessage(actionResponse: .init(method: viewAction.method))
        }
        
        getExchangeRate(viewAction: .init())
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.selected,
                                                       type: dataStore?.paymentMethod,
                                                       quote: dataStore?.quote))
    }
}
