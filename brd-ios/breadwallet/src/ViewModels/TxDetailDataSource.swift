//
//  TxDetailDataSource.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2017-12-20.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxDetailDataSource: NSObject {
    
    // MARK: - Types
    
    enum Field: String {
        case amount
        case status
        case memo
        case timestamp
        case address
        case exchangeRate
        case blockHeight
        case confirmations
        case transactionId
        case gasPrice
        case gasLimit
        case fee
        case total
        case extraAttribute
        case gift
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .amount:
                return TxAmountCell.self
            case .status:
                return TxStatusCell.self
            case .memo:
                return TxMemoCell.self
            case .address, .transactionId:
                return TxAddressCell.self
            case .gift:
                return TxGiftCell.self
            default:
                return TxLabelCell.self
            }
        }
        
        func registerCell(forTableView tableView: UITableView) {
            tableView.register(cellType, forCellReuseIdentifier: self.rawValue)
        }
    }
    
    // MARK: - Vars
    
    fileprivate var fields: [Field]
    fileprivate let viewModel: TxDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: TxDetailViewModel) {
        self.viewModel = viewModel
        
        // define visible rows and order
        fields = [.amount]
        
        if viewModel.status != .complete && viewModel.status != .invalid {
            fields.append(.status)
        }
        
        fields.append(.timestamp)
        fields.append(.address)
        
        if let gift = viewModel.gift {
            if !(gift.reclaimed == true) && !(gift.claimed == true) {
                fields.append(.gift)
            }
        }
        if viewModel.comment != nil { fields.append(.memo) }
        if viewModel.gasPrice != nil { fields.append(.gasPrice) }
        if viewModel.gasLimit != nil { fields.append(.gasLimit) }
        if viewModel.fee != nil { fields.append(.fee) }
        if viewModel.total != nil { fields.append(.total) }
        if viewModel.exchangeRate != nil { fields.append(.exchangeRate) }
        if viewModel.extraAttribute != nil { fields.append(.extraAttribute) }
        
        fields.append(.blockHeight)
        fields.append(.confirmations)
        fields.append(.transactionId)
    }
    
    func registerCells(forTableView tableView: UITableView) {
        fields.forEach { $0.registerCell(forTableView: tableView) }
    }
    
    fileprivate func title(forField field: Field) -> String {
        switch field {
        case .status:
            return L10n.TransactionDetails.statusHeader
        case .memo:
            return L10n.TransactionDetails.commentsHeader
        case .address:
            return viewModel.addressHeader
        case .exchangeRate:
            return L10n.TransactionDetails.exchangeRateHeader
        case .blockHeight:
            return L10n.TransactionDetails.blockHeightLabel
        case .transactionId:
            return L10n.TransactionDetails.txHashHeader
        case .gasPrice:
            return L10n.TransactionDetails.gasPriceHeader
        case .gasLimit:
            return L10n.TransactionDetails.gasLimitHeader
        case .fee:
            return L10n.TransactionDetails.feeHeader
        case .total:
            return L10n.TransactionDetails.totalHeader
        case .confirmations:
            return L10n.TransactionDetails.confirmationsLabel
        case .extraAttribute:
            return viewModel.extraAttributeHeader
        case .gift:
            return "Gift"
        default:
            return ""
        }
    }
}

// MARK: -
extension TxDetailDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: field.rawValue,
                                                 for: indexPath)
        
        if let rowCell = cell as? TxDetailRowCell {
            rowCell.title = title(forField: field)
        }

        switch field {
        case .amount:
            guard let amountCell = cell as? TxAmountCell else { return cell }
            amountCell.set(viewModel: viewModel)
    
        case .status:
            guard let statusCell = cell as? TxStatusCell else { return cell }
            statusCell.set(txInfo: viewModel)
            
        case .memo:
            guard let memoCell = cell as? TxMemoCell else { return cell }
            memoCell.set(viewModel: viewModel, tableView: tableView)
            
        case .address:
            guard let addressCell = cell as? TxAddressCell else { return cell }
            addressCell.set(address: viewModel.displayAddress)
            
        case .transactionId:
            guard let addressCell = cell as? TxAddressCell else { return cell }
            addressCell.set(address: viewModel.transactionHash)
            
        case .confirmations:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.confirmations
            
        case .gift:
            guard let giftCell = cell as? TxGiftCell else { return cell }
            guard let gift = viewModel.gift else { return cell }
            giftCell.set(gift: gift, viewModel: viewModel)
            
        default:
            return self.tableView(tableView, labelCellForRowAt: indexPath, for: field)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, labelCellForRowAt indexPath: IndexPath, for field: Field) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: field.rawValue, for: indexPath)
        
        if let rowCell = cell as? TxDetailRowCell {
            rowCell.title = title(forField: field)
        }

        switch field {
        case .timestamp:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.titleLabel.attributedText = viewModel.timestampHeader
            labelCell.value = viewModel.longTimestamp
            
        case .exchangeRate:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.exchangeRate ?? ""
            
        case .blockHeight:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.blockHeight
            
        case .gasPrice:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.gasPrice ?? ""
            
        case .gasLimit:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.gasLimit ?? ""
            
        case .fee:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.fee ?? ""
            
        case .total:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.total ?? ""
            
        case .confirmations:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.confirmations
            
        case .extraAttribute:
            guard let labelCell = cell as? TxLabelCell else { return cell }
            labelCell.value = viewModel.extraAttribute ?? ""
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
