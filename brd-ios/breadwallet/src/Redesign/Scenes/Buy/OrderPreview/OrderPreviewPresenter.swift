//
//  OrderPreviewPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

final class OrderPreviewPresenter: NSObject, Presenter, OrderPreviewActionResponses {
    
    typealias Models = OrderPreviewModels
    
    weak var viewController: OrderPreviewViewController?
    
    // MARK: - OrderPreviewActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let card = item.card,
              let isAchAccount = item.isAchAccount else { return }
        
        let wrappedViewModel = prepareOrderPreviewViewModel(for: item)
        
        let achNotificationModel = InfoViewModel(description: .text(item.type?.disclaimer), dismissType: .persistent)
        let achTermsModel = InfoViewModel(description: .text(L10n.Buy.terms),
                                          button: .init(title: L10n.About.terms, isUnderlined: true),
                                          tickbox: .init(title: .text(L10n.Buy.understandAndAgree)),
                                          dismissType: .persistent)
        
        let termsText = NSMutableAttributedString(string: L10n.Buy.terms + " ")
        termsText.addAttribute(NSAttributedString.Key.font,
                               value: Fonts.Body.three,
                               range: NSRange(location: 0, length: termsText.length))
        termsText.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: LightColors.Text.two,
                               range: NSRange(location: 0, length: termsText.length))
        
        let interactableText = NSMutableAttributedString(string: L10n.About.terms)
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: Fonts.Body.three,
                                      range: NSRange(location: 0, length: interactableText.length))
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: LightColors.primary,
            NSAttributedString.Key.underlineColor: LightColors.primary,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        interactableText.addAttributes(linkAttributes, range: NSRange(location: 0, length: interactableText.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        termsText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: termsText.length))
        
        termsText.append(interactableText)
        
        var sections: [Models.Sections] = [
            .orderInfoCard,
            .payment,
            .termsAndConditions,
            .submit
        ]
        
        if isAchAccount {
            sections.insert(.achNotification, at: 0)
        }
        
        let sectionRows: [Models.Sections: [Any]] = [
            .achNotification: [
                achNotificationModel
            ],
            .orderInfoCard: [
                wrappedViewModel
            ],
            .payment: [
                PaymentMethodViewModel(methodTitle: .text(L10n.Buy.paymentMethod),
                                       logo: card.displayImage,
                                       type: card.type,
                                       previewFor: item.type,
                                       cardNumber: .text(card.displayName),
                                       expiration: .text(CardDetailsFormatter.formatExpirationDate(month: card.expiryMonth, year: card.expiryYear)))
            ],
            .termsAndConditions: [
                isAchAccount ? achTermsModel : LabelViewModel.attributedText(termsText)
            ],
            .submit: [
                ButtonViewModel(title: L10n.Button.confirm, enabled: false)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse) {
        let model: PopupViewModel
        
        if actionResponse.isCardFee {
            let feeText = L10n.Buy.cardFee
            model = .init(title: .text(L10n.Swap.cardFee), body: feeText)
        } else {
            model = .init(title: .text(L10n.Buy.networkFees),
                          body: L10n.Buy.networkFeeMessage)
        }
        
        viewController?.displayInfoPopup(responseDisplay: .init(model: model))
    }
    
    func presentThreeDSecure(actionResponse: OrderPreviewModels.ThreeDSecure.ActionResponse) {
        viewController?.displayThreeDSecure(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse) {
        viewController?.displayContinueEnabled(responseDisplay: .init(continueEnabled: actionResponse.isValid))
    }
    
    func presentCvvInfoPopup(actionResponse: OrderPreviewModels.CvvInfoPopup.ActionResponse) {
        let model = PopupViewModel(title: .text(L10n.Buy.securityCode),
                                   imageName: Asset.cards.name,
                                   body: L10n.Buy.securityCodePopup)
        
        viewController?.displayCvvInfoPopup(responseDisplay: .init(model: model))
    }
    
    func presentTimeOut(actionResponse: OrderPreviewModels.ExpirationValidations.ActionResponse) {
        viewController?.displayTimeOut(responseDisplay: .init(isTimedOut: actionResponse.isTimedOut))
    }
    
    func presentTermsAndConditions(actionResponse: OrderPreviewModels.TermsAndConditions.ActionResponse) {
        viewController?.displayTermsAndConditions(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse) {
        guard let reference = actionResponse.paymentReference, actionResponse.failed == false else {
            let reason: FailureReason = actionResponse.isAch == true ? (actionResponse.previewType == .sell ? .sell : .buyAch) : .buyCard
            viewController?.displayFailure(responseDisplay: .init(reason: reason))
            return
        }
        let reason: SuccessReason = actionResponse.isAch == true ? (actionResponse.previewType == .sell ? .sell : .buyAch) : .buyCard
        
        viewController?.displaySubmit(responseDisplay: .init(paymentReference: reference, reason: reason))
    }
    
    func presentToggleTickbox(actionResponse: OrderPreviewModels.Tickbox.ActionResponse) {
        viewController?.displayContinueEnabled(responseDisplay: .init(continueEnabled: actionResponse.value))
    }
    
    // MARK: - Additional Helpers
    
    private func prepareOrderPreviewViewModel(for item: Models.Item) -> BuyOrderViewModel {
        let model: BuyOrderViewModel
        
        guard let toAmount = item.to,
              let quote = item.quote,
              let isAchAccount = item.isAchAccount else {
            return .init(amount: .init(title: .text(""), value: .text("")), cardFee: .init(title: .text(""), value: .text("")),
                         networkFee: .init(title: .text(""), value: .text("")), totalCost: .init(title: .text(""), value: .text("")))
        }
        
        let to = toAmount.fiatValue
        let infoImage = Asset.help.image.withRenderingMode(.alwaysOriginal)
        let toFiatValue = toAmount.fiatValue
        let toCryptoValue = ExchangeFormatter.crypto.string(for: toAmount.tokenValue) ?? ""
        let toCryptoDisplayImage = item.to?.currency.imageSquareBackground
        let toCryptoDisplayName = item.to?.currency.displayName ?? ""
        let from = item.from ?? 0
        let cardFee = from * (quote.buyFee ?? 0) / 100 + (quote.buyFeeUsd ?? 0)
        let networkFee = item.networkFee?.fiatValue ?? 0
        let fiatCurrency = (quote.fromFee?.currency ?? C.usdCurrencyCode).uppercased()
        
        let currencyFormat = "%@ %@"
        let amountText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: to) ?? "", fiatCurrency)
        let cardFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: cardFee) ?? "", fiatCurrency)
        let networkFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: networkFee) ?? "", fiatCurrency)
        
        let rate = String(format: "1 %@ = %@ %@", toAmount.currency.code, ExchangeFormatter.fiat.string(for: 1 / quote.exchangeRate) ?? "", fiatCurrency)
        let totalText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: toFiatValue + networkFee + cardFee) ?? "", fiatCurrency)
        
        let cardAchFee: TitleValueViewModel = isAchAccount ?
            .init(title: .text(L10n.Buy.achFee("$\(String(format: "%.2f", quote.buyFeeUsd?.doubleValue ?? 0.0)) + \(quote.buyFee ?? 0)%")),
                  value: .text(cardFeeText)) :
            .init(title: .text("\(L10n.Swap.cardFee) (\(quote.buyFee ?? 0)%)"),
                  value: .text(cardFeeText),
                  infoImage: .image(infoImage))
        
        switch item.type {
        case .sell:
            let totalText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: toFiatValue - networkFee - cardFee) ?? "", fiatCurrency)
            model = .init(title: .text(L10n.Sell.yourOrder),
                          currencyIcon: .image(toCryptoDisplayImage),
                          currencyAmountName: .text(toCryptoValue + " " + toCryptoDisplayName),
                          amount: .init(title: .text(L10n.Sell.rate), value: .text(rate), infoImage: nil),
                          cardFee: .init(title: .text(L10n.Sell.subtotal), value: .text(amountText)),
                          networkFee: cardAchFee,
                          totalCost: .init(title: .text(L10n.Swap.youReceive), value: .text(totalText)))
            
        default:
            model = .init(currencyIcon: .image(toCryptoDisplayImage),
                          currencyAmountName: .text(toCryptoValue + " " + toCryptoDisplayName),
                          rate: .init(exchangeRate: rate, timer: nil),
                          amount: .init(title: .text(L10n.Swap.amountPurchased), value: .text(amountText), infoImage: nil),
                          cardFee: cardAchFee,
                          networkFee: .init(title: .text(L10n.Swap.miningNetworkFee),
                                            value: .text(networkFeeText),
                                            infoImage: .image(infoImage)),
                          totalCost: .init(title: .text(L10n.Swap.total), value: .text(totalText)))
        }
        
        return model
    }
}
