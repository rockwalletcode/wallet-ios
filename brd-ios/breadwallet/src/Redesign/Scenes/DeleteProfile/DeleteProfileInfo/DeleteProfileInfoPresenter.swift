//
//  DeleteProfileInfoPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class DeleteProfileInfoPresenter: NSObject, Presenter, DeleteProfileInfoActionResponses {
    typealias Models = DeleteProfileInfoModels

    weak var viewController: DeleteProfileInfoViewController?

    // MARK: - DeleteProfileInfoActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        var checklistTitle: LabelViewModel { return .text(L10n.AccountDelete.deleteWhatMean) }
        var checkmarks: [ChecklistItemViewModel] { return [
            .init(title: .text(L10n.AccountDelete.explanationOne), image: nil),
            .init(title: .text(L10n.AccountDelete.explanationTwo), image: nil),
            .init(title: .text(L10n.AccountDelete.explanationThree), image: nil)
            ]
        }
        
        let sections: [Models.Section] = [
            .title,
            .checkmarks,
            .tickbox
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .title: [
                checklistTitle
            ],
            .checkmarks: checkmarks,
            .tickbox: [
                TickboxItemViewModel(title: .text(L10n.AccountDelete.recoverWallet))
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentDeleteProfile(actionResponse: DeleteProfileInfoModels.DeleteProfile.ActionResponse) {
        let popupViewModel = PopupViewModel(title: .text(""),
                                            imageName: "deleteAlert",
                                            body: L10n.AccountDelete.accountDeletedPopup,
                                            buttons: [.init(title: L10n.Button.finish)],
                                            closeButton: .init(image: "close"))
        
        viewController?.displayDeleteProfile(responseDisplay: .init(popupViewModel: popupViewModel,
                                                                    popupConfig: Presets.Popup.normal))
    }
    
    func presentToggleTickbox(actionResponse: DeleteProfileInfoModels.Tickbox.ActionResponse) {
        viewController?.displayToggleTickbox(responseDisplay: .init(model: .init(title: L10n.Button.continueAction, enabled: actionResponse.value)))
    }
    
    // MARK: - Additional Helpers
}
