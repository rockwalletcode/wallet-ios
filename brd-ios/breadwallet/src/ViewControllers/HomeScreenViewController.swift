//
//  HomeScreenViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-11-27.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, Subscriber {
    private let walletAuthenticator: WalletAuthenticator
    private let assetListTableView = AssetListTableView()
    private let toolbar = UIToolbar()
    private var toolbarButtons = [UIButton]()
    private let notificationHandler = NotificationHandler()
    private let coreSystem: CoreSystem
    
    private lazy var subHeaderView: UIView = {
        let subHeaderView = UIView()
        subHeaderView.translatesAutoresizingMaskIntoConstraints = false
        subHeaderView.backgroundColor = .clear
        subHeaderView.clipsToBounds = false
        
        return subHeaderView
    }()
    
    private lazy var totalAssetsTitleLabel: UILabel = {
        let totalAssetsTitleLabel = UILabel(font: Fonts.Body.two, color: LightColors.Text.three)
        totalAssetsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAssetsTitleLabel.text = L10n.HomeScreen.totalAssets
        
        return totalAssetsTitleLabel
    }()
    
    private lazy var totalAssetsAmountLabel: UILabel = {
        let totalAssetsAmountLabel = UILabel(font: Fonts.Title.three, color: LightColors.Text.three)
        totalAssetsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAssetsAmountLabel.adjustsFontSizeToFitWidth = true
        totalAssetsAmountLabel.minimumScaleFactor = 0.5
        totalAssetsAmountLabel.textAlignment = .right
        totalAssetsAmountLabel.text = "0"
        
        return totalAssetsAmountLabel
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logo_icon")
        
        return logoImageView
    }()
    
    var didSelectCurrency: ((Currency) -> Void)?
    var didTapManageWallets: (() -> Void)?
    var didTapBuy: (() -> Void)?
    var didTapTrade: (() -> Void)?
    var didTapProfile: (() -> Void)?
    var didTapProfileFromPrompt: ((Result<Profile?, Error>?) -> Void)?
    var showPrompts: (() -> Void)?
    var didTapMenu: (() -> Void)?
    
    var isInExchangeFlow = false
    
    private lazy var totalAssetsNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = true
        formatter.numberStyle = .currency
        formatter.generatesDecimalNumbers = true
        return formatter
    }()
    
    private lazy var pullToRefreshControl: UIRefreshControl = {
        let pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl.attributedTitle = NSAttributedString(string: L10n.HomeScreen.pullToRefresh)
        pullToRefreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        return pullToRefreshControl
    }()
    
    // MARK: - Lifecycle
    
    init(walletAuthenticator: WalletAuthenticator, coreSystem: CoreSystem) {
        self.walletAuthenticator = walletAuthenticator
        self.coreSystem = coreSystem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Store.unsubscribe(self)
    }
    
    @objc func reload() {
        UserManager.shared.refresh { [weak self] _ in
            self?.attemptShowKYCPrompt()
        }
        
        setupSubscriptions()
        Currencies.shared.reloadCurrencies()
        
        coreSystem.refreshWallet { [weak self] in
            self?.assetListTableView.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isInExchangeFlow = false
        ExchangeCurrencyHelper.revertIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        attemptShowKYCPrompt()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assetListTableView.didSelectCurrency = didSelectCurrency
        assetListTableView.didTapAddWallet = didTapManageWallets
        assetListTableView.didReload = { [weak self] in
            self?.pullToRefreshControl.endRefreshing()
        }
        
        addSubviews()
        addConstraints()
        setInitialData()
        setupSubscriptions()
        updateTotalAssets()
        
        if !Store.state.isLoginRequired {
            NotificationAuthorizer().showNotificationsOptInAlert(from: self, callback: { _ in
                self.notificationHandler.checkForInAppNotifications()
            })
        }
    }
    
    // MARK: Setup

    private func addSubviews() {
        view.addSubview(subHeaderView)
        subHeaderView.addSubview(logoImageView)
        subHeaderView.addSubview(totalAssetsTitleLabel)
        subHeaderView.addSubview(totalAssetsAmountLabel)
        view.addSubview(promptContainerStack)
        view.addSubview(toolbar)
        
        assetListTableView.refreshControl = pullToRefreshControl
        pullToRefreshControl.layer.zPosition = assetListTableView.view.layer.zPosition - 1
    }

    private func addConstraints() {
        let headerHeight: CGFloat = 64
        let toolbarHeight: CGFloat = 84.0

        subHeaderView.constrain([
            subHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -Margins.huge.rawValue),
            subHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subHeaderView.heightAnchor.constraint(equalToConstant: headerHeight) ])
        
        totalAssetsTitleLabel.constrain([
            totalAssetsTitleLabel.topAnchor.constraint(equalTo: subHeaderView.topAnchor),
            totalAssetsTitleLabel.trailingAnchor.constraint(equalTo: subHeaderView.trailingAnchor, constant: -Margins.large.rawValue)])
        
        totalAssetsAmountLabel.constrain([
            totalAssetsAmountLabel.trailingAnchor.constraint(equalTo: totalAssetsTitleLabel.trailingAnchor),
            totalAssetsAmountLabel.topAnchor.constraint(equalTo: totalAssetsTitleLabel.bottomAnchor, constant: Margins.extraSmall.rawValue),
            totalAssetsAmountLabel.bottomAnchor.constraint(equalTo: subHeaderView.bottomAnchor)])
        
        logoImageView.constrain([
            logoImageView.leadingAnchor.constraint(equalTo: subHeaderView.leadingAnchor, constant: Margins.large.rawValue),
            logoImageView.topAnchor.constraint(equalTo: totalAssetsTitleLabel.topAnchor, constant: Margins.extraSmall.rawValue),
            logoImageView.bottomAnchor.constraint(equalTo: totalAssetsAmountLabel.bottomAnchor, constant: -Margins.extraSmall.rawValue)])
        
        promptContainerStack.constrain([
            promptContainerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            promptContainerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            promptContainerStack.topAnchor.constraint(equalTo: subHeaderView.bottomAnchor, constant: Margins.huge.rawValue),
                promptContainerStack.heightAnchor.constraint(equalToConstant: 0).priority(.defaultLow)])
        
        addChildViewController(assetListTableView, layout: {
            assetListTableView.view.constrain([
                assetListTableView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                assetListTableView.view.topAnchor.constraint(equalTo: promptContainerStack.bottomAnchor),
                assetListTableView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                assetListTableView.view.bottomAnchor.constraint(equalTo: toolbar.topAnchor)])
        })
        
        toolbar.constrain([
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight) ])
    }

    private func setInitialData() {
        title = ""
        view.backgroundColor = LightColors.Background.two
        navigationItem.titleView = UIView()
        
        setupToolbar()
        updateTotalAssets()
    }
    
    private func setupToolbar() {
        toolbar.isTranslucent = false
        toolbar.clipsToBounds = true
        toolbar.layer.cornerRadius = CornerRadius.large.rawValue
        toolbar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let buttons = [
            (L10n.Button.home, #imageLiteral(resourceName: "home"), #selector(showHome)),
            (L10n.HomeScreen.trade, #imageLiteral(resourceName: "trade"), #selector(trade)),
            (L10n.HomeScreen.buy, #imageLiteral(resourceName: "buy"), #selector(buy)),
            (L10n.Button.profile, #imageLiteral(resourceName: "user"), #selector(profile)),
            (L10n.HomeScreen.menu, #imageLiteral(resourceName: "more"), #selector(menu))].map { (title, image, selector) -> UIBarButtonItem in
                let button = UIButton.vertical(title: title, image: image)
                button.tintColor = .gray1
                button.addTarget(self, action: selector, for: .touchUpInside)
                return UIBarButtonItem(customView: button)
            }
        
        let paddingWidth = Margins.large.rawValue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarButtons = []
        toolbar.items = [flexibleSpace, buttons[0],
                         flexibleSpace, buttons[1],
                         flexibleSpace, buttons[2],
                         flexibleSpace, buttons[3],
                         flexibleSpace, buttons[4],
                         flexibleSpace]
        
        let buttonWidth = (view.bounds.width - (paddingWidth * CGFloat(buttons.count + 1))) / CGFloat(buttons.count)
        let buttonHeight = CGFloat(44.0)
        buttons.forEach {
            $0.customView?.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            
            // Stash the UIButton's wrapped by the toolbar items in case we need add a badge later.
            if let button = $0.customView as? UIButton {
                self.toolbarButtons.append(button)
            }
        }
    }
    
    private func setupSubscriptions() {
        Store.unsubscribe(self)
        
        Store.subscribe(self, selector: {
            var result = false
            let oldState = $0
            let newState = $1
            $0.wallets.values.map { $0.currency }.forEach { currency in
                result = result || oldState[currency]?.balance != newState[currency]?.balance
                result = result || oldState[currency]?.currentRate?.rate != newState[currency]?.currentRate?.rate
            }
            return result
        }, callback: { _ in
            self.updateTotalAssets()
            self.updateAmountsForWidgets()
        })
        
        // prompts
        Store.subscribe(self, name: .didUpgradePin, callback: { _ in
            if self.generalPromptView.type == .upgradePin {
                self.hidePrompt(self.generalPromptView)

            }
        })
        
        Store.subscribe(self, name: .didWritePaperKey, callback: { _ in
            if self.generalPromptView.type == .paperKey {
                self.hidePrompt(self.generalPromptView)
            }
        })
        
        Store.subscribe(self, selector: {
            $0.wallets.count != $1.wallets.count
        }, callback: { _ in
            self.updateTotalAssets()
            self.updateAmountsForWidgets()
        })
    }
    
    private func updateTotalAssets() {
        guard isInExchangeFlow == false else { return }
        
        let fiatTotal: Decimal = Store.state.wallets.values.map {
            guard let balance = $0.balance,
                let rate = $0.currentRate else { return 0.0 }
            let amount = Amount(amount: balance,
                                rate: rate)
            return amount.fiatValue
        }.reduce(0.0, +)
        
        let localeComponents = [NSLocale.Key.currencyCode.rawValue: UserDefaults.defaultCurrencyCode]
        let localeIdentifier = Locale.identifier(fromComponents: localeComponents)
        totalAssetsNumberFormatter.locale = Locale(identifier: localeIdentifier)
        totalAssetsNumberFormatter.currencySymbol = Store.state.orderedWallets.first?.currentRate?.code ?? ""
        
        totalAssetsAmountLabel.text = totalAssetsNumberFormatter.string(from: fiatTotal as NSDecimalNumber)
    }
    
    private func updateAmountsForWidgets() {
        guard isInExchangeFlow == false else { return }
        
        let info: [CurrencyId: Double] = Store.state.wallets
            .map { ($0, $1) }
            .reduce(into: [CurrencyId: Double]()) {
                if let balance = $1.1.balance {
                    let unit = $1.1.currency.defaultUnit
                    $0[$1.0] = balance.cryptoAmount.double(as: unit) ?? 0
                }
            }

        coreSystem.widgetDataShareService.updatePortfolio(info: info)
        coreSystem.widgetDataShareService.quoteCurrencyCode = Store.state.defaultCurrencyCode
    }
    
    // MARK: Actions
    
    @objc private func showHome() {}
    
    @objc private func buy() {
        didTapBuy?()
    }
    
    @objc private func trade() {
        didTapTrade?()
    }
    
    @objc private func profile() {
        didTapProfile?()
    }
    
    @objc private func menu() { didTapMenu?() }
    
    // MARK: - Prompt
    
    private lazy var promptContainerStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
    
    private var kycStatusPromptView = FEInfoView()
    private var generalPromptView = PromptView()
    
    private func attemptShowGeneralPrompt() {
        guard promptContainerStack.arrangedSubviews.isEmpty == true,
              let nextPrompt = PromptFactory.nextPrompt(walletAuthenticator: walletAuthenticator) else { return }
        
        generalPromptView = PromptFactory.createPromptView(prompt: nextPrompt, presenter: self)
        
        nextPrompt.didPrompt()
        
        generalPromptView.dismissButton.tap = { [unowned self] in
            self.hidePrompt(self.generalPromptView)
        }
        
        if !generalPromptView.shouldHandleTap {
            generalPromptView.continueButton.tap = { [unowned self] in
                if let trigger = nextPrompt.trigger {
                    Store.trigger(name: trigger)
                }
                
                self.hidePrompt(self.generalPromptView)
            }
        }
        
        layoutPrompts(generalPromptView)
    }
    
    func attemptShowKYCPrompt() {
        let profileResult = UserManager.shared.profileResult
        
        switch profileResult {
        case .success(let profile):
            if profile?.status.hasKYC == true {
                hidePrompt(kycStatusPromptView)
                attemptShowGeneralPrompt()
            } else {
                setupKYCPrompt(result: profileResult)
            }
            
        default:
            attemptShowGeneralPrompt()
        }
    }
    
    private func setupKYCPrompt(result: Result<Profile?, Error>?) {
        guard case .success(let profile) = result,
              promptContainerStack.arrangedSubviews.isEmpty == true else { return }
        
        let infoConfig: InfoViewConfiguration = Presets.InfoView.verification
        var infoViewModel = profile?.status.viewModel
        infoViewModel?.headerTrailing = .init(image: "close")
        
        kycStatusPromptView.configure(with: infoConfig)
        kycStatusPromptView.setup(with: infoViewModel)
        
        kycStatusPromptView.setupCustomMargins(all: .large)
        
        kycStatusPromptView.headerButtonCallback = { [weak self] in
            self?.hidePrompt(self?.kycStatusPromptView)
        }
        
        kycStatusPromptView.trailingButtonCallback = { [weak self] in
            self?.didTapProfileFromPrompt?(UserManager.shared.profileResult)
        }
        
        layoutPrompts(kycStatusPromptView)
    }
    
    private func hidePrompt(_ prompt: UIView?) {
        guard let prompt = prompt else { return }
        
        UIView.animate(withDuration: Presets.Animation.duration, delay: 0, options: .curveLinear) {
            prompt.transform = .init(translationX: UIScreen.main.bounds.width, y: 0)
            prompt.alpha = 0.0
            prompt.isHidden = true
        } completion: { [weak self] _ in
            self?.promptContainerStack.layoutIfNeeded()
            self?.view.layoutIfNeeded()
        }
    }
    
    private func layoutPrompts(_ prompt: UIView?) {
        guard let prompt = prompt else { return }
        
        prompt.alpha = 0.0
        
        promptContainerStack.addArrangedSubview(prompt)
        
        UIView.animate(withDuration: Presets.Animation.duration, delay: 0, options: .curveLinear) {
            prompt.alpha = 1.0
            prompt.isHidden = false
        } completion: { [weak self] _ in
            self?.promptContainerStack.layoutIfNeeded()
            self?.view.layoutIfNeeded()
        }
    }
}
