// 
//  CardDetailsFormatter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 10/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct CardDetailsFormatter {
    static func formatNumber(last4: String) -> String {
        return "**** **** **** \(last4)"
    }
    
    static func formatExpirationDate(month: Int, year: Int) -> String {
        let formattedMonth = String(format: "%02d", month)
        
        let year = String(year)
        let formattedYear: String = year.count == 4 ? String(year.dropFirst(2)) : year
        
        return "\(formattedMonth)/\(formattedYear)"
    }
}
