//
//  ApplicationController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-21.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import WalletKit
import UserNotifications
import IQKeyboardManagerSwift
#if canImport(WidgetKit)
import WidgetKit
#endif

class ApplicationController: Subscriber {
    let window = UIWindow()
    var coordinator: BaseCoordinator?
    
    private var modalPresenter: ModalPresenter? {
        didSet {
            DispatchQueue.main.async {
                guard let nvc = self.rootNavigationController else { return }
                self.coordinator = BaseCoordinator(navigationController: nvc)
                self.coordinator?.modalPresenter = self.modalPresenter
            }
        }
    }
    
    private var rootNavigationController: RootNavigationController? {
        return window.rootViewController as? RootNavigationController
    }
    
    var homeScreenViewController: HomeScreenViewController? {
        guard let rootNavController = rootNavigationController,
              let homeScreen = rootNavController.viewControllers.first as? HomeScreenViewController else { return nil }
        return homeScreen
    }
    
    private var application: UIApplication?
    private let coreSystem: CoreSystem!
    private var keyStore: KeyStore!
    private let timeSinceLastExitKey = "TimeSinceLastExit"
    private let shouldRequireLoginTimeoutKey = "ShouldRequireLoginTimeoutKey"
    private var launchURL: URL?
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var startFlowController: StartFlowPresenter?
    private var alertPresenter: AlertPresenter?
    private var urlController: URLController?
    private let notificationHandler = NotificationHandler()
    private var appRatingManager = AppRatingManager()
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    private var shouldDisableBiometrics = false
    
    private var isReachable = true {
        didSet {
            if oldValue == false && isReachable { retryAfterIsReachable() }
        }
    }

    var didTapDeleteAccount: (() -> Void)?
    
    // MARK: - Init/Launch

    init() {
        do {
            self.keyStore = try KeyStore.create()
            self.coreSystem = CoreSystem(keyStore: keyStore)
        } catch { // only possible exception here should be if the keychain is inaccessible
            fatalError("error initializing key store")
        }

        isReachable = Reachability.isReachable
    }

