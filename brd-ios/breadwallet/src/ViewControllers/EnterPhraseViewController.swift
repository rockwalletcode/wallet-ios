//
//  EnterPhraseViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-02-23.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum PhraseEntryReason {
    case setSeed(LoginCompletionHandler)
    case validateForResettingPin(EnterPhraseCallback)
    case validateForWipingWallet(() -> Void)
    case validateForWipingWalletAndDeletingFromDevice(() -> Void)
}

typealias EnterPhraseCallback = (String) -> Void

class EnterPhraseViewController: UIViewController, UIScrollViewDelegate {

    init(keyMaster: KeyMaster, reason: PhraseEntryReason, showBackButton: Bool = true) {
        self.keyMaster = keyMaster
        self.enterPhrase = EnterPhraseCollectionViewController(keyMaster: keyMaster)
        self.faq = UIButton.buildFaqButton(articleId: ArticleIds.recoverWallet, position: .right)
        self.reason = reason
        self.showBackButton = showBackButton
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private
    private let keyMaster: KeyMaster
    private let reason: PhraseEntryReason
    private let showBackButton: Bool
    private let enterPhrase: EnterPhraseCollectionViewController
    private let heading = UILabel.wrapping(font: Fonts.Title.six, color: LightColors.Text.three)
    private let subheading = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    private let faq: UIButton
    private let scrollView = UIScrollView()
    private let container = UIView()
    var phrase: String = ""

    private let headingLeftRightMargins: CGFloat = E.isSmallScreen ? 24 : 54
    
    lazy var contactSupportButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Body.two,
        NSAttributedString.Key.foregroundColor: LightColors.Text.three]

