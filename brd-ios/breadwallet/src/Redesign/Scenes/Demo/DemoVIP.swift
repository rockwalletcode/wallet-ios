//
//  DemoVIP.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

extension Scenes {
    static let Demo = DemoViewController.self
}

protocol DemoViewActions: BaseViewActions, FetchViewActions {
}

protocol DemoActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol DemoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol DemoDataStore: BaseDataStore, FetchDataStore {
}

protocol DemoDataPassing {
    var dataStore: DemoDataStore? { get }
}

protocol DemoRoutes: CoordinatableRoutes {
}
