//
//  AssetListTableView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-12-04.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class AssetListTableView: UITableViewController, Subscriber {

    var didSelectCurrency: ((Currency) -> Void)?
    var didTapAddWallet: (() -> Void)?
    var didReload: (() -> Void)?
    
    private let loadingSpinner = UIActivityIndicatorView(style: .medium)
    private let assetHeight: CGFloat = ViewSizes.extralarge.rawValue
    
    private lazy var manageAssetsButton: ManageAssetsButton = {
        let manageAssetsButton = ManageAssetsButton()
        let manageAssetsButtonTitle = L10n.MenuButton.manageAssets
        manageAssetsButton.set(title: manageAssetsButtonTitle)
        manageAssetsButton.accessibilityLabel = manageAssetsButtonTitle
        
        manageAssetsButton.didTap = { [weak self] in
            self?.addWallet()
        }
        
        return manageAssetsButton
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = LightColors.Background.cards
        
        return footerView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(style: .plain)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Store.state.wallets.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.showLoadingState(true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddWalletButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = LightColors.Background.two
        tableView.register(HomeScreenCell.self, forCellReuseIdentifier: HomeScreenCellIds.regularCell.rawValue)
        tableView.register(HomeScreenHiglightableCell.self, forCellReuseIdentifier: HomeScreenCellIds.highlightableCell.rawValue)
        tableView.separatorStyle = .none
        tableView.rowHeight = assetHeight
        tableView.contentInset = UIEdgeInsets(top: Margins.small.rawValue, left: 0, bottom: 0, right: 0)
        
        setupSubscriptions()
        reload()
    }
    
    private func setupAddWalletButton() {
        guard tableView.tableFooterView == nil else { return }
        
        let manageAssetsButtonHeight: CGFloat = 56.0
        let topBottomInset: CGFloat = Margins.extraLarge.rawValue
        let leftRightInset: CGFloat = Margins.large.rawValue
        let tableViewWidth = tableView.frame.width - tableView.contentInset.left - tableView.contentInset.right
        
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableViewWidth,
                                              height: manageAssetsButtonHeight + (topBottomInset * 2)))
        
        manageAssetsButton.frame = CGRect(x: leftRightInset,
                                          y: topBottomInset,
                                          width: footerView.frame.width - (2 * leftRightInset),
                                          height: manageAssetsButtonHeight)
        
        footerView.addSubview(manageAssetsButton)
        tableView.tableFooterView = footerView
    }
    
    private func setupSubscriptions() {
        Store.lazySubscribe(self, selector: {
            self.mapWallets(state: $0, newState: $1)
        }, callback: { _ in
            self.reload()
        })
        
        Store.lazySubscribe(self, selector: {
            self.mapCurrencies(lhsCurrencies: $0.currencies, rhsCurrencies: $1.currencies)
        }, callback: { _ in
            self.reload()
        })
    }
    
    private func mapWallets(state: State, newState: State) -> Bool {
        var result = false
        let oldState = state
        let newState = newState
        
        state.wallets.values.map { $0.currency }.forEach { currency in
            if oldState[currency]?.balance != newState[currency]?.balance
                || oldState[currency]?.currentRate?.rate != newState[currency]?.currentRate?.rate {
                result = true
            }
        }
        
        return result
    }
    
    private func mapCurrencies(lhsCurrencies: [Currency], rhsCurrencies: [Currency]) -> Bool {
        return lhsCurrencies.map { $0.code } != rhsCurrencies.map { $0.code }
    }
    
    @objc func addWallet() {
        didTapAddWallet?()
    }
    
    func reload() {
        guard let parentViewController = parent as? HomeScreenViewController,
              parentViewController.isInExchangeFlow == false else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.didReload?()
            self?.showLoadingState(false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.state.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = Store.state.currencies[indexPath.row]
        let viewModel = HomeScreenAssetViewModel(currency: currency)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenCellIds.regularCell.rawValue, for: indexPath)
        
        if let cell = cell as? HomeScreenCell {
            cell.set(viewModel: viewModel)
        }
        
        return cell
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = Store.state.currencies[indexPath.row]
        // If a currency has a wallet, home screen cells are always tap-able
        // Also, if HBAR account creation is required, it is also tap-able
        guard (currency.wallet != nil) ||
            //Only an HBAR wallet requiring creation can go to the account screen without a wallet
            (currency.isHBAR && Store.state.requiresCreation(currency)) else { return }
        
        didSelectCurrency?(currency)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return assetHeight
    }
}

extension AssetListTableView {
    // Loading state management
    
    func showLoadingState(_ show: Bool) {
        showLoadingIndicator(show)
        showAddWalletsButton(!show)
    }
    
    func showLoadingIndicator(_ show: Bool) {
        guard show else {
            loadingSpinner.removeFromSuperview()
            return
        }
        
        view.addSubview(loadingSpinner)
        
        loadingSpinner.constrain([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        loadingSpinner.startAnimating()
    }
    
    func showAddWalletsButton(_ show: Bool) {
        manageAssetsButton.isHidden = !show
    }
}
