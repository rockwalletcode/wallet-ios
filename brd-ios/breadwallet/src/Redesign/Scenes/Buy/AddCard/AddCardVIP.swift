//
//  AddCardVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let AddCard = AddCardViewController.self
}

protocol AddCardViewActions: BaseViewActions, FetchViewActions {
    func cardInfoSet(viewAction: AddCardModels.CardInfo.ViewAction)
    func showCvvInfoPopup(viewAction: AddCardModels.CvvInfoPopup.ViewAction)
}

protocol AddCardActionResponses: BaseActionResponses, FetchActionResponses {
    func presentCardInfo(actionResponse: AddCardModels.CardInfo.ActionResponse)
    func presentValidate(actionResponse: AddCardModels.Validate.ActionResponse)
    func presentSubmit(actionResponse: AddCardModels.Submit.ActionResponse)
    func presentCvvInfoPopup(actionResponse: AddCardModels.CvvInfoPopup.ActionResponse)
}

protocol AddCardResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayCardInfo(responseDisplay: AddCardModels.CardInfo.ResponseDisplay)
    func displayValidate(responseDisplay: AddCardModels.Validate.ResponseDisplay)
    func displaySubmit(responseDisplay: AddCardModels.Submit.ResponseDisplay)
    func displayCvvInfoPopup(responseDisplay: AddCardModels.CvvInfoPopup.ResponseDisplay)
}

protocol AddCardDataStore: BaseDataStore, FetchDataStore {
    var cardNumber: String? { get set }
    var cardExpDateString: String? { get set }
    var cardExpDateMonth: String? { get set }
    var cardExpDateYear: String? { get set }
    var cardCVV: String? { get set }
    var months: [String] { get set }
    var years: [String] { get set }
}

protocol AddCardDataPassing {
    var dataStore: AddCardDataStore? { get }
}

protocol AddCardRoutes: CoordinatableRoutes {
}
