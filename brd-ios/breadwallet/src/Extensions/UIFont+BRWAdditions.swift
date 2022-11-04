//
//  UIFont+BRWAdditions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-27.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

// TODO: Unify fonts. 

extension UIFont {
    static var header: UIFont {
        return customBold(size: 18.0)
    }
    static func customBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func customBody(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    static func customMedium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    static func emailPlaceholder() -> UIFont {
        return customBody(size: 15.0)
    }
    static func onboardingHeading() -> UIFont {
        return customBody(size: 24.0)
    }
    static func onboardingSmallHeading() -> UIFont {
        return customBody(size: 18.0)
    }
    static func onboardingSubheading() -> UIFont {
        return customBody(size: 14.0)
    }
    static func onboardingSkipButton() -> UIFont {
        return customBody(size: 14.0)
    }
            
    static var regularAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customBody(size: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.darkText
        ]
    }

    static var boldAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customBold(size: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.darkText
        ]
    }
}
