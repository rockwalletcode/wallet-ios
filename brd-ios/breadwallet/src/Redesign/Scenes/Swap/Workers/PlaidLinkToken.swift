// 
//  PlaidLinkToken.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 14.11.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct PlaidLinkTokenResponseData: ModelResponse {
    var linkToken: String
}

struct PlaidLinkToken {
    var linkToken: String
}

class PlaidLinkTokenWorkerMapper: ModelMapper<PlaidLinkTokenResponseData, PlaidLinkToken> {
    override func getModel(from response: PlaidLinkTokenResponseData?) -> PlaidLinkToken? {
        return .init(linkToken: response?.linkToken ?? "")
    }
}

class PlaidLinkTokenWorker: BaseApiWorker<PlaidLinkTokenWorkerMapper> {
    override func getUrl() -> String {
        return ExchangeEndpoints.plaidLinkToken.url
    }
}
