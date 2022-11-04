//
//  LoginViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-01-19.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication
import WalletKit
import MachO

class LoginViewController: UIViewController, Subscriber {
    enum Context {
        case initialLaunch(loginHandler: LoginCompletionHandler)
        case automaticLock
        case manualLock
        case confirmation

        var shouldAttemptBiometricUnlock: Bool {
            switch self {
            case .manualLock:
                return false
            default:
                return true
            }
        }
    }

    init(for context: Context, keyMaster: KeyMaster, shouldDisableBiometrics: Bool) {
        self.context = context
        self.keyMaster = keyMaster
        self.disabledView = WalletDisabledView()
        self.shouldDisableBiometrics = shouldDisableBiometrics
        
        guard case .confirmation = context else {
            super.init(nibName: nil, bundle: nil)
            return
        }
        
        self.pinViewStyle = .confirm
        super.init(nibName: nil, bundle: nil)
        
        resetPinButton.isHidden = true
        header.text = L10n.VerifyPin.title
        instruction.text = L10n.VerifyPin.continueBody
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationObservers.values.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
        Store.unsubscribe(self)
    }

    // MARK: - Private
    private let keyMaster: KeyMaster
    private let backgroundView = UIView()
    private let pinViewContainer = UIView()
    private lazy var pinPad: PinPadViewController = {
        return PinPadViewController(style: .clear, keyboardType: .pinPad, maxDigits: 0, shouldShowBiometrics: shouldUseBiometrics)
    }()
    private var pinViewStyle: PinViewStyle = .login
    private lazy var pinView: PinView = {
        return PinView(style: pinViewStyle, length: Store.state.pinLength)
    }()
    private let disabledView: WalletDisabledView
    private var logo: UIImageView = {
        let view = UIImageView(image: .init(named: "logo_icon"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var pinPadPottom: NSLayoutConstraint?
    private var topControlTop: NSLayoutConstraint?
    private var unlockTimer: Timer?
    private let pinPadBackground = UIView(color: LightColors.Text.one)
    private let logoBackground = MotionGradientView()
    private var hasAttemptedToShowBiometrics = false
    private let lockedOverlay = UIVisualEffectView()
    private var isResetting = false
    private let context: Context
    private var notificationObservers = [String: NSObjectProtocol]()
    private let debugLabel = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    private let shouldDisableBiometrics: Bool
    
    var confirmationCallback: ((_ success: Bool) -> Void)?
    
    var isBiometricsEnabledForUnlocking: Bool {
        return self.keyMaster.isBiometricsEnabledForUnlocking
    }
    
    lazy var header: UILabel = {
        let header = UILabel()
        header.textColor = LightColors.Text.three
        header.font = Fonts.Title.six
        header.textAlignment = .center
        header.text = L10n.UpdatePin.securedWallet
        
        return header
    }()
    
    lazy var instruction: UILabel = {
        let instruction = UILabel()
        instruction.textColor = LightColors.Text.two
        instruction.font = Fonts.Body.two
        instruction.textAlignment = .center
        instruction.text = L10n.UpdatePin.enterYourPin
        
        return instruction
    }()
    
    lazy var resetPinButton: UIButton = {
        let resetPinButton = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Subtitle.two,
        NSAttributedString.Key.foregroundColor: LightColors.secondary]

        let attributedString = NSMutableAttributedString(string: L10n.RecoverWallet.headerResetPin, attributes: attributes)
        resetPinButton.setAttributedTitle(attributedString, for: .normal)
        resetPinButton.addTarget(self, action: #selector(resetPinTapped), for: .touchUpInside)
        
        return resetPinButton
    }()
    
    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        addPinPadCallbacks()
        setupCloseButton()

        disabledView.didTapReset = { [weak self] in
            guard let self = self else { return }
            self.isResetting = true
            
            RecoveryKeyFlowController.enterResetPinFlow(from: self,
                                                        keyMaster: self.keyMaster,
                                                        callback: { (phrase, navController) in
                                                            let updatePin = UpdatePinViewController(keyMaster: self.keyMaster,
                                                                                                    type: .creationWithPhrase,
                                                                                                    showsBackButton: false,
                                                                                                    phrase: phrase)
                                                            
                                                            navController.pushViewController(updatePin, animated: true)
                                                            
                                                            updatePin.resetFromDisabledWillSucceed = {
                                                                self.disabledView.isHidden = true
                                                            }
                                                            
                                                            updatePin.resetFromDisabledSuccess = { pin in
                                                                if case .initialLaunch = self.context {
                                                                    guard let account = self.keyMaster.createAccount(withPin: pin) else { return assertionFailure() }
                                                                    self.authenticationSucceded(forLoginWithAccount: account)
                                                                } else {
                                                                    self.authenticationSucceded()
                                                                }
                                                            }
            })            
        }
        disabledView.didCompleteWipeGesture = { [weak self] in
            guard let self = self else { return }
            self.wipeFromDisabledGesture()
        }
        disabledView.didTapFaq = { [weak self] in
            guard let self = self else { return }
            self.faqButtonPressed()
        }
        
        updateDebugLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard UIApplication.shared.applicationState != .background else { return }

        if shouldUseBiometrics && !hasAttemptedToShowBiometrics && context.shouldAttemptBiometricUnlock {
            hasAttemptedToShowBiometrics = true
            biometricsTapped()
        }
        
        if !isResetting {
            lockIfNeeded()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unlockTimer?.invalidate()
    }
    
    func setupCloseButton() {
        guard case .confirm = pinViewStyle else { return }

        let closeButton = UIBarButtonItem(image: .init(named: "close"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(dismissModal))

        guard navigationItem.rightBarButtonItem == nil else {
            navigationItem.setLeftBarButton(closeButton, animated: false)
            return
        }
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    @objc func dismissModal() {
        confirmationCallback?(false)
    }

    private func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(pinViewContainer)
        pinViewContainer.addSubview(pinView)
        view.addSubview(logo)
        view.addSubview(header)
        view.addSubview(instruction)
        view.addSubview(resetPinButton)
        view.addSubview(pinPadBackground)
        view.addSubview(debugLabel)
    }

    private func addConstraints() {
        backgroundView.constrain(toSuperviewEdges: nil)
        backgroundView.backgroundColor = LightColors.Background.one
        pinViewContainer.constrain(toSuperviewEdges: nil)
        
        pinPadPottom = pinPadBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        pinPadBackground.constrain([
            pinPadBackground.widthAnchor.constraint(equalToConstant: floor(UIScreen.main.safeWidth/3.0)*3.0),
            pinPadBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinPadBackground.heightAnchor.constraint(equalToConstant: pinPad.height),
            pinPadPottom])
        
        pinView.constrain([
            pinView.centerYAnchor.constraint(equalTo: pinViewContainer.centerYAnchor),
            pinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinView.widthAnchor.constraint(equalToConstant: pinView.width),
            pinView.heightAnchor.constraint(equalToConstant: ViewSizes.small.rawValue)])
        
        debugLabel.constrain([
            debugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.huge.rawValue),
            debugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue)
        ])
        topControlTop = logo.topAnchor.constraint(equalTo: view.topAnchor,
                                                  constant: ViewSizes.medium.rawValue * 2 + C.brdLogoTopMargin)
        logo.constrain([
            logo.bottomAnchor.constraint(equalTo: pinView.topAnchor, constant: -Margins.extraHuge.rawValue),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: ViewSizes.large.rawValue)
        ])
        
        header.constrain([
            header.bottomAnchor.constraint(equalTo: instruction.topAnchor, constant: -Margins.large.rawValue),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        instruction.constrain([
            instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instruction.bottomAnchor.constraint(equalTo: logo.topAnchor, constant: -Margins.extraHuge.rawValue)])
        
        resetPinButton.constrain([
            resetPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetPinButton.heightAnchor.constraint(equalToConstant: Margins.extraLarge.rawValue),
            resetPinButton.bottomAnchor.constraint(equalTo: pinPadBackground.topAnchor, constant: -Margins.extraHuge.rawValue)])
        
        addChild(pinPad)
        pinPadBackground.addSubview(pinPad.view)
        pinPad.view.constrain(toSuperviewEdges: nil)
        pinPad.didMove(toParent: self)
    }
    
    func faqButtonPressed() {
        let text = L10n.AccountCreation.walletDisabled
        
        let model = PopupViewModel(title: .text(L10n.AccountCreation.walletDisabledTitle),
                                   body: text)
        
        showInfoPopup(with: model)
    }
    
    @objc private func resetPinTapped() {
        isResetting = true
        
        RecoveryKeyFlowController.enterResetPinFlow(from: self,
                                                    keyMaster: self.keyMaster,
                                                    callback: { (phrase, navController) in
            let updatePin = UpdatePinViewController(keyMaster: self.keyMaster,
                                                    type: .creationWithPhrase,
                                                    showsBackButton: true,
                                                    phrase: phrase)
            
            navController.pushViewController(updatePin, animated: true)
            
            updatePin.resetFromDisabledSuccess = { pin in
                if case .initialLaunch = self.context {
                    guard let account = self.keyMaster.createAccount(withPin: pin) else { return assertionFailure() }
                    self.authenticationSucceded(forLoginWithAccount: account)
                } else {
                    self.authenticationSucceded()
                }
            }
        })
    }

    private func addPinPadCallbacks() {
        pinPad.didTapBiometrics = { [weak self] in
            self?.biometricsTapped()
        }
        pinPad.ouputDidUpdate = { [weak self] pin in
            guard let pinView = self?.pinView else { return }
            let attemptLength = pin.utf8.count
            pinView.fill(attemptLength)
            self?.pinPad.isAppendingDisabled = attemptLength < Store.state.pinLength ? false : true
            if attemptLength == Store.state.pinLength {
                self?.authenticate(withPin: pin)
            }
        }
    }

    private func authenticate(withPin pin: String) {
        if case .initialLaunch = context {
            guard let account = keyMaster.createAccount(withPin: pin) else { return authenticationFailed() }
            authenticationSucceded(forLoginWithAccount: account, pin: pin)
        } else {
            guard keyMaster.authenticate(withPin: pin) else { return authenticationFailed() }
            authenticationSucceded(pin: pin)
        }
    }

    private func authenticationSucceded(forLoginWithAccount account: Account? = nil, pin: String? = nil) {
        let label = UILabel(font: Fonts.Body.one)
        label.textColor = LightColors.Text.two
        label.alpha = 0.0
        let lock = UIImageView(image: #imageLiteral(resourceName: "unlock"))
        lock.alpha = 0.0

        view.addSubview(label)
        view.addSubview(lock)

        label.constrain([
            label.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -Margins.small.rawValue),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor) ])
        lock.constrain([
            lock.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Margins.small.rawValue),
            lock.centerXAnchor.constraint(equalTo: label.centerXAnchor) ])
        view.layoutIfNeeded()

        UIView.spring(0.6, animations: {
            self.pinPadPottom?.constant = self.pinPad.height
            self.topControlTop?.constant = -100.0
            lock.alpha = 1.0
            label.alpha = 1.0
            self.pinView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            Store.trigger(name: .showStatusBar)
            guard case .confirmation = self.context else {
                self.dismiss(animated: true, completion: {
                    Store.perform(action: LoginSuccess())
                    if case .initialLaunch(let loginHandler) = self.context {
                        guard let account = account else { return assertionFailure() }
                        loginHandler(account)
                    }
                })
                return
            }
            self.confirmationCallback?(true)
        })
    }

    private func authenticationFailed() {
        pinPad.view.isUserInteractionEnabled = false
        pinView.shake { [weak self] in
            self?.pinPad.view.isUserInteractionEnabled = true
        }
        pinPad.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + pinView.shakeDuration) {
            self.pinView.fill(0)
            self.lockIfNeeded()
        }
        
        let attempts = keyMaster.pinAttemptsRemaining == 7 ? L10n.UpdatePin.twoAttempts : L10n.UpdatePin.oneAttempt
        let message = "\(L10n.UpdatePin.incorrectPin) \(attempts)"
        showToastMessage(message: message)
        
        updateDebugLabel()
    }

