//
//  TxStatusCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2017-12-20.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxStatusCell: UITableViewCell, Subscriber {

    // MARK: - Views
    
    private let container = UIView()
    private lazy var statusLabel: UILabel = {
        let label = UILabel(font: UIFont.customBody(size: 14.0))
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    private let statusIndicator = TxStatusIndicator(width: 238.0)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(container)
        container.addSubview(statusLabel)
        container.addSubview(statusIndicator)
    }
    
    private func addConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.small.rawValue,
                                                           left: Margins.small.rawValue,
                                                           bottom: -Margins.large.rawValue,
                                                           right: -Margins.small.rawValue))
        statusIndicator.constrain([
            statusIndicator.topAnchor.constraint(equalTo: container.topAnchor),
            statusIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            statusIndicator.widthAnchor.constraint(equalToConstant: statusIndicator.width),
            statusIndicator.heightAnchor.constraint(equalToConstant: statusIndicator.height)])
        statusLabel.constrain([
            statusLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: statusIndicator.bottomAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)])
    }
    
    // MARK: -
    
    func set(txInfo: TxDetailViewModel) {
        //TODO:CRYPTO hook up refresh logic to System/Wallet tx events IOS-1162
        func handleUpdatedTx(_ updatedTx: Transaction) {
            DispatchQueue.main.async {
                let updatedInfo = TxDetailViewModel(tx: updatedTx)
                self.update(status: updatedInfo.status)
            }
        }
        
        update(status: txInfo.status)
    }
    
    private func update(status: TransactionStatus) {
        statusIndicator.status = status
        switch status {
        case .pending:
            statusLabel.text = L10n.Transaction.pending
        case .confirmed:
            statusLabel.text = L10n.Transaction.confirming
        case .complete, .manuallySettled:
            statusLabel.text = L10n.Transaction.complete
        case .invalid:
            statusLabel.text = L10n.Transaction.invalid
        case .failed, .refunded:
            statusLabel.text = L10n.Transaction.failed
        }
    }
    
    deinit {
        Store.unsubscribe(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
