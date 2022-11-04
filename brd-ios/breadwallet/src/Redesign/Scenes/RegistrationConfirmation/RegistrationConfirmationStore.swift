//
//  RegistrationConfirmationStore.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationConfirmationStore: NSObject, BaseDataStore, RegistrationConfirmationDataStore {
    // MARK: - RegistrationConfirmationDataStore
    
    var itemId: String?
    var code: String?
    var callAssociate: Bool = false
    var shouldShowProfile: Bool = false
    
    // MARK: - Aditional helpers
}
