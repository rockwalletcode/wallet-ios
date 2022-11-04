//
// Created by Equaleyes Solutions Ltd
//

import UIKit

enum AccountVerificationModels {
    
    enum KYCLevel: Int {
        case one = 0
        case two = 1
    }
    
    typealias Item = Profile
    
    enum Section: Sectionable {
        case verificationLevel
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Start {
        struct ViewAction {
            var level: Int = 0
            /// if the user wants to start a basic verification, but already has
            /// an advanced confirmed, we need to warn him that it will be reset
            var confirmed: Bool?
        }
        
        struct ActionResponse {
            var level: KYCLevel
            var confirmed: Bool?
        }
        
        struct ResponseDisplay {
            var level: KYCLevel
        }
    }
    
    struct PersonalInfo {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
}
