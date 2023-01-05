//
//  SellCoordinator.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//
//

import UIKit

class ExchangeCoordinator: BaseCoordinator, OrderPreviewRoutes {
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?) {
        ExchangeAuthHelper.showPinInput(on: navigationController,
                                        keyStore: keyStore,
                                        callback: callback)
    }
    
    func showOrderPreview(type: PreviewType? = .buy,
                          coreSystem: CoreSystem?,
                          keyStore: KeyStore?,
                          to: Amount?,
                          from: Decimal?,
                          card: PaymentCard?,
                          quote: Quote?,
                          availablePayments: [PaymentCard.PaymentType]?) {
        open(scene: Scenes.OrderPreview) { vc in
            vc.dataStore?.type = type
            vc.dataStore?.coreSystem = coreSystem
            vc.dataStore?.keyStore = keyStore
            vc.dataStore?.from = from
            vc.dataStore?.to = to
            vc.dataStore?.card = card
            vc.dataStore?.quote = quote
            vc.dataStore?.availablePayments = availablePayments
            vc.prepareData()
        }
    }
    
    func showTermsAndConditions(url: URL) {
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: L10n.About.terms))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    func showTimeout() {
        // TODO: to mock details, remove when BE rdy
        showSuccess(paymentReference: "",
                    transactionType: .sellTransaction,
                    reason: SuccessReason.sell)
        
//        open(scene: Scenes.Timeout) { vc in
//            vc.navigationItem.hidesBackButton = true
//        }
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
    
    func showSuccess(paymentReference: String, transactionType: TransactionType, reason: SuccessReason) {
        open(scene: Scenes.Success) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.transactionType = transactionType
            vc.dataStore?.itemId = paymentReference
            vc.success = reason
        }
    }
    
    func showFailure(failure: FailureReason, availablePayments: [PaymentCard.PaymentType]?) {
        open(scene: Scenes.Failure) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.failure = failure
            vc.availablePayments = availablePayments
        }
    }
}

class SellCoordinator: ExchangeCoordinator, SellRoutes {
    
    // MARK: - SellRoutes
    
    // MARK: - Aditional helpers
    
}
