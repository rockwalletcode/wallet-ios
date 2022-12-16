//
//  BuyVIP.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

extension Scenes {
    static let Buy = BuyViewController.self
}

protocol BuyViewActions: BaseViewActions,
                         FetchViewActions,
                         FeeFetchable,
                         ExchangeRateViewActions,
                         AchViewActions {
    func setAmount(viewAction: BuyModels.Amounts.ViewAction)
    func setAssets(viewAction: BuyModels.Assets.ViewAction)
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction)
    func navigateAssetSelector(viewAction: BuyModels.AssetSelector.ViewAction)
    func selectPaymentMethod(viewAction: BuyModels.PaymentMethod.ViewAction)
    func retryPaymentMethod(viewAction: BuyModels.RetryPaymentMethod.ViewAction)
}

protocol BuyActionResponses: BaseActionResponses,
                             FetchActionResponses,
                             ExchangeRateActionResponses,
                             AchActionResponses {
    func presentPaymentCards(actionResponse: BuyModels.PaymentCards.ActionResponse)
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse)
    func presentOrderPreview(actionResponse: BuyModels.OrderPreview.ActionResponse)
    func presentNavigateAssetSelector(actionResponse: BuyModels.AssetSelector.ActionResponse)
    func presentLinkToken(actionResponse: BuyModels.PlaidLinkToken.ActionResponse)
    func presentPublicTokenSuccess(actionResponse: BuyModels.PlaidPublicToken.ActionResponse)
    func presentFailure(actionResponse: BuyModels.Failure.ActionResponse)
    func presentUSDCMessage(actionResponse: BuyModels.AchData.ActionResponse)
    func presentMessage(actionResponse: BuyModels.RetryPaymentMethod.ActionResponse)
}

protocol BuyResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays, ExchangeRateResponseDisplays, AchResponseDisplays {
    func displayPaymentCards(responseDisplay: BuyModels.PaymentCards.ResponseDisplay)
    func displayAssets(responseDisplay: BuyModels.Assets.ResponseDisplay)
    func displayOrderPreview(responseDisplay: BuyModels.OrderPreview.ResponseDisplay)
    func displayNavigateAssetSelector(responseDisplay: BuyModels.AssetSelector.ResponseDisplay)
    func displayLinkToken(responseDisplay: BuyModels.PlaidLinkToken.ResponseDisplay)
    func displayFailure(responseDisplay: BuyModels.Failure.ResponseDisplay)
    func displayAchData(actionResponse: BuyModels.AchData.ResponseDisplay)
    func displayManageAssetsMessage(actionResponse: BuyModels.AchData.ResponseDisplay)
}

protocol BuyDataStore: BaseDataStore, FetchDataStore, ExchangeDataStore, AchDataStore {
    var from: Decimal? { get set }
    var to: Decimal? { get set }
    var values: BuyModels.Amounts.ViewAction { get set }
    var toAmount: Amount? { get set }
    var currencies: [Currency] { get set }
    var supportedCurrencies: [SupportedCurrency]? { get set }
    var quote: Quote? { get set }
    
    var coreSystem: CoreSystem? { get set }
    var keyStore: KeyStore? { get set }
    
    var autoSelectDefaultPaymentMethod: Bool { get set }
    var paymentMethod: PaymentCard.PaymentType? { get set }
    var publicToken: String? { get set }
    var mask: String? { get set }
}

protocol BuyDataPassing: AchDataStore {
    var dataStore: BuyDataStore? { get }
}

protocol BuyRoutes: CoordinatableRoutes {
}
