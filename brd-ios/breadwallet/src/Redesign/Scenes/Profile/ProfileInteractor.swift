//
//  ProfileInteractor.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

class ProfileInteractor: NSObject, Interactor, ProfileViewActions {
    
    typealias Models = ProfileModels

    var presenter: ProfilePresenter?
    var dataStore: ProfileStore?

    // MARK: - ProfileViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        UserManager.shared.refresh { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.profile = data
                self?.presenter?.presentData(actionResponse: .init(item: Models.Item(title: data?.email,
                                                                                     image: "avatar",
                                                                                     status: data?.status)))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
                
            default:
                return
            }
        }
    }
    
    func getPaymentCards(viewAction: ProfileModels.PaymentCards.ViewAction) {
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
    
    func showVerificationInfo(viewAction: ProfileModels.VerificationInfo.ViewAction) {
        presenter?.presentVerificationInfo(actionResponse: .init())
    }
    
    func navigate(viewAction: ProfileModels.Navigate.ViewAction) {
        presenter?.presentNavigation(actionResponse: .init(index: viewAction.index))
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
