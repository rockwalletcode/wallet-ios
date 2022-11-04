// 
//  ServerResult.swift
//  breadwallet
//
//  Created by Rok on 29/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ServerResponse: Decodable {
    var result: String?
    var error: ServerError?
    var data: Data?
    
    struct ServerError: Decodable, FEError {
        var code: String?
        var serverMessage: String?
        var statusCode: Int { return Int(code ?? "") ?? -1 }
        var errorMessage: String { return serverMessage ?? ""  }
    }
}
