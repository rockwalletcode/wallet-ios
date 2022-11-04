//
//  RegistrationConfirmationModels.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

enum RegistrationConfirmationModels {
    typealias Item = String?
    
    enum Section: Sectionable {
        case image
        case title
        case instructions
        case input
        case help
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Validate {
        struct ViewAction {
            var item: Item
        }
        
        struct ActionResponse {
            var isValid: Bool
        }
        
        struct ResponseDisplay {
            var isValid: Bool
        }
    }
    
    struct Confirm {
        struct ViewAction {}
        struct ActionResponse {
            var shouldShowProfile: Bool
        }
        struct ResponseDisplay {
            var shouldShowProfile: Bool
        }
    }
    
    struct Resend {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {}
    }
    
    struct Error {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {}
    }
}
