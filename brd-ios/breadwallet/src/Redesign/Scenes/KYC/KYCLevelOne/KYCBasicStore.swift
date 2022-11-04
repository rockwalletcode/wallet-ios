//
//  KYCBasicStore.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

class KYCBasicStore: NSObject, BaseDataStore, KYCBasicDataStore {
    // MARK: - KYCBasicDataStore
    // user id or smth?
    var itemId: String?
    var firstName: String?
    var lastName: String?
    var country: String?
    var countryFullName: String?
    var birthdate: Date?
    var birthDateString: String?
    
    // MARK: - Aditional helpers
}
