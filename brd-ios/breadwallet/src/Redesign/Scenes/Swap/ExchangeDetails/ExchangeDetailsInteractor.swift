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
        let data = ExchangeDetailsRequestData(exchangeId: dataStore?.itemId)
        
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
    
    func copyValue(viewAction: ExchangeDetailsModels.CopyValue.ViewAction) {
        let value = viewAction.value?.filter { !$0.isWhitespace } ?? ""
        UIPasteboard.general.string = value
        
        presenter?.presentCopyValue(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
}
