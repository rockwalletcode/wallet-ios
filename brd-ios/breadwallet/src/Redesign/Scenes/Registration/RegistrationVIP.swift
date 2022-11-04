//
//  RegistrationVIP.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

extension Scenes {
    static let Registration = RegistrationViewController.self
}

protocol RegistrationViewActions: BaseViewActions, FetchViewActions {
    func validate(viewAction: RegistrationModels.Validate.ViewAction)
    func toggleTickbox(viewAction: RegistrationModels.Tickbox.ViewAction)
    func next(viewAction: RegistrationModels.Next.ViewAction)
}

protocol RegistrationActionResponses: BaseActionResponses, FetchActionResponses {
    func presentValidate(actionResponse: RegistrationModels.Validate.ActionResponse)
    func presentNext(actionResponse: RegistrationModels.Next.ActionResponse)
}

protocol RegistrationResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayValidate(responseDisplay: RegistrationModels.Validate.ResponseDisplay)
    func displayNext(responseDisplay: RegistrationModels.Next.ResponseDisplay)
}

protocol RegistrationDataStore: BaseDataStore, FetchDataStore {
    var email: String? { get set }
    var type: RegistrationModels.ViewType { get set }
    var subscribe: Bool? { get set }
    var shouldShowProfile: Bool { get set }
}

protocol RegistrationDataPassing {
    var dataStore: RegistrationDataStore? { get }
}

protocol RegistrationRoutes: CoordinatableRoutes {
    func showRegistrationConfirmation(shouldShowProfile: Bool)
    func showChangeEmail()
}
