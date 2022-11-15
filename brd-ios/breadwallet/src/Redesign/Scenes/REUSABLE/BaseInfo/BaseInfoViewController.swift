//
//  BaseInfoViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class BaseInfoViewController: BaseTableViewController<BaseCoordinator,
                              BaseInfoInteractor,
                              BaseInfoPresenter,
                              BaseInfoStore>,
                              BaseInfoResponseDisplays {
    typealias Models = BaseInfoModels
    
    var imageName: String? { return "statusIcon" }
    var titleText: String? { return "OVERRIDE IN SUBCLASS" }
    var descriptionText: String? { return "THIS AS WELL" }
    
    var buttonViewModels: [ButtonViewModel] { return [] }
    var buttonConfigurations: [ButtonConfiguration] { return [] }
    
    // MARK: - Overrides
    
    override var closeImage: UIImage? { return .init(named: "")}
    
    override func setupVerticalButtons() {
        super.setupVerticalButtons()
        
        verticalButtons.wrappedView.configure(with: .init(buttons: buttonConfigurations))
        verticalButtons.wrappedView.setup(with: .init(buttons: buttonViewModels))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] as? Models.Section {
        case .image:
            return imageName == nil ? 0 : 1
            
        case .title:
            return titleText == nil ? 0 : 1
            
        case .description:
            return descriptionText == nil ? 0 : 1
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .description:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(all: .extraHuge)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, coverCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<FEImageView> = tableView.dequeueReusableCell(for: indexPath),
              let value = imageName
        else { return UITableViewCell() }
        
        cell.setup { view in
            view.configure(with: Presets.Background.transparent)
            view.setup(with: .imageName(value))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = titleText,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three, textAlignment: .center))
            view.setup(with: .text(value))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, descriptionLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = descriptionText,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center))
            view.setup(with: .text(value))
            view.setupCustomMargins(vertical: .extraHuge, horizontal: .extraHuge)
            view.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(Margins.extraHuge.rawValue)
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    
    // MARK: - SwapInfoResponseDisplay
    
    // MARK: - Additional Helpers
}