    /// didFinishLaunchingWithOptions
    func launch(application: UIApplication, options: [UIApplication.LaunchOptionsKey: Any]?) {
        handleLaunchOptions(options)
        
        UNUserNotificationCenter.current().delegate = notificationHandler

        mainSetup()
        setupKeyboard()
        
        Reachability.addDidChangeCallback({ isReachable in
            self.isReachable = isReachable
        })

        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func bumpLaunchCount() {
        guard !keyStore.noWallet else { return }
        UserDefaults.appLaunchCount = (UserDefaults.appLaunchCount + 1)
    }
    
    private func mainSetup() {
        setupDefaults()
        setupRootViewController()
        window.makeKeyAndVisible()
        
        alertPresenter = AlertPresenter(window: window)
        modalPresenter = ModalPresenter(keyStore: keyStore,
                                        system: coreSystem,
                                        window: window,
                                        alertPresenter: alertPresenter,
                                        deleteAccountCallback: didTapDeleteAccount)
        appRatingManager.start()
        setupSubscribers()
        
        ExchangeCurrencyHelper.revertIfNeeded(coordinator: coordinator, completion: { [weak self] in
            self?.initializeAssets(completionHandler: { [weak self] in
                self?.decideFlow()
            })
        })
    }
    
    private func decideFlow() {
        if keyStore.noWallet {
            enterOnboarding()
        } else {
            unlockExistingAccount()
        }
    }
    
    private func setupSubscribers() {
        Store.subscribe(self, name: .wipeWalletNoPrompt, callback: { [weak self] _ in
            self?.wipeWalletNoPrompt()
        })
        
        Store.subscribe(self, name: .didWipeWallet) { [unowned self] _ in
            if let modalPresenter = self.modalPresenter {
                Store.unsubscribe(modalPresenter)
            }
            self.modalPresenter = nil
            self.rootNavigationController?.viewControllers = []
            
            self.setupRootViewController()
            self.decideFlow()
        }
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.disabledToolbarClasses = [SendViewController.self, AmountViewController.self]
    }
    
    private func enterOnboarding() {
        guardProtected {
            guard let startFlowController = self.startFlowController, self.keyStore.noWallet else { return assertionFailure() }
            startFlowController.startOnboarding { [unowned self] account in
                self.setupSystem(with: account)
                Store.perform(action: LoginSuccess())
            }
        }
    }
    
    /// Loads the account for initial launch and initializes the core system
    /// Prompts for login if account needs to be recreated from seed
    private func unlockExistingAccount() {
        guardProtected {
            guard let startFlowController = self.startFlowController, !self.keyStore.noWallet else { return assertionFailure() }
            Store.perform(action: PinLength.Set(self.keyStore.pinLength))
            startFlowController.startLogin { [unowned self] account in
                self.setupSystem(with: account)
            }
        }
    }
    
    /// Initialize the core system with an account
    /// Launch/authenticate with BRDAPI
    /// Initiate KVStore sync
    /// On KVStore sync complete, stand-up Core
    /// Core sync must not begin until KVStore sync completes
    private func setupSystem(with account: Account) {
        // Authenticate with BRDAPI backend
        Backend.connect(authenticator: keyStore as WalletAuthenticator)
        
        DispatchQueue.global(qos: .userInitiated).async {
            Backend.kvStore?.syncAllKeys { [weak self] error in
                print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
                Store.trigger(name: .didSyncKVStore)
                guard let self = self else { return }
                self.setWalletInfo(account: account)
                self.coreSystem.create(account: account,
                                       btcWalletCreationCallback: self.handleDeferedLaunchURL) {
                    self.modalPresenter = ModalPresenter(keyStore: self.keyStore,
                                                         system: self.coreSystem,
                                                         window: self.window,
                                                         alertPresenter: self.alertPresenter,
                                                         deleteAccountCallback: self.didTapDeleteAccount)
                    self.coreSystem.connect()
                    
                    self.wipeWalletIfNeeded()
                }
            }
        }
    }
    
    private func wipeWalletIfNeeded() {
        guard UserDefaults.shouldWipeWalletNoPrompt == true else { return }
        UserDefaults.shouldWipeWalletNoPrompt = false
        Store.trigger(name: .wipeWalletNoPrompt)
    }
    
    private func handleDeferedLaunchURL() {
        // deep link handling
        self.urlController = URLController(walletAuthenticator: self.keyStore)
        if let url = self.launchURL {
            _ = self.urlController?.handleUrl(url)
            self.launchURL = nil
        }
    }
    
    /// background init of assets / animations
    private func initializeAssets(completionHandler: @escaping () -> Void) {
        _ = Rate.symbolMap //Initialize currency symbol map
        
        Backend.apiClient.updateBundles { _ in
            completionHandler()
        }
    }
    
    private func handleLaunchOptions(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let activityDictionary = options?[.userActivityDictionary] as? [String: Any],
              let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
              let url = activity.webpageURL else { return }
        // Handle gift URL at launch.
        launchURL = url
        shouldDisableBiometrics = true
    }
    
    private func setupDefaults() {
        if UserDefaults.standard.object(forKey: shouldRequireLoginTimeoutKey) == nil {
            // Default 3 min timeout.
            UserDefaults.standard.set(C.secondsInMinute*3.0, forKey: shouldRequireLoginTimeoutKey)
        }
    }
    
    // MARK: - Lifecycle
    
    func willEnterForeground() {
        guard !keyStore.noWallet else { return }
        
        if shouldRequireLogin() {
            Store.perform(action: RequireLogin())
        }
        
        resume()
        coreSystem.updateFees()
        bumpLaunchCount()
    }

    func didEnterBackground() {
        pause()
        //Save the backgrounding time if the user is logged in
        if !Store.state.isLoginRequired {
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timeSinceLastExitKey)
        }

        Backend.kvStore?.syncAllKeys { error in
            print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
            Store.trigger(name: .didSyncKVStore)
        }

        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func resume() {
        fetchBackendUpdates()
        coreSystem.resume()
    }
    
    private func pause() {
        coreSystem.pause()
    }

    private func shouldRequireLogin() -> Bool {
        let then = UserDefaults.standard.double(forKey: timeSinceLastExitKey)
        let timeout = UserDefaults.standard.double(forKey: shouldRequireLoginTimeoutKey)
        let now = Date().timeIntervalSince1970
        return now - then > timeout
    }
    
    private func retryAfterIsReachable() {
        guard !keyStore.noWallet else { return }
        resume()
    }
    
    func willResignActive() {
        applyBlurEffect()
        checkForNotificationSettingsChange(appActive: false)
        cacheBalances()
    }
    
    func didBecomeActive() {
        removeBlurEffect()
        checkForNotificationSettingsChange(appActive: true)
    }

    // MARK: Background Task Support

    private func beginBackgroundTask() {
        guard backgroundTaskID == .invalid else { return assertionFailure() }
        UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTaskID)
        backgroundTaskID = .invalid
    }
    
