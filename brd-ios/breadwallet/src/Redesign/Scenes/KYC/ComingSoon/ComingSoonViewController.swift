// 
//  ComingSoonViewController.swift
//  breadwallet
//
//  Created by Rok on 15/11/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let ComingSoon = ComingSoonViewController.self
}

class ComingSoonViewController: BaseInfoViewController {
    
    override var imageName: String? { return "time" }
    override var titleText: String? { return L10n.ComingSoon.title }
    override var descriptionText: String? { return L10n.ComingSoon.body }
    
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.ComingSoon.Buttons.backHome, callback: { [weak self] in
                self?.coordinator?.popToRoot()
            }),
            .init(title: L10n.ComingSoon.Buttons.contactSupport, isUnderlined: true, callback: { [weak self] in
                self?.coordinator?.showSupport()
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
