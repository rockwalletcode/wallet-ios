//
//  SendViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-30.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication
import WalletKit

typealias PresentScan = ((@escaping ScanCompletion) -> Void)

// swiftlint:disable type_body_length
class SendViewController: UIViewController, Subscriber, ModalPresentable {
    // MARK: - Public
    
    var presentScan: PresentScan?
    var presentVerifyPin: ((String, @escaping ((String) -> Void)) -> Void)?
    var onPublishSuccess: (() -> Void)?
    var parentView: UIView? //ModalPresentable
    
    init(sender: Sender, initialRequest: PaymentRequest? = nil) {
        let currency = sender.wallet.currency
        self.currency = currency
        self.sender = sender
        self.initialRequest = initialRequest
        self.balance = currency.state?.balance ?? Amount.zero(currency)
        addressCell = AddressCell(currency: currency)
        amountView = AmountViewController(currency: currency, isPinPadExpandedAtLaunch: false)
        attributeCell = AttributeCell(currency: currency)
        
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private
    
    deinit {
        Store.unsubscribe(self)
        NotificationCenter.default.removeObserver(self)
    }

    private let amountView: AmountViewController
    private let addressCell: AddressCell
    private let attributeCell: AttributeCell?
    private let memoCell = DescriptionSendCell(placeholder: L10n.Send.descriptionLabel)
    private let sendButton = BRDButton(title: L10n.Send.sendLabel, type: .secondary)
    private let currencyBorder = UIView(color: LightColors.Outline.one)
    private var currencySwitcherHeightConstraint: NSLayoutConstraint?
    private var pinPadHeightConstraint: NSLayoutConstraint?
    private var attributeCellHeight: NSLayoutConstraint?
    private let confirmTransitioningDelegate = PinTransitioningDelegate()
    private let sendingActivity = BRActivityViewController(message: L10n.TransactionDetails.titleSending)
    private let sender: Sender
    private let currency: Currency
    private let initialRequest: PaymentRequest?
    private var paymentProtocolRequest: PaymentProtocolRequest?
    private var didIgnoreUsedAddressWarning = false
    private var didIgnoreIdentityNotCertified = false
    private let verticalButtonPadding: CGFloat = 32.0
    private let buttonSize = CGSize(width: 52.0, height: 32.0)
    private var feeLevel: FeeLevel = .regular {
        didSet {
            updateFees()
        }
    }
    private var balance: Amount
    private var maximum: Amount? {
        didSet {
            sender.maximum = maximum
            amountView.maximum = maximum
            if let max = maximum, isSendingMax {
                amountView.forceUpdateAmount(amount: max)
            }
        }
    }
    private var minimum: Amount? {
        didSet { sender.minimum = minimum }
    }
    
    private var amount: Amount? {
        didSet {
            if amount != maximum {
                isSendingMax = false
            }
            if oldValue != amount {
                updateFees()
            }
        }
    }
    private var address: String? {
        if resolvedAddress != nil {
            return resolvedAddress?.cryptoAddress
        }
        if let protoRequest = paymentProtocolRequest {
            return protoRequest.primaryTarget?.description
        } else {
            return addressCell.address
        }
    }
    
    private var resolvedAddress: ResolvedAddress?
    
    private var currentFeeBasis: TransferFeeBasis?
    private var isSendingMax = false {
        didSet {
            amountView.isSendViewSendingMax = isSendingMax
        }
    }
    
    private var timer: Timer?
    
    private func startTimer() {
        guard timer?.isValid != true else { return }
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 15,
                                     target: self,
                                     selector: #selector(updateFees),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LightColors.Background.one
        view.addSubview(addressCell)
        view.addSubview(memoCell)
        view.addSubview(sendButton)
        sendButton.isEnabled = false

        addressCell.constrainTopCorners(height: SendCell.defaultHeight)

        var addressGroupBottom: NSLayoutYAxisAnchor
        if currency.attributeDefinition != nil, let tagCell = attributeCell {
            view.addSubview(tagCell)
            attributeCellHeight = tagCell.heightAnchor.constraint(equalToConstant: SendCell.defaultHeight)
            tagCell.constrain([
                tagCell.leadingAnchor.constraint(equalTo: addressCell.leadingAnchor),
                tagCell.topAnchor.constraint(equalTo: addressCell.bottomAnchor),
                tagCell.trailingAnchor.constraint(equalTo: addressCell.trailingAnchor),
                attributeCellHeight])
            addressGroupBottom = tagCell.bottomAnchor
        } else {
            addressGroupBottom = addressCell.bottomAnchor
        }
        
        addChildViewController(amountView, layout: {
            amountView.view.constrain([
                amountView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                amountView.view.topAnchor.constraint(equalTo: addressGroupBottom, constant: Margins.large.rawValue),
                amountView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor) ])
        })

        memoCell.constrain([
            memoCell.widthAnchor.constraint(equalTo: amountView.view.widthAnchor),
            memoCell.topAnchor.constraint(equalTo: amountView.view.bottomAnchor),
            memoCell.leadingAnchor.constraint(equalTo: amountView.view.leadingAnchor),
            memoCell.heightAnchor.constraint(equalTo: memoCell.textView.heightAnchor, constant: Margins.extraHuge.rawValue) ])

        memoCell.accessoryView.constrain([
                memoCell.accessoryView.constraint(.width) ])

        sendButton.constrain([
            sendButton.constraint(.leading, toView: view, constant: Margins.large.rawValue),
            sendButton.constraint(.trailing, toView: view, constant: -Margins.large.rawValue),
            sendButton.constraint(toBottom: memoCell, constant: verticalButtonPadding),
            sendButton.constraint(.height, constant: ViewSizes.Common.defaultCommon.rawValue),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: E.isIPhoneX ? -Margins.custom(5) : -Margins.large.rawValue) ])
        addButtonActions()
        Store.subscribe(self,
                        selector: { [weak self] oldState, newState in
                            guard let self = self else { return false }
                            return oldState[self.currency]?.balance != newState[self.currency]?.balance },
                        callback: { [weak self] in
                            guard let self = self else { return }
                            if let balance = $0[self.currency]?.balance {
                                self.balance = balance
                            }
        })
        
