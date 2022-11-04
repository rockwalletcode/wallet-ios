//
//  KYCDocumentPickerStore.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import UIKit

class KYCDocumentPickerStore: NSObject, BaseDataStore, KYCDocumentPickerDataStore {
    // MARK: - KYCDocumentPickerDataStore
    var itemId: String?
    var documents: [Document]?
    var document: Document?
    var front: UIImage?
    var back: UIImage?
    var selfie: UIImage?
    
    // photo in 'review'
    var photo: UIImage?
    // MARK: - Aditional helpers
}
