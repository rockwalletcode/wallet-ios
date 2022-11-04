// 
//  FailureViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

// currently not used, but if we need to, we can expand the VC with this protocol instead of enum directly
protocol SimpleMessage {
    var iconName: String { get }
    var title: String { get }
    var description: String { get }
    var firstButtonTitle: String? { get }
    var secondButtonTitle: String? { get }
}

enum FailureReason: SimpleMessage {
    case buy
    case swap
    
    var iconName: String {
        return "error"
    }
    
    var title: String {
        switch self {
        case .buy:
            return L10n.Buy.errorProcessingPayment
            
        case .swap:
            return L10n.Swap.errorProcessingTransaction
        }
    }
    
    var description: String {
        switch self {
        case .buy:
            return L10n.Buy.failureTransactionMessage
            
        case .swap:
            return L10n.Swap.failureSwapMessage
        }
    }
    
    var firstButtonTitle: String? {
        switch self {
        case .buy:
            return L10n.Buy.tryAnotherPayment
            
        case .swap:
            return L10n.Swap.retry
        }
    }
    
    var secondButtonTitle: String? {
        switch self {
        case .buy:
            return L10n.UpdatePin.contactSupport
            
        case .swap:
            return L10n.Swap.backToHome
        }
    }
}

import UIKit

extension Scenes {
    static let Failure = FailureViewController.self
}

class FailureViewController: BaseInfoViewController {
    
    var failure: FailureReason? {
        didSet {
            prepareData()
        }
    }
    override var imageName: String? { return failure?.iconName }
    override var titleText: String? { return failure?.title }
    override var descriptionText: String? { return failure?.description }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: failure?.firstButtonTitle?),
            .init(title: failure?.secondButtonTitle, isUnderlined: true)
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
