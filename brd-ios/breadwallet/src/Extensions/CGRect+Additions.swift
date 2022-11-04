//
//  CGRect+Additions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-29.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
