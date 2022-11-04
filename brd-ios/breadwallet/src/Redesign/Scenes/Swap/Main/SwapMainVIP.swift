//
//  SwapVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

extension Scenes {
    static let Swap = SwapViewController.self
}

protocol SwapViewActions: BaseViewActions, FetchViewActions, FeeFetchable {
    func setAmount(viewAction: SwapModels.Amounts.ViewAction)
    func getExchangeRate(viewAction: SwapModels.Rate.ViewAction)
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction)
    func selectAsset(viewAction: SwapModels.Assets.ViewAction)
    func showConfirmation(viewAction: SwapModels.ShowConfirmDialog.ViewAction)
    func confirm(viewAction: SwapModels.Confirm.ViewAction)
    func showAssetInfoPopup(viewAction: SwapModels.AssetInfoPopup.ViewAction)
}

protocol SwapActionResponses: BaseActionResponses, FetchActionResponses {
    func presentAmount(actionResponse: SwapModels.Amounts.ActionResponse)
    func presentExchangeRate(actionResponse: SwapModels.Rate.ActionResponse)
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse)
    func presentConfirmation(actionResponse: SwapModels.ShowConfirmDialog.ActionResponse)
    func presentConfirm(actionResponse: SwapModels.Confirm.ActionResponse)
    func presentAssetInfoPopup(actionResponse: SwapModels.AssetInfoPopup.ActionResponse)
}

protocol SwapResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay)
    func displayExchangeRate(responseDisplay: SwapModels.Rate.ResponseDisplay)
    func displaySelectAsset(responseDisplay: SwapModels.Assets.ResponseDisplay)
    func displayConfirmation(responseDisplay: SwapModels.ShowConfirmDialog.ResponseDisplay)
    func displayConfirm(responseDisplay: SwapModels.Confirm.ResponseDisplay)
    func displayAssetInfoPopup(responseDisplay: SwapModels.AssetInfoPopup.ResponseDisplay)
    func displayError(responseDisplay: SwapModels.ErrorPopup.ResponseDisplay)
}

protocol SwapDataStore: BaseDataStore, FetchDataStore {
    var from: Amount? { get set }
    var to: Amount? { get set }
    
    var values: SwapModels.Amounts.ViewAction { get set }
    
    var fromFee: TransferFeeBasis? { get set }
    
    var quote: Quote? { get set }
    
    var fromRate: Decimal? { get set }
    var toRate: Decimal? { get set }
    
    var baseCurrencies: [String] { get set }
    var termCurrencies: [String] { get set }
    var baseAndTermCurrencies: [[String]] { get set }
    
    var currencies: [Currency] { get set }
    var coreSystem: CoreSystem? { get set }
    var keyStore: KeyStore? { get set }
    var isKYCLevelTwo: Bool? { get set }
}

protocol SwapDataPassing {
    var dataStore: SwapDataStore? { get }
}

protocol SwapRoutes: CoordinatableRoutes {
    func showAssetSelector(title: String, currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?)
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?)
    func showSwapInfo(from: String, to: String, exchangeId: String)
}
