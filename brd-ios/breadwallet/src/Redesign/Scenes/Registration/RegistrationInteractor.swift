//
//  RegistrationInteractor.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationInteractor: NSObject, Interactor, RegistrationViewActions {
    typealias Models = RegistrationModels
    
    var presenter: RegistrationPresenter?
    var dataStore: RegistrationStore?
    
    // MARK: - RegistrationViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let item = Models.Item(dataStore?.email, dataStore?.type, dataStore?.type == .registration)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func validate(viewAction: RegistrationModels.Validate.ViewAction) {
        dataStore?.email = viewAction.item
        presenter?.presentValidate(actionResponse: .init(isValid: dataStore?.isValid))
    }
    
    func toggleTickbox(viewAction: RegistrationModels.Tickbox.ViewAction) {
        dataStore?.subscribe = viewAction.value
    }
    
    func next(viewAction: RegistrationModels.Next.ViewAction) {
        guard let email = dataStore?.email, let token = UserDefaults.walletTokenValue else { return }
        
        dataStore?.submitting = true
        presenter?.presentValidate(actionResponse: .init(isValid: dataStore?.isValid))
        
        let data = RegistrationRequestData(email: email,
                                           token: token,
                                           subscribe: dataStore?.subscribe)
        RegistrationWorker().execute(requestData: data) { [weak self] result in
            self?.dataStore?.submitting = false
            switch result {
            case .success(let data):
                guard let sessionKey = data?.sessionKey else { return }
                
                UserDefaults.email = email
                UserDefaults.kycSessionKeyValue = sessionKey
                
                UserManager.shared.refresh { _ in
                    self?.presenter?.presentNext(actionResponse: .init(email: email))
                }
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
                self?.presenter?.presentValidate(actionResponse: .init(isValid: self?.dataStore?.isValid))
            }
        }
    }
    
    // MARK: - Aditional helpers
}
