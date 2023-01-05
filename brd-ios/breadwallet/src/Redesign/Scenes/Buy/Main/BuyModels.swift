//
//  BuyModels.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

enum BuyModels {
    
    struct Item {
        var amount: Amount?
        var paymentCard: PaymentCard?
        var type: PaymentCard.PaymentType?
        var achEnabled: Bool?
    }
    
    enum Sections: Sectionable {
        case segment
        case rateAndTimer
        case accountLimits
        case from
        case paymentMethod
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Assets {
        struct ViewAction {
            var currency: String?
            var card: PaymentCard?
        }
        
        struct ActionResponse {
            var amount: Amount?
            var card: PaymentCard?
            var type: PaymentCard.PaymentType?
            var quote: Quote?
            var handleErrors = false
        }
        
        struct ResponseDisplay {
            var cryptoModel: SwapCurrencyViewModel?
            var cardModel: CardSelectionViewModel?
        }
    }
    
    struct Fee {
        struct ViewAction {}
        
        struct ActionResponse {
            var to: Decimal?
        }
        
        struct ResponseDisplay {
            var to: String?
        }
    }
    
    struct PaymentCards {
        struct ViewAction {
            var getCards: Bool?
        }
        
        struct ActionResponse {
            var allPaymentCards: [PaymentCard]
        }
        
        struct ResponseDisplay {
            var allPaymentCards: [PaymentCard]
        }
    }
    
    struct Amounts {
        struct ViewAction {
            var fiatValue: String?
            var tokenValue: String?
        }
    }
    
    struct Limits {
        struct ActionResponse {
            var min: Decimal?
            var max: Decimal?
        }
        
        typealias ResponseDisplay = LabelViewModel
    }
    
    struct OrderPreview {
        struct ViewAction {}
        
        struct ActionResponse {
            var availablePayments: [PaymentCard.PaymentType]?
        }
        
        struct ResponseDisplay {
            var availablePayments: [PaymentCard.PaymentType]?
        }
    }
    
    struct AssetSelector {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            let title: String
        }
    }
    
//    struct Failure {
//        struct ViewAction {}
//        
//        struct ActionResponse {}
//        
//        struct ResponseDisplay {}
//    }
    
    struct PaymentMethod {
        struct ViewAction {
            let method: PaymentCard.PaymentType
        }
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
    
    struct AchData {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            var model: InfoViewModel?
            var config: InfoViewConfiguration?
        }
    }
    
    struct RetryPaymentMethod {
        struct ViewAction {
            let method: PaymentCard.PaymentType
        }
        
        struct ActionResponse {
            let method: PaymentCard.PaymentType
        }
        
        struct ResponseDisplay {}
    }
}
