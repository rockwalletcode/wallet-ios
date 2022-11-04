//
//  ItemSelectionStore.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionStore: NSObject, BaseDataStore, ItemSelectionDataStore {
    // MARK: - ItemSelectionDataStore
    
    var itemId: String?
    var items: [ItemSelectable]?
    var instrumentID: String?
    
    var sceneTitle: String = ""
    
    /// Enable adding entries
    var isAddingEnabled: Bool? = false
    var isSelectingEnabled: Bool? = true
    
    // MARK: - Aditional helpers
}
