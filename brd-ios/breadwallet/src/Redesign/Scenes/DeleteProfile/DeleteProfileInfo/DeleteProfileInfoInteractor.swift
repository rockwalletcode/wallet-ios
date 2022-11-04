//
//  DeleteProfileInfoInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class DeleteProfileInfoInteractor: NSObject, Interactor, DeleteProfileInfoViewActions {
    typealias Models = DeleteProfileInfoModels

    var presenter: DeleteProfileInfoPresenter?
    var dataStore: DeleteProfileInfoStore?

    // MARK: - DeleteProfileInfoViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let item = Models.Item(nil)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func deleteProfile(viewAction: DeleteProfileInfoModels.DeleteProfile.ViewAction) {
        DeleteProfileWorker().execute { [weak self] result in
            switch result {
            case .success:
                UserManager.shared.profile = nil

                UserDefaults.shouldWipeWalletNoPrompt = true
                UserDefaults.email = nil
                UserDefaults.kycSessionKeyValue = nil
                UserDefaults.deviceID = ""

                self?.presenter?.presentDeleteProfile(actionResponse: .init())

            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func wipeWallet(viewAction: DeleteProfileInfoModels.WipeWalletNoPrompt.ViewAction) {
        UserDefaults.shouldWipeWalletNoPrompt = false
        
        Store.trigger(name: .wipeWalletNoPrompt)
    }
    
    func toggleTickbox(viewAction: DeleteProfileInfoModels.Tickbox.ViewAction) {
        presenter?.presentToggleTickbox(actionResponse: .init(value: viewAction.value))
    }
    
    // MARK: - Aditional helpers
}
