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
        guard let currency = dataStore?.toAmount?.currency else {
            return
        }

        ExchangeManager.shared.reload()
        
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.getExchangeRate(viewAction: .init())
                self.presenter?.presentData(actionResponse: .init(item: Models.Item(amount: .zero(currency), paymentCard: self.dataStore?.paymentCard)))
                self.presenter?.presentAssets(actionResponse: .init(amount: self.dataStore?.toAmount,
                                                                    card: self.dataStore?.paymentCard,
                                                                    quote: self.dataStore?.quote))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
        guard dataStore?.supportedCurrencies?.isEmpty != false else { return }
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.dataStore?.supportedCurrencies = currencies
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction) {
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: self.dataStore?.allPaymentCards ?? []))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        guard let rate = dataStore?.quote?.exchangeRate,
              let toCurrency = dataStore?.toAmount?.currency else {
            presenter?.presentError(actionResponse: .init(error: BuyErrors.noQuote(from: C.usdCurrencyCode,
                                                                                   to: dataStore?.toAmount?.currency.code)))
            return
        }
        
        let to: Amount
        let from: Decimal
        
        dataStore?.values = viewAction
        
        if let value = viewAction.tokenValue,
           let crypto = ExchangeFormatter.current.number(from: value)?.decimalValue {
            to = .init(decimalAmount: crypto, isFiat: false, currency: toCurrency, exchangeRate: 1 / rate)
            from = crypto / rate
        } else if let value = viewAction.fiatValue,
                  let fiat = ExchangeFormatter.current.number(from: value)?.decimalValue {
            from = fiat
            to = .init(decimalAmount: fiat, isFiat: true, currency: toCurrency, exchangeRate: 1 / rate)
        } else {
            presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                           card: dataStore?.paymentCard,
                                                           quote: dataStore?.quote,
                                                           handleErrors: true))
            return
        }
        
        dataStore?.toAmount = to
        dataStore?.from = from
        
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.paymentCard,
                                                       quote: dataStore?.quote))
    }
    
    func getExchangeRate(viewAction: Models.Rate.ViewAction) {
        guard let toCurrency = dataStore?.toAmount?.currency.code else { return }
        
        let data = QuoteRequestData(from: C.usdCurrencyCode.lowercased(), to: toCurrency)
        QuoteWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.dataStore?.quote = quote
                
                self?.presenter?.presentExchangeRate(actionResponse: .init(quote: quote,
                                                                           from: C.usdCurrencyCode,
                                                                           to: toCurrency))
                
                let model = self?.dataStore?.values ?? .init()
                self?.setAmount(viewAction: model)
                
            case .failure(let error):
                guard let error = error as? NetworkingError,
                      error == .accessDenied else {
                    self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.quoteFail))
                    return
                }
                
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAssets(viewAction: BuyModels.Assets.ViewAction) {
        if let value = viewAction.currency?.lowercased(),
           let currency = Store.state.currencies.first(where: { $0.code.lowercased() == value }) {
            dataStore?.toAmount = .zero(currency)
        } else if let value = viewAction.card {
            dataStore?.paymentCard = value
        }
        
        getExchangeRate(viewAction: .init())
    }
    
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction) {
        presenter?.presentOrderPreview(actionResponse: .init())
    }
    
    func navigateAssetSelector(viewAction: BuyModels.AssetSelector.ViewAction) {
        presenter?.presentNavigateAssetSelector(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func fetchCards(completion: ((Result<[PaymentCard]?, Error>) -> Void)?) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.allPaymentCards = data
                
                if self?.dataStore?.autoSelectDefaultPaymentMethod == true {
                    self?.dataStore?.paymentCard = self?.dataStore?.allPaymentCards?.first
                }
                
                self?.dataStore?.autoSelectDefaultPaymentMethod = true
                
            default:
                break
            }
            
            completion?(result)
        }
    }
}
