// 
//  Colors.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct LightColors {
    // TODO: update the documentation
    
    struct Background {
        /// Default page background
        static var one = ThemeManager.shared.color(for: "background-01")
        /// Secondary background
        static var two = ThemeManager.shared.color(for: "background-02")
        /// Background for UI elements such as cards, modals, dialogue notifications
        static var three = ThemeManager.shared.color(for: "background-03")
        /// Background for UI elements such as cards, modals, dialogue notifications
        static var cards = ThemeManager.shared.color(for: "background-cards")
    }
    
    /// Primary interactive color. Always the 500 value for the corresponding brand color
    static var primary = ThemeManager.shared.color(for: "primary")
    /// Secondary ui elements such as toast notifications
    static var secondary = ThemeManager.shared.color(for: "secondary")
    /// Low contrast shade to be combined with primary colors whenever needed
    static var tertiary = ThemeManager.shared.color(for: "tertiary")
    
    struct Contrast {
        /// Text of icons on top of primary colors
        static var one = ThemeManager.shared.color(for: "contrast-01")
        /// Text or icons on top of secondary, colors and diabled CTAS
        static var two = ThemeManager.shared.color(for: "contrast-02")
    }
    
    struct Text {
        /// Primary text; Body copy; Headers; Hover text color for light-text-02
        static var one = ThemeManager.shared.color(for: "text-01")
        /// Secondary text; Input labels
        static var two = ThemeManager.shared.color(for: "text-02")
        /// Secondary text; Input labels
        static var three = ThemeManager.shared.color(for: "text-03")
    }
    
    struct Outline {
        /// Default line elements
        static var one = ThemeManager.shared.color(for: "outline-01")
        /// Structural line elements
        static var two = ThemeManager.shared.color(for: "outline-02")
    }
    
    struct Disabled {
        /// Default line elements
        static var one = ThemeManager.shared.color(for: "disabled-01")
        /// Structural line elements
        static var two = ThemeManager.shared.color(for: "disabled-02")
    }
    
    struct Success {
        /// Error 1 message text, icons & backgrounds
        static var one = ThemeManager.shared.color(for: "success-01")
        /// Error 2 message text, icons & backgrounds
        static var two = ThemeManager.shared.color(for: "success-02")
    }
    
    struct Pending {
        /// Error 1 message text, icons & backgrounds
        static var one = ThemeManager.shared.color(for: "pending-01")
        /// Error 2 message text, icons & backgrounds
        static var two = ThemeManager.shared.color(for: "pending-02")
    }
    
    struct Error {
        /// Error 1 message text, icons & backgrounds
        static var one = ThemeManager.shared.color(for: "error-01")
        /// Error 2 message text, icons & backgrounds
        static var two = ThemeManager.shared.color(for: "error-02")
    }
    /// Primary button selected / highlighted
    static var primaryPressed = ThemeManager.shared.color(for: "primary-pressed")
}
