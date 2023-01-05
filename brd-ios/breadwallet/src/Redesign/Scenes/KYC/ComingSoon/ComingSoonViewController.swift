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

enum Reason: SimpleMessage {
    case swapAndBuyCard
    case buyAch
    case sell
    
    var iconName: String {
        return Asset.time.name
    }
    
    var title: String {
        switch self {
        case .swapAndBuyCard:
            return L10n.ComingSoon.title
            
        case .buyAch, .sell:
            return L10n.Buy.Ach.notAvailableTitle
        }
    }
    
    var description: String {
        switch self {
        case .swapAndBuyCard:
            return L10n.ComingSoon.body
            
        case .buyAch:
            return L10n.Buy.Ach.notAvailableBody
            
        case .sell:
            return L10n.Sell.notAvailableBody
        }
    }
    
    var firstButtonTitle: String? {
        switch self {
        case .swapAndBuyCard, .sell:
            return L10n.Swap.backToHome
            
        case .buyAch:
            return L10n.Buy.buyWithCardButton
        }
    }
    
    var secondButtonTitle: String? {
        switch self {
        case .swapAndBuyCard:
            return L10n.UpdatePin.contactSupport
            
        case .buyAch:
            return L10n.Swap.backToHome
            
        case .sell:
            return nil
        }
    }
}

extension Scenes {
    static let ComingSoon = ComingSoonViewController.self
}

class ComingSoonViewController: BaseInfoViewController {
    var reason: Reason? {
        didSet {
            prepareData()
        }
    }
    override var imageName: String? { return reason?.iconName }
    override var titleText: String? { return reason?.title }
    override var descriptionText: String? { return reason?.description }
    
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: reason?.firstButtonTitle, callback: { [weak self] in
                if self?.reason == .swapAndBuyCard || self?.reason == .sell {
                    self?.coordinator?.dismissFlow()
                } else if self?.reason == .buyAch {
                    self?.coordinator?.showBuy(coreSystem: self?.dataStore?.coreSystem, keyStore: self?.dataStore?.keyStore)
                }
            }),
            .init(title: reason?.secondButtonTitle, isUnderlined: true, callback: { [weak self] in
                if self?.reason == .swapAndBuyCard {
                    self?.coordinator?.showSupport()
                } else if self?.reason == .buyAch {
                    self?.coordinator?.dismissFlow()
                }
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
