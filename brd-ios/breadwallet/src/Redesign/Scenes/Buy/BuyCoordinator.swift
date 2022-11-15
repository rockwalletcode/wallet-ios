//
//  BuyCoordinator.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import Frames
import UIKit
import WalletKit

class BuyCoordinator: BaseCoordinator, BuyRoutes, BillingAddressRoutes, OrderPreviewRoutes, AssetSelectionDisplayable {
    // MARK: - BuyRoutes
    
    override func start() {
        open(scene: Scenes.Buy)
    }
    
    func reloadBuy(selectedCard: PaymentCard) {
        let buyVC = navigationController.children.first(where: { $0 is BuyViewController }) as? BuyViewController
        buyVC?.dataStore?.paymentCard = selectedCard
        buyVC?.dataStore?.autoSelectDefaultPaymentMethod = false
        buyVC?.interactor?.getData(viewAction: .init())
    }
    
    func showBillingAddress(checkoutToken: CkoCardTokenResponse?) {
        open(scene: Scenes.BillingAddress) { vc in
            vc.interactor?.dataStore?.checkoutToken = checkoutToken
            vc.prepareData()
            LoadingView.hide()
        }
    }
    
    func showThreeDSecure(url: URL) {
        let webViewController = SimpleWebViewController(url: url)
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        webViewController.setup(with: .init(title: L10n.Buy._3DSecure))
        webViewController.didDismiss = { [weak self] in
            (self?.navigationController.topViewController as? DataPresentable)?.prepareData()
            navController.dismiss(animated: true)
        }
        
        navigationController.present(navController, animated: true)
    }
    
    func showSuccess(paymentReference: String, transactionType: Transaction.TransactionType) {
        open(scene: Scenes.Success) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.transactionType = transactionType
            vc.dataStore?.itemId = paymentReference
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.failure = FailureReason.buy
        }
    }
    
    func showTimeout() {
        open(scene: Scenes.Timeout) { vc in
            vc.navigationItem.hidesBackButton = true
        }
    }
    
    func showTermsAndConditions(url: URL) {
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: L10n.About.terms))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    func showCardSelector(cards: [PaymentCard], selected: ((PaymentCard?) -> Void)?, fromBuy: Bool = true) {
        guard !cards.isEmpty else {
            openModally(coordinator: ItemSelectionCoordinator.self,
                        scene: Scenes.AddCard)
            return
        }
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.CardSelection,
                    presentationStyle: .currentContext) { vc in
            vc?.dataStore?.isAddingEnabled = true
            vc?.dataStore?.isSelectingEnabled = fromBuy
            vc?.dataStore?.items = cards
            let backButtonVisible = self.navigationController.children.last is BillingAddressViewController
            vc?.navigationItem.hidesBackButton = backButtonVisible
            vc?.prepareData()
            
            vc?.itemSelected = { item in
                selected?(item as? PaymentCard)
                self.popToRoot()
            }
        }
    }
    
    func showCountrySelector(countries: [Country], selected: ((Country?) -> Void)?) {
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.ItemSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = countries
            vc?.itemSelected = { item in
                selected?(item as? Country)
            }
            vc?.prepareData()
        }
    }
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?) {
        ExchangeAuthHelper.showPinInput(on: navigationController,
                                        keyStore: keyStore,
                                        callback: callback)
    }
    
    func showOrderPreview(coreSystem: CoreSystem?,
                          keyStore: KeyStore?,
                          to: Amount?,
                          from: Decimal?,
                          card: PaymentCard?,
                          quote: Quote?) {
        open(scene: Scenes.OrderPreview) { vc in
            vc.dataStore?.coreSystem = coreSystem
            vc.dataStore?.keyStore = keyStore
            vc.dataStore?.from = from
            vc.dataStore?.to = to
            vc.dataStore?.card = card
            vc.dataStore?.quote = quote
            vc.prepareData()
        }
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
}

extension BuyCoordinator {
    func showMonthYearPicker(model: [[String]]) {
        guard let viewController = navigationController.children.last(where: { $0 is AddCardViewController }) as? AddCardViewController else { return }
        
        PickerViewViewController.show(on: viewController,
                                      sourceView: viewController.view,
                                      title: nil,
                                      values: model,
                                      selection: .init(primaryRow: 0, secondaryRow: 0)) { _, _, index, _ in
            viewController.interactor?.cardInfoSet(viewAction: .init(expirationDateIndex: index))
        }
    }
}
