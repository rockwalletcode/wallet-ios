// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

extension Scenes {
    static let AccountVerification = AccountVerificationViewController.self
}

protocol AccountVerificationViewActions: BaseViewActions, FetchViewActions {
    func startVerification(viewAction: AccountVerificationModels.Start.ViewAction)
    func showPersonalInfoPopup(viewAction: AccountVerificationModels.PersonalInfo.ViewAction)
    func showPendingStatusError(viewAction: AccountVerificationModels.PendingMessage.ViewAction)
}

protocol AccountVerificationActionResponses: BaseActionResponses, FetchActionResponses {
    func presentStartVerification(actionResponse: AccountVerificationModels.Start.ActionResponse)
    func presentPersonalInfoPopup(actionResponse: AccountVerificationModels.PersonalInfo.ActionResponse)
    func presentPendingStatusError(actionResponse: AccountVerificationModels.PendingMessage.ActionResponse)
}

protocol AccountVerificationResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayStartVerification(responseDisplay: AccountVerificationModels.Start.ResponseDisplay)
    func displayPersonalInfoPopup(responseDisplay: AccountVerificationModels.PersonalInfo.ResponseDisplay)
    func displayPendingStatusError(responseDisplay: AccountVerificationModels.PendingMessage.ResponseDisplay)
}

protocol AccountVerificationDataStore: BaseDataStore, FetchDataStore {

}

protocol AccountVerificationDataPassing {
    var dataStore: AccountVerificationDataStore? { get }
}

protocol AccountVerificationRoutes: CoordinatableRoutes {
}
