//
//  ExchangeDetailsStore.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class ExchangeDetailsStore: NSObject, BaseDataStore, ExchangeDetailsDataStore {
    var itemId: String?
    
    // MARK: - ExchangeDetailsDataStore
    
    var transactionType: TransactionType = .defaultTransaction
    
    // MARK: - Aditional helpers
}
