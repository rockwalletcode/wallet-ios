//
//  DemoViewController.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit
import WalletKit

class DemoViewController: BaseTableViewController<DemoCoordinator,
                          DemoInteractor,
                          DemoPresenter,
                          DemoStore>,
                          DemoResponseDisplays {
    typealias Models = DemoModels
    
    // MARK: - Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<AssetView>.self)
        tableView.register(WrapperTableViewCell<OrderView>.self)
    }
    
    override func prepareData() {
        sections = [
            Models.Section.asset,
            Models.Section.order
        ]
        
        sectionRows = [
            Models.Section.order: [
                OrderViewModel(title: "Rockwallet Order ID",
                               value: NSAttributedString(string: "13rXEZoh5NFj4q9aasdfkLp2..."),
                               isCopyable: true)
            ]
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - User Interaction
    // MARK: - DemoResponseDisplay
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section] as? Models.Section
        
        let cell: UITableViewCell
        switch section {
        case .button:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        case .timer:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)
            
        case .asset:
            cell = self.tableView(tableView, assetCellForRowAt: indexPath)
            
        case .order:
            cell = self.tableView(tableView, orderCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setupCustomMargins(vertical: .small, horizontal: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<ScrollableButtonsView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? ScrollableButtonsViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init(background: Presets.Background.Primary.normal,
                                       buttons: [
                                        Presets.Button.blackIcon
                                       ]
                                      ))
            view.setup(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, assetCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<AssetView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? AssetViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
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
            view.didCopyValue = { [weak self] code in
                self?.coordinator?.showMessage(model: InfoViewModel(description: .text(code), dismissType: .auto),
                                               configuration: Presets.InfoView.error)
            }
        }
        
        return cell
    }
    
    // MARK: - Additional Helpers
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard sections[indexPath.section].hashValue == Models.Section.label.hashValue else { return }
        
        toggleInfo()
    }
    
    func toggleInfo() {
        guard blurView?.superview == nil else {
            hideInfo()
            return
        }
        
        showInfo()
    }
    
    func showInfo() {
        toggleBlur(animated: true)
        guard let blur = blurView else { return }
        let popup = FEPopupView()
        view.insertSubview(popup, aboveSubview: blur)
        popup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualTo(view.snp.topMargin)
            make.leading.greaterThanOrEqualTo(view.snp.leadingMargin)
            make.trailing.greaterThanOrEqualTo(view.snp.trailingMargin)
        }
        popup.layoutIfNeeded()
        popup.alpha = 0
        
        var text = "almost done... "
        text += text
        text += text
        text += text
        text += text
        text += text
        text += text
        text += text
        text += text
        
        popup.configure(with: Presets.Popup.normal)
        popup.setup(with: .init(title: .text("This is a title"),
                                body: text,
                                buttons: [
                                    .init(title: "Donate"),
                                    .init(title: "Donate", image: "close"),
                                    .init(image: "close")
                                ]))
        popup.closeCallback = { [weak self] in
            self?.hideInfo()
        }
        
        popup.buttonCallbacks = [ { print("Donated 10$! Thanks!") } ]
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            popup.alpha = 1
        }
    }
    
    @objc func hideInfo() {
        guard let popup = view.subviews.first(where: { $0 is FEPopupView }) else { return }
        
        toggleBlur(animated: true)
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            popup.alpha = 0
        } completion: { _ in
            popup.removeFromSuperview()
        }
    }
}
