//
// Created by Equaleyes Solutions Ltd
//

import UIKit

struct Fonts {
    static var Primary = "SofiaPro-Bold"
    static var Secondary = "Roboto-Regular"
    static var Tertiary = "Roboto-Medium"
    
    struct Title {
        static var one = ThemeManager.shared.font(for: Fonts.Primary, size: 50)
        static var two = ThemeManager.shared.font(for: Fonts.Primary, size: 42)
        static var three = ThemeManager.shared.font(for: Fonts.Primary, size: 32)
        static var four = ThemeManager.shared.font(for: Fonts.Primary, size: 28)
        static var five = ThemeManager.shared.font(for: Fonts.Primary, size: 24)
        static var six = ThemeManager.shared.font(for: Fonts.Primary, size: 18)
    }
    
    struct Subtitle {
        static var one = ThemeManager.shared.font(for: Fonts.Tertiary, size: 16)
        static var two = ThemeManager.shared.font(for: Fonts.Tertiary, size: 14)
        static var three = ThemeManager.shared.font(for: Fonts.Tertiary, size: 12)
    }
    
    struct Body {
        static var one = ThemeManager.shared.font(for: Fonts.Secondary, size: 16)
        static var two = ThemeManager.shared.font(for: Fonts.Secondary, size: 14)
        static var three = ThemeManager.shared.font(for: Fonts.Secondary, size: 12)
    }
    
    static var button = ThemeManager.shared.font(for: Fonts.Tertiary, size: 14)
    
    struct AlertActionSheet {
        static var title = ThemeManager.shared.font(for: Fonts.Tertiary, size: 32)
        static var body = ThemeManager.shared.font(for: Fonts.Secondary, size: 16)
    }
}
