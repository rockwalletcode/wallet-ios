//
//  TxListViewModel.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-13.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

/// View model of a transaction in list view
struct TxListViewModel: TxViewModel, Hashable {
    
    // MARK: - Properties
    
    var tx: Transaction?
    var swap: SwapDetail?

    func amount(showFiatAmounts: Bool, rate: Rate) -> String {
        if let tx = tx {
            var amount = tx.amount

            // This is the originating tx of a token transfer, so the amount is 0 but we want to show the fee
            if tokenTransferCode != nil {
                amount = tx.fee
            }

            let text = Amount(amount: amount,
                              rate: showFiatAmounts ? rate : nil,
                              negative: (tx.direction == .sent)).description
            return text
        } else if let swap = swap {
            if swap.source.currency == C.usdCurrencyCode,
               swap.status == .pending {
            }
            
            let amount = ExchangeFormatter.crypto.string(for: swap.destination.currencyAmount) ?? ""
            return "\(amount) \(swap.destination.currency)"
        } else {
            return .init()
        }
    }
    
    func shortDescription(for currency: Currency) -> String {
        switch transactionType {
        case .defaultTransaction:
            return handleDefaultTransactions()
            
        case .swapTransaction:
            return handleSwapTransactions(for: currency)
            
        case .sellTransaction:
            return handleSellTransactions()
            
        default:
            return handleBuyTransactions()
        }
    }
    
    private func handleDefaultTransactions() -> String {
        guard let tx = tx else { return "" }
        
        switch status {
        case .invalid:
            return L10n.Transaction.failed
            
        case .complete:
            if tx.direction == .sent {
                return L10n.TransactionDetails.sent(tx.toAddress)
            } else if tx.direction == .received {
                return L10n.TransactionDetails.received(tx.fromAddress)
            }
            return ""
            
        default:
            guard let currency = currency else { return "" }
            return "\(confirmations)/\(currency.confirmationsUntilFinal) " + L10n.TransactionDetails.confirmationsLabel
        }
    }
    
    private func handleBuyTransactions() -> String {
        let isBuy = transactionType == .buyTransaction
        
        switch status {
        case .invalid, .failed, .refunded:
            return isBuy ? L10n.Transaction.purchaseFailed : L10n.Transaction.purchaseFailedWithAch
    
        case .complete, .manuallySettled, .confirmed:
            return isBuy ? L10n.Transaction.purchased : L10n.Transaction.purchasedWithAch
            
        default:
            return isBuy ? L10n.Transaction.pendingPurchase : L10n.Transaction.pendingPurchaseWithAch
        }
    }
    
    private func handleSellTransactions() -> String {
        // TODO: update texts
        switch status {
        case .invalid, .failed, .refunded:
            return "Widrawal failed"
    
        case .complete, .manuallySettled, .confirmed:
            return "Widrawed to bank account"
            
        default:
            return "Pending withdraw with ACH"
        }
    }
    
    private func handleSwapTransactions(for currency: Currency) -> String {
        let sourceCurrency = swapSourceCurrency?.code.uppercased() ?? ""
        let destinationCurrency = swapDestinationCurrency?.code.uppercased() ?? ""
        let isOnSource = currency.code.uppercased() == destinationCurrency
        let swapString = isOnSource ? "from \(sourceCurrency)" : "to \(destinationCurrency)"
        
        switch status {
        case .complete, .manuallySettled:
            return "\(L10n.Transaction.swapped) \(swapString)"
            
        case .pending:
            return "\(L10n.Transaction.pendingSwap) \(swapString)"
            
        case .failed, .refunded:
            return "\(L10n.Transaction.failedSwap) \(swapString)"
            
        default:
            return ""
        }
    }
}
