//
//  ColorOption+Extension.swift
//  breadwalletWidgetExtension
//
//  Created by stringcode on 15/02/2021.
//  Copyright © 2021 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//
import Foundation
import SwiftUI

extension ColorOption {

    var isSystem: Bool {
        return identifier?.contains(Constant.systemPrefix) ?? false
    }

    var isBrdBackgroundColor: Bool {
        return identifier?.contains(Constant.brdBgPrefix) ?? false
    }

    var isBrdTextColor: Bool {
        return identifier?.contains(Constant.brdTextPrefix) ?? false
    }

    var isCurrencyColor: Bool {
        return identifier?.contains(Constant.currencyPrefix) ?? false
    }

    var isBasicColor: Bool {
        return !isSystem && !isCurrencyColor && !isBrdBackgroundColor && !isBrdTextColor
    }
    
    var identifierWithoutPrefix: String? {
        identifier?
            .replacingOccurrences(of: Constant.systemPrefix, with: "")
            .replacingOccurrences(of: Constant.currencyPrefix, with: "")
            .replacingOccurrences(of: Constant.brdTextPrefix, with: "")
            .replacingOccurrences(of: Constant.brdBgPrefix, with: "")
    }
}

// MARK: - Environment / System based ColorOptions

extension ColorOption {

    static let autoBackground = ColorOption(
        identifier: Constant.systemBgId,
        display: L10n.Widget.Color.autoLightDark
    )
    
    static let autoTextColor = ColorOption(
        identifier: Constant.systemTextId,
        display: L10n.Widget.Color.autoLightDark
    )
}

// MARK: - Convenience initializer

extension ColorOption {
    
    convenience init(currency: Currency) {
        self.init(identifier: Constant.currencyPrefix + currency.uid.rawValue,
                  display: currency.name)
    }
}

// MARK: - Basic colors

extension ColorOption {

    static let white = ColorOption(identifier: ".white", display: L10n.Widget.Color.white)
    static let black = ColorOption(identifier: ".black", display: L10n.Widget.Color.black)
    static let gray = ColorOption(identifier: ".gray", display: L10n.Widget.Color.gray)
    static let red = ColorOption(identifier: ".red", display: L10n.Widget.Color.red)
    static let green = ColorOption(identifier: ".green", display: L10n.Widget.Color.green)
    static let blue = ColorOption(identifier: ".blue", display: L10n.Widget.Color.blue)
    static let orange = ColorOption(identifier: ".orange", display: L10n.Widget.Color.orange)
    static let yellow = ColorOption(identifier: ".yellow", display: L10n.Widget.Color.yellow)
    static let pink = ColorOption(identifier: ".pink", display: L10n.Widget.Color.pink)
    static let purple = ColorOption(identifier: ".purple", display: L10n.Widget.Color.purple)

    static func basicColors() -> [ColorOption] {
        return [ .white, .black, .gray, .red, .green, .blue, .orange, .yellow,
                 .pink, .purple]
    }
}

// MARK: - Background colors

extension ColorOption {

    static let primaryBackground = ColorOption(identifier: Constant.brdBgPrefix + "primaryBackground",
                                               display: L10n.Widget.Color.primaryBackground)
    static let secondaryBackground = ColorOption(identifier: Constant.brdBgPrefix + "secondaryBackground",
                                               display: L10n.Widget.Color.secondaryBackground)
    static let tertiaryBackground = ColorOption(identifier: Constant.brdBgPrefix + "tertiaryBackground",
                                                display: L10n.Widget.Color.tertiaryBackground)

    static func backgroundColors() -> [ColorOption] {
        return [.primaryBackground, secondaryBackground, .tertiaryBackground]
    }
}

// MARK: - Text colors

extension ColorOption {

    static let primaryText = ColorOption(identifier: Constant.brdTextPrefix + "primaryText",
                                         display: L10n.Widget.Color.primaryText)
    static let secondaryText = ColorOption(identifier: Constant.brdTextPrefix + "secondaryText",
                                           display: L10n.Widget.Color.secondaryText)
    static let tertiaryText = ColorOption(identifier: Constant.brdTextPrefix + "tertiaryText",
                                          display: L10n.Widget.Color.tertiaryText)

    static func textColors() -> [ColorOption] {
        return [.primaryText, secondaryText, .tertiaryText]
    }
}

// MARK: - Utilities

extension ColorOption {
    
    func colors(in colorScheme: ColorScheme? = nil, currencies: [Currency] = []) -> [Color] {
        if isCurrencyColor {
            let id = identifierWithoutPrefix
            return currencies
                .filter { $0.uid.rawValue == id }
                .map { [Color($0.colors.0), Color($0.colors.1)] }
                .first ?? []
        }
        if isBasicColor || isBrdTextColor || isBrdBackgroundColor {
            return [color(in: colorScheme), color(in: colorScheme)]
                .compactMap { $0 }
        }
        return []
    }
    
    func color(in colorScheme: ColorScheme? = nil) -> Color? {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        case .gray:
            return .gray
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .pink:
            return .pink
        case .purple:
            return .purple
        case .primaryBackground:
            return Color(Theme.primaryBackground)
        case .secondaryBackground:
            return Color(LightColors.Background.two)
        case .tertiaryBackground:
            return Color(LightColors.Background.three)
        case .primaryText:
            return Color(LightColors.Text.one)
        case .secondaryText:
            return Color(LightColors.Text.two)
        case .tertiaryText:
            return Color(Theme.tertiaryText)
        default:
            return nil
        }
    }
}

// MARK: - Constants

private extension ColorOption {

    enum Constant {
        static let currencyPrefix = "currency-"
        static let systemPrefix = "system-"
        static let brdTextPrefix = "brdtext-"
        static let brdBgPrefix = "brdbg-"
        static let systemBgId = Constant.systemPrefix + "bg"
        static let systemTextId = Constant.systemPrefix + "text"
    }
}
