//
// Created by Equaleyes Solutions Ltd
//

import UIKit

final class ResetPinPresenter: NSObject, Presenter, ResetPinActionResponses {
    typealias Models = ResetPinModels

    weak var viewController: ResetPinViewController?
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        
        let sections: [Models.Section] = [
            .title,
            .image,
            .button
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .image: [ImageViewModel.imageName("unlock-wallet")],
            .title: [LabelViewModel.text(L10n.UpdatePin.resetPinSuccess)],
            .button: [ButtonViewModel(title: L10n.Button.goToDashboard, enabled: true)]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - ResetPinActionResponses

    // MARK: - Additional Helpers

}
