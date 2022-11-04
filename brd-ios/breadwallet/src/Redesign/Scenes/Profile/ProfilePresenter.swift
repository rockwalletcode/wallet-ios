//
//  ProfilePresenter.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

final class ProfilePresenter: NSObject, Presenter, ProfileActionResponses {
    
    typealias Models = ProfileModels

    weak var viewController: ProfileViewController?

    // MARK: - ProfileActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let status = item.status,
              let infoView: InfoViewModel = status.viewModel else { return }
        
        let sections: [Models.Section] = [
            .profile,
            .verification,
            .navigation
        ]
        
        var navigationModel = Models.NavigationItems.allCases
        if status != .levelTwo(.levelTwo) {
            navigationModel = navigationModel.filter { $0 != .paymentMethods }
        }
        
        let sectionRows: [Models.Section: [Any]] = [
            .profile: [
                ProfileViewModel(name: item.title ?? "", image: item.image ?? "")
            ],
            .verification: [
                infoView
            ],
            .navigation: navigationModel.compactMap { $0.model }
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentPaymentCards(actionResponse: ProfileModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards))
    }
    
    func presentVerificationInfo(actionResponse: ProfileModels.VerificationInfo.ActionResponse) {
        let model = PopupViewModel(title: .text(L10n.Account.whyVerify),
                                   body: L10n.Account.verifyAccountText)
        
        viewController?.displayVerificationInfo(responseDisplay: .init(model: model))
    }
    
    func presentNavigation(actionResponse: ProfileModels.Navigate.ActionResponse) {
        let item = Models.NavigationItems.allCases[actionResponse.index]
        viewController?.displayNavigation(responseDisplay: .init(item: item))
    }
    
    // MARK: - Additional Helpers
    
}
