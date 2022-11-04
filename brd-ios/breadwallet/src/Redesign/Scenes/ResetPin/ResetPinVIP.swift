//
// Created by Equaleyes Solutions Ltd
//

import UIKit

extension Scenes {
    static let ResetPin = ResetPinViewController.self
}

protocol ResetPinViewActions: BaseViewActions, FetchViewActions {
}

protocol ResetPinActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol ResetPinResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol ResetPinDataStore: BaseDataStore, FetchDataStore {
}

protocol ResetPinDataPassing {
    var dataStore: ResetPinDataStore? { get }
}

protocol ResetPinRoutes: CoordinatableRoutes {
}
