//
//  DocumentReviewVIP.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//
//

import UIKit

enum DocumentImageType {
    case front
    case back
    case selfie
}

extension Scenes {
    static let DocumentReview = DocumentReviewViewController.self
}

protocol DocumentReviewViewActions: BaseViewActions, FetchViewActions {
}

protocol DocumentReviewActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol DocumentReviewResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol DocumentReviewDataStore: BaseDataStore, FetchDataStore {
    var image: UIImage? { get set }
    var type: DocumentImageType { get set }
}

protocol DocumentReviewDataPassing {
    var dataStore: DocumentReviewDataStore? { get }
}

protocol DocumentReviewRoutes: CoordinatableRoutes {
}
