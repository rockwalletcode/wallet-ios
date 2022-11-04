//
//  ConfirmationViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-07-28.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication

class ConfirmationViewController: UIViewController, ContentBoxPresenter {
    init(amount: Amount, fee: Amount, displayFeeLevel: FeeLevel, address: String, currency: Currency,
         resolvedAddress: ResolvedAddress? = nil, shouldShowMaskView: Bool, isStake: Bool = false) {
        self.amount = amount
        self.feeAmount = fee
        self.displayFeeLevel = displayFeeLevel
        self.addressText = address
        self.currency = currency
        self.resolvedAddress = resolvedAddress
        self.isStake = isStake
        
        super.init(nibName: nil, bundle: nil)
        
        transitionDelegate.shouldShowMaskView = shouldShowMaskView
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    private let transitionDelegate = PinTransitioningDelegate()
    private let amount: Amount
    private let feeAmount: Amount
    private let displayFeeLevel: FeeLevel
    private let addressText: String
    private let currency: Currency
    private let resolvedAddress: ResolvedAddress?
    private var isStake: Bool
    
    let contentBox = UIView(color: .white)
    let blurView = UIVisualEffectView()
    let effect = UIBlurEffect(style: .dark)
    
    var successCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?
    
    private lazy var header: ModalHeaderView = {
        let view = ModalHeaderView(title: L10n.Confirmation.title)
        return view
    }()
    
    private lazy var cancel: FEButton = {
        let view = FEButton()
        view.configure(with: Presets.Button.secondary)
        view.setup(with: .init(title: L10n.Button.cancel.uppercased()))
        return view
    }()
    
    private lazy var sendButton: FEButton = {
        let view = FEButton()
        view.configure(with: Presets.Button.primary)
        view.setup(with: .init(title: L10n.Confirmation.send.uppercased()))
        return view
    }()
    
    private lazy var payLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var toLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var amountLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var address: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.one, textColor: LightColors.Text.two, numberOfLines: 1, lineBreakMode: .byTruncatingMiddle))
        return view
    }()
    
    private lazy var processingTime: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.three, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var sendLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        view.setup(with: .text(L10n.Confirmation.amountLabel))
        return view
    }()
    
    private lazy var feeLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var totalLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        view.setup(with: .text(L10n.Confirmation.totalLabel))
        return view
    }()
    
    private lazy var send: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var fee: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var total: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var resolvedAddressLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.one, textColor: LightColors.Text.two))
        return view
    }()
    
    private let resolvedAddressTitle = ResolvedAddressLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        view.addSubview(contentBox)
        contentBox.addSubview(header)
        contentBox.addSubview(payLabel)
        contentBox.addSubview(toLabel)
        contentBox.addSubview(amountLabel)
        contentBox.addSubview(address)
        contentBox.addSubview(resolvedAddressTitle)
        contentBox.addSubview(resolvedAddressLabel)
        contentBox.addSubview(processingTime)
        contentBox.addSubview(sendLabel)
        contentBox.addSubview(feeLabel)
        contentBox.addSubview(totalLabel)
        contentBox.addSubview(send)
        contentBox.addSubview(fee)
        contentBox.addSubview(total)
        contentBox.addSubview(cancel)
        contentBox.addSubview(sendButton)
    }
    
    private func addConstraints() {
        contentBox.constrain([
            contentBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentBox.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Margins.custom(6) ) ])
        
        header.constrainTopCorners(height: ViewSizes.Common.defaultCommon.rawValue)
        
        payLabel.constrain([
            payLabel.leadingAnchor.constraint(equalTo: contentBox.leadingAnchor, constant: Margins.large.rawValue),
            payLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Margins.small.rawValue) ])
        amountLabel.constrain([
            amountLabel.leadingAnchor.constraint(equalTo: payLabel.leadingAnchor),
            amountLabel.topAnchor.constraint(equalTo: payLabel.bottomAnchor, constant: Margins.extraSmall.rawValue)])
        
        toLabel.constrain([
            toLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            toLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: Margins.large.rawValue) ])
        address.constrain([
            address.leadingAnchor.constraint(equalTo: toLabel.leadingAnchor),
            address.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: Margins.extraSmall.rawValue),
            address.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue) ])
        
        if resolvedAddress != nil {
            resolvedAddressTitle.constrain([
                resolvedAddressTitle.leadingAnchor.constraint(equalTo: toLabel.leadingAnchor),
                resolvedAddressTitle.topAnchor.constraint(equalTo: address.bottomAnchor, constant: Margins.large.rawValue) ])
            resolvedAddressLabel.constrain([
                resolvedAddressLabel.leadingAnchor.constraint(equalTo: resolvedAddressTitle.leadingAnchor),
                resolvedAddressLabel.topAnchor.constraint(equalTo: resolvedAddressTitle.bottomAnchor, constant: Margins.extraSmall.rawValue),
                resolvedAddressLabel.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue) ])
        }
        
        let processingTimeAnchor = resolvedAddress == nil ? address.bottomAnchor : resolvedAddressLabel.bottomAnchor
        processingTime.constrain([
            processingTime.leadingAnchor.constraint(equalTo: address.leadingAnchor),
            processingTime.topAnchor.constraint(equalTo: processingTimeAnchor, constant: Margins.extraSmall.rawValue),
            processingTime.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue) ])
        sendLabel.constrain([
            sendLabel.leadingAnchor.constraint(equalTo: processingTime.leadingAnchor),
            sendLabel.topAnchor.constraint(equalTo: processingTime.bottomAnchor, constant: Margins.large.rawValue),
            sendLabel.trailingAnchor.constraint(lessThanOrEqualTo: send.leadingAnchor) ])
        send.constrain([
            send.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue),
            sendLabel.firstBaselineAnchor.constraint(equalTo: send.firstBaselineAnchor) ])
        feeLabel.constrain([
            feeLabel.leadingAnchor.constraint(equalTo: sendLabel.leadingAnchor),
            feeLabel.topAnchor.constraint(equalTo: sendLabel.bottomAnchor, constant: Margins.small.rawValue) ])
        fee.constrain([
            fee.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue),
            fee.firstBaselineAnchor.constraint(equalTo: feeLabel.firstBaselineAnchor) ])
        totalLabel.constrain([
            totalLabel.leadingAnchor.constraint(equalTo: feeLabel.leadingAnchor),
            totalLabel.topAnchor.constraint(equalTo: feeLabel.bottomAnchor, constant: Margins.small.rawValue) ])
        total.constrain([
            total.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue),
            total.firstBaselineAnchor.constraint(equalTo: totalLabel.firstBaselineAnchor) ])
        cancel.constrain([
            cancel.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeButton.rawValue),
            cancel.leadingAnchor.constraint(equalTo: contentBox.leadingAnchor, constant: Margins.large.rawValue),
            cancel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: Margins.huge.rawValue),
            cancel.trailingAnchor.constraint(equalTo: contentBox.centerXAnchor, constant: -Margins.small.rawValue),
            cancel.bottomAnchor.constraint(equalTo: contentBox.bottomAnchor, constant: -Margins.large.rawValue) ])
        sendButton.constrain([
            sendButton.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeButton.rawValue),
            sendButton.leadingAnchor.constraint(equalTo: contentBox.centerXAnchor, constant: Margins.small.rawValue),
            sendButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: Margins.huge.rawValue),
            sendButton.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -Margins.large.rawValue),
            sendButton.bottomAnchor.constraint(equalTo: contentBox.bottomAnchor, constant: -Margins.large.rawValue) ])
    }
    
    private func setInitialData() {
        view.backgroundColor = .clear
        
        var payLabelTitle = ""
        if isStake {
            if addressText == currency.wallet?.receiveAddress {
                payLabelTitle = L10n.Staking.unstake
            } else {
                payLabelTitle = L10n.Staking.stake
            }
        } else {
            payLabelTitle = L10n.Confirmation.send
        }
        
        payLabel.setup(with: .text(payLabelTitle))
        
        let toLabelTitle = isStake ? L10n.Confirmation.validatorAddress : L10n.Confirmation.to
        toLabel.setup(with: .text(toLabelTitle))
        
        let totalAmount = (amount.currency == feeAmount.currency) ? amount + feeAmount : amount
        let displayTotal = Amount(amount: totalAmount,
                                  rate: amount.rate,
                                  minimumFractionDigits: amount.minimumFractionDigits)
        
        let amountLabelTitle = isStake ? currency.wallet?.balance.tokenDescription ?? "" : amount.combinedDescription
        amountLabel.setup(with: .text(amountLabelTitle))
        
        address.setup(with: .text(addressText))
        
        processingTime.setup(with: .text(currency.feeText(forIndex: displayFeeLevel.rawValue)))
        
        send.setup(with: .text(amount.description))
        
        var feeLabelTitle = ""
        if amount.currency != feeAmount.currency && feeAmount.currency.isEthereum {
            feeLabelTitle = L10n.Confirmation.feeLabelETH
        } else {
            feeLabelTitle = L10n.Confirmation.feeLabel
        }
        
        feeLabel.setup(with: .text(feeLabelTitle))
        fee.setup(with: .text(feeAmount.description))
        
        total.setup(with: .text(displayTotal.description))
        
        if currency.isERC20Token {
            totalLabel.isHidden = true
            total.isHidden = true
        }
        
        cancel.tap = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: self.cancelCallback)
        }
        header.closeCallback = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: self.cancelCallback)
        }
        sendButton.tap = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: self.successCallback)
        }
        
        contentBox.layer.cornerRadius = CornerRadius.common.rawValue
        contentBox.layer.masksToBounds = true
        
        if resolvedAddress == nil {
            resolvedAddressLabel.setup(with: .text(nil))
            resolvedAddressTitle.type = nil
            resolvedAddressTitle.isHidden = true
            resolvedAddressLabel.isHidden = true
        } else {
            resolvedAddressLabel.setup(with: .text(resolvedAddress?.humanReadableAddress))
            resolvedAddressTitle.type = resolvedAddress?.type
        }
        
        if isStake {
            feeLabel.isHidden = true
            fee.isHidden = true
            
            total.isHidden = true
            totalLabel.isHidden = true
            
            sendLabel.isHidden = true
            send.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
