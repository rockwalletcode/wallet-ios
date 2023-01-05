//
//  BaseInfoStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class BaseInfoStore: NSObject, BaseDataStore, BaseInfoDataStore {
    
    var itemId: String?
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    // MARK: - BaseInfoDataStore
    var item: Any?

    // MARK: - Aditional helpers
}
