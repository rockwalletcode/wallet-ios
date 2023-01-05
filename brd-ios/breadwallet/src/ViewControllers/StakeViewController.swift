// 
//  StakeViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-10-18.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class StakeViewController: UIViewController, Subscriber, ModalPresentable {
    fileprivate let midContentHeight: CGFloat = 90.0
    fileprivate let bakerContentHeight: CGFloat = 40.0
    fileprivate let selectBakerButtonHeight: CGFloat = 70.0
    fileprivate let removeButtonHeight: CGFloat = 30.0
    
    var presentVerifyPin: ((String, @escaping ((String) -> Void)) -> Void)?
    var onPublishSuccess: (() -> Void)?
    var presentStakeSelection: (((Baker) -> Void) -> Void)?
    
    private let currency: Currency
    private let sender: Sender
    private var baker: Baker?
    
    var parentView: UIView? //ModalPresentable
    
    private let titleLabel = UILabel(font: Fonts.Body.one)
    private let caption = UILabel(font: Fonts.Body.one)
    private let stakeButton = BRDButton(title: L10n.Staking.stake, type: .primary)
    private let selectBakerButton = UIButton()
    private let changeBakerButton = UIButton()
    private let bakerInfoView = UIView()
    private let txPendingView = UIView()
    private let loadingSpinner = UIActivityIndicatorView(style: .medium)
    private let sendingActivity = BRActivityViewController(message: L10n.TransactionDetails.titleSending)
    
    init(currency: Currency, sender: Sender) {
        self.currency = currency
        self.sender = sender
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stakeButton.isHidden = true
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(caption)
        view.addSubview(txPendingView)
        view.addSubview(selectBakerButton)
        view.addSubview(changeBakerButton)
        view.addSubview(stakeButton)
        view.addSubview(bakerInfoView)
        view.addSubview(loadingSpinner)
        
        loadingSpinner.constrain([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Margins.large.rawValue),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        caption.constrain([
            caption.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.huge.rawValue),
            caption.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            caption.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.huge.rawValue)])
        selectBakerButton.constrain([
            selectBakerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            selectBakerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            selectBakerButton.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Margins.extraHuge.rawValue),
            selectBakerButton.constraint(.height, constant: selectBakerButtonHeight) ])
        changeBakerButton.constrain([
            changeBakerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            changeBakerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            changeBakerButton.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Margins.extraHuge.rawValue),
            changeBakerButton.constraint(.height, constant: selectBakerButtonHeight) ])
        txPendingView.constrain([
            txPendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            txPendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            txPendingView.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Margins.custom(7)),
            txPendingView.constraint(.height, constant: midContentHeight) ])
        bakerInfoView.constrain([
            bakerInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            bakerInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            bakerInfoView.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Margins.large.rawValue),
            bakerInfoView.constraint(.height, constant: midContentHeight) ])
        stakeButton.constrain([
            stakeButton.constraint(.leading, toView: view, constant: Margins.large.rawValue),
            stakeButton.constraint(.trailing, toView: view, constant: -Margins.large.rawValue),
            stakeButton.constraint(toBottom: bakerInfoView, constant: Margins.extraHuge.rawValue),
            stakeButton.constraint(.height, constant: ViewSizes.Common.defaultCommon.rawValue),
            stakeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Margins.custom(5)) ])
        
        Store.subscribe(self, name: .didSelectBaker(nil), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .didSelectBaker(let baker?) = trigger {
                self?.showSelected(baker: baker)
            }
        })
        
        setInitialData()
    }
    
    private func setInitialData() {
        titleLabel.text = L10n.Staking.subTitle
        caption.text = L10n.Staking.descriptionTezos
        titleLabel.textAlignment = .center
        caption.textAlignment = .center
        caption.numberOfLines = 0
        caption.lineBreakMode = .byWordWrapping

        stakeButton.tap = stakeTapped
        selectBakerButton.tap = selectBakerTapped
        changeBakerButton.tap = selectBakerTapped
        loadingSpinner.startAnimating()
        
        //Internally, the stake modal has 4 UI states:
        // - Transaction pending - staked, pending confirm
        // - Delegate staked - staked, confirmed
        // - Empty - No delegate selected
        // - Delegate selected - delegate selected, but not staked (triggered from .didSelectBaker())
        if currency.wallet?.hasPendingTxn == true {
            showTxPending()
        } else {
            //Is Staked
            if let validatorAddress = currency.wallet?.stakedValidatorAddress {
                // Retrieve baker from Baking Bad API using stored address
                ExternalAPIClient.shared.send(BakerRequest(address: validatorAddress)) { [weak self] response in
                    guard case .success(let data) = response else { return }
                    self?.showStaked(baker: data)
                }
            //Is not staked, no baker selected
            } else {
                showBakerEmpty()
            }
        }
    }
    
    private func stakeTapped() {
        if currency.wallet?.isStaked == true {
            unstake()
        } else {
            stake()
        }
    }
    
    private func stake() {
        guard let addressText = baker?.address else { return }
        confirm(address: addressText) { [weak self] success in
            guard success else { return }
            self?.send(address: addressText)
        }
    }
    
    private func unstake() {
        guard let address = currency.wallet?.receiveAddress else { return }
        confirm(address: address) { [weak self] success in
            guard success else { return }
            self?.send(address: address)
        }
    }
    
    private func send(address: String) {
        let pinVerifier: PinVerifier = { [weak self] pinValidationCallback in
            guard let self = self else { return assertionFailure() }
            self.sendingActivity.dismiss(animated: false) {
                self.presentVerifyPin?(L10n.VerifyPin.authorize) { pin in
                    self.parent?.view.isFrameChangeBlocked = false
                    pinValidationCallback(pin)
                    self.present(self.sendingActivity, animated: false)
                }
            }
        }
        
        present(sendingActivity, animated: true)
        sender.stake(address: address, pinVerifier: pinVerifier) { [weak self] result in
            guard let self = self else { return }
            self.sendingActivity.dismiss(animated: true) {
                defer { self.sender.reset() }
                switch result {
                case .success:
                    self.onPublishSuccess?()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .creationError(let message):
                    self.showAlert(title: L10n.Alerts.sendFailure, message: message)
                case .publishFailure(let code, let message):
                    self.showAlert(title: L10n.Alerts.sendFailure, message: "\(message) (\(code))")
                case .insufficientGas(let rpcErrorMessage):
                    print("insufficientGas: \(rpcErrorMessage)")
                }
            }
        }
    }
    
    private func confirm(address: String, callback: @escaping (Bool) -> Void) {
        let confirmation = ConfirmationViewController(amount: Amount.zero(currency),
                                                      fee: Amount.zero(currency),
                                                      displayFeeLevel: FeeLevel.regular,
                                                      address: address,
                                                      currency: currency,
                                                      shouldShowMaskView: true,
                                                      isStake: true)
        let transitionDelegate = PinTransitioningDelegate()
        transitionDelegate.shouldShowMaskView = true
        confirmation.transitioningDelegate = transitionDelegate
        confirmation.modalPresentationStyle = .overFullScreen
        confirmation.modalPresentationCapturesStatusBarAppearance = true
        confirmation.successCallback = { callback(true) }
        confirmation.cancelCallback = { callback(false) }
        present(confirmation, animated: true, completion: nil)
    }
    
    private func selectBakerTapped() {
        let stakeSelectViewController = SelectBakerViewController(currency: currency)
        let transitionDelegate = ModalTransitionDelegate(type: .regular)
        stakeSelectViewController.transitioningDelegate = transitionDelegate
        stakeSelectViewController.modalPresentationStyle = .overFullScreen
        stakeSelectViewController.modalPresentationCapturesStatusBarAppearance = true
        let vc = ModalViewController(childViewController: stakeSelectViewController)
        present(vc, animated: true, completion: nil)
    }
    
    private func showTxPending() {
        loadingSpinner.stopAnimating()
        selectBakerButton.isHidden = true
        changeBakerButton.isHidden = true
        stakeButton.isHidden = true
        bakerInfoView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.bakerInfoView.alpha = 1
        }
        buildTxPendingView()
    }
    
    private func showBakerEmpty() {
        loadingSpinner.isHidden = true
        selectBakerButton.isHidden = false
        selectBakerButton.alpha = 0
        changeBakerButton.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.stakeButton.alpha = 0
            self?.bakerInfoView.alpha = 0
            self?.selectBakerButton.alpha = 1
        } completion: { [weak self] _ in
            self?.stakeButton.isHidden = true
            self?.stakeButton.alpha = 1
            self?.bakerInfoView.isHidden = true
            self?.bakerInfoView.alpha = 1
            self?.selectBakerButton.isHidden = false
        }
        buildSelectBakerButton()
    }
    
    private func showSelected(baker: Baker?) {
        self.baker = baker
        selectBakerButton.isHidden = true
        stakeButton.isHidden = false
        stakeButton.title = L10n.Staking.stake
        changeBakerButton.isHidden = false
        
        buildChangeBakerButton(with: baker)
    }
    
    private func showStaked(baker: Baker?) {
        self.baker = baker
        loadingSpinner.stopAnimating()
        selectBakerButton.isHidden = true
        changeBakerButton.isHidden = true
        stakeButton.isHidden = false
        stakeButton.title = L10n.Staking.unstake
        bakerInfoView.isHidden = false
        bakerInfoView.alpha = 0.0
        buildInfoView(with: baker)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bakerInfoView.alpha = 1.0
        }
    }
    
    private func buildChangeBakerButton(with baker: Baker?) {
        changeBakerButton.subviews.forEach { $0.removeFromSuperview() }
        changeBakerButton.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        changeBakerButton.layer.masksToBounds = true
        changeBakerButton.backgroundColor = currency.colors.0
        let bakerName = UILabel(font: Fonts.Title.six, color: .white)
        let bakerFee = UILabel(font: Fonts.Body.three, color: UIColor.white.withAlphaComponent(0.6))
        let bakerROI = UILabel(font: Fonts.Title.six, color: .white)
        let bakerROIHeader = UILabel(font: Fonts.Body.three, color: UIColor.white.withAlphaComponent(0.6))
        let bakerIcon = UIImageView()
        let bakerIconLoadingView = UIView()
        let arrow = UIImageView()
        
        arrow.image = Asset.rightArrow.image.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = LightColors.Text.one
        
        let feeText = baker?.feeString ?? ""
        bakerFee.text = "\(L10n.Staking.feeHeader) \(feeText)"
        bakerROI.text = baker?.roiString
        bakerROI.adjustsFontSizeToFitWidth = true
        bakerROI.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bakerROIHeader.text = L10n.Staking.roiHeader
        bakerName.adjustsFontSizeToFitWidth = true
        bakerName.text = baker?.name
        
        bakerIcon.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIcon.layer.masksToBounds = true
        bakerIcon.backgroundColor = .white
        
        bakerIconLoadingView.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIconLoadingView.layer.masksToBounds = true
        bakerIconLoadingView.backgroundColor = .white
        
        let iconLoadingSpinner = UIActivityIndicatorView(style: .medium)
        bakerIconLoadingView.addSubview(iconLoadingSpinner)
        iconLoadingSpinner.startAnimating()
        
        changeBakerButton.addSubview(bakerName)
        changeBakerButton.addSubview(bakerFee)
        changeBakerButton.addSubview(bakerROI)
        changeBakerButton.addSubview(bakerROIHeader)
        changeBakerButton.addSubview(bakerIcon)
        changeBakerButton.addSubview(bakerIconLoadingView)
        changeBakerButton.addSubview(arrow)
        
        bakerIcon.constrain([
            bakerIcon.topAnchor.constraint(equalTo: changeBakerButton.topAnchor, constant: Margins.large.rawValue),
            bakerIcon.leadingAnchor.constraint(equalTo: changeBakerButton.leadingAnchor, constant: Margins.large.rawValue),
            bakerIcon.heightAnchor.constraint(equalToConstant: bakerContentHeight),
            bakerIcon.widthAnchor.constraint(equalToConstant: bakerContentHeight) ])
        bakerIconLoadingView.constrain([
            bakerIconLoadingView.topAnchor.constraint(equalTo: changeBakerButton.topAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.leadingAnchor.constraint(equalTo: changeBakerButton.leadingAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.heightAnchor.constraint(equalToConstant: bakerContentHeight),
            bakerIconLoadingView.widthAnchor.constraint(equalToConstant: bakerContentHeight) ])
        iconLoadingSpinner.constrain([
            iconLoadingSpinner.centerXAnchor.constraint(equalTo: bakerIconLoadingView.centerXAnchor),
            iconLoadingSpinner.centerYAnchor.constraint(equalTo: bakerIconLoadingView.centerYAnchor)])
        bakerName.constrain([
            bakerName.topAnchor.constraint(equalTo: changeBakerButton.topAnchor, constant: Margins.large.rawValue),
            bakerName.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue),
            bakerName.trailingAnchor.constraint(equalTo: bakerROI.leadingAnchor, constant: -Margins.large.rawValue) ])
        bakerFee.constrain([
            bakerFee.topAnchor.constraint(equalTo: bakerName.bottomAnchor),
            bakerFee.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue) ])
        bakerROI.constrain([
            bakerROI.topAnchor.constraint(equalTo: bakerName.topAnchor),
            bakerROI.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -Margins.large.rawValue) ])
        bakerROIHeader.constrain([
            bakerROIHeader.topAnchor.constraint(equalTo: bakerROI.bottomAnchor),
            bakerROIHeader.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -Margins.large.rawValue) ])
        arrow.constrain([
            arrow.centerYAnchor.constraint(equalTo: changeBakerButton.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: changeBakerButton.trailingAnchor, constant: -Margins.large.rawValue),
            arrow.heightAnchor.constraint(equalToConstant: 10),
            arrow.widthAnchor.constraint(equalToConstant: 7) ])
        
        if let imageUrl = baker?.logo, !imageUrl.isEmpty {
            UIImage.fetchAsync(from: imageUrl) { [weak bakerIcon] (image, url) in
                // Reusable cell, ignore completion from a previous load call
                if url?.absoluteString == imageUrl {
                    bakerIcon?.image = image
                    UIView.animate(withDuration: 0.2) {
                        bakerIconLoadingView.alpha = 0.0
                    }
                }
            }
        }
    }
    
    private func buildSelectBakerButton() {
        selectBakerButton.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        selectBakerButton.layer.masksToBounds = true
        selectBakerButton.backgroundColor = currency.colors.0
        let currencyIcon = UIImageView()
        currencyIcon.image = currency.imageNoBackground
        currencyIcon.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        currencyIcon.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        currencyIcon.layer.masksToBounds = true
        currencyIcon.tintColor = .white
        let selectBakerLabel = UILabel(font: Fonts.Title.six)
        selectBakerLabel.textColor = .black
        selectBakerLabel.text = L10n.Staking.selectBakerTitle
        let arrow = UIImageView()
        arrow.image = Asset.rightArrow.image.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = .white
        
        selectBakerButton.addSubview(currencyIcon)
        selectBakerButton.addSubview(selectBakerLabel)
        selectBakerButton.addSubview(arrow)
        
        currencyIcon.constrain([
            currencyIcon.centerYAnchor.constraint(equalTo: selectBakerButton.centerYAnchor),
            currencyIcon.leadingAnchor.constraint(equalTo: selectBakerButton.leadingAnchor, constant: Margins.large.rawValue),
            currencyIcon.heightAnchor.constraint(equalToConstant: bakerContentHeight),
            currencyIcon.widthAnchor.constraint(equalToConstant: bakerContentHeight) ])
        selectBakerLabel.constrain([
            selectBakerLabel.topAnchor.constraint(equalTo: currencyIcon.topAnchor),
            selectBakerLabel.leadingAnchor.constraint(equalTo: currencyIcon.trailingAnchor, constant: Margins.large.rawValue),
            selectBakerLabel.heightAnchor.constraint(equalToConstant: bakerContentHeight) ])
        arrow.constrain([
            arrow.centerYAnchor.constraint(equalTo: selectBakerButton.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: selectBakerButton.trailingAnchor, constant: -Margins.large.rawValue),
            arrow.heightAnchor.constraint(equalToConstant: 10),
            arrow.widthAnchor.constraint(equalToConstant: 7) ])
    }
    
    private func buildInfoView(with baker: Baker?) {
        bakerInfoView.subviews.forEach {$0.removeFromSuperview()}
        let bakerName = UILabel(font: Fonts.Body.one, color: .darkGray)
        let bakerFee = UILabel(font: Fonts.Body.three, color: .lightGray)
        let bakerROI = UILabel(font: Fonts.Body.one, color: .darkGray)
        let bakerROIHeader = UILabel(font: Fonts.Body.three, color: .lightGray)
        bakerName.adjustsFontSizeToFitWidth = true
        let bakerIcon = UIImageView()
        let bakerIconLoadingView = UIView()
        
        bakerName.text = baker?.name
        let feeText = baker?.feeString ?? ""
        bakerFee.text = "\(L10n.Staking.feeHeader) \(feeText)"
        bakerROI.text = baker?.roiString
        bakerROIHeader.text = L10n.Staking.roiHeader
        
        bakerIcon.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIcon.layer.masksToBounds = true
        
        bakerIconLoadingView.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIconLoadingView.layer.masksToBounds = true
        bakerIconLoadingView.backgroundColor = .lightGray
        
        let iconLoadingSpinner = UIActivityIndicatorView(style: .medium)
        bakerIconLoadingView.addSubview(iconLoadingSpinner)
        iconLoadingSpinner.constrain([
            iconLoadingSpinner.centerXAnchor.constraint(equalTo: bakerIconLoadingView.centerXAnchor),
            iconLoadingSpinner.centerYAnchor.constraint(equalTo: bakerIconLoadingView.centerYAnchor)])
        iconLoadingSpinner.startAnimating()
        
        bakerInfoView.addSubview(bakerName)
        bakerInfoView.addSubview(bakerFee)
        bakerInfoView.addSubview(bakerROI)
        bakerInfoView.addSubview(bakerROIHeader)
        bakerInfoView.addSubview(bakerIcon)
        bakerInfoView.addSubview(bakerIconLoadingView)
        
        bakerIcon.constrain([
            bakerIcon.topAnchor.constraint(equalTo: bakerInfoView.topAnchor, constant: Margins.large.rawValue),
            bakerIcon.leadingAnchor.constraint(equalTo: bakerInfoView.leadingAnchor, constant: Margins.large.rawValue),
            bakerIcon.heightAnchor.constraint(equalToConstant: bakerContentHeight),
            bakerIcon.widthAnchor.constraint(equalToConstant: bakerContentHeight) ])
        bakerIconLoadingView.constrain([
            bakerIconLoadingView.topAnchor.constraint(equalTo: bakerInfoView.topAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.leadingAnchor.constraint(equalTo: bakerInfoView.leadingAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.heightAnchor.constraint(equalToConstant: bakerContentHeight),
            bakerIconLoadingView.widthAnchor.constraint(equalToConstant: bakerContentHeight) ])
        bakerName.constrain([
            bakerName.topAnchor.constraint(equalTo: bakerInfoView.topAnchor, constant: Margins.large.rawValue),
            bakerName.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue) ])
        bakerFee.constrain([
            bakerFee.topAnchor.constraint(equalTo: bakerName.bottomAnchor),
            bakerFee.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue) ])
        bakerROI.constrain([
            bakerROI.topAnchor.constraint(equalTo: bakerName.topAnchor),
            bakerROI.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.extraHuge.rawValue) ])
        bakerROIHeader.constrain([
            bakerROIHeader.topAnchor.constraint(equalTo: bakerROI.bottomAnchor),
            bakerROIHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.extraHuge.rawValue) ])
        
        if let imageUrl = baker?.logo, !imageUrl.isEmpty {
            UIImage.fetchAsync(from: imageUrl) { [weak bakerIcon] (image, url) in
                // Reusable cell, ignore completion from a previous load call
                if url?.absoluteString == imageUrl {
                    bakerIcon?.image = image
                    UIView.animate(withDuration: 0.2) {
                        bakerIconLoadingView.alpha = 0.0
                    }
                }
            }
        }
    }
    
    private func buildTxPendingView() {
        bakerInfoView.subviews.forEach {$0.removeFromSuperview()}
        let pendingSpinner = UIActivityIndicatorView(style: .medium)
        let pendingLabel = UILabel(font: Fonts.Title.five, color: .darkGray)

        pendingLabel.text = L10n.Staking.pendingTransaction
        
        pendingSpinner.startAnimating()
        
        bakerInfoView.addSubview(pendingSpinner)
        bakerInfoView.addSubview(pendingLabel)
        
        pendingSpinner.constrain([
            pendingSpinner.leadingAnchor.constraint(equalTo: bakerInfoView.leadingAnchor, constant: Margins.custom(5)),
            pendingSpinner.centerYAnchor.constraint(equalTo: bakerInfoView.centerYAnchor)])
        pendingLabel.constrain([
            pendingLabel.centerYAnchor.constraint(equalTo: pendingSpinner.centerYAnchor),
            pendingLabel.leadingAnchor.constraint(equalTo: pendingSpinner.trailingAnchor, constant: Margins.large.rawValue) ])
    }
}

// MARK: - ModalDisplayable

extension StakeViewController: ModalDisplayable {
    var faqArticleId: String? {
        return "staking"
    }
    
    var faqCurrency: Currency? {
        return currency
    }

    var modalTitle: String {
        return "\(L10n.Staking.stakingTitle) \(currency.code)"
    }
}
