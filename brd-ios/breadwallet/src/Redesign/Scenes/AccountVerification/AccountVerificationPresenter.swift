// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

final class AccountVerificationPresenter: NSObject, Presenter, AccountVerificationActionResponses {
    
    typealias Models = AccountVerificationModels

    weak var viewController: AccountVerificationViewController?

    // MARK: - AccountVerificationActionResponses
    
    private var isPending = false
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        
        let levelOneStatus: VerificationStatus
        let levelTwoStatus: VerificationStatus
        let description = item.failureReason ?? L10n.Account.idVerification
        
        if item.status.value.contains("KYC2") {
            levelOneStatus = .levelOne
            levelTwoStatus = item.status
        } else {
            levelOneStatus = item.status
            levelTwoStatus = .none
        }
        
        let isActive = levelOneStatus == .levelOne || item.status == .levelOne
        
        switch item.status {
        case .levelTwo(.submitted):
            isPending = true
            
        default:
            break
        }
        
        let sections = [ Models.Section.verificationLevel ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .verificationLevel: [
                VerificationViewModel(kyc: .levelOne,
                                      title: .text(L10n.AccountKYCLevelOne.levelOne),
                                      status: levelOneStatus,
                                      description: .text(L10n.Account.personalInformation),
                                      benefits: .text(L10n.AccountKYCLevelOne.limit),
                                      isActive: true),
                VerificationViewModel(kyc: .levelTwo,
                                      title: .text(L10n.AccountKYCLevelTwo.levelTwo),
                                      status: levelTwoStatus,
                                      description: .text(description),
                                      benefits: .text(L10n.AccountKYCLevelTwo.limits),
                                      buyBenefits: .text(L10n.AccountKYCLevelTwo.buyLimits),
                                      isActive: isActive)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentStartVerification(actionResponse: AccountVerificationModels.Start.ActionResponse) {
        viewController?.displayStartVerification(responseDisplay: .init(level: actionResponse.level, isPending: isPending))
    }
    
    func presentPersonalInfoPopup(actionResponse: AccountVerificationModels.PersonalInfo.ActionResponse) {
        let text = L10n.Account.verifyPersonalInformation
        let model = PopupViewModel(title: .text(L10n.Account.personalInformation),
                                   body: text)
        
        viewController?.displayPersonalInfoPopup(responseDisplay: .init(model: model))
    }
    
    func presentPendingStatusError(actionResponse: AccountVerificationModels.PendingMessage.ActionResponse) {
        let model = InfoViewModel(description: .text(L10n.AccountKYCLevelTwo.verificationPending), dismissType: .auto)
        let config = Presets.InfoView.error
        
        viewController?.displayPendingStatusError(responseDisplay: .init(model: model,
                                                                         config: config))
    }

    // MARK: - Additional Helpers

}
