//
//  KYCBasicViewController.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

class KYCBasicViewController: BaseTableViewController<KYCCoordinator,
                              KYCBasicInteractor,
                              KYCBasicPresenter,
                              KYCBasicStore>,
                              KYCBasicResponseDisplays {
    typealias Models = KYCBasicModels
    
    override var isModalDismissableEnabled: Bool { return false }
    
    override var sceneLeftAlignedTitle: String? {
        return L10n.Account.personalInformation
    }
    private var isValid = false

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        setRoundedShadowBackground()
    }
    
    override func prepareData() {
        super.prepareData()
        
        LoadingView.show()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .name:
            cell = self.tableView(tableView, nameCellForRowAt: indexPath)
            
        case .country:
            cell = self.tableView(tableView, countryTextFieldCellForRowAt: indexPath)
            
        case .birthdate:
            cell = self.tableView(tableView, dateCellForRowAt: indexPath)
            
        case .confirm:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.contentView.setupCustomMargins(vertical: .small, horizontal: .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, nameCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<DoubleHorizontalTextboxView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? DoubleHorizontalTextboxViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.valueChanged = { [weak self] first, last in
                self?.interactor?.nameSet(viewAction: .init(first: first, last: last))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, dateCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<DateView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? DateViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didPresentPicker = { [weak self] in
                self?.coordinator?.showDatePicker(model: model)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, countryTextFieldCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? TextFieldModel,
              let cell: WrapperTableViewCell<FETextField> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: Presets.TextField.two)
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard var model = sectionRows[section]?[indexPath.row] as? ButtonViewModel,
              let cell: WrapperTableViewCell<FEButton> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        model.enabled = isValid
        cell.setup { view in
            view.configure(with: Presets.Button.primary)
            view.setup(with: model)
            view.setupCustomMargins(vertical: .large, horizontal: .large)
            view.snp.makeConstraints { make in
                make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
            }
            
            view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to cell tap callback
        switch sections[indexPath.section] as? Models.Section {
        case .country:
            interactor?.pickCountry(viewAction: .init())
            
        default:
            return
        }
    }
    
    // MARK: - User Interaction
    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.submit(viewAction: .init())
    }

    // MARK: - KYCBasicResponseDisplay
    func displayCountry(responseDisplay: KYCBasicModels.SelectCountry.ResponseDisplay) {
        coordinator?.showCountrySelector(countries: responseDisplay.countries) { [weak self] model in
            self?.interactor?.pickCountry(viewAction: .init(code: model?.code, countryFullName: model?.name))
        }
    }
    
    func displayValidate(responseDisplay: KYCBasicModels.Validate.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.confirm),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FEButton> else { return }
        
        isValid = responseDisplay.isValid
        cell.wrappedView.isEnabled = isValid
    }
    
    func displaySubmit(responseDisplay: KYCBasicModels.Submit.ResponseDisplay) {
        coordinator?.showOverlay(with: .success) {
            UserManager.shared.refresh { [weak self] _ in
                self?.coordinator?.goBack(completion: {
                    // TODO: .goBack() does not work!
                })
            }
        }
    }
    
    // MARK: - Additional Helpers
}
