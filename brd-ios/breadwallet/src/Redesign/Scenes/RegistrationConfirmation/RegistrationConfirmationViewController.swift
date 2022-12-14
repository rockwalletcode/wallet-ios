//
//  RegistrationConfirmationViewController.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

class RegistrationConfirmationViewController: BaseTableViewController<RegistrationCoordinator,
                                              RegistrationConfirmationInteractor,
                                              RegistrationConfirmationPresenter,
                                              RegistrationConfirmationStore>,
                                              RegistrationConfirmationResponseDisplays {
    
    typealias Models = RegistrationConfirmationModels
    
    override var isModalDismissableEnabled: Bool { return true }

    // MARK: - Overrides
    
    override func setupVerticalButtons() {
        super.setupVerticalButtons()
        
        continueButton.configure(with: Presets.Button.primary)
        continueButton.setup(with: .init(title: L10n.Button.confirm,
                                         enabled: false,
                                         callback: { [weak self] in
            self?.buttonTapped()
        }))
        
        guard let config = continueButton.config, let model = continueButton.viewModel else { return }
        verticalButtons.wrappedView.configure(with: .init(buttons: [config]))
        verticalButtons.wrappedView.setup(with: .init(buttons: [model]))
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<CodeInputView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FEImageView>)?.wrappedView.setupCustomMargins(vertical: .extraExtraHuge, horizontal: .large)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .instructions:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            
        case .input:
            cell = self.tableView(tableView, codeInputCellForRowAt: indexPath)
            
        case .help:
            cell = self.tableView(tableView, buttonsCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, codeInputCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<CodeInputView> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init())
            
            view.valueChanged = { [weak self] text in
                self?.textFieldDidFinish(for: indexPath, with: text)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonsCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, buttonsCellForRowAt: indexPath)
        
        guard let cell = cell as? WrapperTableViewCell<ScrollableButtonsView> else {
            return cell
        }
        
        cell.setup { view in
            view.configure(with: .init(buttons: [Presets.Button.noBorders]))
            
            view.callbacks = [
                resendCodeTapped,
                changeEmailTapped
            ]
        }
        
        return cell
    }

    // MARK: - User Interaction
    override func textFieldDidFinish(for indexPath: IndexPath, with text: String?) {
        interactor?.validate(viewAction: .init(item: text))
    }
    
    override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.confirm(viewAction: .init())
    }
    
    private func resendCodeTapped() {
        interactor?.resend(viewAction: .init())
    }
    
    private func changeEmailTapped() {
        coordinator?.showChangeEmail()
    }

    // MARK: - RegistrationConfirmationResponseDisplay
    
    func displayValidate(responseDisplay: RegistrationConfirmationModels.Validate.ResponseDisplay) {
        continueButton.viewModel?.enabled = responseDisplay.isValid
        verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
    }
    
    func displayConfirm(responseDisplay: RegistrationConfirmationModels.Confirm.ResponseDisplay) {
        coordinator?.showOverlay(with: .success) { [weak self] in
            self?.coordinator?.dismissFlow()
        }
    }
    
    func displayError(responseDisplay: RegistrationConfirmationModels.Error.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.input),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<CodeInputView>
        else { return }
        
        cell.wrappedView.showErrorMessage()
    }
    
    // MARK: - Additional Helpers
}
