// 
//  AchPaymentVIP.swift
//  breadwallet
//
//  Created by Rok on 12/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import LinkKit

protocol AchViewActions {
    func getAch(viewAction: AchPaymentModels.Get.ViewAction)
    // implement if needed in adaptor class
    func didGetAch(viewAction: AchPaymentModels.Get.ViewAction)
    func getPlaidToken(viewAction: AchPaymentModels.Link.ViewAction)
    //    // TODO: maybe reuse link?
    //    func relink(viewAction: ExchangeRateModels.CoingeckoRate.ViewAction)
    //    func selected(viewAction: ExchangeRateModels.CoingeckoRate.ViewAction)
}

protocol AchActionResponses: AnyObject {
    var paymentModel: CardSelectionViewModel? { get set }
    
    func presentAch(actionResponse: AchPaymentModels.Get.ActionResponse)
    func presentPlaidToken(actionResponse: AchPaymentModels.Link.ActionResponse)
}

protocol AchResponseDisplays: AnyObject {
    var plaidHandler: Handler? { get set }
    func displayPlaidToken(responseDisplay: AchPaymentModels.Link.ResponseDisplay)
}

protocol AchDataStore {
    var selected: PaymentCard? { get set }
    var ach: PaymentCard? { get set }
    var cards: [PaymentCard] { get set }
}

extension Interactor where Self: AchViewActions,
                           Self.DataStore: AchDataStore,
                           Self.ActionResponses: AchActionResponses {
    func getAch(viewAction: AchPaymentModels.Get.ViewAction) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.ach = data?.first(where: { $0.type == .buyAch })
                self?.dataStore?.cards = data?.filter {$0.type == .buyCard } ?? []
                
            default:
                break
            }
            self?.presenter?.presentAch(actionResponse: .init(item: self?.dataStore?.ach))
            self?.didGetAch(viewAction: viewAction)
        }
    }
    
    func getPlaidToken(viewAction: AchPaymentModels.Link.ViewAction) {
        guard dataStore?.ach == nil else { return }
        
        PlaidLinkTokenWorker().execute { [weak self] result in
            switch result {
            case .success(let response):
                self?.getPublicPlaidToken(for: response?.linkToken)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    private func getPublicPlaidToken(for token: String?) {
        guard let linkToken = token else { return }
        
        var linkConfiguration = LinkTokenConfiguration(token: linkToken) { [weak self] result in
            let publicToken = result.publicToken
            let mask = result.metadata.accounts.first?.mask
            self?.setPublicPlaidToken(publicToken, mask: mask)
        }
        
        linkConfiguration.onExit = { exit in
            if let error = exit.error {
                print("exit with \(error)\n\(exit.metadata)")
            } else {
                print("exit with \(exit.metadata)")
            }
        }
        
        linkConfiguration.onEvent = { event in
            print("Link Event: \(event)")
        }
        
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .failure(let error):
            print("Unable to create Plaid handler due to: \(error)")
        case .success(let handler):
            presenter?.presentPlaidToken(actionResponse: .init(handler: handler))
        }
    }
    
    private func setPublicPlaidToken(_ token: String?, mask: String?) {
        PlaidPublicTokenWorker().execute(requestData: PlaidPublicTokenRequestData(publicToken: token,
                                                                                  mask: mask,
                                                                                  accountId: nil)) { [weak self] result in
            switch result {
            case .success:
                self?.getAch(viewAction: .init())
                
            case .failure:
                return
//                self?.presenter?.presentFailure(actionResponse: .init())
            }
        }
    }
}

extension Presenter where Self: AchActionResponses,
                          Self.ResponseDisplays: AchResponseDisplays {
    func presentAch(actionResponse: AchPaymentModels.Get.ActionResponse) {
        guard let item = actionResponse.item else {
            paymentModel = .init(title: .text(L10n.Buy.achPayments),
                                 subtitle: .text(L10n.Buy.relinkBankAccount),
                                 userInteractionEnabled: true)
            return
        }
        
        switch item.status {
        case .statusOk:
            paymentModel = .init(title: .text(L10n.Buy.transferFromBank),
                                 logo: .image(Asset.bank.image),
                                 cardNumber: .text(item.displayName),
                                 userInteractionEnabled: false)
        default:
            paymentModel = .init(title: .text(L10n.Buy.achPayments),
                                 subtitle: .text(L10n.Buy.relinkBankAccount),
                                 userInteractionEnabled: true)
        }
    }
    
    func presentPlaidToken(actionResponse: AchPaymentModels.Link.ActionResponse) {
        viewController?.displayPlaidToken(responseDisplay: .init(handler: actionResponse.handler))
    }
}

extension Controller where Self: AchResponseDisplays {
    func displayPlaidToken(responseDisplay: AchPaymentModels.Link.ResponseDisplay) {
        plaidHandler = responseDisplay.handler
        plaidHandler?.open(presentUsing: .viewController(self))
    }
}