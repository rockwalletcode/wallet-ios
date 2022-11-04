// 
//  AddWalletsViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-07-30.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class AddWalletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let assetCollection: AssetCollection
    private let coreSystem: CoreSystem
    private var displayData = [CurrencyMetaData]()
    private var allAssets = [CurrencyMetaData]()
    private var addedCurrencyIndices = [Int]()
    private var addedCurrencyIdentifiers = [CurrencyId]()
    private let searchBar = UISearchBar()
  
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkBackground
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray3
        tableView.rowHeight = 66.0
        tableView.register(ManageCurrencyCell.self, forCellReuseIdentifier: ManageCurrencyCell.cellIdentifier)
        
        return tableView
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        return footerView
    }()
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = L10n.Wallet.findAssets
        infoLabel.font = Fonts.Body.two
        infoLabel.textColor = LightColors.Text.two
        infoLabel.textAlignment = .center
        
        return infoLabel
    }()
    
    lazy var infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "info")?.tinted(with: LightColors.Text.two), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        return infoButton
    }()
    
    init(assetCollection: AssetCollection, coreSystem: CoreSystem) {
        self.assetCollection = assetCollection
        self.coreSystem = coreSystem
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allAssets = assetCollection.availableAssets
            .sorted {
                if let balance = coreSystem.walletBalance(currencyId: $0.uid),
                    !balance.isZero,
                    coreSystem.walletBalance(currencyId: $1.uid) == nil {
                    return true
                }
                return false
        }
        displayData = allAssets
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reconcileChanges()
    }
    
    private func reconcileChanges() {
        let currenciesToAdd = addedCurrencyIndices.map { allAssets[$0] }
        
        // Add ETH if needed.
        if let eth = assetCollection.allAssets.first(where: { $0.value.code == Currencies.AssetCodes.eth.value })?.value,
           currenciesToAdd.contains(where: { $0.isERC20Token }),
           !currenciesToAdd.filter({ $0.tokenAddress != nil && ($0.tokenAddress?.isEmpty == false) }).isEmpty, // Tokens are being added
           !assetCollection.enabledAssets.contains(eth), // ETH not already added
           !currenciesToAdd.contains(eth) { // ETH not being explicitly added
            self.assetCollection.add(asset: eth)
        }
        
        addedCurrencyIndices.forEach {
            self.assetCollection.add(asset: allAssets[$0])
        }
        
        assetCollection.saveChanges()
    }
    
    override func viewDidLoad() {
        title = L10n.TokenList.addTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.backgroundColor = LightColors.Background.one
        
        setupSearchBar()
        setupInfoView()
    }
    
    private func addCurrency(_ identifier: CurrencyId) {
        guard let index = allAssets.firstIndex(where: {$0.uid == identifier }) else { return assertionFailure() }
        addedCurrencyIndices.append(index)
        addedCurrencyIdentifiers.append(identifier)
    }
    
    private func removeCurrency(_ identifier: CurrencyId) {
        guard let index = allAssets.firstIndex(where: {$0.uid == identifier }) else { return assertionFailure() }
        addedCurrencyIndices.removeAll(where: { $0 == index })
        addedCurrencyIdentifiers.removeAll(where: { $0 == identifier })
    }
    
    private func setupSearchBar() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 48.0))
        tableView.tableHeaderView = headerView
        headerView.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.constrain([
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchBar.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)])
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.isTranslucent = false
        searchBar.barTintColor = .darkBackground
        searchBar.placeholder = L10n.Search.search
    }
    
    private func setupInfoView() {
        view.addSubview(footerView)
        
        footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        footerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        footerView.addSubview(infoLabel)
        infoLabel.constrain([
            infoLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
        ])
        
        footerView.addSubview(infoButton)
        infoButton.constrain([
            infoButton.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor, constant: Margins.small.rawValue),
            infoButton.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func infoButtonTapped() {
        // show info message alert
        let message = L10n.Wallet.limitedAssetsMessage
        
        let alert = UIAlertController(title: L10n.Wallet.limitedAssets,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Button.ok, style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension AddWalletsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageCurrencyCell.cellIdentifier, for: indexPath) as? ManageCurrencyCell else {
            return UITableViewCell()
        }
        
        let currency = displayData[indexPath.row]
        let balance = coreSystem.walletBalance(currencyId: currency.uid)
        let isHidden = !addedCurrencyIdentifiers.contains(currency.uid)
        cell.set(currency: currency,
                 balance: balance,
                 listType: .add,
                 isHidden: isHidden,
                 isRemovable: true)
        cell.didAddIdentifier = { [unowned self] identifier in
            self.addCurrency(identifier)
        }
        cell.didRemoveIdentifier = { [unowned self] identifier in
            self.removeCurrency(identifier)
        }
        return cell
    }
}

extension AddWalletsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayData = allAssets
        } else {
            displayData = allAssets.filter {
                return $0.name.lowercased().contains(searchText.lowercased()) || $0.code.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
