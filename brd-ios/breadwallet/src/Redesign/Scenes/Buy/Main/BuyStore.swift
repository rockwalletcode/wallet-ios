//
//  BuyStore.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

class BuyStore: NSObject, BaseDataStore, BuyDataStore {
    
    // ExchangeRateDaatStore
    var fromCode: String { return C.usdCurrencyCode }
    var toCode: String { toAmount?.currency.code ?? "" }
    var quoteRequestData: QuoteRequestData {
        return .init(from: fromCode.lowercased(),
                     to: toCode,
                     type: .buy(paymentMethod))
    }
    
    // MARK: - BuyDataStore
    var itemId: String?
    
    var from: Decimal?
    var to: Decimal?
    var values: BuyModels.Amounts.ViewAction = .init()
    var paymentMethod: PaymentCard.PaymentType? = .buyCard
    var publicToken: String?
    var mask: String?
    
    var limits: String {
        guard let quote = quote else { return "" }
        let minText = ExchangeFormatter.fiat.string(for: quote.minimumValue) ?? ""
        let maxText = ExchangeFormatter.fiat.string(for: quote.maximumValue) ?? ""
        let lifetimeLimit = ExchangeFormatter.fiat.string(for: UserManager.shared.profile?.achLifetimeRemainingLimit) ?? ""
        return paymentMethod == .buyAch ? L10n.Buy.achLimits(minText, maxText, lifetimeLimit) : L10n.Buy.buyLimits(minText, maxText)
    }
    
    override init() {
        super.init()
        
        let selectedCurrency: Currency
        
        if paymentMethod == .buyAch {
            guard let currency = Store.state.currencies.first(where: { $0.code == C.USDC }) else { return }
            selectedCurrency = currency
        } else {
            guard let currency = Store.state.currencies.first(where: { $0.code.lowercased() == C.BTC.lowercased() }) ?? Store.state.currencies.first  else { return  }
            selectedCurrency = currency
        }
        
        toAmount = .zero(selectedCurrency)
    }
    
    var feeAmount: Amount? {
        guard let value = quote?.toFee,
              let currency = currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        return .init(decimalAmount: value.fee, isFiat: false, currency: currency, exchangeRate: quote?.exchangeRate)
    }
    
    var toAmount: Amount?
    
    var paymentCard: PaymentCard?
    var allPaymentCards: [PaymentCard]?
    
    var quote: Quote?
    
    var currencies: [Currency] = Store.state.currencies
    var supportedCurrencies: [SupportedCurrency]?
    
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    var autoSelectDefaultPaymentMethod = true
    
    // MARK: - Aditional helpers
    
    var isFormValid: Bool {
        guard let amount = toAmount,
              amount.tokenValue > 0,
              paymentCard != nil,
              feeAmount != nil
        else {
            return false
        }
        return true
    }
}
