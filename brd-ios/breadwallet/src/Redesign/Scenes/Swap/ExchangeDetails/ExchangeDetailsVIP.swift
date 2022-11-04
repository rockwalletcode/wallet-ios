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
}

protocol ExchangeDetailsActionResponses: BaseActionResponses, FetchActionResponses {
    func presentCopyValue(actionResponse: ExchangeDetailsModels.CopyValue.ActionResponse)
}

protocol ExchangeDetailsResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol ExchangeDetailsDataStore: BaseDataStore, FetchDataStore {
    var transactionType: Transaction.TransactionType { get set }
}

protocol ExchangeDetailsDataPassing {
    var dataStore: ExchangeDetailsDataStore? { get }
}

protocol ExchangeDetailsRoutes: CoordinatableRoutes {
}
