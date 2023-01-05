// 
//  Animations.swift
//  breadwallet
//
//  Created by Rok on 08/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import Lottie

internal enum Animations {
    case buyAndSell
    
    var animation: LottieAnimation? {
        let name: String
        switch self {
        case .buyAndSell: name = "arrowToX"
        }
        return LottieAnimation.named(name)
    }
}
