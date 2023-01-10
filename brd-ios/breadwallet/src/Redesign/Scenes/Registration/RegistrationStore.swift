//
//  RegistrationStore.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationStore: NSObject, BaseDataStore, RegistrationDataStore {
    // MARK: - RegistrationDataStore
    
    var submitting = false
    var itemId: String?
    var email: String?
    var type: RegistrationModels.ViewType = .registration
    var subscribe: Bool?
    
    // MARK: - Aditional helpers
    var isValid: Bool {
        return submitting == false && email?.isValidEmailAddress == true
    }
}
