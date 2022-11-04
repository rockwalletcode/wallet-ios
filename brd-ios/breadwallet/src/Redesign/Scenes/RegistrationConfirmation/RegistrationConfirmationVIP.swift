//
//  RegistrationConfirmationVIP.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

extension Scenes {
    static let RegistrationConfirmation = RegistrationConfirmationViewController.self
}

protocol RegistrationConfirmationViewActions: BaseViewActions, FetchViewActions {
    func validate(viewAction: RegistrationConfirmationModels.Validate.ViewAction)
    func confirm(viewAction: RegistrationConfirmationModels.Confirm.ViewAction)
    func resend(viewAction: RegistrationConfirmationModels.Resend.ViewAction)
}

protocol RegistrationConfirmationActionResponses: BaseActionResponses, FetchActionResponses {
    func presentValidate(actionResponse: RegistrationConfirmationModels.Validate.ActionResponse)
    func presentConfirm(actionResponse: RegistrationConfirmationModels.Confirm.ActionResponse)
    func presentResend(actionResponse: RegistrationConfirmationModels.Resend.ActionResponse)
    func presentError(actionResponse: RegistrationConfirmationModels.Error.ActionResponse)
}

protocol RegistrationConfirmationResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayValidate(responseDisplay: RegistrationConfirmationModels.Validate.ResponseDisplay)
    func displayConfirm(responseDisplay: RegistrationConfirmationModels.Confirm.ResponseDisplay)
    func displayError(responseDisplay: RegistrationConfirmationModels.Error.ResponseDisplay)
}

protocol RegistrationConfirmationDataStore: BaseDataStore, FetchDataStore {
    var callAssociate: Bool { get set }
    var shouldShowProfile: Bool { get set }
}

protocol RegistrationConfirmationDataPassing {
    var dataStore: RegistrationConfirmationDataStore? { get }
}

protocol RegistrationConfirmationRoutes: CoordinatableRoutes {
}
