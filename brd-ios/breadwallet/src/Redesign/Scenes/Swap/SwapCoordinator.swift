// 
//  SwapCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapCoordinator: BaseCoordinator, SwapRoutes, AssetSelectionDisplayable {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.Swap)
    }
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?) {
        ExchangeAuthHelper.showPinInput(on: navigationController,
                                        keyStore: keyStore,
                                        callback: callback)
    }
    
    func showSwapInfo(from: String, to: String, exchangeId: String) {
        open(scene: SwapInfoViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.item = (from: from, to: to)
            vc.prepareData()
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.failure = FailureReason.swap
        }
    }
    
    // MARK: - Aditional helpers
}
