// 
//  SwapInfoViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let SwapInfo = SwapInfoViewController.self
}

class SwapInfoViewController: BaseInfoViewController {
    typealias Item = (from: String, to: String)
    
    override var imageName: String? { return "celebrate" }
    override var titleText: String? { return "Swapping \((dataStore?.item as? Item)?.from ?? "")/\((dataStore?.item as? Item)?.to ?? "")" }
    override var descriptionText: String? {
        let to = (dataStore?.item as? Item)?.to ?? ""
        
        return L10n.Swap.swapStatus(to)
    }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.Swap.backToHome, callback: { [weak self] in
                self?.coordinator?.goBack(completion: {})
            }),
            .init(title: L10n.Swap.details, isUnderlined: true, callback: { [weak self] in
                (self?.coordinator as? SwapCoordinator)?.showExchangeDetails(with: self?.dataStore?.itemId, type: .swapTransaction)
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
