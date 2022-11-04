// 
//  SwapHistoryWorker.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 25.7.22.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ExchangeDetailsExchangesResponseData: ModelResponse {
    var exchanges: [ExchangeDetailsResponseData]
}

class SwapHistoryMapper: ModelMapper<ExchangeDetailsExchangesResponseData, [SwapDetail]> {
    override func getModel(from response: ExchangeDetailsExchangesResponseData?) -> [SwapDetail] {
        return response?
            .exchanges
            .compactMap { ExchangeDetailsMapper().getModel(from: $0) } ?? []
    }
}

class SwapHistoryWorker: BaseApiWorker<SwapHistoryMapper> {
    override func getUrl() -> String {
        return ExchangeEndpoints.history.url
    }
}
