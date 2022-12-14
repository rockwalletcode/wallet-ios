// 
//  PlaidErrorWorker.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct PlaidErrorRequestData: RequestModelData {
    let error: String
    
    func getParameters() -> [String: Any] {
        return [
            "plaid_link_error": [
                "name": error
            ]
        ]
    }
}

class PlaidErrorWorker: BaseApiWorker<PlainMapper> {
    override func getUrl() -> String {
        return ExchangeEndpoints.plaidLogError.url
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> HTTPMethod {
        return .post
    }
}
