//
//  OrderPreviewStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class OrderPreviewStore: NSObject, BaseDataStore, OrderPreviewDataStore {
    var itemId: String?
    
    // MARK: - OrderPreviewDataStore
    var type: PreviewType?
    var to: Amount?
    var from: Decimal?
    var toCurrency: String?
    var card: PaymentCard?
    var quote: Quote?
    var networkFee: Amount? {
        guard let value = quote?.toFee,
              let fee = ExchangeFormatter.crypto.string(for: value.fee),
              let currency = Store.state.currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        
        guard let rate = quote?.toFee?.feeRate else {
            return .init(tokenString: fee, currency: currency)
        }
        
        return .init(decimalAmount: value.fee, isFiat: false, currency: currency, exchangeRate: 1 / rate)
    }
    
    var cvv: String?
    var paymentReference: String?
    var paymentstatus: AddCard.Status?
    var availablePayments: [PaymentCard.PaymentType]?
    
    // TODO: update it according to BE data
    var isAchAccount: Bool {
        return card?.type == .buyAch
    }
    
    // MARK: - Aditional helpers
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
}
