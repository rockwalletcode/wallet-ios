//
//  DocumentReviewInteractor.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//
//

import UIKit

class DocumentReviewInteractor: NSObject, Interactor, DocumentReviewViewActions {
    typealias Models = DocumentReviewModels

    var presenter: DocumentReviewPresenter?
    var dataStore: DocumentReviewStore?

    // MARK: - DocumentReviewViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: Models.Item(type: dataStore?.type,
                                                                       image: dataStore?.image,
                                                                       checklist: dataStore?.checklist)))
    }

    // MARK: - Aditional helpers
}
