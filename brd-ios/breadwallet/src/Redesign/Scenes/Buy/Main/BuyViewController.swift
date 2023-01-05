//
//  BuyViewController.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import LinkKit

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
}

class BuyViewController: BaseTableViewController<BuyCoordinator, BuyInteractor, BuyPresenter, BuyStore>, BuyResponseDisplays {
    
    typealias Models = BuyModels
    
    var plaidHandler: Handler?
    var didTriggerGetData: (() -> Void)?
    
    private var supportedCurrencies: [SupportedCurrency]?
    
    // MARK: - Overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getRateAndTimerCell()?.wrappedView.invalidate()
    }
    
    override var sceneLeftAlignedTitle: String? {
        return dataStore?.canUseAch == true ? nil : L10n.Button.buy
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<FESegmentControl>.self)
        tableView.register(WrapperTableViewCell<SwapCurrencyView>.self)
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
        tableView.delaysContentTouches = false
        
        didTriggerGetData = { [weak self] in
            self?.interactor?.getData(viewAction: .init())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .segment:
            cell = self.tableView(tableView, segmentControlCellForRowAt: indexPath)
            
        case .accountLimits:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .rateAndTimer:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)
            
        case .from:
            cell = self.tableView(tableView, cryptoSelectionCellForRowAt: indexPath)
            
        case .paymentMethod:
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
                if self?.dataStore?.paymentMethod == .card {
                    self?.interactor?.navigateAssetSelector(viewAction: .init())
                }
            }
        }
        cell.setupCustomMargins(vertical: .large, horizontal: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, segmentControlCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<FESegmentControl> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? SegmentControlViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didChangeValue = { [weak self] segment in
                self?.view.endEditing(true)
                self?.interactor?.selectPaymentMethod(viewAction: .init(method: segment))
                guard (Store.state.currencies.first(where: { $0.code == C.USDC }) == nil) else { return }
                view.setup(with: SegmentControlViewModel(selectedIndex: .card))
            }
        }
        
        return cell
    }
    
    func getRateAndTimerCell() -> WrapperTableViewCell<ExchangeRateView>? {
        guard let section = sections.firstIndex(of: Models.Sections.rateAndTimer),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView> else {
            continueButton.viewModel?.enabled = false
            continueButton.setup(with: continueButton.viewModel)
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
            
            return nil
        }
        
        return cell
    }
    
    func getAccountLimitsCell() -> WrapperTableViewCell<FELabel>? {
        guard let section = sections.firstIndex(of: Models.Sections.accountLimits),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FELabel> else {
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
        switch dataStore?.paymentMethod {
        case .ach:
            if let usdCurrency = dataStore?.supportedCurrencies?.first(where: {$0.name == C.USDC }) {
                supportedCurrencies = [usdCurrency]
            }
        default:
            supportedCurrencies = dataStore?.supportedCurrencies
        }
        
        coordinator?.showAssetSelector(title: responseDisplay.title,
                                       currencies: dataStore?.currencies,
                                       supportedCurrencies: supportedCurrencies) { [weak self] item in
            guard let item = item as? AssetViewModel else { return }
            self?.interactor?.setAssets(viewAction: .init(currency: item.subtitle))
        }
    }
    
    func displayPaymentCards(responseDisplay: BuyModels.PaymentCards.ResponseDisplay) {
        view.endEditing(true)
        
        coordinator?.showCardSelector(cards: responseDisplay.allPaymentCards, selected: { [weak self] selectedCard in
            guard let selectedCard = selectedCard else { return }
            self?.interactor?.setAssets(viewAction: .init(card: selectedCard))
        }, completion: { [weak self] in
            self?.interactor?.getPayments(viewAction: .init())
        })
    }
    
    func displayAssets(responseDisplay actionResponse: BuyModels.Assets.ResponseDisplay) {
        guard let fromSection = sections.firstIndex(of: Models.Sections.from),
              let toSection = sections.firstIndex(of: Models.Sections.paymentMethod),
              let fromCell = tableView.cellForRow(at: .init(row: 0, section: fromSection)) as? WrapperTableViewCell<SwapCurrencyView>,
              let toCell = tableView.cellForRow(at: .init(row: 0, section: toSection)) as? WrapperTableViewCell<CardSelectionView> else {
            continueButton.viewModel?.enabled = false
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
            
            return
        }
        
        tableView.beginUpdates()
        fromCell.wrappedView.setup(with: actionResponse.cryptoModel)
        toCell.wrappedView.setup(with: actionResponse.cardModel)
        tableView.endUpdates()
        
        continueButton.viewModel?.enabled = dataStore?.isFormValid ?? false
        verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
    }
    
    func displayOrderPreview(responseDisplay: BuyModels.OrderPreview.ResponseDisplay) {
        coordinator?.showOrderPreview(type: .buy,
                                      coreSystem: dataStore?.coreSystem,
                                      keyStore: dataStore?.keyStore,
                                      to: dataStore?.toAmount,
                                      from: dataStore?.from,
                                      card: dataStore?.selected,
                                      quote: dataStore?.quote,
                                      availablePayments: responseDisplay.availablePayments)
    }
    
    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        if responseDisplay.error != nil {
            LoadingView.hide()
        }
        
        guard !isAccessDenied(responseDisplay: responseDisplay) else { return }
        
        if responseDisplay.error != nil {
            continueButton.viewModel?.enabled = false
            verticalButtons.wrappedView.getButton(continueButton)?.setup(with: continueButton.viewModel)
        }
        
        coordinator?.showToastMessage(with: responseDisplay.error,
                                      model: responseDisplay.model,
                                      configuration: responseDisplay.config)
    }
    
    func displayManageAssetsMessage(actionResponse: BuyModels.AchData.ResponseDisplay) {
        coordinator?.showToastMessage(model: actionResponse.model,
                                      configuration: actionResponse.config,
                                      onTapCallback: { [weak self] in
            self?.coordinator?.showManageAssets(coreSystem: self?.dataStore?.coreSystem)
        })
    }
    
    func displayAchData(actionResponse: BuyModels.AchData.ResponseDisplay) {
        interactor?.getPayments(viewAction: .init())
    }
    
    // MARK: - Additional Helpers
    @objc func updatePaymentMethod() {
        guard let availablePayments = dataStore?.availablePayments else { return }
        
        dataStore?.paymentMethod = availablePayments.contains(.ach) == true ? .ach : .card
        interactor?.retryPaymentMethod(viewAction: .init(method: dataStore?.paymentMethod ?? .card))
    }
    
    private func mapStructToDictionary<T>(item: T) -> [String: Any] {
        let dictionary = Dictionary(uniqueKeysWithValues:
            Mirror(reflecting: item).children.lazy.map({ (label: String?, value: Any) in
                if let label = label {
                    return (label, value)
                } else {
                    return (Date().timeIntervalSince1970.description, value)
                }
            })
        )
        return dictionary.compactMapValues { $0 }
    }
}
