//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class ResetPinViewController: BaseTableViewController<ResetPinCoordinator,
                              ResetPinInteractor,
                              ResetPinPresenter,
                              ResetPinStore>,
                              ResetPinResponseDisplays {
    
    typealias Models = ResetPinModels
    
    var resetFromDisabledSuccess: (() -> Void)?

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .button:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? LabelViewModel,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Title.four, textColor: LightColors.Text.one, textAlignment: .center))
            view.setup(with: model)
            view.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(ViewSizes.extraExtraHuge.rawValue)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? ButtonViewModel,
              let cell: WrapperTableViewCell<FEButton> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: Presets.Button.primary)
            view.setup(with: model)
            view.setupCustomMargins(vertical: .large, horizontal: .large)
            view.snp.makeConstraints { make in
                make.height.equalTo(ViewSizes.extraSmall.rawValue)
                make.top.equalTo(ViewSizes.extraExtraHuge.rawValue)
            }
            view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        return cell
    }

    // MARK: - User Interaction
    override func buttonTapped() {
        super.buttonTapped()
        
        dismiss(animated: true, completion: {
            self.resetFromDisabledSuccess?()
        })
    }

    // MARK: - ResetPinResponseDisplay

    // MARK: - Additional Helpers
}
