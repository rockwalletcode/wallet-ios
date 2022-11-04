//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class AccountVerificationCoordinator: BaseCoordinator, AccountVerificationRoutes {
    // MARK: - AccountVerificationRoutes
    
    func showKYCBasic() {
        open(scene: Scenes.KYCBasic)
    }

    // MARK: - Aditional helpers
}
