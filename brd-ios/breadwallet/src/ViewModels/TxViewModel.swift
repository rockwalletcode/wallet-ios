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
    var transactionType: TransactionType { get }
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
    
    var transactionType: TransactionType {
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
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
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
    
    var icon: UIImage? {
        return iconDecider(transactionType: tx?.transactionType ?? transactionType,
                           status: tx?.status ?? status,
                           direction: tx?.direction ?? direction)
    }
    
    private func iconDecider(transactionType: TransactionType, status: TransactionStatus, direction: TransferDirection) -> UIImage? {
        switch transactionType {
        case .buyTransaction, .buyAchTransaction, .sellTransaction:
            switch status {
            case .confirmed, .complete, .manuallySettled, .pending:
                return direction == .received ? Asset.receive.image : Asset.send.image
                
            case .invalid, .refunded, .failed:
                return Asset.loader.image
                
            }
            
        case .defaultTransaction:
            if direction == .received || direction == .recovered {
                return Asset.receive.image
                
            } else if direction == .sent {
                return Asset.send.image
                
            }
            
        case .swapTransaction:
            return Asset.exchange.image
        
        }
        
        return nil
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
    
    static let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return df
    }()
}
