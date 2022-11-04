//
//  OrderPreviewInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewInteractor: NSObject, Interactor, OrderPreviewViewActions {
    typealias Models = OrderPreviewModels

    var presenter: OrderPreviewPresenter?
    var dataStore: OrderPreviewStore?
    
    // MARK: - OrderPreviewViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let reference = dataStore?.paymentReference else {
            let item: Models.Item = (to: dataStore?.to, from: dataStore?.from, quote: dataStore?.quote, networkFee: dataStore?.networkFee, card: dataStore?.card)
            presenter?.presentData(actionResponse: .init(item: item))
            return
        }
        
        let requestData = PaymentStatusRequestData(reference: reference)
        PaymentStatusWorker().execute(requestData: requestData) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.paymentstatus = data?.status
                guard data?.status.isSuccesful == true else {
                    self?.presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.Buy.paymentFailed)))
                    return
                }
                self?.presenter?.presentSubmit(actionResponse: .init(paymentReference: self?.dataStore?.paymentReference ?? ""))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func showInfoPopup(viewAction: OrderPreviewModels.InfoPopup.ViewAction) {
        presenter?.presentInfoPopup(actionResponse: .init(isCardFee: viewAction.isCardFee, fee: dataStore?.quote?.buyFee))
    }
    
    func showCvvInfoPopup(viewAction: OrderPreviewModels.CvvInfoPopup.ViewAction) {
        presenter?.presentCvvInfoPopup(actionResponse: .init())
    }
    
    func submit(viewAction: OrderPreviewModels.Submit.ViewAction) {
        guard let currency = dataStore?.to?.currency,
              let address = currency.wallet?.defaultReceiveAddress,
              let to = dataStore?.to?.tokenValue,
              let from = dataStore?.from
        else { return }
        
        let cryptoFormatter = ExchangeFormatter.crypto
        cryptoFormatter.locale = Locale(identifier: C.usLocaleCode)
        cryptoFormatter.usesGroupingSeparator = false
        
        let toTokenValue = cryptoFormatter.string(for: to) ?? ""
        
        let fiatFormatter = ExchangeFormatter.fiat
        fiatFormatter.locale = Locale(identifier: C.usLocaleCode)
        fiatFormatter.usesGroupingSeparator = false
        
        let depositQuantity = from + (dataStore?.networkFee?.fiatValue ?? 0) + from * (dataStore?.quote?.buyFee ?? 1) / 100
        let formattedDepositQuantity = fiatFormatter.string(from: depositQuantity as NSNumber) ?? ""
        
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   depositQuantity: formattedDepositQuantity,
                                   withdrawalQuantity: toTokenValue,
                                   destination: address,
                                   sourceInstrumentId: dataStore?.card?.id,
                                   nologCvv: dataStore?.cvv?.description)
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let exchangeData):
                self?.dataStore?.paymentReference = exchangeData?.paymentReference
                guard let redirectUrlString = exchangeData?.redirectUrl, let
                        redirectUrl = URL(string: redirectUrlString) else {
                    self?.getData(viewAction: .init())
                    return
                }
                
                ExchangeManager.shared.reload()
                self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func checkTimeOut(viewAction: OrderPreviewModels.ExpirationValidations.ViewAction) {
        let isTimedOut = Date().timeIntervalSince1970 > (dataStore?.quote?.timestamp ?? 0) / 1000
        
        presenter?.presentTimeOut(actionResponse: .init(isTimedOut: isTimedOut))
    }
    
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction) {
        dataStore?.cvv = viewAction.cvv
        let isValid = FieldValidator.validate(cvv: dataStore?.cvv)
        
        presenter?.presentCvv(actionResponse: .init(isValid: isValid))
    }
    
    func showTermsAndConditions(viewAction: OrderPreviewModels.TermsAndConditions.ViewAction) {
        guard let url = URL(string: C.termsAndConditions) else { return }
        presenter?.presentTermsAndConditions(actionResponse: .init(url: url))
    }
    
    // TODO: add rate refreshing logic!
    // MARK: - Aditional helpers
}
