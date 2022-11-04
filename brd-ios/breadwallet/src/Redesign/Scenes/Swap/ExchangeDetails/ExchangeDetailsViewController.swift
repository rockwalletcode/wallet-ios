//
//  ExchangeDetailsViewController.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class ExchangeDetailsViewController: BaseTableViewController<BaseCoordinator,
                                     ExchangeDetailsInteractor,
                                     ExchangeDetailsPresenter,
                                     ExchangeDetailsStore>,
                                     ExchangeDetailsResponseDisplays {
    
    typealias Models = ExchangeDetailsModels
    
    override var sceneLeftAlignedTitle: String? {
        switch dataStore?.transactionType {
        case .buyTransaction:
            return L10n.Buy.details
            
        case .swapTransaction:
            return L10n.Swap.details
            
        default:
            return ""
        }
    }
    
    override var isModalDismissableEnabled: Bool { return isModalDismissable }
    var isModalDismissable = true
    
    // MARK: - Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<AssetView>.self)
        tableView.register(WrapperTableViewCell<OrderView>.self)
        tableView.register(WrapperTableViewCell<BuyOrderView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section] as? Models.Section
        
        let cell: UITableViewCell
        switch section {
        case .header, .toCurrency, .fromCurrency:
            cell = self.tableView(tableView, headerCellForRowAt: indexPath)
            
        case .order, .timestamp, .transactionFrom, .transactionTo:
            cell = self.tableView(tableView, orderCellForRowAt: indexPath)
            
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .buyOrder:
            cell = self.tableView(tableView, buyOrderCellForRowAt: indexPath)
            
        case .none:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .small, horizontal: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, headerCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<AssetView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? AssetViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: Presets.Asset.header)
            view.setup(with: model)
            view.content.setupCustomMargins(vertical: .medium, horizontal: .large)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, orderCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<OrderView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? OrderViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: Presets.Order.small)
            view.setup(with: model)
            
            view.didCopyValue = { [weak self] value in
                self?.interactor?.copyValue(viewAction: .init(value: value))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, buyOrderCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<BuyOrderView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? BuyOrderViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
        }

        return cell
    }
    
    // MARK: - User Interaction

    // MARK: - ExchangeDetailsResponseDisplay

    // MARK: - Additional Helpers
}
