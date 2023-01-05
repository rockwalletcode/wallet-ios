//
//  SwapInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class SwapInteractor: NSObject, Interactor, SwapViewActions {
    
    typealias Models = SwapModels
    
    var presenter: SwapPresenter?
    var dataStore: SwapStore?
    
    private var sender: Sender?
    
    // MARK: - SwapViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard dataStore?.currencies.isEmpty == false else { return }
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                ExchangeManager.shared.reload()
                
                guard let currencies = currencies,
                      currencies.count >= 2 else {
                    self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.selectAssets))
                    return
                }
                self?.dataStore?.supportedCurrencies = currencies
                
                let enabled = self?.dataStore?.currencies.filter { cur in currencies.map { $0.name }.contains(cur.code) }
                
                guard let from = enabled?.first,
                      let to = enabled?.first(where: { $0.code != from.code })
                else {
                    self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.selectAssets))
                    return
                }
                self?.dataStore?.from = .zero(from)
                self?.dataStore?.to = .zero(to)
                
                let item = Models.Item(from: self?.dataStore?.from,
                                       to: self?.dataStore?.to,
                                       quote: self?.dataStore?.quote,
                                       isKYCLevelTwo: self?.dataStore?.isKYCLevelTwo)
                self?.presenter?.presentData(actionResponse: .init(item: item))
                self?.getExchangeRate(viewAction: .init(getFees: false))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.supportedCurrencies(error: error)))
            }
        }
    }
    
    func getCoingeckoExchangeRate(viewAction: ExchangeRateModels.CoingeckoRate.ViewAction) {
        guard let baseCurrency = dataStore?.from?.currency.coinGeckoId,
              let termCurrency = dataStore?.to?.currency.coinGeckoId else {
            presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noQuote(from: dataStore?.fromCode, to: dataStore?.toCode)))
            return
        }
        
        let coinGeckoIds = [baseCurrency, termCurrency]
        let vsCurrency = C.usdCurrencyCode.lowercased()
        let resource = Resources.simplePrice(ids: coinGeckoIds,
                                             vsCurrency: vsCurrency,
                                             options: [.change]) { [weak self] (result: Result<[SimplePrice], CoinGeckoError>) in
            switch result {
            case .success(let data):
                self?.dataStore?.fromRate = Decimal(data.first(where: { $0.id == baseCurrency })?.price ?? 0)
                self?.dataStore?.toRate = Decimal(data.first(where: { $0.id == termCurrency })?.price ?? 0)
                
                guard viewAction.getFees else {
                    self?.setAmountSuccess()
                    
                    return
                }
                
                self?.getFees(viewAction: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        CoinGeckoClient().load(resource)
        _ = generateSender()
    }
    
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction) {
        guard let from = dataStore?.from?.currency,
                let to = dataStore?.to?.currency
        else { return }
        
        dataStore?.from = .zero(to)
        dataStore?.to = .zero(from)
        dataStore?.values = .init()
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        
        // Remove error
        presenter?.presentError(actionResponse: .init(error: nil))
        
        getExchangeRate(viewAction: .init(getFees: false))
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        guard let fromRate = dataStore?.fromRate, let toRate = dataStore?.toRate, fromRate > 0, toRate > 0 else { return }
        
        guard let fromCurrency = dataStore?.from?.currency,
              let toCurrency = dataStore?.to?.currency
        else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.ErrorMessages.noCurrencies)))
            return
        }
        
        let exchangeRate = dataStore?.quote?.exchangeRate ?? 1
        
        let toFeeRate = dataStore?.quote?.toFee?.feeRate ?? 1
        let toFee = (dataStore?.quote?.toFee?.fee ?? 0)
        
        let from: Amount
        let to: Amount
        
        if let fromCryptoAmount = viewAction.fromCryptoAmount,
           let fromCrypto = ExchangeFormatter.current.number(from: fromCryptoAmount)?.decimalValue {
            from = .init(decimalAmount: fromCrypto, isFiat: false, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(decimalAmount: (fromCrypto - toFee / toFeeRate) * exchangeRate, isFiat: false, currency: toCurrency, exchangeRate: toRate)
            
        } else if let fromFiatAmount = viewAction.fromFiatAmount,
                  let fromFiat = ExchangeFormatter.current.number(from: fromFiatAmount)?.decimalValue {
            from = .init(decimalAmount: fromFiat, isFiat: true, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(decimalAmount: (from.tokenValue - toFee / toFeeRate) * exchangeRate, isFiat: false, currency: toCurrency, exchangeRate: toRate)
            
        } else if let toCryptoAmount = viewAction.toCryptoAmount,
                  let toCrypto = ExchangeFormatter.current.number(from: toCryptoAmount)?.decimalValue {
            from = .init(decimalAmount: toCrypto / exchangeRate + toFee / toFeeRate, isFiat: false, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(decimalAmount: toCrypto, isFiat: false, currency: toCurrency, exchangeRate: toRate)
            
        } else if let toFiatAmount = viewAction.toFiatAmount,
                  let toFiat = ExchangeFormatter.current.number(from: toFiatAmount)?.decimalValue {
            to = .init(decimalAmount: toFiat, isFiat: true, currency: toCurrency, exchangeRate: toRate)
            from = .init(decimalAmount: to.tokenValue / exchangeRate + toFee / toFeeRate, isFiat: false, currency: fromCurrency, exchangeRate: fromRate)
            
        } else {
            presenter?.presentAmount(actionResponse: .init(from: dataStore?.from,
                                                           to: dataStore?.to,
                                                           fromFee: dataStore?.fromFeeAmount,
                                                           toFee: dataStore?.toFeeAmount,
                                                           baseBalance: dataStore?.from?.currency.state?.balance,
                                                           minimumValue: dataStore?.quote?.minimumUsd,
                                                           handleErrors: viewAction.handleErrors))
            return
        }
        
        dataStore?.values = viewAction
        dataStore?.values.handleErrors = false
        dataStore?.from = from
        dataStore?.to = to
        
        presenter?.presentAmount(actionResponse: .init(from: dataStore?.from,
                                                       to: dataStore?.to,
                                                       fromFee: dataStore?.fromFeeAmount,
                                                       toFee: dataStore?.toFeeAmount,
                                                       baseBalance: dataStore?.from?.currency.state?.balance,
                                                       minimumValue: dataStore?.quote?.minimumUsd,
                                                       handleErrors: viewAction.handleErrors))
    }
    
    func getFees(viewAction: Models.Fee.ViewAction) {
        guard let from = dataStore?.from,
              let fromAddress = from.currency.wallet?.defaultReceiveAddress,
              let sender = sender else {
            presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noFees))
            return
        }
        
        // Fetching new fees
        fetchWkFee(for: from,
                   with: sender,
                   address: fromAddress) { [weak self] fee in
            self?.dataStore?.fromFee = fee
            
            if self?.dataStore?.fromFee != nil,
               self?.dataStore?.quote != nil {
                // All good
                self?.setAmountSuccess()
            } else if self?.dataStore?.quote?.fromFee?.fee != nil,
                      from.currency.isEthereum {
                // Not enough ETH for Swap + Fee
                let value = self?.dataStore?.fromFeeAmount?.tokenValue ?? self?.dataStore?.quote?.fromFee?.fee ?? 0
                let error = ExchangeErrors.balanceTooLow(balance: value, currency: from.currency.code)
                self?.presenter?.presentError(actionResponse: .init(error: error))
            } else if self?.dataStore?.quote?.fromFee?.fee != nil {
                // Not enough ETH for fee
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.notEnoughEthForFee(currency: from.currency.code)))
            } else {
                // No quote and no WK fee
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noFees))
            }
        }
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        guard let from = dataStore?.from?.currency,
                let to = dataStore?.to?.currency else {
            // nothing to swap ¯\_(ツ)_/¯
            return
        }
        
        if let asset = viewAction.from,
           let from = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.from = .zero(from)
            dataStore?.to = .zero(to)
        }
        
        if let asset = viewAction.to,
           let to = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.to = .zero(to)
            dataStore?.from = .zero(from)
        }

        dataStore?.values = .init()
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        
        getExchangeRate(viewAction: .init(getFees: false))
        
        // TODO: Hide error if pressent
        presenter?.presentError(actionResponse: .init())
    }
    
    func selectAsset(viewAction: SwapModels.Assets.ViewAction) {
        var from: [Currency]?
        var to: [Currency]?
        
        if viewAction.to == true {
            to = dataStore?.currencies.filter { $0.code != dataStore?.from?.currency.code }
        } else {
            from = dataStore?.currencies.filter { $0.code != dataStore?.to?.currency.code }
        }
        
        presenter?.presentSelectAsset(actionResponse: .init(from: from, to: to))
    }
    
    func showConfirmation(viewAction: SwapModels.ShowConfirmDialog.ViewAction) {
        presenter?.presentConfirmation(actionResponse: .init(from: dataStore?.from,
                                                             to: dataStore?.to,
                                                             quote: dataStore?.quote,
                                                             fromFee: dataStore?.fromFeeAmount,
                                                             toFee: dataStore?.toFeeAmount))
    }
    
    func confirm(viewAction: SwapModels.Confirm.ViewAction) {
        guard let currency = dataStore?.currencies.first(where: { $0.code == dataStore?.to?.currency.code }),
              let address = dataStore?.coreSystem?.wallet(for: currency)?.receiveAddress,
              let from = dataStore?.from?.tokenValue,
              let to = dataStore?.to?.tokenValue
        else {
            return
        }
        
        let formatter = ExchangeFormatter.crypto
        formatter.locale = Locale(identifier: C.usLocaleCode)
        formatter.usesGroupingSeparator = false
        
        let fromTokenValue = formatter.string(for: from) ?? ""
        let toTokenValue = formatter.string(for: to) ?? ""
        
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   depositQuantity: fromTokenValue,
                                   withdrawalQuantity: toTokenValue,
                                   destination: address)
        
        // We need to make sure the swap from amount is still less than the balance
        if let balance = sender?.wallet.currency.state?.balance {
            let amount = dataStore?.from ?? Amount(decimalAmount: 0, isFiat: false, currency: dataStore?.from?.currency ?? balance.currency)
            if amount > balance {
                let error = ExchangeErrors.balanceTooLow(balance: from, currency: dataStore?.from?.currency.code ?? "")
                self.presenter?.presentError(actionResponse: .init(error: error))
                return
            }
        }
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.swap = data
                self?.createTransaction(from: data)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.failed(error: error)))
            }
        }
    }
    
    func showAssetInfoPopup(viewAction: SwapModels.AssetInfoPopup.ViewAction) {
        presenter?.presentAssetInfoPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func setAmountSuccess() {
        var model: Models.Amounts.ViewAction = dataStore?.values ?? .init()
        model.handleErrors = true
        setAmount(viewAction: model)
    }
    
    private func generateSender() -> Sender? {
        guard let fromCurrency = dataStore?.from?.currency,
              let wallet = dataStore?.coreSystem?.wallet(for: fromCurrency),
              let keyStore = dataStore?.keyStore,
              let kvStore = Backend.kvStore else { return nil }
        
        sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        
        sender?.updateNetworkFees()
        
        return sender
    }
    
    private func createTransaction(from swap: Swap?) {
        guard let dataStore = dataStore,
              let currency = dataStore.currencies.first(where: { $0.code == swap?.currency }),
              let wallet = dataStore.coreSystem?.wallet(for: currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore.keyStore else {
            presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noFees))
            return
        }
        
        guard let destination = swap?.address,
              let amountValue = swap?.amount,
              let fee = dataStore.fromFee,
              let exchangeId = dataStore.swap?.exchangeId
        else {
            presenter?.presentError(actionResponse: .init(error: ExchangeErrors.noFees))
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        let amount = Amount(decimalAmount: amountValue, isFiat: false, currency: currency)
        let transaction = sender.createTransaction(address: destination,
                                                   amount: amount,
                                                   feeBasis: fee,
                                                   comment: nil,
                                                   exchangeId: exchangeId)
        
        var error: FEError?
        switch transaction {
        case .ok:
            sender.sendTransaction(allowBiometrics: false, exchangeId: exchangeId) { [weak self] data in
                guard let pin: String = try? keychainItem(key: KeychainKey.pin) else {
                    self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.pinConfirmation))
                    return
                }
                data(pin)
            } completion: { [weak self] result in
                defer { sender.reset() }
                
                var error: FEError?
                switch result {
                case .success:
                    ExchangeManager.shared.reload()
                    
                    let from = self?.dataStore?.from?.currency.code
                    let to = self?.dataStore?.to?.currency.code
                    
                    self?.presenter?.presentConfirm(actionResponse: .init(from: from, to: to, exchangeId: exchangeId))
                    
                case .creationError(let message):
                    error = GeneralError(errorMessage: message)
                    
                case .insufficientGas:
                    error = ExchangeErrors.networkFee
                    
                case .publishFailure(let code, let message):
                    error = GeneralError(errorMessage: "Error \(code): \(message)")
                }
                
                guard let error = error else { return }
                self?.presenter?.presentError(actionResponse: .init(error: ExchangeErrors.failed(error: error)))
            }
            
        case .failed:
            error = GeneralError(errorMessage: "Unknown error")
            
        case .invalidAddress:
            error = GeneralError(errorMessage: "invalid address")
            
        case .ownAddress:
            error = GeneralError(errorMessage: "Own address")
            
        case .insufficientFunds:
            error = ExchangeErrors.balanceTooLow(balance: dataStore.fromFeeAmount?.tokenValue ?? dataStore.quote?.fromFee?.fee ?? 0, currency: currency.code)
            
        case .noExchangeRate:
            error = ExchangeErrors.noQuote(from: dataStore.from?.currency.code, to: dataStore.to?.currency.code)
            
        case .noFees:
            error = ExchangeErrors.noFees
            
        case .outputTooSmall(let amount):
            error = ExchangeErrors.tooLow(amount: amount.tokenValue, currency: amount.currency.code, reason: .swap)
            
        case .invalidRequest(let string):
            error = GeneralError(errorMessage: string)
            
        case .paymentTooSmall(let amount):
            error = ExchangeErrors.tooLow(amount: amount.tokenValue, currency: amount.currency.code, reason: .swap)
            
        case .usedAddress:
            error = GeneralError(errorMessage: "Used address")
            
        case .identityNotCertified(let string):
            error = GeneralError(errorMessage: "Not certified \(string)")
            
        case .insufficientGas:
            error = ExchangeErrors.networkFee
        }
        
        guard let error = error else { return }
        presenter?.presentError(actionResponse: .init(error: error))
    }
}
