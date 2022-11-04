//
//  BaseInfoPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

final class BaseInfoPresenter: NSObject, Presenter, BaseInfoActionResponses {
    
    typealias Models = BaseInfoModels

    weak var viewController: BaseInfoViewController?
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Section] = [
            .image,
            .title,
            .description
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: [:]))   
    }

    // MARK: - BaseInfoActionResponses

    // MARK: - Additional Helpers

}
