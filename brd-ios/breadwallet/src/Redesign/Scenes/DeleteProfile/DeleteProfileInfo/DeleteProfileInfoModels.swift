//
//  DeleteProfileInfoModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum DeleteProfileInfoModels {
    typealias Item = Any?
    
    enum Section: Sectionable {
        case title
        case checkmarks
        case tickbox
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Tickbox {
        struct ViewAction {
            var value: Bool
        }
        
        struct ActionResponse {
            var value: Bool
        }
        
        struct ResponseDisplay {
            var model: ButtonViewModel
        }
    }
    
    struct DeleteProfile {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            var popupViewModel: PopupViewModel
            var popupConfig: PopupConfiguration
        }
    }
    
    struct WipeWalletNoPrompt {
        struct ViewAction {}
    }
}
