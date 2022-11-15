//
//  UIColor+BRWAdditions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-21.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: Gradient
    static var gradientStart: UIColor {
        return UIColor(hex: "FF5193")
    }

    static var gradientEnd: UIColor {
        return UIColor(hex: "F29500")
    }

    static var grayTextTint: UIColor {
        return UIColor(red: 163.0/255.0, green: 168.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    }

    static var grayBackgroundTint: UIColor {
        return UIColor(red: 250.0/255.0, green: 251.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }

    static var pink: UIColor {
        return UIColor(red: 252.0/255.0, green: 83.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    }

    static var transparentButton: UIColor {
        return UIColor(white: 1.0, alpha: 0.2)
    }

    static var blueGradientStart: UIColor {
        return UIColor(red: 99.0/255.0, green: 188.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    static var blueGradientEnd: UIColor {
        return UIColor(red: 56.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    }

    static var lightGray: UIColor {
        return UIColor(red: 179.0/255.0, green: 192.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    }

    static var grayBackground: UIColor {
        return UIColor(red: 224.0/255.0, green: 229.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }

    static var transparentIconBackground: UIColor {
        return UIColor(white: 1.0, alpha: 0.25)
    }
}
