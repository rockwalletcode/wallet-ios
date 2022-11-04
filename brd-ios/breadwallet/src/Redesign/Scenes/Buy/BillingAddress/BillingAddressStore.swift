//
//  BillingAddressStore.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Frames
import UIKit

class BillingAddressStore: NSObject, BaseDataStore, BillingAddressDataStore {
    // MARK: - BillingAddressDataStore
    
    var itemId: String?
    var firstName: String?
    var lastName: String?
    var country: String?
    var countryFullName: String?
    var stateProvince: String?
    var city: String?
    var zipPostal: String?
    var address: String?
    var paymentReference: String?
    var paymentstatus: AddCard.Status?
    var checkoutToken: CkoCardTokenResponse?
    
    // MARK: - Aditional helpers
}
