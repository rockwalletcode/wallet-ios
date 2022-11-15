// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

extension Scenes {
    static let KYCLevelTwoPostValidation = KYCLevelTwoPostValidationViewController.self
}

class KYCLevelTwoPostValidationViewController: CheckListViewController {
    override var sceneLeftAlignedTitle: String? { return L10n.AccountKYCLevelTwo.inProgress }
    override var checklistTitle: LabelViewModel { return .text(L10n.AccountKYCLevelTwo.documentsReview) }
    override var checkmarks: [ChecklistItemViewModel] { return [
        .init(title: .text(L10n.AccountKYCLevelTwo.uploadingPhoto)),
        .init(title: .text(L10n.AccountKYCLevelTwo.checkingErrors)),
        .init(title: .text(L10n.AccountKYCLevelTwo.sendingData)),
        .init(title: .text(L10n.AccountKYCLevelTwo.verifying))
    ]
    }
    
    override func buttonTapped() {
        UserManager.shared.refresh { [weak self] _ in
            (self?.coordinator as? KYCCoordinator)?.dismissFlow()
        }
    }
}
