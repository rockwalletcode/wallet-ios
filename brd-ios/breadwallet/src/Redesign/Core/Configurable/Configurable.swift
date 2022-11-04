//
//  Configurable.swift
//  
//
//  Created by Rok Cresnik on 03/09/2021.
//

import UIKit

/// Base Configurable protocol,
///
/// - Needs to be extended
protocol Configurable {}

/// BackgorundConfigurable protocol,
///
/// - Defines variable backgroundColor of type UIColor
/// - Defines variable tintColor of type UIColor
protocol BackgorundConfigurable: Configurable {
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    // optional
    var border: BorderConfiguration? { get }
}

/// BorderConfigurable protocol,
///
/// - Defines variable cornerRadius of type CornerRadius
/// - Defines variable tintColor of type UIColor
/// - Defines variable borderWidth of type CGFloat
protocol BorderConfigurable {
    var tintColor: UIColor { get }
    var borderWidth: CGFloat { get }
    var cornerRadius: CornerRadius { get }
}

/// ShadowConfigurable protocol,
///
/// - Defines variable color of type UIColor
/// - Defines variable opacity of type Opacity
/// - Defines variable offset of type CGSize
/// - Defines variable shadowRadius of type CornerRadius
protocol ShadowConfigurable {
    var color: UIColor { get }
    var opacity: Opacity { get }
    var offset: CGSize { get }
    var shadowRadius: CornerRadius { get }
}

/// TextConfigurable protocol,
///
/// - Defines variable font of type UIFont
/// - Defines variable textColor of type UIColor
/// - Defines variable textAlignment of type NSTextAlignment
/// - Defines variable numberOfLines of type Int
/// - Defines variable lineBreakMode of type NSLineBreakMode
protocol TextConfigurable: Configurable {
    var font: UIFont { get }
    var textColor: UIColor? { get }
    var textAlignment: NSTextAlignment { get }
    var numberOfLines: Int { get }
    var lineBreakMode: NSLineBreakMode { get }
}
