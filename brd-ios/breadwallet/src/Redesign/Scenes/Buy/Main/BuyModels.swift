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
            var bankAccount: PaymentCard?
            var quote: Quote?
            var handleErrors = false
            var paymentMethod: PaymentCard.PaymentType?
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
    
    struct Rate {
        struct ViewAction {
            var from: String?
            var to: String?
        }
        
        struct ActionResponse {
            var method: PaymentCard.PaymentType
            var quote: Quote?
            var from: String?
            var to: String?
        }
        
        struct ResponseDisplay {
            var rate: ExchangeRateViewModel
            var limits: LabelViewModel?
        }
    }
    
    struct OrderPreview {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
    
    struct AssetSelector {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            let title: String
        }
    }
    
    struct PlaidLinkToken {
        struct ViewAction {}
        
        struct ActionResponse {
            var linkToken: String
        }
        
        struct ResponseDisplay {
            var linkToken: String
        }
    }
    
    struct PlaidPublicToken {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
    
    struct Failure {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
    
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
}