        addAddressChangeListener()
        sender.updateNetworkFees()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        if let initialRequest = initialRequest {
            handleRequest(initialRequest)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    private func addAddressChangeListener() {
        addressCell.textDidChange = { [weak self] text in
            guard let self = self else { return }
            guard let text = text else { return }
            guard self.currency.isValidAddress(text) else { return }
            self.updateFees()
        }
    }

    // MARK: - Actions
    
    private func addButtonActions() {
        addressCell.paste.addTarget(self, action: #selector(SendViewController.pasteTapped), for: .touchUpInside)
        addressCell.scan.addTarget(self, action: #selector(SendViewController.scanTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        memoCell.didReturn = { textView in
            textView.resignFirstResponder()
        }
        memoCell.didBeginEditing = { [weak self] in
            self?.amountView.closePinPad()
        }
        addressCell.didBeginEditing = { [weak self] in
            self?.amountView.closePinPad()
        }
        addressCell.didReceivePaymentRequest = { [weak self] request in
            self?.handleRequest(request)
        }
        addressCell.didReceiveResolvedAddress = { [weak self] result, type in
            DispatchQueue.main.async {
                self?.handleResolvableResponse(result, type: type, id: self?.addressCell.address ?? "", shouldShowError: true)
            }
        }
        amountView.balanceTextForAmount = { [weak self] amount, rate in
            return self?.balanceTextForAmount(amount, rate: rate)
        }
        amountView.didUpdateAmount = { [weak self] amount in
            self?.amount = amount
        }
        amountView.didUpdateFee = { [weak self] fee in
            self?.feeLevel = fee
        }
        
        amountView.didChangeFirstResponder = { [weak self] isFirstResponder in
            if isFirstResponder {
                self?.memoCell.textView.resignFirstResponder()
                self?.addressCell.textField.resignFirstResponder()
                self?.attributeCell?.textField.resignFirstResponder()
            }
        }
        
        attributeCell?.didBeginEditing = { [weak self] in
            self?.amountView.closePinPad()
        }
        
        amountView.didTapMax = { [weak self] in
            guard let max = self?.maximum else {
                //This is highly unlikely to be reached because the button should be disabled
                //if a maximum doesn't exist
                self?.showErrorMessage(L10n.Send.Error.maxError)
                return
            }
            self?.isSendingMax = true
            self?.amountView.forceUpdateAmount(amount: max)
        }
    }
    
    @objc private func updateFees() {
        guard let amount = amount else { return }
        guard let address = address, !address.isEmpty else { return _ = handleValidationResult(.invalidAddress) }
        
        sender.estimateFee(address: address, amount: amount, tier: feeLevel, isStake: false) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fee):
                    self?.currentFeeBasis = fee
                    self?.sendButton.isEnabled = true
                    
                case .failure:
                    self?.sendButton.isEnabled = false
                    self?.showAlert(title: L10n.Alert.ethBalance,
                                    message: L10n.ErrorMessages.ethBalanceLow,
                                    buttonLabel: L10n.Button.ok)
                }
                
                self?.amountView.updateBalanceLabel()
            }
        }
    }

    // returns Balance Text, Fee Text and isUserInteractionEnabled for balanceLabel
    private func balanceTextForAmount(_ amount: Amount?, rate: Rate?) -> (NSAttributedString?, NSAttributedString?, Bool) {
        //Use maximum if available, otherwise use balance
        let balanceAmount = Amount(amount: maximum ?? balance, rate: rate, minimumFractionDigits: 0)
        var feeOutput = ""
        if let amount = amount, !amount.isZero, let feeBasis = currentFeeBasis {
            var feeAmount = Amount(cryptoAmount: feeBasis.fee, currency: sender.wallet.feeCurrency)
            feeAmount.rate = rate
            let feeText = feeAmount.description
            feeOutput = L10n.Send.fee(feeText)
        }
        
        let balanceLabelattributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Fonts.Body.two,
            NSAttributedString.Key.foregroundColor: LightColors.Text.two
        ]
        
        var balanceAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: Fonts.Subtitle.two ]
        if isSendingMax || maximum == nil {
            balanceAttributes[NSAttributedString.Key.foregroundColor] = LightColors.Text.two
        } else {
            balanceAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            balanceAttributes[NSAttributedString.Key.foregroundColor] = LightColors.Text.two
        }
        
        let feeAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Fonts.Body.two,
            NSAttributedString.Key.foregroundColor: LightColors.Text.two
        ]
        
        let balanceOutput = NSMutableAttributedString()
        balanceOutput.append(NSAttributedString(string: isSendingMax ? L10n.Send.sendingMax : L10n.Send.balanceString, attributes: balanceLabelattributes))
        balanceOutput.append(NSAttributedString(string: balanceAmount.description, attributes: balanceAttributes))
        return (balanceOutput, NSAttributedString(string: feeOutput, attributes: feeAttributes), !isSendingMax)
    }
    
    @objc private func pasteTapped() {
        guard let pasteboard = UIPasteboard.general.string, !pasteboard.utf8.isEmpty else {
            return showAlert(title: L10n.Alert.error, message: L10n.Send.emptyPasteboard, buttonLabel: L10n.Button.ok)
        }
        
        if let resolver = ResolvableFactory.resolver(pasteboard) {
            self.addressCell.setContent(pasteboard)
            self.addressCell.showResolvingSpinner()
            resolver.fetchAddress(forCurrency: currency) { response in
                DispatchQueue.main.async {
                    self.handleResolvableResponse(response, type: resolver.type, id: pasteboard, shouldShowError: true)
                }
            }
            return
        }
        
        guard let request = PaymentRequest(string: pasteboard, currency: currency) else {
            let message = L10n.Send.invalidAddressOnPasteboard(currency.name)
            return showAlert(title: L10n.Send.invalidAddressTitle, message: message, buttonLabel: L10n.Button.ok)
        }
        self.paymentProtocolRequest = nil
        handleRequest(request)
    }
    
    private func handleResolvableResponse(_ response: Result<(String, String?), ResolvableError>,
                                          type: ResolvableType,
                                          id: String,
                                          shouldShowError: Bool) {
        switch response {
        case .success(let addressDetails):
            let address = addressDetails.0
            let tag = addressDetails.1
            guard currency.isValidAddress(address) else {
                let message = L10n.Send.invalidAddressMessage(currency.name)
                showAlert(title: L10n.Send.invalidAddressTitle, message: message, buttonLabel: L10n.Button.ok)
                resetPayId()
                return
            }
            
            //Here we have a valid address from PayID
            //After this event, the addresscell should be in an un-editable state similar
            //to when a payment request is recieved
            self.resolvedAddress = ResolvedAddress(humanReadableAddress: id,
                                                   cryptoAddress: address,
                                                   label: type.label,
                                                   type: type)
            if tag != nil {
                self.hideDestinationTag()
            }
            addressCell.showResolveableState(type: type, address: address)
            addressCell.hideActionButtons()
            if let destinationTag = tag {
                attributeCell?.setContent(destinationTag)
            }
        case .failure:
            if shouldShowError {
                switch type {
                case .fio:
                    showErrorMessage(L10n.Send.fioInvalid)
                case .payId:
                    showErrorMessage(L10n.Send.payIdInvalid)
                case .uDomains:
                    showErrorMessage(L10n.UDomains.invalid)
                default:
                    showErrorMessage(L10n.UDomains.invalid)
                }
            }
            addressCell.hideResolveableState()
        }
    }
    
    private func hideDestinationTag() {
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.attributeCellHeight?.constant = 0.0
            self.attributeCell?.alpha = 0.0
        }, completion: { _ in
            self.attributeCell?.isHidden = true
        })
    }
    
    private func resetPayId() {
        resolvedAddress = nil
        addressCell.hideResolveableState()
        addressCell.setContent("")
        addressCell.hideResolveableState()
    }

    @objc private func scanTapped() {
        memoCell.textView.resignFirstResponder()
        addressCell.textField.resignFirstResponder()
        presentScan? { [weak self] scanResult in
            self?.paymentProtocolRequest = nil
            guard case .paymentRequest(let request)? = scanResult, let request = request else { return }
            self?.handleRequest(request)
        }
    }
    
    private func validateSendForm() -> Bool {
        //Payment Protocol Requests do their own validation
        guard paymentProtocolRequest == nil else { return true }
        
        guard let address = address, !address.isEmpty else {
            showAlert(title: L10n.Alert.error, message: L10n.Send.noAddress, buttonLabel: L10n.Button.ok)
            return false
        }
        
        //Having an invalid address will cause fee estimation to fail,
        //so we need to display this error before the fee estimate error.
        //Without this, the fee estimate error will be shown and the user won't
        //know that the address is invalid.
        guard currency.isValidAddress(address) else {
            let message = L10n.Send.invalidAddressMessage(currency.name)
            showAlert(title: L10n.Send.invalidAddressTitle, message: message, buttonLabel: L10n.Button.ok)
            return false
        }

        guard let amount = amount, !amount.isZero else {
            showAlert(title: L10n.Alert.error, message: L10n.Send.noAmount, buttonLabel: L10n.Button.ok)
            return false
        }
        
        guard let feeBasis = currentFeeBasis else {
            showAlert(title: L10n.Alert.error, message: L10n.Send.noFeeEstimate, buttonLabel: L10n.Button.ok)
            return false
        }
        
        //XRP destination Tag must fit into UInt32
        var attributeText: String?
        if let attribute = attributeCell?.attribute, currency.isXRP,
           !attribute.isEmpty {
            if UInt32(attribute) == nil {
                showAlert(title: L10n.Alert.error, message: L10n.Send.destinationTag, buttonLabel: L10n.Button.ok)
               return false
            }
            attributeText = attribute
        }

        return handleValidationResult(sender.createTransaction(address: address,
                                                        amount: amount,
                                                        feeBasis: feeBasis,
                                                        comment: memoCell.textView.text,
                                                        attribute: attributeText))
    }
    
    private func handleValidationResult(_ result: SenderValidationResult, protocolRequest: PaymentProtocolRequest? = nil) -> Bool {
        switch result {
        case .noFees:
            showAlert(title: L10n.Alert.error, message: L10n.Send.noFeesError, buttonLabel: L10n.Button.ok)
            
        case .invalidAddress:
            let message = L10n.Send.invalidAddressMessage(currency.name)
            showAlert(title: L10n.Send.invalidAddressTitle, message: message, buttonLabel: L10n.Button.ok)
            
        case .ownAddress:
            showAlert(title: L10n.Alert.error, message: L10n.Send.containsAddress, buttonLabel: L10n.Button.ok)
            
        case .outputTooSmall(let minOutput), .paymentTooSmall(let minOutput):
            let amountText = "\(minOutput.tokenDescription) (\(minOutput.fiatDescription))"
            let message = L10n.PaymentProtocol.Errors.smallPayment(amountText)
            showAlert(title: L10n.Alert.error, message: message, buttonLabel: L10n.Button.ok)
            
        case .insufficientFunds:
            showAlert(title: L10n.Alert.error, message: L10n.Send.insufficientFunds, buttonLabel: L10n.Button.ok)
            
        case .failed:
            showAlert(title: L10n.Alert.error, message: L10n.Send.creatTransactionError, buttonLabel: L10n.Button.ok)
            
        case .insufficientGas:
            showInsufficientGasError()
            
        case .identityNotCertified(let message):
            showError(title: L10n.Send.identityNotCertified, message: message, ignore: { [unowned self] in
                self.didIgnoreIdentityNotCertified = true
                if let protoReq = protocolRequest {
                    self.didReceivePaymentProtocolRequest(protoReq)
                }
            })
            return false
        case .invalidRequest(let errorMessage):
            showAlert(title: L10n.PaymentProtocol.Errors.badPaymentRequest, message: errorMessage, buttonLabel: L10n.Button.ok)
            return false
        case .usedAddress:
            showError(title: L10n.Send.UsedAddress.title,
                      message: "\(L10n.Send.UsedAddress.firstLine)\n\n\(L10n.Send.UsedAddress.secondLIne)",
                      ignore: { [unowned self] in
                self.didIgnoreUsedAddressWarning = true
            })
            return false
            
        // allow sending without exchange rates available (the tx metadata will not be set)
        case .ok, .noExchangeRate:
            return true
        }
        
        return false
    }

    @objc private func sendTapped() {
        if addressCell.textField.isFirstResponder {
            addressCell.textField.resignFirstResponder()
        }
        
        if attributeCell?.textField.isFirstResponder == true {
            attributeCell?.textField.resignFirstResponder()
        }
        
        guard validateSendForm(),
            let amount = amount,
            let address = address,
            let feeBasis = currentFeeBasis else { return }

        let feeCurrency = sender.wallet.feeCurrency
        let fee = Amount(cryptoAmount: feeBasis.fee, currency: feeCurrency)
        
        let displayAmount = Amount(amount: amount,
                                  rate: amountView.selectedRate,
                                  maximumFractionDigits: Amount.highPrecisionDigits)
        let feeAmount = Amount(amount: fee,
                               rate: (amountView.selectedRate != nil) ? feeCurrency.state?.currentRate : nil,
                               maximumFractionDigits: Amount.highPrecisionDigits)

        let confirm = ConfirmationViewController(amount: displayAmount,
                                                 fee: feeAmount,
                                                 displayFeeLevel: feeLevel,
                                                 address: address,
                                                 currency: currency,
                                                 resolvedAddress: resolvedAddress,
                                                 shouldShowMaskView: false)
        confirm.successCallback = send
        confirm.cancelCallback = sender.reset
        present(confirm, animated: true, completion: nil)
        return
    }
    
    private func send() {
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
        sender.sendTransaction(allowBiometrics: true, pinVerifier: pinVerifier) { [weak self] result in
            guard let self = self else { return }
            self.sendingActivity.dismiss(animated: true) {
                defer { self.sender.reset() }
                switch result {
                case .success:
                    self.dismiss(animated: true) {
                        Store.trigger(name: .showStatusBar)
                        self.onPublishSuccess?()
                    }
                case .creationError(let message):
                    self.showAlert(title: L10n.Alerts.sendFailure, message: message, buttonLabel: L10n.Button.ok)
                case .publishFailure(let code, let message):
                    let codeStr = code == 0 ? "" : " (\(code))"
                    self.showAlert(title: L10n.Send.sendError, message: message + codeStr, buttonLabel: L10n.Button.ok)
                case .insufficientGas:
                    self.showInsufficientGasError()
                }
            }
        }
    }
    
    // MARK: - Payment Protocol Requests

    private func handleRequest(_ request: PaymentRequest) {
        switch request.type {
        case .local:
            addressCell.setContent(request.toAddress?.description)
            addressCell.isEditable = true
            if let amount = request.amount {
                amountView.forceUpdateAmount(amount: amount)
            }
            if request.label != nil {
                memoCell.content = request.label
            }
            if request.destinationTag != nil {
                attributeCell?.setContent(request.destinationTag)
            }
        case .remote:
            let loadingView = BRActivityViewController(message: L10n.Send.loadingRequest)
            present(loadingView, animated: true, completion: nil)
            request.fetchRemoteRequest(completion: { [weak self] request in
                DispatchQueue.main.async {
                    loadingView.dismiss(animated: true, completion: {
                        if let paymentProtocolRequest = request?.paymentProtocolRequest {
                            self?.didReceivePaymentProtocolRequest(paymentProtocolRequest)
                        } else {
                            self?.showErrorMessage(L10n.Send.remoteRequestError)
                        }
                    })
                }
            })
        }
    }
    
    private func didReceivePaymentProtocolRequest(_ paymentProtocolRequest: PaymentProtocolRequest) {
        self.paymentProtocolRequest = paymentProtocolRequest
        estimateFeeForRequest(paymentProtocolRequest) { self.handleProtoReqFeeEstimation(paymentProtocolRequest, result: $0) }
    }
    
    func estimateFeeForRequest(_ protoReq: PaymentProtocolRequest, completion: @escaping (Result<TransferFeeBasis, WalletKit.Wallet.FeeEstimationError>) -> Void) {
        let networkFee = protoReq.requiredNetworkFee ?? sender.wallet.feeForLevel(level: feeLevel)
        protoReq.estimateFee(fee: networkFee, completion: completion)
    }
    
    private func handleProtoReqFeeEstimation(_ protoReq: PaymentProtocolRequest, result: Result<TransferFeeBasis, WalletKit.Wallet.FeeEstimationError>) {
        switch result {
        case .success(let transferFeeBasis):
            DispatchQueue.main.async {
                //We need to keep track of the fee basis here so that we can display the fee amount
                //in the tx confirmation view
                self.currentFeeBasis = transferFeeBasis
                self.validateReq(protoReq: protoReq, feeBasis: transferFeeBasis)
            }
        case .failure(let error):
            self.showErrorMessage("Error estimating fee: \(error)")
        }
    }
    
    private func validateReq(protoReq: PaymentProtocolRequest, feeBasis: TransferFeeBasis) {
        guard let totalAmount = protoReq.totalAmount else { handleZeroAmountPaymentProtocolRequest(protoReq); return }
        let requestAmount = Amount(cryptoAmount: totalAmount, currency: currency, maximumFractionDigits: 8)
        guard !requestAmount.isZero else { handleZeroAmountPaymentProtocolRequest(protoReq); return }
        let result = sender.createTransaction(protocolRequest: protoReq,
                                            ignoreUsedAddress: didIgnoreUsedAddressWarning,
                                            ignoreIdentityNotCertified: didIgnoreIdentityNotCertified,
                                            feeBasis: feeBasis,
                                            comment: protoReq.memo)
        guard handleValidationResult(result, protocolRequest: protoReq) else { return }
        addressCell.setContent(protoReq.displayText)
        memoCell.content = protoReq.memo
        amountView.forceUpdateAmount(amount: requestAmount)
        addressCell.isEditable = false
        addressCell.hideActionButtons()
        amountView.isEditable = false
        sender.displayPaymentProtocolResponse = { [weak self] in
            self?.showAlert(title: L10n.Import.success, message: $0)
        }
    }
    
    private func handleZeroAmountPaymentProtocolRequest(_ protoReq: PaymentProtocolRequest) {
        guard let address = protoReq.primaryTarget?.description else {
            showErrorMessage(L10n.Send.invalidAddressTitle); return
        }
        //After this point, a zero amount Payment protocol request behaves like a
        //regular send except the address cell isn't editable
        addressCell.setContent(address)
        addressCell.isEditable = false
        addressCell.hideActionButtons()
    }
    
    // MARK: - Errors

    private func showError(title: String, message: String, ignore: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Button.ignore, style: .default, handler: { _ in
            ignore()
        }))
        alertController.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /// Insufficient gas for ERC20 token transfer
    private func showInsufficientGasError() {
        guard let feeAmount = self.currentFeeBasis?.fee else { return assertionFailure() }
        
        let message = L10n.Send.insufficientGasMessage(feeAmount.description)

        let alertController = UIAlertController(title: L10n.Send.insufficientGasTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Button.yes, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            Store.trigger(name: .showCurrency(self.sender.wallet.feeCurrency))
        }))
        alertController.addAction(UIAlertAction(title: L10n.Button.no, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Keyboard Notifications

extension SendViewController {
    
    @objc private func keyboardWillShow(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }
    
    //TODO - maybe put this in ModalPresentable?
    private func copyKeyboardChangeAnimation(notification: Notification) {
        guard let info = KeyboardNotificationInfo(notification.userInfo) else { return }
        UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: {
            guard let parentView = self.parentView else { return }
            parentView.frame.origin.y = info.deltaY
        }, completion: nil)
    }
}

// MARK: - ModalDisplayable

extension SendViewController: ModalDisplayable {
    var faqArticleId: String? {
        return ArticleIds.sendTx
    }
    
    var faqCurrency: Currency? {
        return currency
    }

    var modalTitle: String {
        return "\(L10n.Send.title) \(currency.name)"
    }
}
