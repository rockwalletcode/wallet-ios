//
//  BuyViewController.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

class BuyViewController: BaseTableViewController<BuyCoordinator, BuyInteractor, BuyPresenter, BuyStore>, BuyResponseDisplays {
    
    typealias Models = BuyModels
    
    override var sceneLeftAlignedTitle: String? {
        return L10n.HomeScreen.buy
    }
    
    lazy var continueButton: FEButton = {
        let view = FEButton()
        return view
    }()
    
    var didTriggerGetData: (() -> Void)?
    
    // MARK: - Overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getRateAndTimerCell()?.wrappedView.invalidate()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<SwapCurrencyView>.self)
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
        tableView.delaysContentTouches = false
        
        didTriggerGetData = { [weak self] in
            self?.interactor?.getData(viewAction: .init())
        }
    }
    
    override func setupVerticalButtons() {
        super.setupVerticalButtons()
        
        continueButton.configure(with: Presets.Button.primary)
        continueButton.setup(with: .init(title: L10n.Button.continueAction,
                                         enabled: false,
                                         callback: { [weak self] in
            self?.buttonTapped()
        }))
        
        guard let config = continueButton.config, let model = continueButton.viewModel else { return }
        verticalButtons.wrappedView.configure(with: .init(buttons: [config]))
        verticalButtons.wrappedView.setup(with: .init(buttons: [model]))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .accountLimits:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .rateAndTimer:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)

        case .from:
            cell = self.tableView(tableView, cryptoSelectionCellForRowAt: indexPath)

        case .to:
            cell = self.tableView(tableView, paymentSelectionCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cryptoSelectionCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<SwapCurrencyView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? SwapCurrencyViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(shadow: Presets.ExchangeView.shadow,
                                       background: Presets.ExchangeView.background))
            view.setup(with: model)
            
            view.didChangeFiatAmount = { [weak self] value in
                self?.interactor?.setAmount(viewAction: .init(fiatValue: value))
            }
            
            view.didChangeCryptoAmount = { [weak self] value in
                self?.interactor?.setAmount(viewAction: .init(tokenValue: value))
            }
            
            view.didFinish = { [weak self] _ in
                self?.interactor?.setAmount(viewAction: .init())
            }
            
            view.didTapSelectAsset = { [weak self] in
                self?.interactor?.navigateAssetSelector(viewAction: .init())
            }
            
            view.setupCustomMargins(top: .zero, leading: .zero, bottom: .medium, trailing: .zero)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, paymentSelectionCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? CardSelectionViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didTapSelectCard = { [weak self] in
                self?.interactor?.getPaymentCards(viewAction: .init())
            }
            
            view.setupCustomMargins(top: .zero, leading: .zero, bottom: .medium, trailing: .zero)
        }
        
        return cell
    }
    
    private func getRateAndTimerCell() -> WrapperTableViewCell<ExchangeRateView>? {
        guard let section = sections.firstIndex(of: Models.Sections.rateAndTimer),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView> else {
            continueButton.viewModel?.enabled = false
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
            
            return nil
        }
        
        return cell
    }
    
    // MARK: - User Interaction

    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.showOrderPreview(viewAction: .init())
    }
    
    // MARK: - BuyResponseDisplay
    
    func displayNavigateAssetSelector(responseDisplay: BuyModels.AssetSelector.ResponseDisplay) {
        coordinator?.showAssetSelector(title: responseDisplay.title,
                                       currencies: dataStore?.currencies,
                                       supportedCurrencies: dataStore?.supportedCurrencies) { [weak self] item in
            guard let item = item as? AssetViewModel else { return }
            self?.interactor?.setAssets(viewAction: .init(currency: item.subtitle))
        }
    }
    
    func displayPaymentCards(responseDisplay: BuyModels.PaymentCards.ResponseDisplay) {
        view.endEditing(true)
        
        coordinator?.showCardSelector(cards: responseDisplay.allPaymentCards, selected: { [weak self] selectedCard in
            self?.interactor?.setAssets(viewAction: .init(card: selectedCard))
        })
    }
    
    func displayAssets(responseDisplay actionResponse: BuyModels.Assets.ResponseDisplay) {
        guard let fromSection = sections.firstIndex(of: Models.Sections.from),
              let toSection = sections.firstIndex(of: Models.Sections.to),
              let fromCell = tableView.cellForRow(at: .init(row: 0, section: fromSection)) as? WrapperTableViewCell<SwapCurrencyView>,
              let toCell = tableView.cellForRow(at: .init(row: 0, section: toSection)) as? WrapperTableViewCell<CardSelectionView> else {
            continueButton.viewModel?.enabled = false
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
            
            return
        }
        
        fromCell.wrappedView.setup(with: actionResponse.cryptoModel)
        toCell.wrappedView.setup(with: actionResponse.cardModel)
        
        continueButton.viewModel?.enabled = dataStore?.isFormValid ?? false
        verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
    }
    
    func displayExchangeRate(responseDisplay: BuyModels.Rate.ResponseDisplay) {
        tableView.beginUpdates()
        
        if let cell = getRateAndTimerCell() {
            cell.setup { view in
                view.setup(with: responseDisplay.rate)
                
                view.completion = { [weak self] in
                    self?.interactor?.getExchangeRate(viewAction: .init())
                }
            }
        } else {
            continueButton.viewModel?.enabled = false
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
        }
        
        if let section = sections.firstIndex(of: Models.Sections.accountLimits),
           let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FELabel> {
            cell.setup { view in
                view.setup(with: responseDisplay.limits)
            }
        }
        
        tableView.endUpdates()
    }
    
    func displayOrderPreview(responseDisplay: BuyModels.OrderPreview.ResponseDisplay) {
        coordinator?.showOrderPreview(coreSystem: dataStore?.coreSystem,
                                      keyStore: dataStore?.keyStore,
                                      to: dataStore?.toAmount,
                                      from: dataStore?.from,
                                      card: dataStore?.paymentCard,
                                      quote: dataStore?.quote)
    }
    
    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        if responseDisplay.error != nil {
            LoadingView.hide()
        }
        
        guard !isAccessDenied(responseDisplay: responseDisplay) else { return }
        
        guard responseDisplay.error != nil else {
            coordinator?.hideMessage()
            return
        }
        
        continueButton.viewModel?.enabled = false
        verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
        
        coordinator?.showMessage(with: responseDisplay.error,
                                 model: responseDisplay.model,
                                 configuration: responseDisplay.config)
    }
}
