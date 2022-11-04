//
//  UIColor+BRWAdditions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-21.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

extension UIColor {
        
    static var newGradientStart: UIColor {
        return UIColor(hex: "FB5491")
    }
    
    static var almostBlack: UIColor {
        return UIColor(hex: "#282828")
    }

    static var vibrantYellow: UIColor {
        return UIColor(hex: "#F8BA37")
    }
    
    static var gray1: UIColor {
        return UIColor(hex: "#696969")
    }
    
    static var gray2: UIColor {
        return UIColor(hex: "#A0A0A0")
    }
    
    static var gray3: UIColor {
        return UIColor(hex: "#C9C9C9")
    }
    
    static var green: UIColor {
        return UIColor(hex: "#00A86E")
    }
    
    static var red: UIColor {
        return UIColor(hex: "#FF5C4A")
    }
    
    static var homeBackground: UIColor {
        return UIColor(hex: "#fafafa")
    }
    
    static var shadowColor: UIColor {
        return UIColor.black.withAlphaComponent(0.15)
    }
    
    static var swapButtonEnabledColor: UIColor {
        return UIColor(red: 0.0/255.0, green: 171.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    
    static var swapButtonDisabledColor: UIColor {
        return UIColor(red: 141.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    }
    
    static var swapDarkPurple: UIColor {
        return UIColor(red: 38.0/255.0, green: 21.0/255.0, blue: 56.0/255.0, alpha: 1.0)
    }
    
    static var swapBackgroundPurpleColor: UIColor {
        return UIColor(red: 51.0/255.0, green: 32.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    }
    
    static var swapDividerColorColor: UIColor {
        return UIColor(red: 56.0/255.0, green: 38.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    }
    
    static var newGradientEnd: UIColor {
        return UIColor(hex: "FAA03F")
    }

    static var darkBackground: UIColor {
        return LightColors.Background.two
    }
    
    static var darkPromptBackground: UIColor {
        return UIColor(hex: "3E334F")
    }

    static var darkPromptTitleColor: UIColor {
        return .white
    }

    static var darkPromptBodyColor: UIColor {
        return UIColor(hex: "A1A9BC")
    }
    
    static var emailInputBackgroundColor: UIColor {
        return UIColor(hex: "F8F7FC").withAlphaComponent(0.05)
    }
    
    static var submitButtonEnabledBlue: UIColor {
        return UIColor(hex: "29ABE2")
    }
    
    static var orangeText: UIColor {
        return UIColor(hex: "FA724D")
    }
    
    static var newWhite: UIColor {
        return UIColor(hex: "BDBDBD")
    }
    
    static var greenCheck: UIColor {
        return UIColor(hex: "00A86E")
    }
    
    static var redCheck: UIColor {
        return UIColor(hex: "D72431")
    }
    
    static var shuttleGrey: UIColor {
        return UIColor(hex: "5F6368")
    }
    
    static var disabledBackground: UIColor {
        return UIColor(hex: "3E3C61")
    }

    // MARK: Buttons
    static var primaryButton: UIColor {
        return UIColor(hex: "2C78FF")
    }
    
    static var orangeButton: UIColor {
        return UIColor(hex: "E7AA41")
    }

    static var secondaryButton: UIColor {
        return UIColor(red: 245.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }

    static var secondaryBorder: UIColor {
        return UIColor(red: 213.0/255.0, green: 218.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }

    // MARK: text color
        
    static var darkText: UIColor {
        return UIColor(hex: "4F4F4F")
    }

    static var lightText: UIColor {
        return UIColor(hex: "828282")
    }

    static var lightHeaderBackground: UIColor {
        return UIColor(hex: "F9F9F9")
    }

    static var lightTableViewSectionHeaderBackground: UIColor {
        return UIColor(hex: "ECECEC")
    }

    static var darkLine: UIColor {
        return UIColor(red: 36.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }

    static var secondaryShadow: UIColor {
        return UIColor(red: 213.0/255.0, green: 218.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }

    // MARK: Gradient
    static var gradientStart: UIColor {
        return UIColor(hex: "FF5193")
    }

    static var gradientEnd: UIColor {
        return UIColor(hex: "F29500")
    }

    static var offWhite: UIColor {
        return UIColor(white: 247.0/255.0, alpha: 1.0)
    }

    static var borderGray: UIColor {
        return UIColor(white: 221.0/255.0, alpha: 1.0)
    }

    static var separatorGray: UIColor {
        return UIColor(white: 221.0/255.0, alpha: 1.0)
    }

    static var grayText: UIColor {
        return UIColor(white: 136.0/255.0, alpha: 1.0)
    }

    static var grayTextTint: UIColor {
        return UIColor(red: 163.0/255.0, green: 168.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    }

    static var secondaryGrayText: UIColor {
        return UIColor(red: 101.0/255.0, green: 105.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    }
    
    static var emailPlaceholderText: UIColor {
        return UIColor(hex: "828092")
    }
    
    static var grayBackgroundTint: UIColor {
        return UIColor(red: 250.0/255.0, green: 251.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }

    static var cameraGuidePositive: UIColor {
        return UIColor(red: 72.0/255.0, green: 240.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    }

    static var cameraGuideNegative: UIColor {
        return UIColor(red: 240.0/255.0, green: 74.0/255.0, blue: 93.0/255.0, alpha: 1.0)
    }

    static var purple: UIColor {
        return UIColor(red: 209.0/255.0, green: 125.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }

    static var darkPurple: UIColor {
        return UIColor(red: 127.0/255.0, green: 83.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }

    static var pink: UIColor {
        return UIColor(red: 252.0/255.0, green: 83.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    }

    static var blue: UIColor {
        return UIColor(red: 76.0/255.0, green: 152.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }

    static var whiteTint: UIColor {
        return UIColor(red: 245.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    
    static var outlineButtonBackground: UIColor {
        return UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 0.3)
    }

    static var transparentWhite: UIColor {
        return UIColor(white: 1.0, alpha: 0.3)
    }
    
    static var transparentWhiteText: UIColor {
        return UIColor(white: 1.0, alpha: 0.75)
    }
    
    static var disabledWhiteText: UIColor {
        return UIColor(white: 1.0, alpha: 0.5)
    }

    static var transparentBlack: UIColor {
        return UIColor(white: 0.0, alpha: 0.3)
    }
    
    static var transparentButton: UIColor {
        return UIColor(white: 1.0, alpha: 0.2)
    }

    static var darkOpaqueButton: UIColor {
        return UIColor(hex: "6496F8")
//        return UIColor(white: 1.0, alpha: 0.05)
    }
    
    static var blueGradientStart: UIColor {
        return UIColor(red: 99.0/255.0, green: 188.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    static var blueGradientEnd: UIColor {
        return UIColor(red: 56.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }

    static var txListGreen: UIColor {
        return UIColor(red: 0.0, green: 169.0/255.0, blue: 157.0/255.0, alpha: 1.0)
    }
    
    static var blueButtonText: UIColor {
        return UIColor(red: 127.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    static var darkGray: UIColor {
        return UIColor(red: 84.0/255.0, green: 104.0/255.0, blue: 117.0/255.0, alpha: 1.0)
    }
    
    static var lightGray: UIColor {
        return UIColor(red: 179.0/255.0, green: 192.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    }
    
    static var mediumGray: UIColor {
        return UIColor(red: 120.0/255.0, green: 143.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    }
    
    static var receivedGreen: UIColor {
        return UIColor(red: 155.0/255.0, green: 213.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    }
    
    static var failedRed: UIColor {
        return UIColor(red: 244.0/255.0, green: 107.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    }
    
    static var statusIndicatorActive: UIColor {
        return UIColor(red: 75.0/255.0, green: 119.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    }
    
    static var grayBackground: UIColor {
        return UIColor(red: 224.0/255.0, green: 229.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }
    
    static var whiteBackground: UIColor {
        return UIColor(red: 249.0/255.0, green: 251.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    }
    
    static var separator: UIColor {
        return UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }
    
    static var navigationTint: UIColor {
        return LightColors.Text.one
    }
    
    static var navigationBackground: UIColor {
        return LightColors.Background.one
    }
    
    static var transparentCellBackground: UIColor {
        return UIColor(white: 1.0, alpha: 0.03)
    }
    
    static var transparentIconBackground: UIColor {
        return UIColor(white: 1.0, alpha: 0.25)
    }
    
    static var disabledCellBackground: UIColor {
        return UIColor(hex: "190C2A")
    }
    
    static var pageIndicatorDotBackground: UIColor {
        return UIColor(hex: "1F1E3D")
    }
    
    static var pageIndicatorDot: UIColor {
        return  UIColor(hex: "027AFF")
    }
    
    static var onboardingHeadingText: UIColor {
        return .white
    }
    
    static var onboardingSubheadingText: UIColor {
        return UIColor(hex: "8B89A1")
    }
    
    static var onboardingSkipButtonTitle: UIColor {
        return UIColor(hex: "8B89A1")
    }
    
    static var onboardingOrangeText: UIColor {
        return UIColor(hex: "EA8017")
    }

    static var rewardsViewNormalTitle: UIColor {
        return UIColor(hex: "2A2A2A")
    }

    static var rewardsViewExpandedTitle: UIColor {
        return UIColor(hex: "441E36")
    }

    static var rewardsViewExpandedBody: UIColor {
        return UIColor(hex: "#441E36").withAlphaComponent(0.7)
    }
}
