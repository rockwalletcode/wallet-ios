// 
//  Float+Extensions.swift
//  breadwallet
//
//  Created by Rok on 09/11/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

extension Decimal {
    func round(to places: Int) -> Decimal {
        let divisor = pow(10.0, Double(places))
        let result = (doubleValue * divisor).rounded() / divisor
        return NSDecimalNumber(value: result).decimalValue
    }
}
