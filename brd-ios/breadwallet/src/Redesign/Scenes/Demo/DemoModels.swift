//
//  DemoModels.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

enum DemoModels {
    
    enum Section: Sectionable {
        case date
        case profile
        case verification
        case navigation
        case label
        case button
        case textField
        case infoView
        case segmentControl
        case timer
        case asset
        case order
        
        var header: AccessoryType? { return .advanced(.init(named: "swap"), "ROK", "ZELOOOO drago") }
        var footer: AccessoryType? { return nil }
    }
    
}
