// 
//  BackgroundConfiguration.swift
//  breadwallet
//
//  Created by Rok on 16/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct BackgroundConfiguration: BackgorundConfigurable {
    var backgroundColor: UIColor = .clear
    var tintColor: UIColor = .clear
    var border: BorderConfiguration?
}

extension BackgroundConfiguration {
    func withBorder(border: BorderConfiguration?) -> BackgroundConfiguration {
        var copy = self
        copy.border = border
        return copy
    }
    
    func withCornerRadius(radius: CornerRadius) -> BackgroundConfiguration {
        var copy = self
        copy.border?.cornerRadius = radius
        return copy
    }
}
