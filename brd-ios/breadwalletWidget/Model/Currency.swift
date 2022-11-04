// 
//  Currency.swift
//  breadwallet
//
//  Created by stringcode on 15/02/2021.
//  Copyright © 2021 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class Currency: SharedCurrency, CurrencyWithIcon {
    /// Unique identifier from BlockchainDB
    override var uid: CurrencyId { return metaData.uid }
    
    /// Display name (e.g. Bitcoin)
    override var name: String { return metaData.name }
    
    override var coinGeckoId: String? { return metaData.coinGeckoId }
    
    override var code: String { return metaData.code.uppercased() }
    
    let metaData: CurrencyMetaData
    
    /// Primary + secondary color
    override var colors: (UIColor, UIColor) { return metaData.colors }
    /// False if a token has been delisted, true otherwise
    override var isSupported: Bool { return metaData.isSupported }
    
    init(metaData: CurrencyMetaData) {
        self.metaData = metaData
    }
}

// MARK: - AssetOption

extension Currency {
    func assetOption() -> AssetOption {
        return AssetOption(identifier: uid.rawValue, display: name)
    }
}
