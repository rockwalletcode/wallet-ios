//
//  UIViewController+BRWAdditions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-21.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum NavBarButtonSide {
    case left
    case right
}

enum NavBarButtonPosition {
    case left, middle, right
}

extension UIViewController {
    func addChildViewController(_ viewController: UIViewController, layout: () -> Void) {
        addChild(viewController)
        view.addSubview(viewController.view)
        layout()
        viewController.didMove(toParent: self)
    }

    func setBarButtonItem(from navigationController: UINavigationController, to side: NavBarButtonSide, target: AnyObject? = nil, action: Selector? = nil) {
        switch side {
        case .left:
            navigationItem.leftBarButtonItem = navigationController.children.last?.navigationItem.leftBarButtonItem
            
            if target != nil && action != nil {
                navigationItem.leftBarButtonItem?.target = target
                navigationItem.leftBarButtonItem?.action = action
            }
            
        case .right:
            navigationItem.rightBarButtonItem = navigationController.children.last?.navigationItem.rightBarButtonItem
            
            if target != nil && action != nil {
                navigationItem.rightBarButtonItem?.target = target
                navigationItem.rightBarButtonItem?.action = action
            }
            
        }
    }
    
    func addCloseNavigationItem(side: NavBarButtonSide = .left) {
        let close = side == .left ? UIButton.buildModernCloseButton(position: .left) : UIButton.buildModernCloseButton(position: .right)
        
        close.tap = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        switch side {
        case .left:
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: close)]
            
        case .right:
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: close)]
            
        }
    }
    
    func setAsNonDismissableModal() {
        isModalInPresentation = true
    }
}
