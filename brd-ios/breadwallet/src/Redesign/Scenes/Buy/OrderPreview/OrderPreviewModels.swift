//
//  OrderPreviewModels.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

enum PreviewType {
    // split buy into ach_buy and card_buy
    case buy
    case sell
    
    var title: String {
        switch self {
        case .buy: return L10n.Buy.orderPreview
        case .sell: return L10n.Sell.orderPreview
        }
    }
    
    var disclaimer: String {
        switch self {
        case .buy: return L10n.Buy.achPaymentDurationWarning
        case .sell: return L10n.Sell.achDurationWarning
        }
    }
}

enum OrderPreviewModels {
    
    typealias Item = (type: PreviewType?, to: Amount?, from: Decimal?, quote: Quote?, networkFee: Amount?, card: PaymentCard?, isAchAccount: Bool?)
    
    enum Sections: Sectionable {
        case achNotification
        case orderInfoCard
        case payment
        case termsAndConditions
        case submit
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct InfoPopup {
        struct ViewAction {
            var isCardFee: Bool
        }
        struct ActionResponse {
            var isCardFee: Bool
            var fee: Decimal?
        }
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
    
    struct ThreeDSecure {
        struct ActionResponse {
            var url: URL
        }
        
        struct ResponseDisplay {
            var url: URL
        }
    }
    
    struct ThreeDSecureStatus {
        struct ViewAction {}
    }
    
    struct CvvValidation {
        struct ViewAction {
            var cvv: String?
        }
        
        struct ActionResponse {
            var isValid: Bool
        }
        
        struct ResponseDisplay {
            var continueEnabled: Bool
        }
    }
    
    struct TermsAndConditions {
        struct ViewAction {}
        
        struct ActionResponse {
            var url: URL
        }
        
        struct ResponseDisplay {
            var url: URL
        }
    }
    
    struct ExpirationValidations {
        struct ViewAction {}
        
        struct ActionResponse {
            var isTimedOut: Bool
        }
        
        struct ResponseDisplay {
            var isTimedOut: Bool
        }
    }
    
    struct CvvInfoPopup {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
    
    struct Submit {
        struct ViewAction {}
        
        struct ActionResponse {
            var paymentReference: String?
            var previewType: PreviewType?
            var isAch: Bool?
            var failed: Bool?
        }
        
        struct ResponseDisplay {
            var paymentReference: String
            var reason: SuccessReason
        }
    }
    
    struct Failure {
        struct ResponseDisplay {
            var reason: FailureReason
        }
    }
    
    struct Tickbox {
        struct ViewAction {
            var value: Bool
        }
        
        struct ActionResponse {
            var value: Bool
        }
        
        struct ResponseDisplay {}
    }
}
