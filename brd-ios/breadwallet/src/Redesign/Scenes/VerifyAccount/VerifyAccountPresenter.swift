//
// Created by Equaleyes Solutions Ltd
//

import UIKit

final class VerifyAccountPresenter: NSObject, Presenter, VerifyAccountActionResponses {
    
    typealias Models = VerifyAccountModels

    weak var viewController: VerifyAccountViewController?
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let coverImageName = item.coverImageName,
              let subtitleMessage = item.subtitleMessage else { return }
        
        let sections: [Models.Section] = [
            .image,
            .title,
            .description
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .image: [ImageViewModel.imageName(coverImageName)],
            .title: [LabelViewModel.text(L10n.Account.messageVerifyAccount)],
            .description: [LabelViewModel.text(subtitleMessage)]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - VerifyAccountActionResponses

    // MARK: - Additional Helpers

}
