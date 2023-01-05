//
//  AddCardViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class AddCardViewController: BaseTableViewController<ItemSelectionCoordinator,
                             AddCardInteractor,
                             AddCardPresenter,
                             AddCardStore>,
                             AddCardResponseDisplays {
    typealias Models = AddCardModels
    
    override var sceneTitle: String? {
        return L10n.Buy.addCard
    }

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<BankCardInputDetailsView>.self)
        
        setRoundedShadowBackground()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .cardDetails:
            cell = self.tableView(tableView, bankCardInputDetailsCellForRowAt: indexPath)

        case .confirm:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.contentView.setupCustomMargins(vertical: .small, horizontal: .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, bankCardInputDetailsCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<BankCardInputDetailsView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? BankCardInputDetailsViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.valueChanged = { [weak self] number, cvv in
                self?.interactor?.cardInfoSet(viewAction: .init(number: number, cvv: cvv))
            }
            
            view.didTapCvvInfo = { [weak self] in
                self?.interactor?.showCvvInfoPopup(viewAction: .init())
            }
            
            view.didTriggerExpirationField = { [weak self] in
                guard let self = self, let dataStore = self.dataStore else { return }
                self.coordinator?.showMonthYearPicker(model: [dataStore.months, dataStore.years])
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
                make.height.equalTo(ViewSizes.Common.largeCommon.rawValue)
            }
            
            view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    @objc override func buttonTapped() {
        super.buttonTapped()
        
        LoadingView.show()
        
        interactor?.submit(viewAction: .init())
    }

    // MARK: - AddCardResponseDisplay
    
    func displayCardInfo(responseDisplay: AddCardModels.CardInfo.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.cardDetails),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<BankCardInputDetailsView> else { return }
        
        cell.wrappedView.setup(with: responseDisplay.model)
    }
    
    func displayValidate(responseDisplay: AddCardModels.Validate.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.confirm),
              var model = sectionRows[Models.Section.confirm]?.first as? ButtonViewModel else { return }
        
        model.enabled = responseDisplay.isValid
        sectionRows[Models.Section.confirm] = [model]
        tableView.reloadSections([section], with: .none)
    }
    
    func displaySubmit(responseDisplay: AddCardModels.Submit.ResponseDisplay) {
        guard let store = dataStore else { return }
        LoadingView.show()
        
        coordinator?.showBillingAddress(store)
    }
    
    func displayCvvInfoPopup(responseDisplay: AddCardModels.CvvInfoPopup.ResponseDisplay) {
        coordinator?.showPopup(with: responseDisplay.model, config: Presets.Popup.normal)
    }
    
    // MARK: - Additional Helpers
    
}
