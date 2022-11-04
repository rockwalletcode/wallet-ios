//
//  BaseInfoVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

extension Scenes {
    static let BaseInfo = BaseInfoViewController.self
}

protocol BaseInfoViewActions: BaseViewActions, FetchViewActions {
}

protocol BaseInfoActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol BaseInfoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol BaseInfoDataStore: BaseDataStore, FetchDataStore {
    var item: Any? { get set }
}

protocol BaseInfoDataPassing {
    var dataStore: BaseInfoDataStore? { get }
}

protocol BaseInfoRoutes: CoordinatableRoutes {
}
