//
//  KYCBasicModels.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

enum KYCBasicModels {
    
    typealias Item = KYCBasicStore
 
    enum Section: Sectionable {
        case name
        case country
        case state
        case birthdate
        case confirm
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    struct Name {
        struct ViewAction {
            var first: String?
            var last: String?
        }
    }
    
    struct SelectCountry {
        struct ViewAction {
            var code: String?
            var countryFullName: String?
        }
        
        struct ActionResponse {
            var countries: [Country]?
        }
        
        struct ResponseDisplay {
            var countries: [Country]
        }
    }
    
    struct SelectState {
        struct ViewAction {
            var state: USState?
        }
        
        struct ActionResponse {
            var states: [USState]?
        }
        
        struct ResponseDisplay {
            var states: [USState]
        }
    }
    
    struct BirthDate {
        struct ViewAction {
            var date: Date?
        }
    }
    
    struct Validate {
        struct ViewAction {}
        
        struct ActionResponse {
            var isValid: Bool
        }
        
        struct ResponseDisplay {
            var isValid: Bool
        }
    }
    
    struct Submit {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
}
