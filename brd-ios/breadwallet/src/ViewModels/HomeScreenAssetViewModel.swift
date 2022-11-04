//
//  HomeScreenAssetViewModel.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-31.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import Foundation

struct HomeScreenAssetViewModel {
    let currency: Currency
    
    var exchangeRate: String {
        return currency.state?.currentRate?.localString(forCurrency: currency) ?? ""
    }
    
    var fiatBalance: String {
        guard let balance = currency.state?.balance,
            let rate = currency.state?.currentRate
            else { return "" }
        
        return Amount(amount: balance, rate: rate).fiatDescription
    }
    
    var tokenBalance: String {
        guard let balance = currency.state?.balance,
              let text = ExchangeFormatter.crypto.string(for: balance.tokenValue)
        else { return "" }
        
        return text
    }
}
