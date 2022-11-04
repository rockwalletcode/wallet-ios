// 
//  ManageWalletsViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-07-30.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class ManageWalletsViewController: UITableViewController {
    
    private let assetCollection: AssetCollection
    private let coreSystem: CoreSystem
    private var displayData = [CurrencyMetaData]()
    
    private lazy var manageAssetsButton: ManageAssetsButton = {
        let manageAssetsButton = ManageAssetsButton()
        let manageAssetsButtonTitle = "+ " + L10n.TokenList.addTitle
        manageAssetsButton.set(title: manageAssetsButtonTitle)
        manageAssetsButton.accessibilityLabel = manageAssetsButtonTitle
        
        manageAssetsButton.didTap = { [weak self] in
            self?.pushAddWallets()
        }
        
        return manageAssetsButton
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = LightColors.Background.one
        
        return footerView
    }()
    
    init(assetCollection: AssetCollection, coreSystem: CoreSystem) {
        self.assetCollection = assetCollection
        self.coreSystem = coreSystem
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        tableView.backgroundColor = LightColors.Background.one
        tableView.rowHeight = 66.0
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = LightColors.Outline.one
        title = L10n.TokenList.manageTitle
        tableView.register(ManageCurrencyCell.self, forCellReuseIdentifier: ManageCurrencyCell.cellIdentifier)
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddWallets))
        
        //If we are first in the nav controller stack, we need a close button
        if navigationController?.viewControllers.first == self {
            let button = UIButton.buildModernCloseButton(position: .left)
            button.tintColor = LightColors.Text.three
            button.tap = {
                self.dismiss(animated: true, completion: nil)
            }
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayData = assetCollection.enabledAssets
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        assetCollection.saveChanges()
    }
    
    override func viewDidLayoutSubviews() {
        setupAddButton()
    }
    
    private func removeCurrency(_ identifier: CurrencyId) {
        guard let index = displayData.firstIndex(where: { $0.uid == identifier }) else { return }
        displayData.remove(at: index)
        assetCollection.removeAsset(at: index)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }, completion: { [unowned self] _ in
            self.tableView.reloadData() // to update isRemovable
        })
    }
    
    private func setupAddButton() {
        guard tableView.tableFooterView == nil else { return }
        
        let manageAssetsButtonHeight: CGFloat = 56.0
        let topBottomInset: CGFloat = 20
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
    
    @objc private func pushAddWallets() {
        let vc = AddWalletsViewController(assetCollection: assetCollection, coreSystem: coreSystem)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ManageWalletsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageCurrencyCell.cellIdentifier, for: indexPath) as? ManageCurrencyCell else {
            return UITableViewCell()
        }
        let metaData = displayData[indexPath.row]
        // cannot remove a native currency if its tokens are enabled, or remove the last currency
        let currencyIsRemovable = !coreSystem.isWalletRequired(for: metaData.uid) && assetCollection.enabledAssets.count > 1
        cell.set(currency: metaData,
                 balance: nil,
                 listType: .manage,
                 isHidden: false,
                 isRemovable: currencyIsRemovable)
        cell.didRemoveIdentifier = { [unowned self] identifier in
            self.removeCurrency(identifier)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = displayData[sourceIndexPath.row]
        displayData.remove(at: sourceIndexPath.row)
        displayData.insert(movedObject, at: destinationIndexPath.row)
        assetCollection.moveAsset(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
