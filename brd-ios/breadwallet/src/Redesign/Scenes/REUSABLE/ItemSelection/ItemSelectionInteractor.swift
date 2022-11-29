//
//  ItemSelectionInteractor.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionInteractor: NSObject, Interactor, ItemSelectionViewActions {
    typealias Models = ItemSelectionModels

    var presenter: ItemSelectionPresenter?
    var dataStore: ItemSelectionStore?

    // MARK: - ItemSelectionViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let items = dataStore?.items,
              items.isEmpty == false,
              let isAddingEnabled = dataStore?.isAddingEnabled else { return }
        
        let item = Models.Item(items: items, isAddingEnabled: isAddingEnabled)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func search(viewAction: ItemSelectionModels.Search.ViewAction) {
        guard let items = dataStore?.items,
              let searchText = viewAction.text?.lowercased() else { return }
        
        let searchData = searchText.isEmpty ? items : items.filter { $0.displayName?.lowercased().contains(searchText) ?? false }
        let item = Models.Item(items: searchData, isAddingEnabled: dataStore?.isAddingEnabled)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction) {
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                guard let items = self.dataStore?.items,
                      let isAddingEnabled = self.dataStore?.isAddingEnabled else { return }
                
                let item = Models.Item(items: items, isAddingEnabled: isAddingEnabled)
                self.presenter?.presentData(actionResponse: .init(item: item))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func showActionSheetRemovePayment(viewAction: ItemSelectionModels.ActionSheet.ViewAction) {
        presenter?.presentActionSheetRemovePayment(actionResponse: .init(instrumentId: viewAction.instrumentId, last4: viewAction.last4))
    }
    
    func removePayment(viewAction: ItemSelectionModels.RemovePayment.ViewAction) {
        DeleteCardWorker().execute(requestData: DeleteCardRequestData(instrumentId: self.dataStore?.instrumentID)) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentRemovePaymentMessage(actionResponse: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func removePaymenetPopup(viewAction: ItemSelectionModels.RemovePaymenetPopup.ViewAction) {
        dataStore?.instrumentID = viewAction.instrumentID
        presenter?.presentRemovePaymentPopup(actionResponse: .init(last4: viewAction.last4))
    }
    
    // MARK: - Aditional helpers
    
    private func fetchCards(completion: ((Result<[PaymentCard]?, Error>) -> Void)?) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.items = data?.filter { $0.type == .buyCard }
                
            default:
                break
            }
            
            completion?(result)
        }
    }
}
