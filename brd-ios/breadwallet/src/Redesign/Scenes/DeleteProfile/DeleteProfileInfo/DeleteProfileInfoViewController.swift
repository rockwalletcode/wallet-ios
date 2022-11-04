//
//  DeleteProfileInfoViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class DeleteProfileInfoViewController: BaseTableViewController<DeleteProfileInfoCoordinator,
                                       DeleteProfileInfoInteractor,
                                       DeleteProfileInfoPresenter,
                                       DeleteProfileInfoStore>,
                                       DeleteProfileInfoResponseDisplays {
    typealias Models = DeleteProfileInfoModels
    
    override var sceneLeftAlignedTitle: String? { return L10n.AccountDelete.deleteAccountTitle }
    
    private var recoveryKeyFlowNextButton: FEButton?
    private var recoveryKeyFlowBarButton: UIBarButtonItem?
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
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
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm.uppercased(), enabled: false))
        
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? DeleteProfileInfoModels.Section {
        case .title:
            cell =  self.tableView(tableView, labelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three))
            (cell as? WrapperTableViewCell<FELabel>)?.setupCustomMargins(top: .huge, leading: .large, bottom: .extraSmall, trailing: .huge)
            
        case .checkmarks:
            cell = self.tableView(tableView, checkmarkCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<ChecklistItemView>)?.wrappedView.setupCustomMargins(top: .medium, leading: .small, bottom: .medium, trailing: .huge)
            
        case .tickbox:
            cell = self.tableView(tableView, tickboxCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<TickboxItemView>)?.wrappedView.setupCustomMargins(top: .large, leading: .small, bottom: .extraSmall, trailing: .huge)

            (cell as? WrapperTableViewCell<TickboxItemView>)?.wrappedView.didToggleTickbox = { [weak self] value in
                self?.tickboxToggled(value: value)
            }
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        
        return cell
    }
    
    // MARK: - User Interaction
    
    override func buttonTapped() {
        super.buttonTapped()
        
        guard let navigationController = coordinator?.navigationController, let keyStore = dataStore?.keyMaster else { return }
        RecoveryKeyFlowController.pushUnlinkWalletFlowWithoutIntro(from: navigationController,
                                                                   keyMaster: keyStore,
                                                                   phraseEntryReason: .validateForWipingWalletAndDeletingFromDevice({ [weak self] in
            self?.interactor?.deleteProfile(viewAction: .init())
        })) { [weak self] nextButton, barButton in
            self?.recoveryKeyFlowNextButton = nextButton
            self?.recoveryKeyFlowBarButton = barButton
            self?.recoveryKeyFlowNextButton?.isEnabled = false
            self?.recoveryKeyFlowBarButton?.isEnabled = false
        }
    }
    
    func tickboxToggled(value: Bool) {
        interactor?.toggleTickbox(viewAction: .init(value: value))
    }
    
    // MARK: - DeleteProfileInfoResponseDisplay
    
    func displayDeleteProfile(responseDisplay: DeleteProfileInfoModels.DeleteProfile.ResponseDisplay) {
        guard let navigationController = coordinator?.navigationController else { return }
        
        coordinator?.showPopup(on: navigationController,
                               blurred: false,
                               with: responseDisplay.popupViewModel,
                               config: responseDisplay.popupConfig,
                               closeButtonCallback: { [weak self] in
            self?.interactor?.wipeWallet(viewAction: .init())
        }, callbacks: [ { [weak self] in
            self?.interactor?.wipeWallet(viewAction: .init())
        } ])
    }
    
    func displayToggleTickbox(responseDisplay: DeleteProfileInfoModels.Tickbox.ResponseDisplay) {
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm.uppercased(), enabled: responseDisplay.model.enabled))
    }

    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        super.displayMessage(responseDisplay: responseDisplay)
        
        recoveryKeyFlowNextButton?.isEnabled = true
        recoveryKeyFlowBarButton?.isEnabled = true
    }
    
    // MARK: - Additional Helpers
}
