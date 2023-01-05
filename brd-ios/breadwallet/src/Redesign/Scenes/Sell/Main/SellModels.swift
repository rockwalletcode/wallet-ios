//
//  SellModels.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//
//

import UIKit

enum SellModels {
    typealias Item = Currency
    enum Sections: Sectionable {
        case rateAndTimer
        case accountLimits
        case payoutMethod
        case swapCard
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Amounts {
        struct ViewAction {
            var from: String?
            var to: String?
        }
        
        struct ActionResponse {
            var from: Amount?
        }
        
        struct ResponseDisplay {
            var continueEnabled = false
            var amounts: MainSwapViewModel
        }
    }
    
    struct PaymentMethod {
        struct ViewAction {}
        
        struct ActionResponse {
            var from: Amount?
        }
        
        struct ResponseDisplay {
            var continueEnabled = false
            var amounts: MainSwapViewModel
        }
    }
}
