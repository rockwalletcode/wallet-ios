// 
//  UINavigationController+Completion.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 29/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension UINavigationController {
    func pushViewController(viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated: Bool,
                                 completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
