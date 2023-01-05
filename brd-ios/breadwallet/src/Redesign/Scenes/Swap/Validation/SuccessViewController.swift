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

enum SuccessReason: SimpleMessage {
    case buyCard
    case buyAch
    case sell
    
    var iconName: String {
        return Asset.success.name
    }
    
    var title: String {
        switch self {
        case .buyCard:
            return L10n.Buy.purchaseSuccessTitle
            
        case .buyAch:
            return L10n.Buy.bankAccountSuccessTitle
            
        case .sell:
            return L10n.Sell.withdrawalSuccessTitle
        }
    }
    
    var description: String {
        switch self {
        case .buyCard:
            return L10n.Buy.purchaseSuccessText
            
        case .buyAch:
            return L10n.Buy.bankAccountSuccessText
            
        case .sell:
            return L10n.Sell.withdrawalSuccessText
        }
    }
    
    var firstButtonTitle: String? {
        switch self {
        default:
            return L10n.Swap.backToHome
        }
    }
    
    var secondButtonTitle: String? {
        switch self {
        case .sell:
            return L10n.Sell.withdrawDetails
            
        default:
            return L10n.Buy.details
        }
    }
}

extension Scenes {
    static let Success = SuccessViewController.self
}

class SuccessViewController: BaseInfoViewController {
    var success: SuccessReason? {
        didSet {
            prepareData()
        }
    }
    
    var transactionType: TransactionType = .defaultTransaction
    override var imageName: String? { return success?.iconName }
    override var titleText: String? { return success?.title }
    override var descriptionText: String? { return success?.description }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: success?.firstButtonTitle, callback: { [weak self] in
                self?.coordinator?.dismissFlow()
            }),
            .init(title: success?.secondButtonTitle, isUnderlined: true, callback: { [weak self] in
                self?.coordinator?.showExchangeDetails(with: self?.dataStore?.itemId, type: self?.transactionType ?? .defaultTransaction)
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
