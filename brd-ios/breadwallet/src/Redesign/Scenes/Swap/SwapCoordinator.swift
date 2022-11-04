// 
//  SwapCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
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
    
    func showSwapDetails(exchangeId: String) {
        open(scene: ExchangeDetailsViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.transactionType = .swapTransaction
            vc.prepareData()
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.failure = FailureReason.swap
            vc.firstCallback = { [weak self] in
                self?.popToRoot(completion: {
                    (self?.navigationController.topViewController as? SwapViewController)?.didTriggerGetExchangeRate?()
                })
            }
            
            vc.secondCallback = { [weak self] in
                self?.goBack(completion: {})
            }
        }
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
}
