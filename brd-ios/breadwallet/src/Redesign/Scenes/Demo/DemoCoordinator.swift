//
//  DemoCoordinator.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

class DemoCoordinator: BaseCoordinator, DemoRoutes {
    
    // MARK: - DemoRoutes

    // MARK: - Aditional helpers
    override func start() {
        open(scene: Scenes.Demo)
    }
}
