// 
//  SwapInfoViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
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
            .init(title: L10n.Swap.backToHome),
            .init(title: L10n.Swap.details, isUnderlined: true)
        ]
    }
    
    override var buttonCallbacks: [(() -> Void)] {
        return [
            homeTapped,
            swapDetailsTapped
        ]
    }
    
    func homeTapped() {
        coordinator?.goBack(completion: {})
    }
    
    func swapDetailsTapped() {
        guard let itemId = dataStore?.itemId else { return }
        (coordinator as? SwapCoordinator)?.showSwapDetails(exchangeId: itemId)
    }
}
