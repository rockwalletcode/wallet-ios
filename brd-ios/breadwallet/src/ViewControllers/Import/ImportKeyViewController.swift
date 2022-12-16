//
//  StartImportViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-06-13.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import WalletKit

/**
 *  Screen that allows the user to scan a QR code corresponding to a private key.
 *
 *  It can be displayed in response to the "Redeem Private Key" menu item under Bitcoin
 *  preferences or in response to the user scanning a private key using the Scan QR Code
 *  item in the main menu. In the latter case, an initial QR code is passed to the init() method.
 */
class ImportKeyViewController: UIViewController, Subscriber {
    /**
     *  Initializer
     *
     *  walletManager - Bitcoin wallet manager
     *  initialQRCode - a QR code that was previously scanned, causing this import view controller to
     *                  be displayed
     */
    init(wallet: Wallet, initialQRCode: QRCode? = nil) {
        self.wallet = wallet
        self.initialQRCode = initialQRCode
        assert(wallet.currency.isBitcoin || wallet.currency.isBitcoinCash, "Importing only supports BTC or BCH. ")
        super.init(nibName: nil, bundle: nil)
    }

    private let wallet: Wallet
    private let header = UIView()
    private let illustration = UIImageView(image: Asset.importIllustration.image)
    private let message = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    private let warning = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    private let button = BRDButton(title: L10n.Import.scan, type: .secondary)
    private let bullet = UIImageView(image: Asset.cancel.image)
    private let balanceActivity = BRActivityViewController(message: L10n.Import.checking)
    private let importingActivity = BRActivityViewController(message: L10n.Import.importing)
    private let unlockingActivity = BRActivityViewController(message: L10n.Import.unlockingActivity)
    private var viewModel: (any TxViewModel)?
    private lazy var importConfirmationAlert: WrapperPopupView<TitleValueView> = {
        let alert = WrapperPopupView<TitleValueView>()
        alert.configure(with: .init(background: .init(backgroundColor: LightColors.Background.one, border: Presets.Border.commonPlain),
                                    trailing: Presets.Button.blackIcon,
                                    confirm: Presets.Button.primary,
                                    cancel: Presets.Button.secondary,
                                    wrappedView: Presets.TitleValue.alert))
        alert.wrappedView.axis = .vertical
        return alert
    }()
    