    private var shouldUseBiometrics: Bool {
        return LAContext.canUseBiometrics && !keyMaster.pinLoginRequired && isBiometricsEnabledForUnlocking && !shouldDisableBiometrics
    }

    @objc func biometricsTapped() {
        guard !isWalletDisabled else { return }
        if case .initialLaunch = context {
            keyMaster.createAccount(withBiometricsPrompt: L10n.UnlockScreen.touchIdPrompt, completion: { account in
                if let account = account {
                    self.authenticationSucceded(forLoginWithAccount: account)
                }
            })
        } else {
            keyMaster.authenticate(withBiometricsPrompt: L10n.UnlockScreen.touchIdPrompt, completion: { result in
                if result == .success {
                    self.authenticationSucceded()
                }
            })
        }
    }

    private func lockIfNeeded() {
        guard keyMaster.walletIsDisabled else {
            pinPad.view.isUserInteractionEnabled = true
            disabledView.hide { [weak self] in
                self?.disabledView.removeFromSuperview()
                self?.setNeedsStatusBarAppearanceUpdate()
            }
            return
        }
        
        navigationController?.isNavigationBarHidden = true
        let disabledUntil = keyMaster.walletDisabledUntil
        let disabledUntilDate = Date(timeIntervalSince1970: disabledUntil)
        let unlockInterval = disabledUntil - Date().timeIntervalSince1970
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate(unlockInterval > C.secondsInDay ? "h:mm:ss a MMM d, yyy" : "h:mm:ss a")

        disabledView.setTimeLabel(string: L10n.UnlockScreen.disabled(df.string(from: disabledUntilDate)))

        pinPad.view.isUserInteractionEnabled = false
        unlockTimer?.invalidate()
        unlockTimer =  Timer.scheduledTimer(withTimeInterval: unlockInterval, repeats: false) { _ in
            self.pinPad.view.isUserInteractionEnabled = true
            self.unlockTimer = nil
            self.disabledView.hide { [unowned self] in
                self.disabledView.removeFromSuperview()
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }

        if disabledView.superview == nil {
            view.addSubview(disabledView)
            setNeedsStatusBarAppearanceUpdate()
            disabledView.constrain(toSuperviewEdges: .zero)
            disabledView.show()
        }
    }

    private var isWalletDisabled: Bool {
        let now = Date().timeIntervalSince1970
        return keyMaster.walletDisabledUntil > now
    }
    
    private func updateDebugLabel() {
        guard E.isDebug else { return }
        let remaining = keyMaster.pinAttemptsRemaining
        let timestamp = keyMaster.walletDisabledUntil
        let disabledUntil = Date(timeIntervalSince1970: timestamp)
        let firstLine = "\(L10n.UpdatePin.remainingAttempts) \(remaining)"
        let secondLine = "\(L10n.UpdatePin.disabledUntil) \(disabledUntil)"
        debugLabel.text = "\(firstLine)\n\(secondLine)"
    }
    
    private func wipeFromDisabledGesture() {
        let disabledUntil = keyMaster.walletDisabledUntil
        let unlockInterval = disabledUntil - Date().timeIntervalSince1970
        
        //If unlock time is greater than 4 hours allow wiping
        guard unlockInterval > (C.secondsInMinute * 60 * 4.0) else { return }
        let alertView = UIAlertController(title: "",
                                          message: L10n.UnlockScreen.wipePrompt, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: L10n.Button.cancel, style: .default, handler: nil))
        alertView.addAction(UIAlertAction(title: L10n.JailbreakWarnings.wipe, style: .destructive, handler: { _ in
            Store.trigger(name: .wipeWalletNoPrompt)
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
