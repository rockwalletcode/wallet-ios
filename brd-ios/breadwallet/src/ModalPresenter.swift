//
//  ModalPresenter.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-25.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftUI
import WalletKit

// swiftlint:disable type_body_length
// swiftlint:disable cyclomatic_complexity

class ModalPresenter: Subscriber {
    
    // MARK: - Public
    
    init(keyStore: KeyStore, system: CoreSystem, window: UIWindow, alertPresenter: AlertPresenter?, deleteAccountCallback: (() -> Void)?) {
        self.system = system
        self.window = window
        self.alertPresenter = alertPresenter
        self.deleteAccountCallback = deleteAccountCallback
        self.keyStore = keyStore
        self.modalTransitionDelegate = ModalTransitionDelegate(type: .regular)
        addSubscriptions()
    }
    
    deinit {
        Store.unsubscribe(self)
    }
    
    // MARK: - Private
    private let window: UIWindow
    private let keyStore: KeyStore
    private var alertPresenter: AlertPresenter?
    private var deleteAccountCallback: (() -> Void)?
    private let modalTransitionDelegate: ModalTransitionDelegate
    private let messagePresenter = MessageUIPresenter()
    private let verifyPinTransitionDelegate = PinTransitioningDelegate()
    private var currentRequest: PaymentRequest?
    private var menuNavController: RootNavigationController?
    private var feedbackManager: EmailFeedbackManager?
    private let system: CoreSystem
    
    private func addSubscriptions() {
        Store.lazySubscribe(self,
                            selector: { $0.rootModal != $1.rootModal },
                            callback: { [weak self] in self?.presentModal($0.rootModal) })
        
        Store.subscribe(self, name: .presentFaq("", nil), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .presentFaq(let articleId, let currency) = trigger {
                self?.presentFaq(articleId: articleId, currency: currency)
            }
        })
        
        //Subscribe to prompt actions
        Store.subscribe(self, name: .promptUpgradePin, callback: { [weak self] _ in
            self?.presentUpgradePin()
        })
        Store.subscribe(self, name: .promptPaperKey, callback: { [weak self] _ in
            self?.presentWritePaperKey()
        })
        Store.subscribe(self, name: .promptBiometrics, callback: { [weak self] _ in
            self?.presentBiometricsMenuItem()
        })
        Store.subscribe(self, name: .promptShareData, callback: { [weak self] _ in
            self?.promptShareData()
        })
        Store.subscribe(self, name: .openFile(Data()), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .openFile(let file) = trigger {
                self?.handleFile(file)
            }
        })
        
        //URLs
        Store.subscribe(self, name: .paymentRequest(nil), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case let .paymentRequest(request) = trigger {
                if let request = request {
                    self?.handlePaymentRequest(request: request)
                }
            }
        })
        Store.subscribe(self, name: .scanQr, callback: { [weak self] _ in
            self?.handleScanQrURL()
        })
        Store.subscribe(self, name: .authenticateForPlatform("", true, {_ in}), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .authenticateForPlatform(let prompt, let allowBiometricAuth, let callback) = trigger {
                self?.authenticateForPlatform(prompt: prompt, allowBiometricAuth: allowBiometricAuth, callback: callback)
            }
        })
        Store.subscribe(self, name: .confirmTransaction(nil, nil, nil, .regular, "", {_ in}), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .confirmTransaction(let currency?, let amount?, let fee?, let displayFeeLevel, let address, let callback) = trigger {
                self?.confirmTransaction(currency: currency, amount: amount, fee: fee, displayFeeLevel: displayFeeLevel, address: address, callback: callback)
            }
        })
        Store.subscribe(self, name: .lightWeightAlert(""), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case let .lightWeightAlert(message) = trigger {
                self?.showLightWeightAlert(message: message)
            }
        })
        Store.subscribe(self, name: .showCurrency(nil), callback: { [weak self] in
            guard let trigger = $0 else { return }
            if case .showCurrency(let currency?) = trigger {
                self?.showAccountView(currency: currency, animated: true, completion: nil)
            }
        })
        
        // Push Notifications Permission Request
        Store.subscribe(self, name: .registerForPushNotificationToken) { [weak self]  _ in
            guard let top = self?.topViewController else { return }
            NotificationAuthorizer().requestAuthorization(fromViewController: top, completion: { granted in
                DispatchQueue.main.async {
                    if granted {
                        print("[PUSH] notification authorization granted")
                    } else {
                        // TODO: log event
                        print("[PUSH] notification authorization denied")
                    }
                }
            })
        }
        
        // in-app notifications
        Store.subscribe(self, name: .showInAppNotification(nil)) { [weak self] (trigger) in
            guard let self = self else { return }
            guard let topVC = self.topViewController else { return }
            
            if case let .showInAppNotification(notification?)? = trigger {
                let display: (UIImage?) -> Void = { (image) in
                    let notificationVC = InAppNotificationViewController(notification, image: image)
                    let navigationController = RootNavigationController(rootViewController: notificationVC)
                    topVC.present(navigationController, animated: true)
                }
                
                // Fetch the image first so that it's ready when we display the notification
                // screen to the user.
                if let imageUrl = notification.imageUrl, !imageUrl.isEmpty {
                    UIImage.fetchAsync(from: imageUrl) { (image) in
                        display(image)
                    }
                } else {
                    display(nil)
                }
                
            }
        }
        
