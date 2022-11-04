//
//  WhiteDecimalPad.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-03-16.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class WhiteDecimalPad: GenericPinPadCell {

    override var style: PinPadStyle {
        get { return .white }
        set {}
    }

    override func addConstraints() {
        label.constrain(toSuperviewEdges: nil)
        imageView.constrain(toSuperviewEdges: nil)
    }
}
