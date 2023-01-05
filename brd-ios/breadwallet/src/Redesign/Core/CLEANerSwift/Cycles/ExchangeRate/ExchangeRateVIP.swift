// 
//  ExchangeRateVIP.swift
//  breadwallet
//
//  Created by Rok on 09/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

protocol ExchangeRateViewActions {
    func getExchangeRate(viewAction: ExchangeRateModels.ExchangeRate.ViewAction)
    func getCoingeckoExchangeRate(viewAction: ExchangeRateModels.CoingeckoRate.ViewAction)
}

protocol ExchangeRateActionResponses {
    func presentExchangeRate(actionResponse: ExchangeRateModels.ExchangeRate.ActionResponse)
}

protocol ExchangeRateResponseDisplays {
    var tableView: ContentSizedTableView { get set }
    var continueButton: FEButton { get set }
    func getRateAndTimerCell() -> WrapperTableViewCell<ExchangeRateView>?
    func getAccountLimitsCell() -> WrapperTableViewCell<FELabel>?
    func displayExchangeRate(responseDisplay: ExchangeRateModels.ExchangeRate.ResponseDisplay)
}

protocol ExchangeDataStore: NSObject {
    var limits: String? { get }
    var fromCode: String { get }
    var toCode: String { get }
    var quoteRequestData: QuoteRequestData { get }
    var quote: Quote? { get set }
    var showTimer: Bool { get set }
}

extension Interactor where Self: ExchangeRateViewActions,
                           Self.DataStore: ExchangeDataStore,
                           Self.ActionResponses: ExchangeRateActionResponses {
    
    func getExchangeRate(viewAction: ExchangeRateModels.ExchangeRate.ViewAction) {
        guard let fromCurrency = dataStore?.fromCode.uppercased(),
              let toCurrency = dataStore?.toCode.uppercased(),
              let data = dataStore?.quoteRequestData
        else { return }
        
        // clear previous rate (in case the request fails, we don't want old values displayed)
        dataStore?.quote = nil
        presenter?.presentExchangeRate(actionResponse: .init(quote: dataStore?.quote,
                                                             from: dataStore?.fromCode,
                                                             to: dataStore?.toCode,
                                                             limits: dataStore?.limits,
                                                             showTimer: dataStore?.showTimer))
        
        getCoingeckoExchangeRate(viewAction: .init(getFees: viewAction.getFees))
        QuoteWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.dataStore?.quote = quote
                self?.presenter?.presentExchangeRate(actionResponse: .init(quote: quote,
                                                                           from: fromCurrency,
                                                                           to: toCurrency,
                                                                           limits: self?.dataStore?.limits,
                                                                           showTimer: self?.dataStore?.showTimer))
                
            case .failure(let error):
                guard let error = error as? NetworkingError,
                      error == .accessDenied else {
                    self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.quoteFail))
                    return
                }
            }
        }
    }
    
    func getCoingeckoExchangeRate(viewAction: ExchangeRateModels.CoingeckoRate.ViewAction) {}
}

extension Presenter where Self: ExchangeRateActionResponses,
                          Self.ResponseDisplays: ExchangeRateResponseDisplays {
    func presentExchangeRate(actionResponse: ExchangeRateModels.ExchangeRate.ActionResponse) {
        var exchangeRateViewModel: ExchangeRateViewModel
            if let from = actionResponse.from,
               let to = actionResponse.to,
               let quote = actionResponse.quote,
               let showTimer = actionResponse.showTimer {
                let text = String(format: "1 %@ = %@ %@", to.uppercased(), RWFormatter().string(for: 1 / quote.exchangeRate) ?? "", from)

                exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: text,
                                                              timer: TimerViewModel(till: quote.timestamp, repeats: false),
                                                              showTimer: showTimer)
            } else {
                exchangeRateViewModel = ExchangeRateViewModel(timer: nil, showTimer: false)
            }
    
            viewController?.displayExchangeRate(responseDisplay: .init(rateAndTimer: exchangeRateViewModel,
                                                                       accountLimits: .text(actionResponse.limits)))
    }
}

extension Controller where Self: ExchangeRateResponseDisplays,
                           Self.ViewActions: ExchangeRateViewActions {
    
    func displayExchangeRate(responseDisplay: ExchangeRateModels.ExchangeRate.ResponseDisplay) {
        if let cell = getRateAndTimerCell() {
            cell.wrappedView.setup(with: responseDisplay.rateAndTimer)
            cell.wrappedView.completion = { [weak self] in
                self?.interactor?.getExchangeRate(viewAction: .init())
            }
        } else {
            var vm = continueButton.viewModel
            vm?.enabled = false
            continueButton.setup(with: vm)
            
        }
        
        if let cell = getAccountLimitsCell() {
            cell.wrappedView.setup(with: responseDisplay.accountLimits)
        }
    }
}
