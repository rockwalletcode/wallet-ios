//
//  DeleteProfileInfoVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let DeleteProfileInfo = DeleteProfileInfoViewController.self
}

protocol DeleteProfileInfoViewActions: BaseViewActions, FetchViewActions {
    func deleteProfile(viewAction: DeleteProfileInfoModels.DeleteProfile.ViewAction)
    func wipeWallet(viewAction: DeleteProfileInfoModels.WipeWalletNoPrompt.ViewAction)
    func toggleTickbox(viewAction: DeleteProfileInfoModels.Tickbox.ViewAction)
}

protocol DeleteProfileInfoActionResponses: BaseActionResponses, FetchActionResponses {
    func presentToggleTickbox(actionResponse: DeleteProfileInfoModels.Tickbox.ActionResponse)
}

protocol DeleteProfileInfoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayToggleTickbox(responseDisplay: DeleteProfileInfoModels.Tickbox.ResponseDisplay)
}

protocol DeleteProfileInfoDataStore: BaseDataStore, FetchDataStore {
    var keyMaster: KeyStore? { get set }
}

protocol DeleteProfileInfoDataPassing {
    var dataStore: DeleteProfileInfoDataStore? { get }
}

protocol DeleteProfileInfoRoutes: CoordinatableRoutes {
}
