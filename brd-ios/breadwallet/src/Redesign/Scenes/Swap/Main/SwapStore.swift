//
//  SwapStore.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class SwapStore: NSObject, BaseDataStore, SwapDataStore {
    
    // ExchangeRateDaatStore
    var fromCode: String { from?.currency.code ?? "" }
    var toCode: String { to?.currency.code ?? "" }
    var quoteRequestData: QuoteRequestData {
        return .init(from: fromCode,
                     to: toCode)
    }
    
    // MARK: - SwapDataStore
    var itemId: String?
    
    var from: Amount?
    var to: Amount?
    
    var values: SwapModels.Amounts.ViewAction = .init()
    
    var fromFee: TransferFeeBasis?
    
    var quote: Quote?
    var fromRate: Decimal?
    var toRate: Decimal?
    
    var supportedCurrencies: [SupportedCurrency]?
    
    var defaultCurrencyCode: String?
    
    var baseCurrencies: [String] = []
    var termCurrencies: [String] = []
    var baseAndTermCurrencies: [[String]] = []
    
    var swap: Swap?
    
    var currencies: [Currency] = []
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    var isKYCLevelTwo: Bool?
    
    var limits: String? {
        guard let quote = quote,
              let minText = ExchangeFormatter.fiat.string(for: quote.minimumValue),
              let maxText = ExchangeFormatter.fiat.string(for: quote.maximumValue)
        else { return nil }
        
        return L10n.Swap.swapLimits(minText, maxText)
    }
    
    // MARK: - Aditional helpers
    var fromFeeAmount: Amount? {
        guard let value = fromFee,
              let currency = currencies.first(where: { $0.code == value.fee.currency.code.uppercased() }) else {
            return nil
        }
        return .init(cryptoAmount: value.fee, currency: currency)
    }
    
    var toFeeAmount: Amount? {
        guard let value = quote?.toFee,
              let fee = ExchangeFormatter.crypto.string(for: value.fee),
              let currency = currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        return .init(tokenString: fee, currency: currency)
    }
}
