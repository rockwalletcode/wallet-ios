//
//  DocumentReviewModels.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//
//

import UIKit

enum DocumentReviewModels {
    
    typealias Item = (type: DocumentImageType?, image: UIImage?, checklist: [ChecklistItemViewModel]?)
    
    enum Sections: Sectionable {
        case title
        case checkmarks
        case image
        case buttons
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
}
