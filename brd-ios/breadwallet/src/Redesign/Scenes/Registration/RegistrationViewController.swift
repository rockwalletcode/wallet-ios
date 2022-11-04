//
//  RegistrationViewController.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationViewController: BaseTableViewController<RegistrationCoordinator,
                                  RegistrationInteractor,
                                  RegistrationPresenter,
                                  RegistrationStore>,
                                  RegistrationResponseDisplays {
    typealias Models = RegistrationModels

    // MARK: - Overrides
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        confirmButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
            make.edges.equalTo(confirmButton.snp.margins)
        }
        confirmButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.wrappedView.configure(with: Presets.Button.primary)
        confirmButton.wrappedView.setup(with: .init(title: L10n.RecoverWallet.next, enabled: false))
        
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .instructions:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            
        case .email:
            cell = self.tableView(tableView, textFieldCellForRowAt: indexPath)
            
            let castedCell = cell as? WrapperTableViewCell<FETextField>
            castedCell?.setup { view in
                view.configure(with: Presets.TextField.email)
            }
            
        case .tickbox:
            cell = self.tableView(tableView, tickboxCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, tickboxCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<TickboxItemView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? TickboxItemViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didToggleTickbox = { [weak self] value in
                self?.interactor?.toggleTickbox(viewAction: .init(value: value))
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    
    override func textFieldDidUpdate(for indexPath: IndexPath, with text: String?, on section: AnyHashable) {
        super.textFieldDidUpdate(for: indexPath, with: text, on: section)
        
        interactor?.validate(viewAction: .init(item: text))
    }
    
    override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.next(viewAction: .init())
    }

    // MARK: - RegistrationResponseDisplay
    func displayValidate(responseDisplay: RegistrationModels.Validate.ResponseDisplay) {
        confirmButton.wrappedView.setup(with: .init(title: L10n.RecoverWallet.next, enabled: responseDisplay.isValid))
    }
    
    func displayNext(responseDisplay: RegistrationModels.Next.ResponseDisplay) {
        guard let shouldShowProfile = dataStore?.shouldShowProfile else { return }
        coordinator?.showRegistrationConfirmation(shouldShowProfile: shouldShowProfile)
    }

    // MARK: - Additional Helpers
}
