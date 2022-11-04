//
//  TxDetailViewModel.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-12-20.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

/// View model of a transaction in detail view
struct TxDetailViewModel: TxViewModel, Hashable {
    
    // MARK: -
    
    let amount: String
    let fiatAmount: String
    let originalFiatAmount: String?
    let exchangeRate: String?
    let tx: Transaction?
    let swap: SwapDetail?
    
    // Ethereum-specific fields
    var gasPrice: String?
    var gasLimit: String?
    var fee: String?
    var total: String?
    
    var title: String {
        guard status != .invalid else { return L10n.TransactionDetails.titleFailed }
        switch direction {
        case .recovered:
            return L10n.TransactionDetails.titleInternal
        case .received:
            return status == .complete ? L10n.TransactionDetails.titleReceived : L10n.TransactionDetails.titleReceiving
        case .sent:
            return status == .complete ? L10n.TransactionDetails.titleSent : L10n.TransactionDetails.titleSending
        }
    }
    
    var timestampHeader: NSAttributedString {
        if status == .complete {
            let text = " " + L10n.TransactionDetails.completeTimestampHeader
            let attributedString = NSMutableAttributedString(string: text)
            let icon = NSTextAttachment()
            icon.image = #imageLiteral(resourceName: "CircleCheckSolid").withRenderingMode(.alwaysTemplate).tinted(with: LightColors.Success.one)
            icon.bounds = CGRect(x: 0, y: -2.0, width: 14.0, height: 14.0)
            let iconString = NSAttributedString(attachment: icon)
            attributedString.insert(iconString, at: 0)
            attributedString.addAttributes([.foregroundColor: LightColors.Text.two,
                                            .font: Fonts.Body.two],
                                           range: NSRange(location: iconString.length - 1, length: attributedString.length))
            return attributedString
        } else {
            return NSAttributedString(string: L10n.TransactionDetails.initializedTimestampHeader)
        }
    }
    
    var addressHeader: String {
        if direction == .sent {
            return L10n.TransactionDetails.addressToHeader
        } else {
            if tx?.currency.isBitcoinCompatible == true {
                return L10n.TransactionDetails.addressViaHeader
            } else {
                return L10n.TransactionDetails.addressFromHeader
            }
        }
    }
    
    var extraAttribute: String? {
        return tx?.extraAttribute
    }
    
    var extraAttributeHeader: String {
        if tx?.currency.isXRP == true {
            return L10n.TransactionDetails.destinationTag
        }
        if tx?.currency.isHBAR == true {
            return L10n.TransactionDetails.hederaMemo
        }
        return ""
    }
    
    var transactionHash: String {
        guard let tx = tx,
              let currency = currency
        else { return "" }
        
        return currency.isEthereumCompatible ? tx.hash : tx.hash.removing(prefix: "0x")
    }
}

extension TxDetailViewModel {
    init(tx: Transaction) {
        swap = nil
        let rate = tx.currency.state?.currentRate ?? Rate.empty
        amount = TxDetailViewModel.tokenAmount(tx: tx) ?? ""
        
        let fiatAmounts = TxDetailViewModel.fiatAmounts(tx: tx, currentRate: rate)
        fiatAmount = fiatAmounts.0
        originalFiatAmount = fiatAmounts.1
        exchangeRate = TxDetailViewModel.exchangeRateText(tx: tx)
        self.tx = tx

        if tx.direction == .sent {
            var feeAmount = tx.fee
            feeAmount.maximumFractionDigits = Amount.highPrecisionDigits
            fee = Store.state.showFiatAmounts ? feeAmount.fiatDescription : feeAmount.tokenDescription
        }
        
        let currency = tx.currency
        //TODO:CRYPTO incoming token transfers have a feeBasis with 0 values
        if let feeBasis = tx.feeBasis,
            (currency.isEthereum || (currency.isEthereumCompatible && tx.direction == .sent)) {
            let gasFormatter = ExchangeFormatter.current
            gasFormatter.maximumFractionDigits = 0
            self.gasLimit = gasFormatter.string(from: feeBasis.costFactor as NSNumber)

            let gasUnit = feeBasis.pricePerCostFactor.currency.unit(named: "gwei") ?? currency.defaultUnit
            gasPrice = feeBasis.pricePerCostFactor.tokenDescription(in: gasUnit)
        }

        // for outgoing txns for native tokens show the total amount sent including fee
        if tx.direction == .sent, tx.confirmations > 0, tx.amount.currency == tx.fee.currency {
            var totalWithFee = tx.amount + tx.fee
            totalWithFee.maximumFractionDigits = Amount.highPrecisionDigits
            total = Store.state.showFiatAmounts ? totalWithFee.fiatDescription : totalWithFee.tokenDescription
        }
    }
    
    /// The fiat exchange rate at the time of transaction
    /// Returns nil if no rate found or rate currency mismatches the current fiat currency
    private static func exchangeRateText(tx: Transaction) -> String? {
        guard let metaData = tx.metaData,
            let currentRate = tx.currency.state?.currentRate,
            !metaData.exchangeRate.isZero,
            (metaData.exchangeRateCurrency == currentRate.code || metaData.exchangeRateCurrency.isEmpty) else { return nil }
        let nf = NumberFormatter()
        nf.currencySymbol = currentRate.currencySymbol
        nf.numberStyle = .currency
        return nf.string(from: metaData.exchangeRate as NSNumber) ?? nil
    }
    
    private static func tokenAmount(tx: Transaction) -> String? {
        let amount = Amount(amount: tx.amount,
                            rate: nil,
                            maximumFractionDigits: Amount.highPrecisionDigits,
                            negative: (tx.direction == .sent && !tx.amount.isZero))
        return amount.description
    }
    
    /// Fiat amount at current exchange rate and at original rate at time of transaction (if available)
    /// Returns the token transfer description for token transfer originating transactions, as first return value.
    /// Returns (currentFiatAmount, originalFiatAmount)
    private static func fiatAmounts(tx: Transaction, currentRate: Rate) -> (String, String?) {
        let currentAmount = Amount(amount: tx.amount,
                                   rate: currentRate).description
        
        guard let metaData = tx.metaData else { return (currentAmount, nil) }
        
        guard metaData.tokenTransfer.isEmpty else {
            let tokenTransfer = L10n.Transaction.tokenTransfer(metaData.tokenTransfer.uppercased())
            return (tokenTransfer, nil)
        }
        
        // no tx-time rate
        guard !metaData.exchangeRate.isZero,
            (metaData.exchangeRateCurrency == currentRate.code || metaData.exchangeRateCurrency.isEmpty) else {
                return (currentAmount, nil)
        }
        
        let originalRate = Rate(code: currentRate.code,
                                name: currentRate.name,
                                rate: metaData.exchangeRate,
                                reciprocalCode: currentRate.reciprocalCode)
        let originalAmount = Amount(amount: tx.amount,
                                    rate: originalRate).description
        return (currentAmount, originalAmount)
    }
}
