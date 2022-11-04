// 
//  KYCLevelTwoEntryViewController.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let KYCLevelTwo = KYCLevelTwoEntryViewController.self
}

class KYCLevelTwoEntryViewController: CheckListViewController {
    override var sceneLeftAlignedTitle: String? { return L10n.AccountKYCLevelTwo.confirmID }
    override var checklistTitle: LabelViewModel { return .text(L10n.AccountKYCLevelTwo.beforeStart) }
    override var checkmarks: [ChecklistItemViewModel] { return [
        .init(title: .text(L10n.AccountKYCLevelTwo.prepareDocument)),
        .init(title: .text(L10n.AccountKYCLevelTwo.makeSure)),
        .init(title: .text(L10n.AccountKYCLevelTwo.takePhotos))
        ]
    }
    
    override func buttonTapped() {
        (coordinator as? KYCCoordinator)?.showIdentitySelector()
    }
}
