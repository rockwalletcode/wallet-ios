// 
//  ExchangeFormatter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 12/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ExchangeFormatter {
    static var crypto: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        return formatter
    }
    
    static var fiat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static var current: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        return formatter
    }
    
    static func createAmountString(string: String) -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString(string: string)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingMiddle
        style.alignment = .right
        attributedString.addAttribute(.paragraphStyle, value: style,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}

extension String {
    func sanitize(inputFormat: NumberFormatter, expectedFormat: NumberFormatter) -> String {
        // remove grouping separators
        var sanitized = replacingOccurrences(of: inputFormat.currencyGroupingSeparator, with: "")
        sanitized = sanitized.replacingOccurrences(of: inputFormat.groupingSeparator, with: "")

        // replace decimal separators
        sanitized = sanitized.replacingOccurrences(of: inputFormat.currencyDecimalSeparator, with: expectedFormat.decimalSeparator)
        sanitized = sanitized.replacingOccurrences(of: inputFormat.decimalSeparator, with: expectedFormat.decimalSeparator)
        
        return sanitized
    }
    
    func cleanupFormatting(forFiat: Bool) -> String {
        let text = isEmpty != false ? "0" : self
        
        let expectedFormat = forFiat ? ExchangeFormatter.fiat : ExchangeFormatter.crypto
        let inputFormat = ExchangeFormatter.current
        
        let sanitized = text.sanitize(inputFormat: inputFormat, expectedFormat: expectedFormat)
        
        return sanitized
    }
}