    // Previously scanned QR code passed to init()
    private var initialQRCode: QRCode?

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        setInitialData()
        title = L10n.Import.title
        navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let code = initialQRCode {
            handleScanResult(code)
            
            // Set this nil so that if the user tries to can another QR code via the
            // Scan Private Key button we don't end up trying to process the initial
            // code again. viewWillAppear() will get called again when the scanner/camera
            // is dismissed.
            initialQRCode = nil
        }
    }
    
    deinit {
        wallet.unsubscribe(self)
    }
    
    private func addSubviews() {
        view.addSubview(header)
        header.addSubview(illustration)
        view.addSubview(message)
        view.addSubview(button)
        view.addSubview(bullet)
        view.addSubview(warning)
    }

    private func addConstraints() {
        header.constrain([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.heightAnchor.constraint(equalToConstant: 160)])
        illustration.constrain([
            illustration.constraint(.top, toView: header, constant: Margins.large.rawValue),
            illustration.heightAnchor.constraint(equalToConstant: 69),
            illustration.constraint(.centerX, toView: header),
            illustration.constraint(.bottom, toView: header, constant: -Margins.extraExtraHuge.rawValue)])
        message.constrain([
            message.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            message.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Margins.huge.rawValue),
            message.centerXAnchor.constraint(equalTo: view.centerXAnchor) ])
        bullet.constrain([
            bullet.leadingAnchor.constraint(equalTo: message.leadingAnchor),
            bullet.topAnchor.constraint(equalTo: message.bottomAnchor, constant: Margins.huge.rawValue) ])
        warning.constrain([
            warning.leadingAnchor.constraint(equalTo: bullet.trailingAnchor, constant: Margins.large.rawValue),
            warning.topAnchor.constraint(equalTo: bullet.topAnchor),
            warning.trailingAnchor.constraint(equalTo: message.trailingAnchor) ])
        button.constrain([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Margins.huge.rawValue),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.constraint(.height, constant: ViewSizes.Common.largeCommon.rawValue) ])
    }

    private func setInitialData() {
        view.backgroundColor = LightColors.Background.one
        header.backgroundColor = LightColors.primary
        illustration.contentMode = .scaleAspectFit
        bullet.tintColor = LightColors.Text.two
        message.text = L10n.Import.message
        warning.text = L10n.Import.warning

        // Set up the tap handler for the "Scan Private Key" button.
        button.tap = { [weak self] in
            guard let self = self else { return }
            let scan = ScanViewController(forScanningPrivateKeysOnly: true) { result in
                guard let result = result else { return }
                self.handleScanResult(result)
            }
            self.parent?.present(scan, animated: true, completion: nil)
        }
    }
    
    private func handleScanResult(_ result: QRCode) {
        switch result {
        case .privateKey(let key):
            didReceiveAddress(key)
        case .gift(let key, let model):
            didReceiveAddress(key)
            self.viewModel = model
        default:
            break
        }
    }

    private func didReceiveAddress(_ address: String) {
        guard !Key.isProtected(asPrivate: address) else {
            return unlock(address: address) { self.createTransaction(withPrivKey: $0) }
        }
        
        guard let key = Key.createFromString(asPrivate: address) else {
            showErrorMessage(L10n.Import.Error.notValid)
            return
        }

        createTransaction(withPrivKey: key)
        
    }
    
    private func createTransaction(withPrivKey key: Key) {
        present(balanceActivity, animated: true, completion: nil)
        wallet.createSweeper(forKey: key) { result in
            DispatchQueue.main.async {
                self.balanceActivity.dismiss(animated: true) {
                    switch result {
                    case .success(let sweeper):
                        self.importFrom(sweeper)
                    case .failure(let error):
                        self.handleError(error)
                    }
                }
            }
        }
    }
    
    private func importFrom(_ sweeper: WalletSweeper) {
        guard let balance = sweeper.balance else { return self.showErrorMessage(L10n.Import.Error.empty) }
        let balanceAmount = Amount(cryptoAmount: balance, currency: wallet.currency)
        guard !balanceAmount.isZero else { return self.showErrorMessage(L10n.Import.Error.empty) }
        sweeper.estimate(fee: wallet.feeForLevel(level: .regular)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feeBasis):
                    self.confirmImport(fromSweeper: sweeper, fee: feeBasis)
                case .failure(let error):
                    self.handleEstimateFeeError(error)
                }
            }
        }
    }
    
    private func confirmImport(fromSweeper sweeper: WalletSweeper, fee: TransferFeeBasis) {
        let balanceAmount = Amount(cryptoAmount: sweeper.balance!, currency: wallet.currency)
        let feeAmount = Amount(cryptoAmount: fee.fee, currency: wallet.currency)
        let message = String(format: L10n.Import.confirm("%@", "%@"), balanceAmount.fiatDescription, feeAmount.fiatDescription)
        
        importConfirmationAlert.setup(with: .init(trailing: .init(image: Asset.close.name),
                                                  confirm: .init(title: L10n.Button.continueAction),
                                                  cancel: .init(title: L10n.Button.cancel),
                                                  wrappedView: .init(title: .text(L10n.Import.title),
                                                                     value: .text(message)),
                                                 hideSeparator: true))
        
        importConfirmationAlert.confirmCallback = {
            self.present(self.importingActivity, animated: true)
            self.submit(sweeper: sweeper, fee: fee)
        }
        navigationController?.view.addSubview(importConfirmationAlert)
        
        importConfirmationAlert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.importConfirmationAlert.alpha = 1
        }
    }
    
    private func submit(sweeper: WalletSweeper, fee: TransferFeeBasis) {
        guard let transfer = sweeper.submit(estimatedFeeBasis: fee) else {
            self.importingActivity.dismiss(animated: true) {
                self.showErrorMessage(L10n.Alerts.sendFailure)
            }
            return
        }
        wallet.subscribe(self) { event in
            switch event {
            case .transferSubmitted(let eventTransfer, let success):
                guard eventTransfer.hash == transfer.hash,
                        success
                else {
                    return self.showErrorMessage(L10n.Import.Error.failedSubmit)
                }
                
                DispatchQueue.main.async {
                    self.importingActivity.dismiss(animated: true) {
                        self.markAsReclaimed()
                        self.showSuccess()
                    }
                }
                
            default:
                print("IMPORT: \(event.description)")
                return
                
            }
        }
        
        // TODO: quick (not) fix... basically we just dismiss loading, cause WK is not returning any event updates
        importingActivity.dismiss(animated: true) {
            self.showSuccess()
        }
    }
    
    private func markAsReclaimed() {
        guard let kvStore = Backend.kvStore else { return assertionFailure() }
        guard let viewModel = viewModel else { return assertionFailure() }
        guard let gift = viewModel.gift else { return assertionFailure() }
        let newGift = Gift(shared: gift.shared,
                           claimed: gift.claimed,
                           reclaimed: true,
                           txnHash: gift.txnHash,
                           keyData: gift.keyData,
                           name: gift.name,
                           rate: gift.rate,
                           amount: gift.amount)
        viewModel.tx?.updateGiftStatus(gift: newGift, kvStore: kvStore)
        if let hash = newGift.txnHash {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Store.trigger(name: .txMetaDataUpdated(hash))
            }
        }
        
    }
    
    private func handleError(_ error: WalletSweeperError) {
        switch error {
        case .unsupportedCurrency:
            showErrorMessage(L10n.Import.Error.unsupportedCurrency)
        case .invalidKey:
            showErrorMessage(L10n.Send.invalidAddressTitle)
        case .invalidSourceWallet:
            showErrorMessage(L10n.Send.invalidAddressTitle)
        case .insufficientFunds:
            showErrorMessage(L10n.Send.insufficientFunds)
        case .unableToSweep:
            showErrorMessage(L10n.Import.Error.sweepError)
        case .noTransfersFound:
            showErrorMessage(L10n.Import.Error.empty)
        case .unexpectedError:
            showErrorMessage(L10n.Alert.somethingWentWrong)
        case .clientError(let error):
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func handleEstimateFeeError(_ error: FeeEstimationError) {
        switch error {
        case .InsufficientFunds:
            showErrorMessage(L10n.Send.insufficientFunds)
        case .InsufficientGas:
            showErrorMessage(L10n.Send.insufficientGas)
        case .ServiceError:
            showErrorMessage(L10n.Import.Error.serviceError)
        case .ServiceUnavailable:
            showErrorMessage(L10n.Import.Error.serviceUnavailable)
        }
    }

    private func unlock(address: String, callback: @escaping (Key) -> Void) {
        let alert = UIAlertController(title: L10n.Import.title, message: L10n.Import.password, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = L10n.Import.passwordPlaceholder
            textField.isSecureTextEntry = true
            textField.returnKeyType = .done
        })
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .default, handler: { _ in
            self.unlock(alert: alert, address: address, callback: callback)
        }))
        present(alert, animated: true)
    }
    
    private func unlock(alert: UIAlertController, address: String, callback: @escaping (Key) -> Void) {
        present(self.unlockingActivity, animated: true, completion: {
            guard let password = alert.textFields?.first?.text,
                let key = Key.createFromString(asPrivate: address, withPassphrase: password) else {
                self.unlockingActivity.dismiss(animated: true, completion: {
                    self.showErrorMessage(L10n.Import.wrongPassword)
                })
                return
            }
            self.unlockingActivity.dismiss(animated: true, completion: {
                callback(key)
            })
        })
    }

    private func showSuccess() {
        Store.perform(action: Alert.Show(.sweepSuccess(callback: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
