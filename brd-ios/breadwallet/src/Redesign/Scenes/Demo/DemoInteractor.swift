//
//  DemoInteractor.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

class DemoInteractor: NSObject, Interactor, DemoViewActions {
    typealias Models = DemoModels

    var presenter: DemoPresenter?
    var dataStore: DemoStore?

    // MARK: - DemoViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {}

    // MARK: - Aditional helpers
}
