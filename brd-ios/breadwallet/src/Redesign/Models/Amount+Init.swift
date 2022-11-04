//
//  Amount+Init.swift
//  breadwallet
//
//  Created by Rok on 06/09/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

extension Amount {
    init(decimalAmount: Decimal, isFiat: Bool, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 16) {
        let amount = decimalAmount
        
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = decimals
        
        let amountString = formatter.string(for: amount)?.cleanupFormatting(forFiat: isFiat) ?? ""
        let isNegative = amount.sign == .minus
        
        guard let exchangeRate = exchangeRate, decimals >= 0 else {
            let exchangeRate = exchangeRate?.doubleValue ?? 1
            
            let fiatRate = Rate(code: currency.code,
                                name: currency.name,
                                rate: exchangeRate <= 0 ? 1 : exchangeRate,
                                reciprocalCode: "")
            if isFiat, let fallbackAmount = Amount(fiatString: "0", currency: currency, rate: fiatRate, negative: isNegative) {
                self = Amount(fiatString: amountString, currency: currency, rate: fiatRate, negative: isNegative) ?? fallbackAmount
            } else {
                self = Amount(tokenString: amountString, currency: currency, negative: isNegative)
            }
            
            return
        }
        
        let value: Amount?
        let rate = Rate(code: currency.code,
                        name: currency.name,
                        rate: exchangeRate.doubleValue,
                        reciprocalCode: "")
        
        if isFiat {
            value = Amount(fiatString: amountString, currency: currency, rate: rate, negative: isNegative)
        } else {
            value = Amount(tokenString: amountString, currency: currency, rate: rate, negative: isNegative)
        }
        
        guard let value = value,
                  value.tokenValue != 0 else {
            self = .init(decimalAmount: amount, isFiat: isFiat, currency: currency, exchangeRate: exchangeRate, decimals: decimals - 1)
            
            return
        }
        self = value
    }
}
