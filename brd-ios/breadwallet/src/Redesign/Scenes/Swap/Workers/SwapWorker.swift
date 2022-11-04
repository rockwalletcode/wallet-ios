// 
//  SwapWorker.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapRequestData: RequestModelData {
    var deviceId: String?
    var quoteId: Int?
    var depositQuantity: String
    var withdrawalQuantity: String
    var destination: String?
    var sourceInstrumentId: String?
    var nologCvv: String?
    
    func getParameters() -> [String: Any] {
        let params: [String: Any?] = [
            "device_id": deviceId,
            "quote_id": quoteId,
            "deposit_quantity": depositQuantity,
            "withdrawal_quantity": withdrawalQuantity,
            "destination": destination,
            "source_instrument_id": sourceInstrumentId,
            "nolog_cvv": nologCvv
        ]
        
        return params.compactMapValues { $0 }
    }
}

struct SwapResponseData: ModelResponse {
    var exchangeId: Int?
    var currency: String?
    var amount: String?
    var address: String?
    var status: String?
    var paymentReference: String?
    var redirectUrl: String?
}

struct Swap: Model {
    var exchangeId: String?
    var currency: String?
    var amount: Decimal?
    var address: String?
    var status: AddCard.Status?
    var paymentReference: String?
    var redirectUrl: String?
}

class SwapMapper: ModelMapper<SwapResponseData, Swap> {
    override func getModel(from response: SwapResponseData?) -> Swap? {
        guard let response = response,
              let amount = Decimal(string: response.amount ?? "")
        else {
            return .init(status: .init(rawValue: response?.status ?? ""),
                         paymentReference: response?.paymentReference,
                         redirectUrl: response?.redirectUrl)
        }
        
        return .init(exchangeId: "\(response.exchangeId ?? 0)",
                     currency: response.currency?.uppercased() ?? "",
                     amount: amount,
                     address: response.address)
    }
}

class SwapWorker: BaseApiWorker<SwapMapper> {
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(ExchangeEndpoints.create)
    }
}
