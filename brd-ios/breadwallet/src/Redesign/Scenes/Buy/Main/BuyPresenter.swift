//
//  BuyPresenter.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

final class BuyPresenter: NSObject, Presenter, BuyActionResponses {
    typealias Models = BuyModels
    
    weak var viewController: BuyViewController?
    
    private var exchangeRateViewModel: ExchangeRateViewModel = .init()
    
    // MARK: - BuyActionResponses
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        var sections: [Models.Sections] = [
            .rateAndTimer,
            .from,
            .paymentMethod,
            .accountLimits
        ]
        
        if UserManager.shared.profile?.canUseAch == true {
            sections.insert(.segment, at: 0)
        }
        
        exchangeRateViewModel = ExchangeRateViewModel(timer: TimerViewModel(), showTimer: false)
        let paymentSegment = SegmentControlViewModel(selectedIndex: .buyCard)
        
        let paymentMethodViewModel: CardSelectionViewModel
        switch paymentSegment.selectedIndex {
        case .buyAch:
            paymentMethodViewModel = CardSelectionViewModel(title: .text(L10n.Buy.achPayments),
                                                            subtitle: .text(L10n.Buy.linkBankAccount),
                                                            userInteractionEnabled: true)
        default:
            paymentMethodViewModel = CardSelectionViewModel()
        }
        
