//
//  BillingAddressViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class BillingAddressViewController: BaseTableViewController<ItemSelectionCoordinator,
                                    BillingAddressInteractor,
                                    BillingAddressPresenter,
                                    BillingAddressStore>,
                                    BillingAddressResponseDisplays {
    typealias Models = BillingAddressModels
    
    override var sceneTitle: String? {
        return L10n.Buy.billingAddress
    }
    private var isValid = false
    private var isPickCountryPressed = false

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        setRoundedShadowBackground()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .name:
            cell = self.tableView(tableView, nameCellForRowAt: indexPath)
            
        case .country:
            cell = self.tableView(tableView, countryTextFieldCellForRowAt: indexPath)
            
        case .stateProvince:
            cell = self.tableView(tableView, textFieldCellForRowAt: indexPath)
            
        case .cityAndZipPostal:
            cell = self.tableView(tableView, cityAndZipPostalCellForRowAt: indexPath)
            
        case .address:
            cell = self.tableView(tableView, textFieldCellForRowAt: indexPath)
            
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
            
            view.valueChanged = { [weak self] first, second in
                self?.interactor?.nameSet(viewAction: .init(first: first, last: second))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cityAndZipPostalCellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            view.valueChanged = { [weak self] first, second in
                self?.interactor?.cityAndZipPostalSet(viewAction: .init(city: first, zipPostal: second))
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
            isPickCountryPressed = true
            
        default:
            return
        }
    }
    
    // MARK: - User Interaction
    @objc override func buttonTapped() {
        super.buttonTapped()
        
        LoadingView.show()
        
        interactor?.submit(viewAction: .init())
    }

    // MARK: - BillingAddressResponseDisplay
    
    func displayCountry(responseDisplay: BillingAddressModels.SelectCountry.ResponseDisplay) {
        guard isPickCountryPressed else { return }
        
        coordinator?.showCountrySelector(countries: responseDisplay.countries) { [weak self] model in
            self?.interactor?.pickCountry(viewAction: .init(code: model?.code, countryFullName: model?.name))
        }
        
        isPickCountryPressed = false
    }
    
    func displayValidate(responseDisplay: BillingAddressModels.Validate.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.confirm),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FEButton> else { return }
        
        isValid = responseDisplay.isValid
        cell.wrappedView.isEnabled = isValid
    }
    
    func displaySubmit(responseDisplay: BillingAddressModels.Submit.ResponseDisplay) {
        LoadingView.hide()
        coordinator?.dismissFlow()
        coordinator?.showOverlay(with: .success) { [weak self] in
            self?.interactor?.getPaymentCards(viewAction: .init())
        }
    }
    
    func displayPaymentCards(responseDisplay: BillingAddressModels.PaymentCards.ResponseDisplay) {
        coordinator?.showCardSelector(cards: responseDisplay.allPaymentCards, selected: { [weak self] selectedCard in
            guard let selectedCard = selectedCard else { return }
            self?.coordinator?.reloadBuy(selectedCard: selectedCard)
        })
    }
    
    func displayThreeDSecure(responseDisplay: BillingAddressModels.ThreeDSecure.ResponseDisplay) {
        coordinator?.showThreeDSecure(url: responseDisplay.url)
    }
    
    // MARK: - Additional Helpers
    
    override func textFieldDidUpdate(for indexPath: IndexPath, with text: String?, on section: AnyHashable) {
        super.textFieldDidUpdate(for: indexPath, with: text, on: section)
        
        switch section as? Models.Section {
        case .stateProvince:
            interactor?.stateProvinceSet(viewAction: .init(stateProvince: text))
            
        case .address:
            interactor?.addressSet(viewAction: .init(address: text))
            
        default:
            break
        }
    }
}
