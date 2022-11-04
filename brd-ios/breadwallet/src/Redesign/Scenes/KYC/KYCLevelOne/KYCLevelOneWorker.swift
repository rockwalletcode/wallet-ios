// 
//  KYCLevelOneWorker.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct KYCBasicRequestData: RequestModelData {
    var firstName: String
    var lastName: String
    var country: String
    var birthDate: String
    
    func getParameters() -> [String: Any] {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "country": country,
            "date_of_birth": birthDate
        ]
    }
}

class KYCLevelOneWorker: BaseApiWorker<PlainMapper> {
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.basic)
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
}