        let sectionRows: [Models.Sections: [ViewModel]] =  [
            .segment: [paymentSegment],
            .rateAndTimer: [exchangeRateViewModel],
            .from: [SwapCurrencyViewModel(title: .text(L10n.Swap.iWant),
                                          shouldShowFiatField: true)],
            .paymentMethod: [paymentMethodViewModel],
            .accountLimits: [
                LabelViewModel.text("")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let quote = actionResponse.quote else {
            return
        }
        
        let text = String(format: "1 %@ = %@ %@", to.uppercased(), RWFormatter().string(for: 1 / quote.exchangeRate) ?? "", from)
        let minText = ExchangeFormatter.fiat.string(for: quote.minimumValue) ?? ""
        let maxText = ExchangeFormatter.fiat.string(for: quote.maximumValue) ?? ""
        let lifetimeLimit = ExchangeFormatter.fiat.string(for: UserManager.shared.profile?.achLifetimeRemainingLimit) ?? ""
        let limitText = actionResponse.method == .buyAch ? L10n.Buy.achLimits(minText, maxText, lifetimeLimit) : L10n.Buy.buyLimits(minText, maxText)
        
        exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: text,
                                                      timer: TimerViewModel(till: quote.timestamp,
                                                                            repeats: false),
                                                      showTimer: false)
        
        viewController?.displayExchangeRate(responseDisplay: .init(rate: exchangeRateViewModel,
                                                                   limits: .text(limitText)))
    }
    
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse) {
        var cryptoModel: SwapCurrencyViewModel
        let cardModel: CardSelectionViewModel
        
        let fromFiatValue = actionResponse.amount?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: actionResponse.amount?.fiatValue)
        let fromTokenValue = actionResponse.amount?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(for: actionResponse.amount?.tokenValue)
        
        let formattedFiatString = ExchangeFormatter.createAmountString(string: fromFiatValue ?? "")
        let formattedTokenString = ExchangeFormatter.createAmountString(string: fromTokenValue ?? "")
        
        cryptoModel = .init(amount: actionResponse.amount,
                            formattedFiatString: formattedFiatString,
                            formattedTokenString: formattedTokenString,
                            title: .text(L10n.Swap.iWant),
                            shouldShowFiatField: true)
        
        if let paymentCard = actionResponse.card, actionResponse.paymentMethod == .buyCard {
            cardModel = .init(logo: paymentCard.displayImage,
                              cardNumber: .text(paymentCard.displayName),
                              expiration: .text(CardDetailsFormatter.formatExpirationDate(month: paymentCard.expiryMonth, year: paymentCard.expiryYear)),
                              userInteractionEnabled: true)
        } else if let paymentCard = actionResponse.card, actionResponse.paymentMethod == .buyAch {
            cardModel = .init(title: .text(L10n.Buy.transferFromBank),
                              subtitle: nil,
                              logo: .image(Asset.bank.image),
                              cardNumber: .text(paymentCard.displayName),
                              userInteractionEnabled: false)
            cryptoModel.selectionDisabled = true
        } else if actionResponse.paymentMethod == .buyCard {
            cardModel = .init(userInteractionEnabled: true)
        } else {
            cardModel = CardSelectionViewModel(title: .text(L10n.Buy.achPayments),
                                               subtitle: .text(L10n.Buy.linkBankAccount),
                                               userInteractionEnabled: true)
            cryptoModel.selectionDisabled = true
        }
        viewController?.displayAssets(responseDisplay: .init(cryptoModel: cryptoModel, cardModel: cardModel))
        
        guard actionResponse.handleErrors else { return }
        handleError(actionResponse: actionResponse)
    }
    
    private func handleError(actionResponse: BuyModels.Assets.ActionResponse) {
        let fiat = (actionResponse.amount?.fiatValue ?? 0).round(to: 2)
        let minimumAmount = actionResponse.quote?.minimumUsd ?? 0
        let maximumAmount = actionResponse.quote?.maximumUsd ?? 0
        
        let profile = UserManager.shared.profile
        let lifetimeLimit = profile?.buyLifetimeRemainingLimit ?? 0
        
        switch fiat {
        case _ where fiat <= 0:
            // Fiat value is below 0
            presentError(actionResponse: .init(error: nil))
            
        case _ where fiat < minimumAmount:
            // Value below minimum Fiat
            presentError(actionResponse: .init(error: ExchangeErrors.tooLow(amount: minimumAmount, currency: C.usdCurrencyCode, reason: .buyCard)))
            
        case _ where fiat > lifetimeLimit,
            _ where minimumAmount > lifetimeLimit:
            // Over lifetime limit
            let limit = profile?.buyAllowanceLifetime ?? 0
            presentError(actionResponse: .init(error: ExchangeErrors.overLifetimeLimit(limit: limit)))
            
        case _ where fiat > maximumAmount,
            _ where minimumAmount > maximumAmount:
            // Over exchange limit
            presentError(actionResponse: .init(error: ExchangeErrors.tooHigh(amount: maximumAmount, currency: C.usdCurrencyCode, reason: .buyCard)))
            
        default:
            // Remove error
            presentError(actionResponse: .init(error: nil))
        }
    }
    
    private func presentAchData(actionResponse: BuyModels.Assets.ActionResponse) {
        
    }
    
    private func presentCardData(actionResponse: BuyModels.Assets.ActionResponse) {
        
    }
    
    func presentPaymentCards(actionResponse: BuyModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards))
    }
    
    func presentOrderPreview(actionResponse: BuyModels.OrderPreview.ActionResponse) {
        viewController?.displayOrderPreview(responseDisplay: .init())
    }
    
    func presentNavigateAssetSelector(actionResponse: BuyModels.AssetSelector.ActionResponse) {
        viewController?.displayNavigateAssetSelector(responseDisplay: .init(title: L10n.Swap.iWant))
    }
    
    func presentLinkToken(actionResponse: BuyModels.PlaidLinkToken.ActionResponse) {
        viewController?.displayLinkToken(responseDisplay: .init(linkToken: actionResponse.linkToken))
    }
    
    func presentPublicTokenSuccess(actionResponse: BuyModels.PlaidPublicToken.ActionResponse) {
        viewController?.displayAchData(actionResponse: .init())
        
        viewController?.displayMessage(responseDisplay: .init(model: .init(description: .text(L10n.Buy.achSuccess)),
                                                              config: Presets.InfoView.verification))
        
    }
    
    func presentFailure(actionResponse: BuyModels.Failure.ActionResponse) {
        viewController?.displayFailure(responseDisplay: .init())
    }
    
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        guard !isAccessDenied(error: actionResponse.error) else { return }
        
        guard let error = actionResponse.error as? FEError else {
            viewController?.displayMessage(responseDisplay: .init())
            return
        }
        
        let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .auto)
        let config = Presets.InfoView.error
        
        viewController?.displayMessage(responseDisplay: .init(error: error, model: model, config: config))
    }
    
    func presentUSDCMessage(actionResponse: BuyModels.AchData.ActionResponse) {
        let infoMessage = NSMutableAttributedString(string: L10n.Buy.disabledUSDCMessage)
        let linkRange = infoMessage.mutableString.range(of: L10n.WalletConnectionSettings.link)
        
        if linkRange.location != NSNotFound {
            infoMessage.addAttribute(.underlineStyle, value: 1, range: linkRange)
        }
        
        let model = InfoViewModel(description: .attributedText(infoMessage),
                                  dismissType: .tapToDismiss)
        let config = Presets.InfoView.verification
        
        viewController?.displayManageAssetsMessage(actionResponse: .init(model: model, config: config))
    }
    
    // MARK: - Additional Helpers
    
}
