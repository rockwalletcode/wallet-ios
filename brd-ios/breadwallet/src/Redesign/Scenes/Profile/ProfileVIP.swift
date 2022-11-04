//
//  ProfileVIP.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

extension Scenes {
    static let Profile = ProfileViewController.self
}

protocol ProfileViewActions: BaseViewActions, FetchViewActions {
    func showVerificationInfo(viewAction: ProfileModels.VerificationInfo.ViewAction)
    func navigate(viewAction: ProfileModels.Navigate.ViewAction)
    func getPaymentCards(viewAction: ProfileModels.PaymentCards.ViewAction)
}

protocol ProfileActionResponses: BaseActionResponses, FetchActionResponses {
    func presentVerificationInfo(actionResponse: ProfileModels.VerificationInfo.ActionResponse)
    func presentNavigation(actionResponse: ProfileModels.Navigate.ActionResponse)
    func presentPaymentCards(actionResponse: ProfileModels.PaymentCards.ActionResponse)
}

protocol ProfileResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayVerificationInfo(responseDisplay: ProfileModels.VerificationInfo.ResponseDisplay)
    func displayNavigation(responseDisplay: ProfileModels.Navigate.ResponseDisplay)
    func displayPaymentCards(responseDisplay: ProfileModels.PaymentCards.ResponseDisplay)
}

protocol ProfileDataStore: BaseDataStore, FetchDataStore {
    var profile: Profile? { get set }
    var allPaymentCards: [PaymentCard]? { get set }
    var paymentCard: PaymentCard? { get set }
    var autoSelectDefaultPaymentMethod: Bool { get set }
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

protocol ProfileRoutes: CoordinatableRoutes {
    func showAvatarSelection()
    func showSecuirtySettings()
    func showPreferences()
    func showExport()
    func showVerificationScreen(for profile: Profile?)
}
