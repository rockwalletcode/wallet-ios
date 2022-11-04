//
//  SwapViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapViewController: BaseTableViewController<SwapCoordinator,
                          SwapInteractor,
                          SwapPresenter,
                          SwapStore>,
                          SwapResponseDisplays {
    
    typealias Models = SwapModels
    
    override var sceneLeftAlignedTitle: String? {
        return L10n.HomeScreen.trade
    }
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    var didTriggerGetExchangeRate: (() -> Void)?
    
    // MARK: - Overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getRateAndTimerCell()?.wrappedView.invalidate()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<MainSwapView>.self)
        tableView.delaysContentTouches = false
        
        // TODO: Same code as CheckListViewController. Refactor
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
            make.leading.centerX.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.wrappedView.configure(with: Presets.Button.primary)
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm.uppercased(), enabled: false))
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        didTriggerGetExchangeRate = { [weak self] in
            self?.interactor?.getExchangeRate(viewAction: .init(getFees: true))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .accountLimits:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .rateAndTimer:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)
            
        case .swapCard:
            cell = self.tableView(tableView, swapMainCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, swapMainCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<MainSwapView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? MainSwapViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(shadow: Presets.Shadow.light,
                                       background: .init(backgroundColor: LightColors.Background.one,
                                                         tintColor: LightColors.Text.one,
                                                         border: Presets.Border.zero)))
            view.setup(with: model)
            
            view.didChangeFromFiatAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(fromFiatAmount: amount))
            }
            
            view.didChangeFromCryptoAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(fromCryptoAmount: amount))
            }
            
            view.didChangeToFiatAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(toFiatAmount: amount))
            }
            
            view.didChangeToCryptoAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(toCryptoAmount: amount))
            }
            
            view.didTapFromAssetsSelection = { [weak self] in
                self?.interactor?.selectAsset(viewAction: .init(from: true))
            }
            
            view.didTapToAssetsSelection = { [weak self] in
                self?.interactor?.selectAsset(viewAction: .init(to: true))
            }
            
            view.didFinish = { [weak self] didSwitchPlaces in
                if didSwitchPlaces, let cell = self?.getRateAndTimerCell() {
                    cell.setup { view in
                        view.invalidate()
                    }
                    
                    self?.interactor?.switchPlaces(viewAction: .init())
                } else {
                    self?.interactor?.getFees(viewAction: .init())
                }
            }
            
            view.contentSizeChanged = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            
            view.setupCustomMargins(top: .zero, leading: .zero, bottom: .medium, trailing: .zero)
        }
        
        return cell
    }
    
    private func getRateAndTimerCell() -> WrapperTableViewCell<ExchangeRateView>? {
        guard let section = sections.firstIndex(of: Models.Sections.rateAndTimer),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView> else {
            confirmButton.wrappedView.isEnabled = false
            
            return nil
        }
        
        return cell
    }
    
    // MARK: - User Interaction

    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.showConfirmation(viewAction: .init())
    }
    
    // MARK: - SwapResponseDisplay
    
    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        if responseDisplay.error != nil {
            LoadingView.hide()
        }
        
        guard !isAccessDenied(responseDisplay: responseDisplay) else { return }
        
        guard let error = responseDisplay.error as? SwapErrors else {
            coordinator?.hideMessage()
            return
        }
        
        switch error {
        case .noQuote:
            displayExchangeRate(responseDisplay: .init(rate: .init()))
            
        case .failed:
            coordinator?.showFailure()
            
        default:
            coordinator?.showMessage(with: responseDisplay.error,
                                     model: responseDisplay.model,
                                     configuration: responseDisplay.config)
        }
    }
    
    func displayAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay) {
        // TODO: Extract to VIPBaseViewController
        LoadingView.hide()
        
        confirmButton.wrappedView.isEnabled = responseDisplay.continueEnabled
        
        guard let section = sections.firstIndex(of: Models.Sections.swapCard),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<MainSwapView> else { return }
        
        cell.setup { view in
            let model = responseDisplay.amounts
            view.setup(with: model)
        }
    }
    
    func displayExchangeRate(responseDisplay: SwapModels.Rate.ResponseDisplay) {
        if let cell = getRateAndTimerCell() {
            cell.setup { view in
                view.configure(with: .init())
                view.setup(with: responseDisplay.rate)
                
                view.completion = { [weak self] in
                    self?.interactor?.getExchangeRate(viewAction: .init(getFees: true))
                }
            }
        }
        
        if let section = sections.firstIndex(of: Models.Sections.accountLimits),
           let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FELabel> {
            cell.setup { view in
                let model = responseDisplay.limits
                view.setup(with: model)
            }
        }
        
        if let section = sections.firstIndex(of: Models.Sections.swapCard),
           let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<MainSwapView> {
            cell.setup { view in
                view.setToggleSwitchPlacesButtonState(true)
            }
        }
        
        UIView.transition(with: tableView, duration: Presets.Animation.duration, options: .transitionCrossDissolve) { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
    
    func displaySelectAsset(responseDisplay: SwapModels.Assets.ResponseDisplay) {
        view.endEditing(true)
        
        coordinator?.showAssetSelector(title: responseDisplay.title,
                                       currencies: responseDisplay.to ?? responseDisplay.from,
                                       supportedCurrencies: dataStore?.supportedCurrencies,
                                       selected: { [weak self] model in
            guard let model = model as? AssetViewModel else { return }
            
            guard responseDisplay.from?.isEmpty == false else {
                self?.interactor?.assetSelected(viewAction: .init(to: model.subtitle))
                return
            }
            self?.interactor?.assetSelected(viewAction: .init(from: model.subtitle))
        })
    }
    
    func displayConfirmation(responseDisplay: SwapModels.ShowConfirmDialog.ResponseDisplay) {
        let _: WrapperPopupView<SwapConfirmationView>? = coordinator?.showPopup(with: responseDisplay.config,
                                                                                viewModel: responseDisplay.viewModel,
                                                                                confirmedCallback: { [weak self] in
            self?.coordinator?.showPinInput(keyStore: self?.dataStore?.keyStore) { success in
                if success {
                    LoadingView.show()
                    
                    self?.interactor?.confirm(viewAction: .init())
                } else {
                    self?.coordinator?.dismissFlow()
                }
            }
        })
    }
    
    func displayConfirm(responseDisplay: SwapModels.Confirm.ResponseDisplay) {
        LoadingView.hide()
        coordinator?.showSwapInfo(from: responseDisplay.from, to: responseDisplay.to, exchangeId: responseDisplay.exchangeId)
    }
    
    func displayError(responseDisplay: SwapModels.ErrorPopup.ResponseDisplay) {
        interactor?.showAssetInfoPopup(viewAction: .init())
    }
    
    func displayAssetInfoPopup(responseDisplay: SwapModels.AssetInfoPopup.ResponseDisplay) {
        coordinator?.showPopup(on: self,
                               blurred: true,
                               with: responseDisplay.popupViewModel,
                               config: responseDisplay.popupConfig,
                               closeButtonCallback: { [weak self] in
            self?.coordinator?.goBack(completion: {})
        }, callbacks: [ { [weak self] in
            self?.coordinator?.goBack(completion: {})
        }])
    }
    
    // MARK: - Additional Helpers
}
