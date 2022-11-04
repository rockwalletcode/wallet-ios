//
//  CheckListModels.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//
//

import UIKit

enum CheckListModels {
    
    enum Sections: Sectionable {
        case title
        case checkmarks
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
}
