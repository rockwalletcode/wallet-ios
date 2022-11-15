//
//  RegistrationCoordinator.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationCoordinator: BaseCoordinator, RegistrationRoutes {
    // MARK: - RegistrationRoutes
    
    override func start() {
        guard UserDefaults.email != nil else {
            return open(scene: Scenes.Registration) { vc in
                vc.navigationItem.hidesBackButton = true
            }
        }
        
        let vc = navigationController.children.first(where: { $0 is RegistrationViewController }) as? RegistrationViewController
        let shouldShowProfile = vc?.dataStore?.shouldShowProfile ?? false
        showRegistrationConfirmation(shouldShowProfile: shouldShowProfile)
    }
    
    func showRegistrationConfirmation(shouldShowProfile: Bool = false) {
        open(scene: Scenes.RegistrationConfirmation) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.shouldShowProfile = shouldShowProfile
            vc.prepareData()
        }
    }
    
    func showChangeEmail() {
        open(scene: Scenes.Registration) { vc in
            vc.dataStore?.type = .resend
            vc.prepareData()
        }
    }
    
    override func showProfile() {
        upgradeAccountOrShowPopup { [weak self] _ in
            self?.set(coordinator: ProfileCoordinator.self, scene: Scenes.Profile) { vc in
                vc?.prepareData()
            }
        }
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
}
