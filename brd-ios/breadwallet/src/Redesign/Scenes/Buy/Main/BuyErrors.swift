// 
//  BuyErrors.swift
//  breadwallet
//
//  Created by Rok on 19/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum BuyErrors: FEError {
    case noQuote(from: String?, to: String?)
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    case pinConfirmation
    case authorizationFailed
    case quoteFail
    
    var errorMessage: String {
        switch self {
        case .tooLow(let amount, let currency):
            return L10n.ErrorMessages.amountTooLow(ExchangeFormatter.fiat.string(for: amount.doubleValue) ?? "", currency)
            
        case .tooHigh(let amount, let currency):
            return L10n.ErrorMessages.amountTooHigh(ExchangeFormatter.fiat.string(for: amount.doubleValue) ?? "", currency)
            
        case .noQuote(let from, let to):
            let from = from ?? "/"
            let to = to ?? "/"
            return L10n.ErrorMessages.noQuoteForPair(from, to)
            
        case  .pinConfirmation:
            return L10n.ErrorMessages.pinConfirmationFailed
            
        case .authorizationFailed:
            return L10n.ErrorMessages.authorizationFailed
            
        case .quoteFail:
            return L10n.ErrorMessages.exchangeQuoteFailed
            
        }
    }
}
