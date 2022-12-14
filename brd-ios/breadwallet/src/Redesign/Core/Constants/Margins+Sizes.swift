//
//  Margins+Sizes.swift
//  
//
//  Created by Rok Cresnik on 14/09/2021.
//

import UIKit

/// View inset/offset margins
enum Margins: CGFloat {
    /// 0
    case zero = 0
    /// 2
    case minimum = 2
    /// 4
    case extraSmall = 4
    /// 8
    case small = 8
    /// 12
    case medium = 12
    /// special case for special days
    case special = 14
    /// 16
    case large = 16
    /// 20
    case extraLarge = 20
    /// 24
    case huge = 24
    /// 32
    case extraHuge = 32
    /// 36
    case extraExtraHuge = 36
    
    static func custom(_ increment: Int) -> CGFloat {
        return CGFloat(increment) * Margins.small.rawValue
    }
}

enum BorderWidth: CGFloat {
    /// 0
    case zero = 0
    /// 1
    case minimum = 1
}

enum Opacity: Float {
    /// 0
    case zero = 0
    /// 0.08
    case lowest = 0.12
    /// 0.15
    case low = 0.15
    /// 0.30
    case high = 0.3
    /// 0.80
    case highest = 0.8
}

enum ViewSizes: CGFloat {
    enum Common: CGFloat {
        /// 48
        case defaultCommon = 48.0
        /// 56
        case largeCommon = 56.0
        /// 64
        case hugeCommon = 64.0
    }
    
    /// 1
    case minimum = 1.0
    /// 20
    case extraSmall = 20.0
    /// 24
    case small = 24.0
    /// 32
    case medium = 32.0
    /// 40
    case large = 40.0
    /// 80
    case extralarge = 80.0
    /// 100
    case extraExtraHuge = 100.0
    /// Illustration
    case illustration = 180.0
}
