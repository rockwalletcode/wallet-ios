//
//  ExchangeDetailsInteractor.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class ExchangeDetailsInteractor: NSObject, Interactor, ExchangeDetailsViewActions {
    typealias Models = ExchangeDetailsModels

    var presenter: ExchangeDetailsPresenter?
    var dataStore: ExchangeDetailsStore?
    
    // MARK: - ExchangeDetailsViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let itemId = dataStore?.itemId,
              !itemId.isEmpty else {
            mockData()
            return
        }
        
        let data = ExchangeDetailsRequestData(exchangeId: itemId)
        ExchangeDetailsWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data, let transactionType = self?.dataStore?.transactionType else { return }
                let item = ExchangeDetailsModels.Item(detail: data, type: transactionType)
                self?.presenter?.presentData(actionResponse: .init(item: item))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    private func mockData() {
        let card = PaymentCard(type: .ach,
                               id: "121",
                               fingerprint: "222",
                               expiryMonth: 5,
                               expiryYear: 2026,
                               scheme: .none,
                               last4: "121",
                               image: nil,
                               accountName: "roks account",
                               status: .statusOk,
                               cardType: .credit)
        
        let source = SwapDetail.SourceDestination(currency: "USD", currencyAmount: 120, usdAmount: 120, usdFee: 5, paymentInstrument: card)
        let destination = SwapDetail.SourceDestination(currency: "USDC", currencyAmount: 118, usdAmount: 120, usdFee: 5, paymentInstrument: card)
        
        let details = SwapDetail(orderId: 121,
                                 status: .pending,
                                 statusDetails: "SMTH",
                                 source: source,
                                 destination: destination,
                                 rate: 0.99,
                                 timestamp: Int(Date().timeIntervalSince1970),
                                 type: .sellTransaction)
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(detail: details, type: .sellTransaction)))
    }
    
    func copyValue(viewAction: ExchangeDetailsModels.CopyValue.ViewAction) {
        let value = viewAction.value?.filter { !$0.isWhitespace } ?? ""
        UIPasteboard.general.string = value
        
        presenter?.presentCopyValue(actionResponse: .init())
    }
    
    func showInfoPopup(viewAction: ExchangeDetailsModels.InfoPopup.ViewAction) {
        presenter?.presentInfoPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
}
