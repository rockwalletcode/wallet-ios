// 
//  TimeoutViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 22/08/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Timeout = TimeoutViewController.self
}

class TimeoutViewController: BaseInfoViewController {
    override var imageName: String? { return "timeoutStatusIcon" }
    override var titleText: String? { return L10n.PaymentConfirmation.paymentTimeout }
    override var descriptionText: String? { return L10n.PaymentConfirmation.paymentExpired }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.PaymentConfirmation.tryAgain, callback: { [weak self] in
                self?.coordinator?.popToRoot(completion: { [weak self] in
                    (self?.navigationController?.topViewController as? BuyViewController)?.didTriggerGetData?()
                })
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary]
    }
}
