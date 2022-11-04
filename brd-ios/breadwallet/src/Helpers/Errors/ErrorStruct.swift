// 
//  ErrorStruct.swift
//  breadwallet
//
//  Created by Rok on 29/04/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ErrorStruct: Codable {
    let description: String
    let createdAt: Date
    
    var data: [String: Any] {
        return [
            "description": description,
            "createdAt": createdAt.timeIntervalSince1970
        ]
    }
}

extension Array where Element == ErrorStruct {
    var data: [String: Any] {
        return [
            "message": compactMap { $0.data }
        ]
    }
}
