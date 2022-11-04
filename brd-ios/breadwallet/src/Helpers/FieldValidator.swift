// 
//  FieldValidator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct FieldValidator {
    static func validate(fields: [String?]) -> Bool {
        var fieldValidationIsAllowed = [String?: Bool]()
        
        fields.forEach { field in
            fieldValidationIsAllowed[String(describing: field)] = field?.count ?? 0 >= 1
        }
        
        return fieldValidationIsAllowed.values.contains(where: { $0 == false }) == false
    }
    
    static func validate(cvv: String?) -> Bool {
        guard let cvv = cvv else { return false }
        return cvv.count > 2 && cvv.count < 5
    }
    
    static func validate(cardNumber: String?) -> Bool {
        guard let cardNumber = cardNumber else { return false }
        return cardNumber.count > 11 && cardNumber.count < 17
    }
}
