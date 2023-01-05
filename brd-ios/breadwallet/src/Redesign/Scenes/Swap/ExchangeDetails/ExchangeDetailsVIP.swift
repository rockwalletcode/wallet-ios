//
//  ExchangeDetailsVIP.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

extension Scenes {
    static let ExchangeDetails = ExchangeDetailsViewController.self
}

protocol ExchangeDetailsViewActions: BaseViewActions, FetchViewActions {
    func copyValue(viewAction: ExchangeDetailsModels.CopyValue.ViewAction)
    func showInfoPopup(viewAction: ExchangeDetailsModels.InfoPopup.ViewAction)
}

protocol ExchangeDetailsActionResponses: BaseActionResponses, FetchActionResponses {
    func presentCopyValue(actionResponse: ExchangeDetailsModels.CopyValue.ActionResponse)
    func presentInfoPopup(actionResponse: ExchangeDetailsModels.InfoPopup.ActionResponse)
}

protocol ExchangeDetailsResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayInfoPopup(responseDisplay: ExchangeDetailsModels.InfoPopup.ResponseDisplay)
}

protocol ExchangeDetailsDataStore: BaseDataStore, FetchDataStore {
    var transactionType: TransactionType { get set }
}

protocol ExchangeDetailsDataPassing {
    var dataStore: ExchangeDetailsDataStore? { get }
}

protocol ExchangeDetailsRoutes: CoordinatableRoutes {
}
