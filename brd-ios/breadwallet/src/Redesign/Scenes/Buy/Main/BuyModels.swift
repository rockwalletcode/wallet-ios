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
        case rateAndTimer
        case accountLimits
        case from
        case to
        
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
        struct ViewAction {}
        
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
}
