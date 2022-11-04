//
//  DocumentReviewPresenter.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//
//

import UIKit

final class DocumentReviewPresenter: NSObject, Presenter, DocumentReviewActionResponses {
    typealias Models = DocumentReviewModels
    
    weak var viewController: DocumentReviewViewController?
    
    // MARK: - DocumentReviewActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
        let image = item.image else { return }
        
        let sections: [Models.Sections] =  [
            .title,
            .checkmarks,
            .image,
            .buttons
        ]
        
        // HMM
        let sectionRows: [Models.Sections: [Any]] = [
            .title: [LabelViewModel.text(L10n.Account.beforeConfirm)],
            .checkmarks: item.checklist ?? [],
            .image: [ImageViewModel.photo(image)],
            .buttons: [
                ScrollableButtonsViewModel(buttons: [
                    .init(title: L10n.Account.retakePhoto.uppercased()),
                    .init(title: L10n.Button.confirm.uppercased())
                ])
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    // MARK: - Additional Helpers
    
}
