//
//  OrderPreviewVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let OrderPreview = OrderPreviewViewController.self
}

protocol OrderPreviewViewActions: BaseViewActions, FetchViewActions {
    func showTermsAndConditions(viewAction: OrderPreviewModels.TermsAndConditions.ViewAction)
    func checkTimeOut(viewAction: OrderPreviewModels.ExpirationValidations.ViewAction)
    func showInfoPopup(viewAction: OrderPreviewModels.InfoPopup.ViewAction)
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction)
    func showCvvInfoPopup(viewAction: OrderPreviewModels.CvvInfoPopup.ViewAction)
    func submit(viewAction: OrderPreviewModels.Submit.ViewAction)
    func toggleTickbox(viewAction: OrderPreviewModels.Tickbox.ViewAction)
}

protocol OrderPreviewActionResponses: BaseActionResponses, FetchActionResponses {
    func presentTermsAndConditions(actionResponse: OrderPreviewModels.TermsAndConditions.ActionResponse)
    func presentTimeOut(actionResponse: OrderPreviewModels.ExpirationValidations.ActionResponse)
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse)
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse)
    func presentCvvInfoPopup(actionResponse: OrderPreviewModels.CvvInfoPopup.ActionResponse)
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse)
    func presentToggleTickbox(actionResponse: OrderPreviewModels.Tickbox.ActionResponse)
}

protocol OrderPreviewResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayTermsAndConditions(responseDisplay: OrderPreviewModels.TermsAndConditions.ResponseDisplay)
    func displayTimeOut(responseDisplay: OrderPreviewModels.ExpirationValidations.ResponseDisplay)
    func displayInfoPopup(responseDisplay: OrderPreviewModels.InfoPopup.ResponseDisplay)
    func displayContinueEnabled(responseDisplay: OrderPreviewModels.CvvValidation.ResponseDisplay)
    func displayCvvInfoPopup(responseDisplay: OrderPreviewModels.CvvInfoPopup.ResponseDisplay)
    func displaySubmit(responseDisplay: OrderPreviewModels.Submit.ResponseDisplay)
    func displayFailure(responseDisplay: OrderPreviewModels.Failure.ResponseDisplay)
}

protocol OrderPreviewDataStore: BaseDataStore, FetchDataStore {
    var type: PreviewType? { get set }
    var to: Amount? { get set }
    var from: Decimal? { get set }
    var toCurrency: String? { get set }
    var card: PaymentCard? { get set }
    var quote: Quote? { get set }
    var networkFee: Amount? { get }
    var cvv: String? { get set }
    var paymentReference: String? { get set }
    var paymentstatus: AddCard.Status? { get set }
    var isAchAccount: Bool { get }
}

protocol OrderPreviewDataPassing {
    var dataStore: OrderPreviewDataStore? { get }
}

protocol OrderPreviewRoutes: CoordinatableRoutes {
    func showOrderPreview(type: PreviewType?,
                          coreSystem: CoreSystem?,
                          keyStore: KeyStore?,
                          to: Amount?,
                          from: Decimal?,
                          card: PaymentCard?,
                          quote: Quote?,
                          availablePayments: [PaymentCard.PaymentType]?)
    func showPinInput(keyStore: KeyStore?, callback: ((_ success: Bool) -> Void)?)
    func showTermsAndConditions(url: URL)
    func showTimeout()
    func showThreeDSecure(url: URL)
    func showSuccess(paymentReference: String, transactionType: TransactionType, reason: SuccessReason)
    func showFailure(failure: FailureReason, availablePayments: [PaymentCard.PaymentType]?)
}
