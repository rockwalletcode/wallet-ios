//
//  ProfileModels.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

enum ProfileModels {
    typealias Item = (title: String?, image: String?, status: VerificationStatus?)
    
    enum Section: Sectionable {
        case profile
        case verification
        case navigation
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    enum NavigationItems: String, CaseIterable {
        case paymentMethods
        case security
        case preferences
    }
    
    struct Navigate {
        struct ViewAction {
            var index: Int
        }
        struct ActionResponse {
            var index: Int
        }
        struct ResponseDisplay {
            var item: NavigationItems
        }
    }
    
    struct VerificationInfo {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
    
    struct PaymentCards {
        struct ViewAction {}
        
        struct ActionResponse {
            var allPaymentCards: [PaymentCard]
        }
        
        struct ResponseDisplay {
            var allPaymentCards: [PaymentCard]
        }
    }
}

extension ProfileModels.NavigationItems {
    var model: NavigationViewModel {
        switch self {
        case .paymentMethods:
            return .init(image: .imageName("card"),
                         label: .text(L10n.Buy.paymentMethod),
                         button: .init(image: nil))
            
        case .security:
            return .init(image: .imageName("lock_closed"),
                         label: .text(L10n.MenuButton.security),
                         button: .init(image: nil))

        case .preferences:
            return .init(image: .imageName("settings"),
                         label: .text(L10n.Settings.preferences),
                         button: .init(image: nil))
        }
    }
}
