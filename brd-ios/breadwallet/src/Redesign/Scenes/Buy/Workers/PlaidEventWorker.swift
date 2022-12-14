// 
//  PlaidEventWorker.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct PlaidEventRequestData: RequestModelData {
    let event: String
    
    func getParameters() -> [String: Any] {
        return [
            "plaid_callback_event": [
                "name": event
            ]
        ]
    }
}

class PlaidEventWorker: BaseApiWorker<PlainMapper> {
    override func getUrl() -> String {
        return ExchangeEndpoints.plaidLogEvent.url
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> HTTPMethod {
        return .post
    }
}
