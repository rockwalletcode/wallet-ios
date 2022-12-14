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

protocol BuyViewActions: BaseViewActions, FetchViewActions, FeeFetchable {
    func setAmount(viewAction: BuyModels.Amounts.ViewAction)
    func getExchangeRate(viewAction: BuyModels.Rate.ViewAction)
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction)
    func setAssets(viewAction: BuyModels.Assets.ViewAction)
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction)
    func navigateAssetSelector(viewAction: BuyModels.AssetSelector.ViewAction)
    func getLinkToken(viewAction: BuyModels.PlaidLinkToken.ViewAction)
    func setPublicToken(viewAction: BuyModels.PlaidPublicToken.ViewAction)
    func selectPaymentMethod(viewAction: BuyModels.PaymentMethod.ViewAction)
}

protocol BuyActionResponses: BaseActionResponses, FetchActionResponses {
    func presentPaymentCards(actionResponse: BuyModels.PaymentCards.ActionResponse)
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse)
    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse)
    func presentOrderPreview(actionResponse: BuyModels.OrderPreview.ActionResponse)
    func presentNavigateAssetSelector(actionResponse: BuyModels.AssetSelector.ActionResponse)
    func presentLinkToken(actionResponse: BuyModels.PlaidLinkToken.ActionResponse)
    func presentPublicTokenSuccess(actionResponse: BuyModels.PlaidPublicToken.ActionResponse)
    func presentFailure(actionResponse: BuyModels.Failure.ActionResponse)
    func presentUSDCMessage(actionResponse: BuyModels.AchData.ActionResponse)
}

protocol BuyResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayPaymentCards(responseDisplay: BuyModels.PaymentCards.ResponseDisplay)
    func displayAssets(responseDisplay: BuyModels.Assets.ResponseDisplay)
    func displayExchangeRate(responseDisplay: BuyModels.Rate.ResponseDisplay)
    func displayOrderPreview(responseDisplay: BuyModels.OrderPreview.ResponseDisplay)
    func displayNavigateAssetSelector(responseDisplay: BuyModels.AssetSelector.ResponseDisplay)
    func displayLinkToken(responseDisplay: BuyModels.PlaidLinkToken.ResponseDisplay)
    func displayFailure(responseDisplay: BuyModels.Failure.ResponseDisplay)
    func displayAchData(actionResponse: BuyModels.AchData.ResponseDisplay)
    func displayManageAssetsMessage(actionResponse: BuyModels.AchData.ResponseDisplay)
}

protocol BuyDataStore: BaseDataStore, FetchDataStore {
    var from: Decimal? { get set }
    var to: Decimal? { get set }
    var values: BuyModels.Amounts.ViewAction { get set }
    var toAmount: Amount? { get set }
    var currencies: [Currency] { get set }
    var supportedCurrencies: [SupportedCurrency]? { get set }
    var paymentCard: PaymentCard? { get set }
    var allPaymentCards: [PaymentCard]? { get set }
    var quote: Quote? { get set }
    
    var coreSystem: CoreSystem? { get set }
    var keyStore: KeyStore? { get set }
    
    var autoSelectDefaultPaymentMethod: Bool { get set }
    var paymentMethod: PaymentCard.PaymentType? { get set }
    var publicToken: String? { get set }
    var mask: String? { get set }
}

protocol BuyDataPassing {
    var dataStore: BuyDataStore? { get }
}

protocol BuyRoutes: CoordinatableRoutes {
    func showOrderPreview(coreSystem: CoreSystem?,
                          keyStore: KeyStore?,
                          to: Amount?,
                          from: Decimal?,
                          card: PaymentCard?,
                          quote: Quote?)
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?)
}
