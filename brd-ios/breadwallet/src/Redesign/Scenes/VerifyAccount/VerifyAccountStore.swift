//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class VerifyAccountStore: NSObject, BaseDataStore, VerifyAccountDataStore {
    var itemId: String?
    
    // MARK: - VerifyAccountDataStore
    
    var coverImageName: String?
    var subtitleMessage: String?
    
    // MARK: - Aditional helpers
}
