// 
//  SuccessViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Success = SuccessViewController.self
}

class SuccessViewController: BaseInfoViewController {
    var transactionType: Transaction.TransactionType = .defaultTransaction
    override var imageName: String? { return "success" }
    override var titleText: String? { return L10n.Buy.purchaseSuccessTitle }
    override var descriptionText: String? { return L10n.Buy.purchaseSuccessText }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.Swap.backToHome, callback: { [weak self] in
                self?.coordinator?.goBack(completion: {})
            }),
            .init(title: L10n.Buy.details, isUnderlined: true, callback: { [weak self] in
                self?.coordinator?.showExchangeDetails(with: self?.dataStore?.itemId, type: self?.transactionType ?? .defaultTransaction)
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
