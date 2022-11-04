// 
//  ExchangeAuthHelper.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 20/09/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ExchangeAuthHelper {
    static func showPinInput(on viewController: UIViewController, keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?) {
        guard let keyStore = keyStore else {
            fatalError("KeyStore not found.")
        }
        
        let loginVC = LoginViewController(for: .confirmation,
                                          keyMaster: keyStore,
                                          shouldDisableBiometrics: !keyStore.isBiometricsEnabledForTransactions)
        let loginNVC = RootNavigationController(rootViewController: loginVC)
        
        loginVC.confirmationCallback = { success in
            loginNVC.dismiss(animated: true) {
                callback?(success)
            }
        }
        
        loginNVC.modalPresentationStyle = .fullScreen
        viewController.show(loginNVC, sender: nil)
    }
}
