//
//  ExchangeDetailsWorker.swift
//  breadwallet
//
//  Created by Rok on 21/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ExchangeDetailsResponseData: ModelResponse {
    struct SourceDestination: ModelResponse {
        var currency: String?
        var currencyAmount: Double?
        var usdAmount: Double?
        var transactionId: String?
        var usdFee: Double?
        var paymentInstrument: PaymentCardsResponseData.PaymentInstrument?
        var feeRate: Decimal?
        var feeFixedRate: Decimal?
    }
    
    var orderId: Int?
    var status: String?
    var statusDetails: String?
    var source: SourceDestination?
    var destination: SourceDestination?
    var rate: Double?
    var timestamp: Int?
    var type: String?
}

struct SwapDetail: Model, Hashable {
    struct SourceDestination: Model, Hashable {
        var currency: String
        var currencyAmount: Double
        var usdAmount: Double
        var transactionId: String?
        var usdFee: Double
        var paymentInstrument: PaymentCard
        var feeRate: Decimal?
        var feeFixedRate: Decimal?
    }
    
    var orderId: Int
    var status: TransactionStatus
    var statusDetails: String
    var source: SourceDestination
    var destination: SourceDestination
    var rate: Double
    var timestamp: Int
    var type: Transaction.TransactionType
}

class ExchangeDetailsMapper: ModelMapper<ExchangeDetailsResponseData, SwapDetail> {
    override func getModel(from response: ExchangeDetailsResponseData?) -> SwapDetail {
        let source = response?.source
        let sourceCard = response?.source?.paymentInstrument
        let destination = response?.destination
        let destinationCard = response?.destination?.paymentInstrument
        let sourceData = SwapDetail.SourceDestination(currency: source?.currency?.uppercased() ?? "",
                                                      currencyAmount: source?.currencyAmount ?? 0,
                                                      usdAmount: source?.usdAmount ?? 0,
                                                      transactionId: source?.transactionId,
                                                      usdFee: source?.usdFee ?? 0,
                                                      paymentInstrument: PaymentCard(type: PaymentCard.PaymentType(rawValue: sourceCard?.type ?? "") ?? .buyCard,
                                                                                     id: sourceCard?.id ?? "",
                                                                                     fingerprint: sourceCard?.fingerprint ?? "",
                                                                                     expiryMonth: sourceCard?.expiryMonth ?? 0,
                                                                                     expiryYear: sourceCard?.expiryYear ?? 0,
                                                                                     scheme: PaymentCard.Scheme(rawValue: sourceCard?.scheme ?? "") ?? .none,
                                                                                     last4: sourceCard?.last4 ?? "",
                                                                                     accountName: sourceCard?.accountName ?? ""),
                                                      feeRate: source?.feeRate,
                                                      feeFixedRate: source?.feeFixedRate)
        let destinationData = SwapDetail.SourceDestination(currency: destination?.currency?.uppercased() ?? "",
                                                           currencyAmount: destination?.currencyAmount ?? 0,
                                                           usdAmount: destination?.usdAmount ?? 0,
                                                           transactionId: destination?.transactionId,
                                                           usdFee: destination?.usdFee ?? 0,
                                                           paymentInstrument: PaymentCard(type: PaymentCard.PaymentType(rawValue: sourceCard?.type ?? "") ?? .buyCard,
                                                                                          id: destinationCard?.id ?? "",
                                                                                          fingerprint: destinationCard?.fingerprint ?? "",
                                                                                          expiryMonth: destinationCard?.expiryMonth ?? 0,
                                                                                          expiryYear: destinationCard?.expiryYear ?? 0,
                                                                                          scheme: PaymentCard.Scheme(rawValue: destinationCard?.scheme ?? "") ?? .none,
                                                                                          last4: destinationCard?.last4 ?? "",
                                                                                          accountName: sourceCard?.accountName ?? ""),
                                                           feeRate: source?.feeRate,
                                                           feeFixedRate: source?.feeFixedRate)

        return SwapDetail(orderId: Int(response?.orderId ?? 0),
                          status: .init(string: response?.status) ?? .failed,
                          statusDetails: response?.statusDetails ?? "",
                          source: sourceData,
                          destination: destinationData,
                          rate: response?.rate ?? 0,
                          timestamp: Int(response?.timestamp ?? 0),
                          type: Transaction.TransactionType(rawValue: response?.type ?? "") ?? .defaultTransaction)
    }
}

struct ExchangeDetailsRequestData: RequestModelData {
    var exchangeId: String?
    
    func getParameters() -> [String: Any] {
        let params = ["exchangeId": exchangeId]
        
        return params.compactMapValues { $0 }
    }
}

class ExchangeDetailsWorker: BaseApiWorker<ExchangeDetailsMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? ExchangeDetailsRequestData)?.exchangeId else { return "" }
        
        return APIURLHandler.getUrl(ExchangeEndpoints.details, parameters: urlParams)
    }
}
