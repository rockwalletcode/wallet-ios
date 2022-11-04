//
// Created by Equaleyes Solutions Ltd
//

import UIKit

enum ResetPinModels {
    
    enum Section: Sectionable {
        case title
        case image
        case button
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
}
