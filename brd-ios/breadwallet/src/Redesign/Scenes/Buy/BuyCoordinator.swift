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

class BuyCoordinator: ExchangeCoordinator, BuyRoutes, BillingAddressRoutes, AssetSelectionDisplayable {
    // MARK: - BuyRoutes
    
    override func start() {
        open(scene: Scenes.Buy)
    }
    
    func reloadBuy(selectedCard: PaymentCard) {
        let buyVC = navigationController.children.first(where: { $0 is BuyViewController }) as? BuyViewController
        buyVC?.dataStore?.selected = selectedCard
        buyVC?.dataStore?.autoSelectDefaultPaymentMethod = false
        buyVC?.interactor?.getData(viewAction: .init())
    }
    
    func showBillingAddress(_ store: AddCardStore) {
        open(scene: Scenes.BillingAddress) { vc in
            vc.dataStore?.cardNumber = store.cardNumber
            vc.dataStore?.cvv = store.cardCVV
            vc.dataStore?.expYear = store.cardExpDateYear
            vc.dataStore?.expMonth = store.cardExpDateMonth
            vc.prepareData()
            LoadingView.hide()
        }
    }
    
    func showCardSelector(cards: [PaymentCard], selected: ((PaymentCard?) -> Void)?, fromBuy: Bool = true, completion: (() -> Void)? = nil) {
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
            
            vc?.paymentCardDeleted = {
                completion?()
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
    
    func showManageAssets(coreSystem: CoreSystem?) {
        guard let coreSystem = coreSystem, let assetCollection = coreSystem.assetCollection else { return }
        
        let vc = ManageWalletsViewController(assetCollection: assetCollection, coreSystem: coreSystem)
        let nc = RootNavigationController(rootViewController: vc)
        navigationController.present(nc, animated: true)
    }
    
    func dismissCardsSelectionFlow(completion: (() -> Void)?) {
        navigationController.dismiss(animated: true, completion: completion)
        parentCoordinator?.childDidFinish(child: self)
    }
    
    // MARK: - Aditional helpers
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
