// 
//  AchPaymentModels.swift
//  breadwallet
//
//  Created by Rok on 12/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import LinkKit

enum AchPaymentModels {
    enum Get {
        struct ViewAction {
            var openCards: Bool?
        }
        
        struct ActionResponse {
            var item: PaymentCard?
        }
        
        struct ResponseDisplay {
            var viewModel: CardSelectionViewModel?
        }
    }
    
    enum Link {
        struct ViewAction {}
        
        struct ActionResponse {
            var handler: Handler
        }
        
        struct ResponseDisplay {
            var handler: Handler
        }
    }
}