    /// Initialize WalletInfo in KV-store. Needed prior to creating the System.
    private func setWalletInfo(account: Account) {
        guard let kvStore = Backend.kvStore, WalletInfo(kvStore: kvStore) == nil else { return }
        print("[KV] created new WalletInfo")
        let walletInfo = WalletInfo(name: L10n.AccountHeader.defaultWalletName)
        walletInfo.creationDate = account.timestamp
        _ = try? kvStore.set(walletInfo)
    }
    
    /// Fetch updates from backend services.
    private func fetchBackendUpdates() {
        DispatchQueue.global(qos: .utility).async {
            Backend.kvStore?.syncAllKeys { error in
                print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
                Store.trigger(name: .didSyncKVStore)
            }
        }
        
        Backend.updateExchangeRates()
    }
    
    // MARK: - UI
    private func setupRootViewController() {
        let navigationController = RootNavigationController()
        window.rootViewController = navigationController
        
        startFlowController = StartFlowPresenter(keyMaster: keyStore,
                                                 rootViewController: navigationController,
                                                 shouldDisableBiometrics: shouldDisableBiometrics,
                                                 createHomeScreen: createHomeScreen)
        startFlowController?.didFinish = { [weak self] in
            self?.afterLoginFlow()
        }
    }
    
    private func afterLoginFlow() {
        UserManager.shared.refresh { [weak self] result in
            self?.homeScreenViewController?.showPrompts?()
            
            switch result {
            case .success(let profile):
                guard profile?.status == VerificationStatus.none || profile?.status == .emailPending || profile?.roles.contains(.unverified) == true else { return }
                
                self?.coordinator?.showRegistration()
                
            case .failure:
                if let token = UserDefaults.walletTokenValue {
                    let newDeviceRequestData = NewDeviceRequestData(token: token)
                    NewDeviceWorker().execute(requestData: newDeviceRequestData) { [weak self] result in
                        switch result {
                        case .success(let data):
                            UserDefaults.email = data?.email
                            UserDefaults.kycSessionKeyValue = data?.sessionKey
                            
                            self?.coordinator?.showRegistration()
                            
                        case .failure(let error):
                            guard let error = error as? NetworkingError, error != .dataUnavailable else { return }
                            
                            self?.coordinator?.showMessage(with: error)
                        }
                    }
                }
                
            default:
                return
            }
        }
    }
    
    private func addHomeScreenHandlers(homeScreen: HomeScreenViewController,
                                       navigationController: UINavigationController) {
        
        homeScreen.showPrompts = { [weak self] in
            // TODO: Should be refactored with Coordinators.
            self?.homeScreenViewController?.attemptShowKYCPrompt()
        }
        
        homeScreen.didSelectCurrency = { [unowned self] currency in
            let wallet = self.coreSystem.wallet(for: currency)
            let accountViewController = AccountViewController(currency: currency, wallet: wallet)
            navigationController.pushViewController(accountViewController, animated: true)
        }
        
        homeScreen.didTapBuy = { [weak self] in
            guard let self = self else { return }
            
            self.homeScreenViewController?.isInExchangeFlow = true
            
            self.coordinator?.showBuy(coreSystem: self.coreSystem,
                                      keyStore: self.keyStore)
        }
        
        homeScreen.didTapTrade = { [weak self] in
            guard let self = self else { return }
            
            self.homeScreenViewController?.isInExchangeFlow = true
            
            self.coordinator?.showSwap(currencies: Store.state.currencies,
                                       coreSystem: self.coreSystem,
                                       keyStore: self.keyStore)
        }
        
        homeScreen.didTapProfile = { [weak self] in
            self?.coordinator?.showProfile()
        }
        
        didTapDeleteAccount = { [unowned self] in
            coordinator?.showDeleteProfileInfo(keyMaster: keyStore)
        }
        
        homeScreen.didTapProfileFromPrompt = { [unowned self] profile in
            switch profile {
            case .success(let profile):
                if profile?.email == nil {
                    coordinator?.showRegistration(shouldShowProfile: true)
                } else if UserManager.shared.profile?.status.canBuy == false {
                    coordinator?.showVerificationsModally()
                }

            case .failure(let error):
                guard (error as? NetworkingError) == .sessionExpired else { return }
                
                coordinator?.showRegistration(shouldShowProfile: true)
                
            default:
                break
            }
        }
        
        homeScreen.didTapMenu = { [unowned self] in
            self.modalPresenter?.presentMenu()
        }
        
        homeScreen.didTapManageWallets = { [unowned self] in
            guard let assetCollection = self.coreSystem.assetCollection else { return }
            let vc = ManageWalletsViewController(assetCollection: assetCollection, coreSystem: self.coreSystem)
            let nc = RootNavigationController(rootViewController: vc)
            navigationController.present(nc, animated: true, completion: nil)
        }
    }
    
