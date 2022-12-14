// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

class AccountVerificationInteractor: NSObject, Interactor, AccountVerificationViewActions {
    
    typealias Models = AccountVerificationModels

    var presenter: AccountVerificationPresenter?
    var dataStore: AccountVerificationStore?

    // MARK: - AccountVerificationViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: dataStore?.profile))
    }

    func startVerification(viewAction: AccountVerificationModels.Start.ViewAction) {
        presenter?.presentStartVerification(actionResponse: .init(level: Models.KYCLevel(rawValue: viewAction.level) ?? .one))
    }
    
    func showPersonalInfoPopup(viewAction: AccountVerificationModels.PersonalInfo.ViewAction) {
        presenter?.presentPersonalInfoPopup(actionResponse: .init())
    }
    
    func showPendingStatusError(viewAction: AccountVerificationModels.PendingMessage.ViewAction) {
        presenter?.presentPendingStatusError(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
}