        let attributedString = NSMutableAttributedString(string: L10n.UpdatePin.contactSupport, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(contactSupportTapped), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    lazy var nextButton: FEButton = {
        let button = FEButton()
        
        return button
    }()
    
    var didToggleNextButton: ((FEButton?, UIBarButtonItem?) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHeadings()
        addSubviews()
        addConstraints()
        setInitialData()
        
        if showBackButton {
            setBackButton()
        } else {
            let barButtonItem = UIBarButtonItem(title: "",
                                                style: .plain,
                                                target: self,
                                                action: #selector(dismissFlow))
            barButtonItem.image = Asset.close.image
            navigationItem.rightBarButtonItem = barButtonItem
            
            navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.isEnabled = true
    }
    
    @objc private func dismissFlow() {
        navigationController?.dismiss(animated: true)
    }
    
    func setBackButton() {
        let back = UIBarButtonItem(image: Asset.back.image,
                                   style: .plain,
                                   target: self,
                                   action: #selector(onBackButton))
        back.tintColor = LightColors.Text.three
        navigationItem.leftBarButtonItem = back
    }
    
    @objc func onBackButton() {
        guard navigationController?.viewControllers.first == self else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.dismiss(animated: true)
    }
    
    private func setUpHeadings() {
        [heading, subheading].forEach({
            $0.textAlignment = .center
        })
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(heading)
        container.addSubview(subheading)
        container.addSubview(contactSupportButton)
        scrollView.addSubview(nextButton)

        addChild(enterPhrase)
        container.addSubview(enterPhrase.view)
        enterPhrase.didMove(toParent: self)
    }

    private func addConstraints() {
        scrollView.constrain([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor) ])
        container.constrain(toSuperviewEdges: nil)
        container.constrain([
            container.widthAnchor.constraint(equalTo: view.widthAnchor) ])
        heading.constrain([
            heading.topAnchor.constraint(equalTo: container.topAnchor, constant: Margins.huge.rawValue),
            heading.leftAnchor.constraint(equalTo: container.leftAnchor, constant: headingLeftRightMargins),
            heading.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -headingLeftRightMargins)
            ])
        subheading.constrain([
            subheading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: Margins.large.rawValue),
            subheading.leftAnchor.constraint(equalTo: container.leftAnchor, constant: headingLeftRightMargins),
            subheading.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -headingLeftRightMargins)
            ])
        
        let enterPhraseMargin: CGFloat = E.isSmallScreen ? (Margins.large.rawValue * 0.75) : Margins.large.rawValue
        
        enterPhrase.view.constrain([
            enterPhrase.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: enterPhraseMargin),
            enterPhrase.view.topAnchor.constraint(equalTo: subheading.bottomAnchor, constant: Margins.extraHuge.rawValue),
            enterPhrase.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -enterPhraseMargin),
            enterPhrase.view.heightAnchor.constraint(equalToConstant: enterPhrase.height)])
        
        contactSupportButton.constrain([
            contactSupportButton.topAnchor.constraint(equalTo: enterPhrase.view.bottomAnchor, constant: -Margins.small.rawValue),
            contactSupportButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Margins.extraHuge.rawValue),
            contactSupportButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Margins.large.rawValue)
        ])
        
        nextButton.constrain([
            nextButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ViewSizes.Common.defaultCommon.rawValue),
            nextButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margins.large.rawValue),
            nextButton.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeCommon.rawValue)
        ])
        nextButton.configure(with: Presets.Button.primary)
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
    }

    private func setInitialData() {
        scrollView.delegate = self
        view.backgroundColor = LightColors.Background.one
        nextButton.setup(with: .init(title: L10n.RecoverWallet.next))
        
        enterPhrase.didFinishPhraseEntry = { [weak self] phrase in
            self?.phrase = phrase
        }

        switch reason {
        case .setSeed:
            heading.text = L10n.RecoveryKeyFlow.recoveryYourWallet
            subheading.text = L10n.RecoveryKeyFlow.recoveryYourWalletSubtitle
        case .validateForResettingPin:
            heading.text = L10n.RecoveryKeyFlow.enterRecoveryKey
            subheading.text = L10n.RecoveryKeyFlow.resetPINInstruction
            faq.tap = {
                self.faqButtonPressed()
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: faq)
        case .validateForWipingWallet:
            heading.text = L10n.RecoveryKeyFlow.enterRecoveryKey
            subheading.text = L10n.RecoveryKeyFlow.enterRecoveryKeySubtitle
        case .validateForWipingWalletAndDeletingFromDevice:
            heading.text = L10n.RecoveryKeyFlow.enterRecoveryKey
            subheading.text = L10n.RecoverWallet.enterRecoveryPhrase
        }
    }
    
    // MARK: - User Interaction
    @objc func nextTapped(_ sender: UIButton?) {
        view.endEditing(true)
        nextButton.isEnabled = false
        validatePhrase(phrase)
    }
    
    @objc private func contactSupportTapped() {
        guard let url = URL(string: C.supportLink) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: L10n.MenuButton.support))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        present(navController, animated: true)
    }
    
    func faqButtonPressed() {
        let text = L10n.RecoverWallet.recoveryPhrasePopup
        
        let model = PopupViewModel(title: .text(L10n.RecoverWallet.whatIsRecoveryPhrase),
                                   body: text)
        
        showInfoPopup(with: model)
    }

    private func validatePhrase(_ phrase: String) {
        guard keyMaster.isSeedPhraseValid(phrase) else {
            showErrorMessage()
            return
        }
        
        switch reason {
        case .setSeed(let callback):
            guard let account = self.keyMaster.setSeedPhrase(phrase) else {
                showErrorMessage()
                return
            }
            //Since we know that the user had their phrase at this point,
            //this counts as a write date
            UserDefaults.writePaperPhraseDate = Date()
            Store.perform(action: LoginSuccess())
            return callback(account)
        case .validateForResettingPin(let callback):
            guard self.keyMaster.authenticate(withPhrase: phrase) else {
                showErrorMessage()
                return
            }
            UserDefaults.writePaperPhraseDate = Date()
            return callback(phrase)
        case .validateForWipingWallet(let callback), .validateForWipingWalletAndDeletingFromDevice(let callback):
            guard self.keyMaster.authenticate(withPhrase: phrase) else {
                showErrorMessage()
                return
            }
            didToggleNextButton?(nextButton, navigationItem.rightBarButtonItem)
            return callback()
        }
    }
    
    func showErrorMessage() {
        nextButton.isEnabled = true
        let model: InfoViewModel = .init(description: .text(L10n.RecoverWallet.invalid), dismissType: .auto)
        showToastMessage(model: model, configuration: Presets.InfoView.error)
        
        contactSupportButton.isHidden = false
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var contentInset = scrollView.contentInset
        if contentInset.bottom == 0.0 {
            contentInset.bottom = frameValue.cgRectValue.height + 44.0
        }
        scrollView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: Notification) {
        var contentInset = scrollView.contentInset
        if contentInset.bottom > 0.0 {
            contentInset.bottom = 0.0
        }
        scrollView.contentInset = contentInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
