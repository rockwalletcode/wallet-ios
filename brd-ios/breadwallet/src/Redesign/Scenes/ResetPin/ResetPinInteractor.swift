// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

class ResetPinInteractor: NSObject, Interactor, ResetPinViewActions {
    typealias Models = ResetPinModels

    var presenter: ResetPinPresenter?
    var dataStore: ResetPinStore?
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: nil))
    }

    // MARK: - ResetPinViewActions

    // MARK: - Aditional helpers
}
