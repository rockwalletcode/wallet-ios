// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

enum AccountVerificationModels {
    
    enum KYCLevel: Int {
        case one = 0
        case two = 1
        case veriff = 2
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
        }
        
        struct ActionResponse {
            var level: KYCLevel
            var sessionUrl: String?
        }
        
        struct ResponseDisplay {
            var level: KYCLevel
            var isPending: Bool
            var sessionUrl: String
        }
    }
    
    struct PendingMessage {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var model: InfoViewModel
            var config: InfoViewConfiguration
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
