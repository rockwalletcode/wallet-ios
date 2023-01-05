//
//  SellStore.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//
//

import UIKit

class SellStore: NSObject, BaseDataStore, SellDataStore {
    
    
    // MARK: - SellDataStore
    
    // ExchangeRateDaatStore
    var quote: Quote? = .init(quoteId: 5,
                              exchangeRate: 0.99,
                              timestamp: Date().timeIntervalSince1970,
                              minimumValue: 100,
                              maximumValue: 200,
                              minimumUsd: 100,
                              maximumUsd: 200)
    
    var fromCode: String { currency?.code ?? "" }
    var toCode: String { C.usdCurrencyCode }
    var showTimer: Bool = false
    var quoteRequestData: QuoteRequestData {
        return .init(from: fromCode,
                     to: toCode,
                     type: .sell)
    }
    
    // MARK: - AchDataStore
    var ach: PaymentCard?
    var selected: PaymentCard?
    var cards: [PaymentCard] = []
    var paymentMethod: PaymentCard.PaymentType? = .ach
    
    var currency: Currency?
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    var limits: String? {
        guard let quote = quote,
              let minText = ExchangeFormatter.fiat.string(for: quote.minimumValue),
              let maxText = ExchangeFormatter.fiat.string(for: quote.maximumValue),
              let lifetimeLimit = ExchangeFormatter.fiat.string(for: UserManager.shared.profile?.achLifetimeRemainingLimit)
        else { return nil }
        
        return L10n.Sell.sellLimits(minText, maxText, lifetimeLimit)
    }
    
    var fromAmount: Amount?
    var toAmount: Decimal? { return fromAmount?.fiatValue }
    
    // MARK: - Aditional helpers
    var isFormValid: Bool {
        // TODO: remove after BE is ready
        return true
//        guard let amount = toAmount,
//              amount > 0,
//              selected != nil,
//              selected?.status == .statusOk
//        else {
//            return false
//        }
//        return true
    }
}
