//
//  TxViewModel.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-11.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import Foundation
import WalletKit
import UIKit

/// Representation of a transaction
protocol TxViewModel: Hashable {
    var tx: Transaction? { get }
    var swap: SwapDetail? { get }
    var currency: Currency? { get }
    var blockHeight: String { get }
    var longTimestamp: String { get }
    var status: TransactionStatus { get }
    var transactionType: Transaction.TransactionType { get }
    var direction: TransferDirection { get }
    var displayAddress: String { get }
    var comment: String? { get }
    var tokenTransferCode: String? { get }
    var gift: Gift? { get }
}

// Default and passthru values
extension TxViewModel {
    var currency: Currency? {
        if let tx = tx {
            return tx.currency
        } else if let swap = swap {
            return Store.state.currencies.first(where: { $0.code.lowercased() == swap.source.currency.lowercased() })
        } else {
            return nil
        }
    }
    
    var swapSourceCurrency: Currency? {
        let sourceCurrency = swap?.source.currency.lowercased() ?? tx?.swapSource?.currency.lowercased()
        return Store.state.currencies.first(where: { $0.code.lowercased() == sourceCurrency })
    }
    
    var swapDestinationCurrency: Currency? {
        let destinationCurrency = swap?.destination.currency.lowercased() ?? tx?.swapDestination?.currency.lowercased()
        return Store.state.currencies.first(where: { $0.code.lowercased() == destinationCurrency })
    }
    
    var status: TransactionStatus {
        if let tx = tx {
            return tx.status
        } else if let swap = swap {
            return swap.status
        }
        return .invalid
    }
    
    var transactionType: Transaction.TransactionType {
        if let tx = tx {
            return tx.transactionType
        } else if let swap = swap {
            return swap.type
        }
        return .defaultTransaction
    }
    var direction: TransferDirection {
        if let tx = tx {
            return tx.direction
        } else if let swap = swap {
            if swap.source.currency.lowercased() == currency?.code.lowercased() {
                return .sent
            } else {
                return .received
            }
        }
        
        return .received
        
    }
    var comment: String? { return tx?.comment }
    
    // BTC does not have "from" address, only "sent to" or "received at"
    var displayAddress: String {
        if let tx = tx {
            guard !tx.currency.isBitcoinCompatible || direction != .sent else {
                return tx.toAddress
            }
            
            return tx.fromAddress
        } else if let swap = swap {
            let address: String?
            switch direction {
            case .sent:
                address = swap.source.transactionId
                
            case .received:
                address = swap.destination.transactionId
                
            default:
                address = ""
            }
            return address ?? ""
        }
        
        return ""
    }
    
    var blockHeight: String {
        return tx?.blockNumber?.description ?? L10n.TransactionDetails.notConfirmedBlockHeightLabel
    }
    
    var confirmations: String {
        return "\(tx?.confirmations ?? 0)"
    }
    
    private var timestamp: Double? {
        let time: Double?
        if let tx = tx,
           tx.timestamp > 0 {
            time = tx.timestamp
        } else if let swap = swap {
            time = Double(swap.timestamp) / 1000
        } else {
            time = nil
        }
        return time
    }
    
    var longTimestamp: String {
        guard let time = timestamp else { return L10n.Transaction.justNow }
        let date = Date(timeIntervalSince1970: time)
        return DateFormatter.longDateFormatter.string(from: date)
    }
    
    var shortTimestamp: String {
        guard let time = timestamp else { return L10n.Transaction.justNow }
        let date = Date(timeIntervalSince1970: time)
        
        if date.hasEqualDay(Date()) {
            return DateFormatter.justTime.string(from: date)
        } else {
            return DateFormatter.mediumDateFormatter.string(from: date)
        }
    }
    
    var tokenTransferCode: String? {
        guard let tx = tx,
              let code = tx.metaData?.tokenTransfer,
              !code.isEmpty else { return nil }
        
        return code
    }
    
    var icon: StatusIcon {
        guard let tx = tx, let currency = currency else {
            return exchangeStatusIconDecider(status: swap?.status)
        }
        
        switch tx.transactionType {
        case .defaultTransaction, .buyTransaction:
            if tx.confirmations < currency.confirmationsUntilFinal, tx.transactionType != .buyTransaction {
                return tx.direction == .received ? .receive : .send
            } else if tx.transactionType == .buyTransaction {
                return exchangeStatusIconDecider(status: tx.status)
            } else if tx.status == .invalid {
                return tx.transactionType == .buyTransaction ? .receive : .send
            } else if tx.direction == .received || tx.direction == .recovered {
                return .receive
            }
            
        case .swapTransaction:
            return .exchange
        }
        
        return .send
    }
    
    private func exchangeStatusIconDecider(status: TransactionStatus?) -> StatusIcon {
        if transactionType == .swapTransaction { return .exchange }
        
        let status = status ?? .failed
        
        if status == .complete || status == .manuallySettled || status == .confirmed {
            return transactionType == .buyTransaction ? .receive : .send
        }
        
        if status == .pending {
            return transactionType == .buyTransaction ? .receive : .send
        }
        
        return transactionType == .buyTransaction ? .receive : .send
    }
    
    var gift: Gift? {
        return tx?.metaData?.gift
    }
}

// MARK: - Formatting

extension DateFormatter {
    static let longDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM d, yyy h:mm a")
        return df
    }()
    
    static let justTime: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("h:mm a")
        return df
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d")
        return df
    }()

    static let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return df
    }()
}

private extension String {
    var smallCondensed: String {
        let start = String(self[..<index(startIndex, offsetBy: 5)])
        let end = String(self[index(endIndex, offsetBy: -5)...])
        return start + "..." + end
    }
    
    var largeCondensed: String {
        let start = String(self[..<index(startIndex, offsetBy: 10)])
        let end = String(self[index(endIndex, offsetBy: -10)...])
        return start + "..." + end
    }
}
