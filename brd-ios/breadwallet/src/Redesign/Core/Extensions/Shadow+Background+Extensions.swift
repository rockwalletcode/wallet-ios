// 
//  Shadow+Background+Extensions.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 23/10/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension CALayer {
    func setShadow(with config: ShadowConfiguration) {
        shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowRadius = config.shadowRadius.rawValue
        shadowOpacity = config.opacity.rawValue
        shadowOffset = config.offset
        shadowColor = config.color.cgColor
        masksToBounds = false
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
}

extension UIView {
    func setBackground(with config: BackgroundConfiguration) {
        backgroundColor = config.backgroundColor
        
        guard let border = config.border else { return }
        let radius = border.cornerRadius == .fullRadius ? bounds.height / 2 : border.cornerRadius.rawValue
        
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.cornerCurve = .continuous
        layer.borderWidth = border.borderWidth
        layer.borderColor = border.tintColor.cgColor
    }
}
