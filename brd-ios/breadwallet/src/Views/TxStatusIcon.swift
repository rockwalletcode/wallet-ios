// 
//  TxStatusIcon.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-09-10.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

enum StatusIcon: String {
    case send
    case receive
    case exchange
    
    var icon: UIImage? { return .init(named: rawValue) }
}
