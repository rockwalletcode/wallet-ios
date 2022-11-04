// 
//  ShadowConfiguration.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ShadowConfiguration: ShadowConfigurable {
    var color: UIColor
    var opacity: Opacity
    var offset: CGSize
    var shadowRadius: CornerRadius
}
