// 
//  DeleteProfileInfoCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class DeleteProfileInfoCoordinator: BaseCoordinator, DeleteProfileInfoRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {}
    
    func start(with keyMaster: KeyStore) {
        open(scene: Scenes.DeleteProfileInfo) { vc in
            vc.dataStore?.keyMaster = keyMaster
            vc.prepareData()
        }
    }
    
    // MARK: - Aditional helpers
    
}
