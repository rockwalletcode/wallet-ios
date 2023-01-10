//
//  RegistrationModels.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

enum RegistrationModels {
    
    enum ViewType {
        case registration
        case resend
        
        var title: String {
            switch self {
            case .registration:
                return L10n.Account.welcome
                
            case .resend:
                return L10n.Account.changeEmail
            }
        }
        
        var instructions: String {
            switch self {
            case .registration:
                return L10n.Account.createAccount
                
            case .resend:
                return L10n.Account.verifyEmail
            }
        }
    }
    
    typealias Item = (email: String?, type: ViewType?, showMarketingTickbox: Bool)
    
    enum Section: Sectionable {
        case image
        case title
        case instructions
        case email
        case tickbox
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Validate {
        struct ViewAction {
            var item: String?
        }
        
        struct ActionResponse {
            var isValid: Bool?
        }
        
        struct ResponseDisplay {
            var isValid: Bool
        }
    }
    
    struct Tickbox {
        struct ViewAction {
            var value: Bool
        }
    }
    
    struct Next {
        struct ViewAction {}
        struct ActionResponse {
            var email: String?
        }
        struct ResponseDisplay {}
    }
}
