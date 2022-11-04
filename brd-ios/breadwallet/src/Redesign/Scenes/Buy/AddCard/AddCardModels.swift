//
//  AddCardModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Frames
import UIKit

enum AddCardModels {
    typealias Item = AddCardStore
    
    enum Section: Sectionable {
        case cardDetails
        case confirm
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    struct CardInfo {
        struct ViewAction {
            var number: String?
            var cvv: String?
            var expirationDateIndex: PickerViewViewController.Index?
        }
        
        struct ActionResponse {
            var dataStore: AddCardStore?
        }
        
        struct ResponseDisplay {
            var model: BankCardInputDetailsViewModel
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
        
        struct ActionResponse {
            var checkoutToken: CkoCardTokenResponse?
        }
        
        struct ResponseDisplay {
            var checkoutToken: CkoCardTokenResponse?
        }
    }
    
    struct CvvInfoPopup {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
}