    /// Creates an instance of the home screen. This may be invoked from StartFlowPresenter.presentOnboardingFlow().
    private func createHomeScreen(navigationController: UINavigationController) -> HomeScreenViewController {
        let homeScreen = HomeScreenViewController(walletAuthenticator: keyStore as WalletAuthenticator,
                                                  coreSystem: coreSystem)
        addHomeScreenHandlers(homeScreen: homeScreen, navigationController: navigationController)
        
        return homeScreen
    }
    
    private func applyBlurEffect() {
        guard !Store.state.isLoginRequired && !Store.state.isPromptingBiometrics else { return }
        blurView.alpha = 1.0
        blurView.frame = window.frame
        window.addSubview(blurView)
    }
    
    private func cacheBalances() {
        Store.state.orderedWallets.forEach {
            guard let balance = $0.balance else { return }
            UserDefaults.saveBalance(balance, forCurrency: $0.currency)
        }
    }
    
    private func removeBlurEffect() {
        let duration = Store.state.isLoginRequired ? 0.4 : 0.1 // keep content hidden if lock screen about to appear on top
        UIView.animate(withDuration: duration, animations: {
            self.blurView.alpha = 0.0
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }
    
    // do not call directly, instead use wipeWalletNoPrompt trigger so other subscribers are notified
    private func wipeWalletNoPrompt() {
        let activity = BRActivityViewController(message: L10n.WipeWallet.wiping)
        var topViewController = rootNavigationController as UIViewController?
        while let newTopViewController = topViewController?.presentedViewController {
            topViewController = newTopViewController
        }
        topViewController?.present(activity, animated: true, completion: nil)
        
        let success = keyStore.wipeWallet()
        guard success else { // unexpected error writing to keychain
            activity.dismiss(animated: true)
            topViewController?.showAlert(title: L10n.WipeWallet.failedTitle, message: L10n.WipeWallet.failedMessage)
            return
        }
        
        self.coreSystem.shutdown {
            DispatchQueue.main.async {
                Backend.disconnectWallet()
                Store.perform(action: Reset())
                activity.dismiss(animated: true) {
                    Store.trigger(name: .didWipeWallet)
                }
            }
        }
    }
}

extension ApplicationController {
    func open(url: URL) -> Bool {
        //If this is the same as launchURL, it has already been handled in didFinishLaunchingWithOptions
        guard launchURL != url else { return true }
        if let urlController = urlController {
            return urlController.handleUrl(url)
        } else {
            launchURL = url
            return false
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return open(url: userActivity.webpageURL!)
        }
        return false
    }
}

// MARK: - Push notifications
extension ApplicationController {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard UserDefaults.pushToken != deviceToken else { return }
        UserDefaults.pushToken = deviceToken
        Backend.apiClient.savePushNotificationToken(deviceToken)
        Store.perform(action: PushNotifications.SetIsEnabled(true))
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[PUSH] failed to register for remote notifications: \(error.localizedDescription)")
        Store.perform(action: PushNotifications.SetIsEnabled(false))
    }
    
    private func checkForNotificationSettingsChange(appActive: Bool) {
        guard Backend.isConnected else { return }
        
        if appActive {
            // check if notification settings changed
            NotificationAuthorizer().areNotificationsAuthorized { authorized in
                DispatchQueue.main.async {
                    if authorized {
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        if Store.state.isPushNotificationsEnabled, let pushToken = UserDefaults.pushToken {
                            Store.perform(action: PushNotifications.SetIsEnabled(false))
                            Backend.apiClient.deletePushNotificationToken(pushToken)
                        }
                    }
                }
            }
        } else {
            if !Store.state.isPushNotificationsEnabled, let pushToken = UserDefaults.pushToken {
                Backend.apiClient.deletePushNotificationToken(pushToken)
            }
        }
    }
}
