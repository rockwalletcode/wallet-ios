//
//  CheckListVIP.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//
//

import UIKit

extension Scenes {
    static let CheckList = CheckListViewController.self
}

protocol CheckListViewActions: BaseViewActions {
}

protocol CheckListActionResponses: BaseActionResponses {
}

protocol CheckListResponseDisplays: AnyObject, BaseResponseDisplays {
}

protocol CheckListDataStore: BaseDataStore {
}

protocol CheckListDataPassing {
    var dataStore: CheckListDataStore? { get }
}

protocol CheckListRoutes: CoordinatableRoutes {
}
