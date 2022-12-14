// 
//  ExchangeEndpoints.swift
//  breadwallet
//
//  Created by Rok on 04/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum ExchangeEndpoints: String, URLType {
    static var baseURL: String = "https://" + E.apiUrl + "blocksatoshi/exchange/%@"
    
    case supportedCurrencies = "supported-currencies"
    case quote = "quote?from=%@&to=%@&type=%@"
    case create = "create"
    case ach = "ach/create"
    case details = "exchange/%@"
    case history = "exchanges"
    case paymentInstruments = "v2/payment-instruments"
    case paymentInstrument = "payment-instrument"
    case paymentInstrumentId = "payment-instrument?instrument_id=%@"
    case paymentStatus = "payment-status?reference=%@"
    
    case plaidLinkToken = "plaid-link-token"
    case plaidLinkTokenId = "plaid-link-token?account_id=%@"
    case plaidPublicToken = "plaid-public-token"
    case plaidLogEvent = "plaid-log-event"
    case plaidLogError = "plaid-log-link-error"
    
    var url: String {
        return String(format: Self.baseURL, rawValue)
    }
}
