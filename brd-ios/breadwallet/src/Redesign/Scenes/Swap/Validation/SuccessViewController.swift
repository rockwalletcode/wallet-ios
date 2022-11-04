// 
//  SuccessViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Success = SuccessViewController.self
}

class SuccessViewController: BaseInfoViewController {
    override var imageName: String? { return "success" }
    override var titleText: String? { return L10n.Buy.purchaseSuccessTitle }
    override var descriptionText: String? { return L10n.Buy.purchaseSuccessText }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.Swap.backToHome.uppercased()),
            .init(title: L10n.Buy.details, isUnderlined: true)
        ]
    }

    override var buttonCallbacks: [(() -> Void)] {
        return [
            first,
            second
        ]
    }
    
    var firstCallback: (() -> Void)?
    var secondCallback: (() -> Void)?
    
    func first() {
        firstCallback?()
    }

    func second() {
        secondCallback?()
    }
}
