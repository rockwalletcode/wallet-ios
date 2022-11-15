// 
//  PlaidPublicToken.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 14.11.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct PlaidPublicTokenRequestData: RequestModelData {
    let publicToken: String?
    
    func getParameters() -> [String: Any] {
        return [
            "public_token": publicToken ?? ""
        ]
    }
}

class PlaidPublicTokenWorker: BaseApiWorker<PlainMapper> {

    override func getUrl() -> String {
        return ExchangeEndpoints.plaidPublicToken.url
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> HTTPMethod {
        return .post
    }
}
