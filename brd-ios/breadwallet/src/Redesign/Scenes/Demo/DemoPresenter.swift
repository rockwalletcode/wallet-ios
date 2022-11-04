//
//  DemoPresenter.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

final class DemoPresenter: NSObject, Presenter, DemoActionResponses {
    typealias Models = DemoModels

    weak var viewController: DemoViewController?

    // MARK: - DemoActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {}

    // MARK: - Additional Helpers

}
