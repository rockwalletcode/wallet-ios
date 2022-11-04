// 
//  QuoteWorker.swift
//  breadwallet
//
//  Created by Rok on 04/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct QuoteRequestData: RequestModelData {
    var from: String?
    var to: String?
    
    func getParameters() -> [String: Any] {
        let params = [
            "from": from,
            "to": to
        ]
        return params.compactMapValues { $0 }
    }
}

struct QuoteModelResponse: ModelResponse {
    var quoteId: Int
    var exchangeRate: Decimal
    var barTime: Double
    var timestamp: Double
    
    var minimumValue: Decimal
    var maximumValue: Decimal
    var minimumValueUsd: Decimal
    var maximumValueUsd: Decimal
    
    struct Fee: Codable {
        var feeCurrency: String?
        var rate: Decimal?
        var depositRate: Decimal?
    }
    var fromFeeCurrency: Fee?
    var toFeeCurrency: Fee?
    var fromFee: Decimal?
    var toFee: Decimal?
    var buyFees: Decimal?
}

struct Quote {
    var quoteId: Int
    var exchangeRate: Decimal
    var timestamp: Double
    
    var minimumValue: Decimal
    var maximumValue: Decimal
    var minimumUsd: Decimal
    var maximumUsd: Decimal
    var fromFeeRate: Decimal?
    var toFeeRate: Decimal?
    var fromFee: EstimateFee?
    var toFee: EstimateFee?
    var buyFee: Decimal?
}

struct EstimateFee: Model {
    var fee: Decimal
    var feeRate: Decimal?
    var currency: String
}

class QuoteMapper: ModelMapper<QuoteModelResponse, Quote> {
    override func getModel(from response: QuoteModelResponse?) -> Quote? {
        guard let response = response else { return nil }

        var fromFee: EstimateFee?
        if let currency = response.fromFeeCurrency?.feeCurrency,
           let value = response.fromFee {
            fromFee = .init(fee: value, currency: currency)
        }
        
        var toFee: EstimateFee?
        if let currency = response.toFeeCurrency?.feeCurrency,
            let value = response.toFee {
            toFee = .init(fee: value, feeRate: response.toFeeCurrency?.depositRate ?? 0, currency: currency)
        }
        
        return .init(quoteId: response.quoteId,
                     exchangeRate: response.exchangeRate,
                     timestamp: response.timestamp,
                     minimumValue: response.minimumValue,
                     maximumValue: response.maximumValue,
                     minimumUsd: response.minimumValueUsd,
                     maximumUsd: response.maximumValueUsd,
                     fromFeeRate: response.fromFeeCurrency?.rate,
                     toFeeRate: response.toFeeCurrency?.rate,
                     fromFee: fromFee,
                     toFee: toFee,
                     buyFee: response.buyFees)
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData),
              let from = urlParams.from,
              let to = urlParams.to
        else { return "" }
        
        return APIURLHandler.getUrl(ExchangeEndpoints.quote, parameters: from, to)
    }
}
