// 
//  ExchangeRateModels.swift
//  breadwallet
//
//  Created by Rok on 09/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum ExchangeRateModels {
    enum ExchangeRate {
        struct ViewAction {
            var getFees: Bool = false
        }
        
        struct ActionResponse {
            var quote: Quote?
            var from: String?
            var to: String?
            var limits: String?
            var showTimer: Bool?
        }
        
        struct ResponseDisplay {
            var rateAndTimer: ExchangeRateViewModel?
            var accountLimits: LabelViewModel?
        }
    }
    enum CoingeckoRate {
        struct ViewAction {
            var getFees: Bool = false
        }
    }
}