//        Store.subscribe(self, name: .handleGift(URL(string: "")!)) { [weak self] in
//            guard let trigger = $0, let `self` = self else { return }
//            if case let .handleGift(url) = trigger {
//                if let gift = QRCode(url: url, viewModel: nil) {
//                    self.handleGift(qrCode: gift)
//                }
//            }
//        }
        
        Store.subscribe(self, name: .reImportGift(nil)) { [weak self] in
            guard let trigger = $0, let `self` = self else { return }
            if case let .reImportGift(viewModel) = trigger {
                guard let gift = viewModel?.gift else { return assertionFailure() }
                let code = QRCode(url: URL(string: gift.url!)!, viewModel: viewModel)
                guard let wallet = Currencies.shared.btc?.wallet else { return assertionFailure() }
                self.presentKeyImport(wallet: wallet, scanResult: code)
            }
        }
    }
    
    private func handleGift(qrCode: QRCode) {
        guard let wallet = Currencies.shared.btc?.wallet else { return }
        guard case .gift(let key, _) = qrCode else { return }
        guard let privKey = Key.createFromString(asPrivate: key) else { return }
        wallet.createSweeper(forKey: privKey) { result in
            DispatchQueue.main.async {
                let giftView = RedeemGiftViewController(qrCode: qrCode, wallet: wallet, sweeperResult: result)
                self.topViewController?.present(giftView, animated: true)
            }
        }
    }
    
    private func presentModal(_ type: RootModal) {
        guard let vc = rootModalViewController(type) else {
            Store.perform(action: RootModalActions.Present(modal: .none))
            return
        }
        vc.transitioningDelegate = modalTransitionDelegate
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        topViewController?.present(vc, animated: true) {
            Store.perform(action: RootModalActions.Present(modal: .none))
            Store.trigger(name: .hideStatusBar)
        }
    }
    
    func presentFaq(articleId: String? = nil, currency: Currency? = nil) {
        guard let url = URL(string: C.supportLink) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: L10n.MenuButton.support))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        topViewController?.present(navController, animated: true)
    }
    
    private func rootModalViewController(_ type: RootModal) -> UIViewController? {
        switch type {
        case .none:
            return nil
        case .send(let currency):
            return makeSendView(currency: currency)
        case .receive(let currency):
            return makeReceiveView(currency: currency, isRequestAmountVisible: (currency.urlSchemes?.first != nil))
        case .loginScan:
            presentLoginScan()
            return nil
        case .requestAmount(let currency, let address):
            let requestVc = RequestAmountViewController(currency: currency, receiveAddress: address)
            
            requestVc.shareAddress = { [weak self] uri, qrCode in
                self?.messagePresenter.presenter = self?.topViewController
                self?.messagePresenter.presentShareSheet(text: uri, image: qrCode)
            }
            
            return ModalViewController(childViewController: requestVc)
        case .receiveLegacy:
            guard let btc = Currencies.shared.btc else { return nil }
            return makeReceiveView(currency: btc, isRequestAmountVisible: false, isBTCLegacy: true)
        case .gift:
            guard let currency = Currencies.shared.btc else { return nil }
            guard let wallet = system.wallet(for: currency),
                  let kvStore = Backend.kvStore else { assertionFailure(); return nil }
            let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
            let giftView = GiftViewController(sender: sender, wallet: wallet, currency: currency)
            
            giftView.presentVerifyPin = { [weak self, weak giftView] bodyText, success in
                guard let self = self else { return }
                let vc = VerifyPinViewController(bodyText: bodyText,
                                                 pinLength: Store.state.pinLength,
                                                 walletAuthenticator: self.keyStore,
                                                 pinAuthenticationType: .transactions,
                                                 success: success)
                vc.transitioningDelegate = self.verifyPinTransitionDelegate
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                giftView?.view.isFrameChangeBlocked = true
                giftView?.present(vc, animated: true)
            }
            giftView.onPublishSuccess = { [weak self] in
                self?.alertPresenter?.presentAlert(.sendSuccess, completion: {})
            }
            
            topViewController?.present(giftView, animated: true, completion: {
                Store.perform(action: RootModalActions.Present(modal: .none))
            })
            return nil
        case .stake(let currency):
            return makeStakeView(currency: currency)
        }
    }
    
    private func makeStakeView(currency: Currency) -> UIViewController? {
        guard let wallet = system.wallet(for: currency),
              let kvStore = Backend.kvStore else { assertionFailure(); return nil }
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        let stakeView = StakeViewController(currency: currency, sender: sender)
        stakeView.presentVerifyPin = { [weak self, weak stakeView] bodyText, success in
            guard let self = self else { return }
            let vc = VerifyPinViewController(bodyText: bodyText,
                                             pinLength: Store.state.pinLength,
                                             walletAuthenticator: self.keyStore,
                                             pinAuthenticationType: .transactions,
                                             success: success)
            vc.transitioningDelegate = self.verifyPinTransitionDelegate
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            stakeView?.view.isFrameChangeBlocked = true
            stakeView?.present(vc, animated: true)
        }
        stakeView.onPublishSuccess = { [weak self] in
            self?.alertPresenter?.presentAlert(.sendSuccess, completion: {})
        }
        return ModalViewController(childViewController: stakeView)
    }
    
    private func makeSendView(currency: Currency) -> UIViewController? {
        guard let wallet = system.wallet(for: currency),
              let kvStore = Backend.kvStore else { assertionFailure(); return nil }
        guard !(currency.state?.isRescanning ?? false) else {
            let alert = UIAlertController(title: L10n.Alert.error, message: L10n.Send.isRescanning, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .cancel, handler: nil))
            topViewController?.present(alert, animated: true)
            return nil
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        let sendVC = SendViewController(sender: sender,
                                        initialRequest: currentRequest)
        currentRequest = nil
        
        let root = ModalViewController(childViewController: sendVC)
        sendVC.presentScan = presentScan(parent: root, currency: currency)
        sendVC.presentVerifyPin = { [weak self, weak root] bodyText, success in
            guard let self = self, let root = root else { return }
            let vc = VerifyPinViewController(bodyText: bodyText,
                                             pinLength: Store.state.pinLength,
                                             walletAuthenticator: self.keyStore,
                                             pinAuthenticationType: .transactions,
                                             success: success)
            vc.transitioningDelegate = self.verifyPinTransitionDelegate
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            root.view.isFrameChangeBlocked = true
            root.present(vc, animated: true)
        }
        
        sendVC.onPublishSuccess = { [weak self] in
            self?.alertPresenter?.presentAlert(.sendSuccess, completion: {})
        }
        
        topViewController?.present(root, animated: true)
        
        return nil
    }
    
    private func makeReceiveView(currency: Currency, isRequestAmountVisible: Bool, isBTCLegacy: Bool = false) -> UIViewController? {
        let receiveVC = ReceiveViewController(currency: currency, isRequestAmountVisible: isRequestAmountVisible, isBTCLegacy: isBTCLegacy)
        let root = ModalViewController(childViewController: receiveVC)
        
        receiveVC.shareAddress = { [weak self, weak root] address, qrCode in
            guard let self = self, let root = root else { return }
            self.messagePresenter.presenter = root
            self.messagePresenter.presentShareSheet(text: address, image: qrCode)
        }
        
        return root
    }
    
    private func presentLoginScan() {
        guard let top = topViewController else { return }
        let present = presentScan(parent: top, currency: nil)
        present { [unowned self] scanResult in
            guard let scanResult = scanResult else { return }
            switch scanResult {
            case .paymentRequest(let request):
                guard let request = request else { return }
                
                let message = L10n.Scanner.paymentPromptMessage(request.currency.name)
                let alert = UIAlertController.confirmationAlert(title: L10n.Scanner.paymentPromptTitle, message: message) {
                    self.currentRequest = request
                    self.presentModal(.send(currency: request.currency))
                }
                top.present(alert, animated: true)
                
            case .privateKey:
                let alert = UIAlertController(title: L10n.Settings.importTitle, message: nil, preferredStyle: .actionSheet)
                
                let wallets = [Currencies.shared.bsv?.wallet,
                               Currencies.shared.btc?.wallet,
                               Currencies.shared.bch?.wallet]
                wallets.forEach { wallet in
                    alert.addAction(UIAlertAction(title: wallet?.currency.code, style: .default, handler: { _ in
                        if let wallet {
                            self.presentKeyImport(wallet: wallet, scanResult: scanResult)
                        }
                    }))
                }
                
                alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
                
                top.present(alert, animated: true)
            case .deepLink(let url):
                UIApplication.shared.open(url)
            case .invalid:
                break
            case .gift:
                self.handleGift(qrCode: scanResult)
            }
        }
    }
    
    // MARK: Settings
    func presentPreferences() {
        guard let menuNav = topViewController as? RootNavigationController else { return }
        let items = preparePreferencesMenuItems(menuNav: menuNav)
        let rootMenu = MenuViewController(items: items, title: L10n.Settings.preferences)
        topViewController?.show(rootMenu, sender: nil)
    }
    
    func presentSecuritySettings() {
        guard let menuNav = topViewController as? RootNavigationController else { return }
        let items = prepareSecuritySettingsMenuItems(menuNav: menuNav)
        let rootMenu = MenuViewController(items: items,
                                          title: L10n.MenuButton.security,
                                          faqButton: UIButton.buildFaqButton(articleId: ArticleIds.securityCenter, position: .right))
        
        topViewController?.show(rootMenu, sender: nil)
    }
    
    private func preparePreferencesMenuItems(menuNav: RootNavigationController) -> [MenuItem] {
        // MARK: Bitcoin Menu
        var btcItems: [MenuItem] = []
        if let btc = Currencies.shared.btc, let btcWallet = btc.wallet {
            // Rescan
            var rescan = MenuItem(title: L10n.Settings.sync, callback: { [unowned self] in
                menuNav.pushViewController(ReScanViewController(system: self.system, wallet: btcWallet), animated: true)
            })
            rescan.shouldShow = { [unowned self] in
                self.system.connectionMode(for: btc) == .p2p_only
            }
            btcItems.append(rescan)
            
            // Nodes
            var nodeSelection = MenuItem(title: L10n.NodeSelector.title, callback: {
                let nodeSelector = NodeSelectorViewController(wallet: btcWallet)
                menuNav.pushViewController(nodeSelector, animated: true)
            })
            nodeSelection.shouldShow = { [unowned self] in
                self.system.connectionMode(for: btc) == .p2p_only
            }
            btcItems.append(nodeSelection)
            btcItems.append(MenuItem(title: L10n.Settings.importTitle, callback: {
                menuNav.dismiss(animated: true, completion: { [weak self] in
                    guard let self = self else { return }
                    self.presentKeyImport(wallet: btcWallet)
                })
            }))
            
            var enableSegwit = MenuItem(title: L10n.Settings.enableSegwit, callback: {
                let segwitView = SegwitViewController()
                menuNav.pushViewController(segwitView, animated: true)
            })
            enableSegwit.shouldShow = { return !UserDefaults.hasOptedInSegwit }
            var viewLegacyAddress = MenuItem(title: L10n.Settings.viewLegacyAddress, callback: {
                Store.perform(action: RootModalActions.Present(modal: .receiveLegacy))
            })
            viewLegacyAddress.shouldShow = { return UserDefaults.hasOptedInSegwit }
            
            btcItems.append(enableSegwit)
            btcItems.append(viewLegacyAddress)
        }
        var btcMenu = MenuItem(title: L10n.Settings.currencyPageTitle(Currencies.shared.btc?.name ?? ""), subMenu: btcItems, rootNav: menuNav)
        btcMenu.shouldShow = { return !btcItems.isEmpty }
        
        // MARK: Bitcoin Cash Menu
        var bchItems: [MenuItem] = []
        if let bch = Currencies.shared.bch, let bchWallet = bch.wallet {
            if system.connectionMode(for: bch) == .p2p_only {
                // Rescan
                bchItems.append(MenuItem(title: L10n.Settings.sync, callback: { [weak self] in
                    guard let self = self else { return }
                    menuNav.pushViewController(ReScanViewController(system: self.system, wallet: bchWallet), animated: true)
                }))
            }
            bchItems.append(MenuItem(title: L10n.Settings.importTitle, callback: {
                menuNav.dismiss(animated: true, completion: { [unowned self] in
                    self.presentKeyImport(wallet: bchWallet)
                })
            }))
            
        }
        var bchMenu = MenuItem(title: L10n.Settings.currencyPageTitle(Currencies.shared.bch?.name ?? ""), subMenu: bchItems, rootNav: menuNav)
        bchMenu.shouldShow = { return !bchItems.isEmpty }
        
        // MARK: Bitcoin SV Menu
        var bsvItems: [MenuItem] = []
        if let bsv = Currencies.shared.bsv, let bsvWallet = bsv.wallet {
            if system.connectionMode(for: bsv) == .p2p_only {
                // Rescan
                bsvItems.append(MenuItem(title: L10n.Settings.sync, callback: { [weak self] in
                    guard let self = self else { return }
                    menuNav.pushViewController(ReScanViewController(system: self.system, wallet: bsvWallet), animated: true)
                }))
            }
            bsvItems.append(MenuItem(title: L10n.Settings.importTitle, callback: {
                menuNav.dismiss(animated: true, completion: { [unowned self] in
                    self.presentKeyImport(wallet: bsvWallet)
                })
            }))
            
        }
        var bsvMenu = MenuItem(title: L10n.Settings.currencyPageTitle(Currencies.shared.bsv?.name ?? ""), subMenu: bsvItems, rootNav: menuNav)
        bsvMenu.shouldShow = { return !bsvItems.isEmpty }
        
        // MARK: Ethereum Menu
        var ethItems: [MenuItem] = []
        if let eth = Currencies.shared.eth, let ethWallet = eth.wallet {
            if system.connectionMode(for: eth) == .p2p_only {
                // Rescan
                ethItems.append(MenuItem(title: L10n.Settings.sync, callback: { [weak self] in
                    guard let self = self else { return }
                    menuNav.pushViewController(ReScanViewController(system: self.system, wallet: ethWallet), animated: true)
                }))
            }
        }
        var ethMenu = MenuItem(title: L10n.Settings.currencyPageTitle(Currencies.shared.eth?.name ?? ""), subMenu: ethItems, rootNav: menuNav)
        ethMenu.shouldShow = { return !ethItems.isEmpty }
        
        // MARK: Preferences
        let preferencesItems: [MenuItem] = [
            // Display Currency
            MenuItem(title: L10n.Settings.currency, accessoryText: {
                let code = Store.state.defaultCurrencyCode
                let components: [String: String] = [NSLocale.Key.currencyCode.rawValue: code]
                let identifier = Locale.identifier(fromComponents: components)
                return Locale(identifier: identifier).currencyCode ?? ""
            }, callback: {
                menuNav.pushViewController(DefaultCurrencyViewController(), animated: true)
            }),
            
            bsvMenu,
            btcMenu,
            bchMenu,
            ethMenu,
            
            // Share Anonymous Data
            MenuItem(title: L10n.Settings.shareData, callback: {
                menuNav.pushViewController(ShareDataViewController(), animated: true)
            }),
            
            // Reset Wallets
            MenuItem(title: L10n.Settings.resetCurrencies, callback: { [weak self] in
                guard let self = self else { return }
                menuNav.dismiss(animated: true, completion: {
                    self.system.resetToDefaultCurrencies()
                })
            }),
            
            // Notifications
            MenuItem(title: L10n.Settings.notifications, callback: {
                menuNav.pushViewController(PushNotificationsViewController(), animated: true)
            })
        ]
        
        return preferencesItems
    }
    
    func presentMenu() {
        let menuNav = RootNavigationController()
        menuNav.modalPresentationStyle = .overFullScreen
        // MARK: Preferences
        let preferencesItems = preparePreferencesMenuItems(menuNav: menuNav)
        
        // MARK: Security Settings
        let securityItems = prepareSecuritySettingsMenuItems(menuNav: menuNav)
        
        // MARK: Root Menu
        var rootItems: [MenuItem] = [
            // Scan QR Code
            MenuItem(title: L10n.MenuButton.scan, icon: MenuItem.Icon.scan) { [weak self] in
                self?.presentLoginScan()
            },
            // Feedback
            MenuItem(title: L10n.MenuButton.feedback, icon: MenuItem.Icon.feedback) { [weak self] in
                guard let topVc = self?.topViewController else { return }
                
                let feedback = EmailFeedbackManager.Feedback(recipients: C.feedbackEmail, subject: L10n.Title.rockwalletFeedback, body: "")
                if let feedbackManager = EmailFeedbackManager(feedback: feedback, on: topVc) {
                    self?.feedbackManager = feedbackManager
                    
                    self?.feedbackManager?.send { _ in
                        self?.feedbackManager = nil
                    }
                } else {}
            },
            // Manage Assets
            MenuItem(title: L10n.MenuButton.manageAssets, icon: MenuItem.Icon.wallet) { [weak self] in
                guard let self = self, let assetCollection = self.system.assetCollection else { return }
                let vc = ManageWalletsViewController(assetCollection: assetCollection, coreSystem: self.system)
                menuNav.pushViewController(vc, animated: true)
            },
           
            // Preferences
            MenuItem(title: L10n.Settings.preferences, icon: MenuItem.Icon.preferences, subMenu: preferencesItems, rootNav: menuNav),
            
            // Security Settings
            MenuItem(title: L10n.MenuButton.security, icon: Asset.lockClosed.image, subMenu: securityItems, rootNav: menuNav),
            
            // Support
            MenuItem(title: L10n.MenuButton.support, icon: MenuItem.Icon.support) { [weak self] in
                self?.presentFaq()
            },
            // About
            MenuItem(title: L10n.Settings.about, icon: MenuItem.Icon.about) {
                menuNav.pushViewController(AboutViewController(), animated: true)
            },
            // Export transaction history
            MenuItem(title: L10n.Settings.exportTransfers, icon: MenuItem.Icon.export) { [weak self] in
                self?.presentExportTransfers()
            }
        ]
        
        // MARK: Developer/QA Menu
        
        if E.isSimulator || E.isDebug || E.isTestFlight {
            var developerItems = [MenuItem]()
            
            developerItems.append(MenuItem(title: L10n.Title.fastSync, callback: { [weak self] in
                self?.presentConnectionModeScreen(menuNav: menuNav)
            }))
            
            developerItems.append(MenuItem(title: L10n.Title.sendLogs) { [weak self] in
                self?.showEmailLogsModal()
            })
            
            developerItems.append(MenuItem(title: L10n.Title.lockWallet) {
                Store.trigger(name: .lock)
            })
            
            developerItems.append(MenuItem(title: L10n.Title.unlinkWalletNoPrompt) {
                Store.trigger(name: .wipeWalletNoPrompt)
            })
            
            if E.isDebug { // for dev/debugging use only
                // For test wallets with a PIN of 111111, the PIN is auto entered on startup.
                let title = UserDefaults.debugShouldAutoEnterPIN ? L10n.PushNotifications.on.uppercased() : L10n.PushNotifications.off.uppercased()
                developerItems.append(MenuItem(title: L10n.Title.autoEnterPin,
                                               accessoryText: { title },
                                               callback: {
                    _ = UserDefaults.toggleAutoEnterPIN()
                    (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                }))
                
                developerItems.append(MenuItem(title: L10n.Title.connectionSettingsOverride,
                                               accessoryText: { UserDefaults.debugConnectionModeOverride.description },
                                               callback: {
                    UserDefaults.cycleConnectionModeOverride()
                    (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                }))
            }
            
            // For test wallets, suppresses the paper key prompt on the home screen.
            
            var title = UserDefaults.debugShouldSuppressPaperKeyPrompt ? L10n.PushNotifications.on.uppercased() : L10n.PushNotifications.off.uppercased()
            developerItems.append(MenuItem(title: L10n.Title.suppressPaperKeyPrompt,
                                           accessoryText: { title },
                                           callback: {
                _ = UserDefaults.toggleSuppressPaperKeyPrompt()
                (menuNav.topViewController as? MenuViewController)?.reloadMenu()
            }))
            
            title = UserDefaults.debugShowAppRatingOnEnterWallet ? L10n.PushNotifications.on.uppercased() : L10n.PushNotifications.off.uppercased()
            // always show the app rating when viewing transactions if 'ON' AND Suppress is 'OFF' (see below)
            developerItems.append(MenuItem(title: "App rating on enter wallet",
                                           accessoryText: { title },
                                           callback: {
                _ = UserDefaults.toggleShowAppRatingPromptOnEnterWallet()
                (menuNav.topViewController as? MenuViewController)?.reloadMenu()
            }))
            
            developerItems.append(MenuItem(title: "Suppress app rating prompt",
                                           accessoryText: { UserDefaults.debugSuppressAppRatingPrompt ? "ON" : "OFF" },
                                           callback: {
                _ = UserDefaults.toggleSuppressAppRatingPrompt()
                (menuNav.topViewController as? MenuViewController)?.reloadMenu()
            }))
            
            // Shows a preview of the paper key.
            if UserDefaults.debugShouldAutoEnterPIN, let paperKey = keyStore.seedPhrase(pin: "111111") {
                let words = paperKey.components(separatedBy: " ")
                let timestamp = (try? keyStore.loadAccount().map { $0.timestamp }.get()) ?? Date.zeroValue()
                let preview = "\(words[0]) \(words[1])... (\(DateFormatter.mediumDateFormatter.string(from: timestamp))"
                developerItems.append(MenuItem(title: "Paper key preview",
                                               accessoryText: { UserDefaults.debugShouldShowPaperKeyPreview ? preview : "" },
                                               callback: {
                    _ = UserDefaults.togglePaperKeyPreview()
                    (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                }))
            }
            
            developerItems.append(MenuItem(title: "Reset User Defaults",
                                           callback: {
                UserDefaults.resetAll()
                menuNav.showAlert(title: "", message: "User defaults reset")
                (menuNav.topViewController as? MenuViewController)?.reloadMenu()
            }))
            
            developerItems.append(MenuItem(title: "Clear Core persistent storage and exit",
                                           callback: { [weak self] in
                guard let self = self else { return }
                self.system.shutdown {
                    fatalError("forced exit")
                }
            }))
            
            developerItems.append(
                MenuItem(title: "API Host",
                         accessoryText: { Backend.apiClient.host }, callback: {
                             let alert = UIAlertController(title: "Set API Host", message: "Clear and save to reset", preferredStyle: .alert)
                             alert.addTextField(configurationHandler: { textField in
                                 textField.text = Backend.apiClient.host
                                 textField.keyboardType = .URL
                                 textField.clearButtonMode = .always
                             })
                             
                             alert.addAction(UIAlertAction(title: L10n.Title.save, style: .default) { (_) in
                                 guard let newHost = alert.textFields?.first?.text, !newHost.isEmpty else {
                                     UserDefaults.debugBackendHost = nil
                                     Backend.apiClient.host = C.backendHost
                                     (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                                     return
                                 }
                                 let originalHost = Backend.apiClient.host
                                 Backend.apiClient.host = newHost
                                 Backend.apiClient.me { (success, _, _) in
                                     if success {
                                         UserDefaults.debugBackendHost = newHost
                                         (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                                     } else {
                                         Backend.apiClient.host = originalHost
                                     }
                                 }
                             })
                             
                             alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
                             
                             menuNav.present(alert, animated: true)
                         }))
            
            developerItems.append(
                MenuItem(title: L10n.Settings.webDebugUrl,
                         accessoryText: { UserDefaults.platformDebugURL?.absoluteString ?? "<not set>" }, callback: {
                             let alert = UIAlertController(title: "Set debug URL", message: "Clear and save to reset", preferredStyle: .alert)
                             alert.addTextField(configurationHandler: { textField in
                                 textField.text = UserDefaults.platformDebugURL?.absoluteString ?? ""
                                 textField.keyboardType = .URL
                                 textField.clearButtonMode = .always
                             })
                             
                             alert.addAction(UIAlertAction(title: L10n.Title.save, style: .default) { (_) in
                                 guard let input = alert.textFields?.first?.text,
                                       !input.isEmpty,
                                       let debugURL = URL(string: input) else {
                                     UserDefaults.platformDebugURL = nil
                                     (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                                     return
                                 }
                                 UserDefaults.platformDebugURL = debugURL
                                 (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                             })
                             
                             alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
                             
                             menuNav.present(alert, animated: true)
                         }))
            
            developerItems.append(MenuItem(title: L10n.Settings.debugCrash) {
                fatalError(L10n.Settings.debugCrash)
            })
            
            rootItems.append(MenuItem(title: L10n.Settings.developerOptions, icon: nil, subMenu: developerItems, rootNav: menuNav, faqButton: nil))
        }
        
        let rootMenu = MenuViewController(items: rootItems,
                                          title: L10n.Settings.title)
        rootMenu.addCloseNavigationItem(side: .right)
        menuNav.viewControllers = [rootMenu]
        
        self.menuNavController = menuNav
        
        self.topViewController?.present(menuNav, animated: true)
    }
    
    private func presentConnectionModeScreen(menuNav: UINavigationController) {
        guard let kv = Backend.kvStore, let walletInfo = WalletInfo(kvStore: kv) else {
            return assertionFailure()
        }
        let connectionSettings = WalletConnectionSettings(system: self.system,
                                                          kvStore: kv,
                                                          walletInfo: walletInfo)
        let connectionSettingsVC = WalletConnectionSettingsViewController(walletConnectionSettings: connectionSettings) { _ in
            (menuNav.viewControllers.compactMap { $0 as? MenuViewController }).last?.reloadMenu()
        }
        menuNav.pushViewController(connectionSettingsVC, animated: true)
    }
    
    private func presentScan(parent: UIViewController, currency: Currency?) -> PresentScan {
        return { [weak parent] scanCompletion in
            guard ScanViewController.isCameraAllowed else {
                if let parent = parent {
                    ScanViewController.presentCameraUnavailableAlert(fromRoot: parent)
                }
                return
            }
            
            let vc = ScanViewController(forPaymentRequestForCurrency: currency, completion: { scanResult in
                scanCompletion(scanResult)
                parent?.view.isFrameChangeBlocked = false
            })
            parent?.view.isFrameChangeBlocked = true
            parent?.present(vc, animated: true, completion: {})
        }
    }
    
    private func presentWritePaperKey(fromViewController vc: UIViewController) {
        RecoveryKeyFlowController.enterRecoveryKeyFlow(pin: nil,
                                                       keyMaster: self.keyStore,
                                                       from: vc,
                                                       context: .none,
                                                       dismissAction: nil)
    }
    
    private func wipeWallet() {
        let alert = UIAlertController.confirmationAlert(title: L10n.WipeWallet.alertTitle,
                                                        message: L10n.WipeWallet.alertMessage,
                                                        okButtonTitle: L10n.Button.yes,
                                                        cancelButtonTitle: L10n.Button.cancel) {
            Store.perform(action: Alert.Show(.walletUnlinked(callback: {
                self.topViewController?.dismiss(animated: true, completion: {
                    Store.trigger(name: .wipeWalletNoPrompt)
                })
            })))
        }
        topViewController?.present(alert, animated: true)
    }
    
    private func presentKeyImport(wallet: Wallet, scanResult: QRCode? = nil) {
        let nc = RootNavigationController()
        nc.modalPresentationStyle = .overFullScreen
        let start = ImportKeyViewController(wallet: wallet, initialQRCode: scanResult)
        start.addCloseNavigationItem()
        let faqButton = UIButton.buildFaqButton(articleId: ArticleIds.importWallet, currency: wallet.currency, position: .right)
        start.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: faqButton)]
        nc.pushViewController(start, animated: true)
        topViewController?.present(nc, animated: true)
    }
    
    // MARK: - Prompts
    
    func presentExportTransfers() {
        let alert = UIAlertController(title: L10n.ExportTransfers.header, message: L10n.ExportTransfers.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.ExportTransfers.confirmExport, style: .default, handler: { (_) in
            self.topViewController?.present(BRActivityViewController(message: ""), animated: true)
            DispatchQueue.global(qos: .background).async {
                guard let csvFile = CsvExporter.instance.exportTransfers(wallets: self.system.wallets) else {
                    DispatchQueue.main.async {
                        self.topViewController?.dismiss(animated: true) {
                            self.topViewController?.showAlert(
                                title: L10n.ExportTransfers.exportFailedTitle,
                                message: L10n.ExportTransfers.exportFailedBody)
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.topViewController?.dismiss(animated: true) {
                        let activityViewController = UIActivityViewController(activityItems: [csvFile], applicationActivities: nil)
                        self.topViewController?.present(activityViewController, animated: true)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        topViewController?.present(alert, animated: true)
    }
    
    func presentBiometricsMenuItem() {
        let biometricsSettings = BiometricsSettingsViewController(keyStore)
        let nc = RootNavigationController(rootViewController: biometricsSettings)
        biometricsSettings.addCloseNavigationItem()
        topViewController?.present(nc, animated: true)
    }
    
    private func promptShareData() {
        let shareData = ShareDataViewController()
        let nc = RootNavigationController(rootViewController: shareData)
        shareData.addCloseNavigationItem()
        topViewController?.present(nc, animated: true)
    }
    
    func presentWritePaperKey() {
        guard let vc = topViewController else { return }
        presentWritePaperKey(fromViewController: vc)
    }
    
    func presentUpgradePin() {
        let updatePin = UpdatePinViewController(keyMaster: keyStore, type: .update)
        let nc = RootNavigationController(rootViewController: updatePin)
        updatePin.addCloseNavigationItem()
        topViewController?.present(nc, animated: true)
    }
    
    private func handleFile(_ file: Data) {
        //TODO:CRYPTO payment request -- what is this use case?
        /*
        if let request = PaymentProtocolRequest(data: file) {
            if let topVC = topViewController as? ModalViewController {
                let attemptConfirmRequest: () -> Bool = {
                    if let send = topVC.childViewController as? SendViewController {
                        send.confirmProtocolRequest(request)
                        return true
                    }
                    return false
                }
                if !attemptConfirmRequest() {
                    modalTransitionDelegate.reset()
                    topVC.dismiss(animated: true, completion: {
                        //TODO:BCH
                        Store.perform(action: RootModalActions.Present(modal: .send(currency: Currencies.btc)))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { //This is a hack because present has no callback
                            _ = attemptConfirmRequest()
                        })
                    })
                }
            }
        } else if let ack = PaymentProtocolACK(data: file) {
            if let memo = ack.memo {
                let alert = UIAlertController(title: "", message: memo, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .cancel, handler: nil))
                topViewController?.present(alert, animated: true)
            }
            //TODO - handle payment type
        } else {
            let alert = UIAlertController(title: L10n.Alert.error, message: L10n.PaymentProtocol.Errors.corruptedDocument, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .cancel, handler: nil))
            topViewController?.present(alert, animated: true)
        }
         */
    }
    
    private func handlePaymentRequest(request: PaymentRequest) {
        self.currentRequest = request
        
        guard !Store.state.isLoginRequired else {
            presentModal(.send(currency: request.currency))
            
            return
        }
        
        showAccountView(currency: request.currency, animated: false) {
            self.presentModal(.send(currency: request.currency))
        }
    }
    
    private func showAccountView(currency: Currency, animated: Bool, completion: (() -> Void)?) {
        let pushAccountView = {
            guard let nc = self.topViewController?.navigationController as? RootNavigationController,
                  nc.viewControllers.count == 1 else { return }
            let accountViewController = AccountViewController(currency: currency, wallet: self.system.wallet(for: currency))
            nc.pushViewController(accountViewController, animated: animated)
            completion?()
        }
        
        if let accountVC = topViewController as? AccountViewController {
            if accountVC.currency == currency {
                completion?()
            } else {
                accountVC.navigationController?.popToRootViewController(animated: false)
                pushAccountView()
            }
        } else if topViewController is HomeScreenViewController {
            pushAccountView()
        } else if let presented = UIApplication.shared.activeWindow?.rootViewController?.presentedViewController {
            if let nc = presented.presentingViewController as? RootNavigationController, nc.viewControllers.count > 1 {
                // modal on top of another account screen
                presented.dismiss(animated: false) {
                    self.showAccountView(currency: currency, animated: animated, completion: completion)
                }
            } else {
                presented.dismiss(animated: true) {
                    pushAccountView()
                }
            }
        }
    }
    
    private func handleScanQrURL() {
        guard !Store.state.isLoginRequired else { presentLoginScan(); return }
        if topViewController is AccountViewController || topViewController is LoginViewController {
            presentLoginScan()
        } else {
            if let presented = UIApplication.shared.activeWindow?.rootViewController?.presentedViewController {
                presented.dismiss(animated: true, completion: {
                    self.presentLoginScan()
                })
            }
        }
    }
    
    private func authenticateForPlatform(prompt: String, allowBiometricAuth: Bool, callback: @escaping (PlatformAuthResult) -> Void) {
        if allowBiometricAuth && keyStore.isBiometricsEnabledForUnlocking {
            keyStore.authenticate(withBiometricsPrompt: prompt, completion: { result in
                switch result {
                case .success:
                    return callback(.success(nil))
                case .cancel:
                    return callback(.cancelled)
                case .failure:
                    self.verifyPinForPlatform(prompt: prompt, callback: callback)
                case .fallback:
                    self.verifyPinForPlatform(prompt: prompt, callback: callback)
                }
            })
        } else {
            self.verifyPinForPlatform(prompt: prompt, callback: callback)
        }
    }
    
    private func verifyPinForPlatform(prompt: String, callback: @escaping (PlatformAuthResult) -> Void) {
        let verify = VerifyPinViewController(bodyText: prompt,
                                             pinLength: Store.state.pinLength,
                                             walletAuthenticator: keyStore,
                                             pinAuthenticationType: .unlocking,
                                             success: { pin in
            callback(.success(pin))
        })
        verify.didCancel = { callback(.cancelled) }
        verify.transitioningDelegate = verifyPinTransitionDelegate
        verify.modalPresentationStyle = .overFullScreen
        verify.modalPresentationCapturesStatusBarAppearance = true
        topViewController?.present(verify, animated: true)
    }
    
    private func confirmTransaction(currency: Currency, amount: Amount, fee: Amount, displayFeeLevel: FeeLevel, address: String, callback: @escaping (Bool) -> Void) {
        let confirm = ConfirmationViewController(amount: amount,
                                                 fee: fee,
                                                 displayFeeLevel: displayFeeLevel,
                                                 address: address,
                                                 currency: currency,
                                                 shouldShowMaskView: true)
        confirm.successCallback = {
            callback(true)
        }
        confirm.cancelCallback = {
            callback(false)
        }
        topViewController?.present(confirm, animated: true)
    }
    
    private var topViewController: UIViewController? {
        var viewController = window.rootViewController
        if let nc = viewController as? UINavigationController {
            viewController = nc.topViewController
        }
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        return viewController
    }
    
    private func showLightWeightAlert(message: String) {
        let alert = LightWeightAlert(message: message)
        guard let view = UIApplication.shared.activeWindow else { return }
        view.addSubview(alert)
        alert.constrain([
            alert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: view.centerYAnchor) ])
        alert.background.effect = nil
        UIView.animate(withDuration: 0.6, animations: {
            alert.background.effect = alert.effect
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 1.0, options: [], animations: {
                alert.background.effect = nil
            }, completion: { _ in
                alert.removeFromSuperview()
            })
        })
    }
    
    private func showEmailLogsModal() {
        self.messagePresenter.presenter = self.topViewController
        self.messagePresenter.presentEmailLogs()
    }
    
    private func prepareSecuritySettingsMenuItems(menuNav: RootNavigationController) -> [MenuItem] {
        // MARK: Security Settings
        var securityItems: [MenuItem] = [
            // Unlink
            MenuItem(title: L10n.Settings.wipe) { [weak self] in
                guard let self = self, let vc = self.topViewController else { return }
                RecoveryKeyFlowController.presentUnlinkWalletFlow(from: vc,
                                                                  keyMaster: self.keyStore,
                                                                  phraseEntryReason: .validateForWipingWallet({ [weak self] in
                    self?.wipeWallet()
                }))
            },
            
            // Update PIN
            MenuItem(title: L10n.UpdatePin.updateTitle) { [weak self] in
                guard let self = self else { return }
                let updatePin = UpdatePinViewController(keyMaster: self.keyStore, type: .update)
                menuNav.pushViewController(updatePin, animated: true)
            },
            
            // Biometrics
            MenuItem(title: LAContext.biometricType() == .face ? L10n.SecurityCenter.faceIdTitle : L10n.SecurityCenter.touchIdTitle) { [weak self] in
                guard let self = self else { return }
                self.presentBiometricsMenuItem()
            },
            
            // Paper key
            MenuItem(title: L10n.SecurityCenter.paperKeyTitle) { [weak self] in
                guard let self = self else { return }
                self.presentWritePaperKey(fromViewController: menuNav)
            },
            
            // Portfolio data for widget
            MenuItem(title: L10n.Settings.shareWithWidget,
                     accessoryText: { [weak self] in
                         self?.system.widgetDataShareService.sharingEnabled ?? false ? L10n.PushNotifications.on.uppercased() : L10n.PushNotifications.off.uppercased()
                     },
                     callback: { [weak self] in
                         self?.system.widgetDataShareService.sharingEnabled.toggle()
                         (menuNav.topViewController as? MenuViewController)?.reloadMenu()
                     }),
            
            // Add iCloud backup
            MenuItem(title: L10n.CloudBackup.backupMenuTitle) {
                let synchronizer = BackupSynchronizer(context: .existingWallet, keyStore: self.keyStore, navController: menuNav)
                let cloudView = CloudBackupView(synchronizer: synchronizer)
                let hosting = UIHostingController(rootView: cloudView)
                menuNav.pushViewController(hosting, animated: true)
            }
        ]
        
        let deleteAccount = MenuItem(title: L10n.Account.deleteAccount, color: LightColors.Error.one) { [weak self] in
            self?.deleteAccountCallback?()
        }
        
        if UserManager.shared.profile?.roles.contains(.customer) == true,
           UserDefaults.email != nil {
            securityItems.append(deleteAccount)
        }
        
        return securityItems
    }
}
