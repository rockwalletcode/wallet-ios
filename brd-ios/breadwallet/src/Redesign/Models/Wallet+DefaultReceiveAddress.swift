// 
//  Wallet+defaultReceiveAddress.swift
//  breadwallet
//
//  Created by Rok on 06/09/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import WalletKit

extension Wallet {
    var defaultReceiveAddress: String {
        let addressScheme: AddressScheme
        if currency.isBitcoin {
            addressScheme = UserDefaults.hasOptedInSegwit ? .btcSegwit : .btcLegacy
        } else {
            addressScheme = currency.network.defaultAddressScheme
        }
        return receiveAddress(for: addressScheme)
    }
}
