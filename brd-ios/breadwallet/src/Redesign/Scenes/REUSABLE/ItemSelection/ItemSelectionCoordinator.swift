//
//  ItemSelectionCoordinator.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionCoordinator: BuyCoordinator, ItemSelectionRoutes {
    // MARK: - ItemSelectionRoutes
    override func start() {
        open(scene: Scenes.ItemSelection)
    }
    
    func showPaymentsActionSheet(okButtonTitle: String,
                           cancelButtonTitle: String,
                           handler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .destructive, handler: { _ in
            handler()
        }))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Aditional helpers
}
