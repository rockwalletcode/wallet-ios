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

    // MARK: - BuyActionResponses
    
    private var exchangeRateViewModel = ExchangeRateViewModel()
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .from,
            .to,
            .accountLimits
        ]
        
        exchangeRateViewModel = ExchangeRateViewModel(timer: TimerViewModel(), showTimer: false)

        let sectionRows: [Models.Sections: [ViewModel]] =  [
            .rateAndTimer: [exchangeRateViewModel],
            .accountLimits: [
                LabelViewModel.text("")
            ],
            .from: [SwapCurrencyViewModel(title: .text(L10n.Swap.iWant))],
            .to: [CardSelectionViewModel(userInteractionEnabled: true)]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let quote = actionResponse.quote else {
            return
        }
        
        let text = String(format: "1 %@ = %@ %@", to.uppercased(), ExchangeFormatter.fiat.string(for: 1 / quote.exchangeRate) ?? "", from)
        let minText = ExchangeFormatter.fiat.string(for: quote.minimumValue) ?? ""
        let maxText = ExchangeFormatter.fiat.string(for: quote.maximumValue) ?? ""
        let limitText = String(format: L10n.Buy.buyLimits(minText, maxText))
        
        exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: text,
                                                      timer: TimerViewModel(till: quote.timestamp,
                                                                            repeats: false),
                                                      showTimer: false)
        
        viewController?.displayExchangeRate(responseDisplay: .init(rate: exchangeRateViewModel,
                                                                   limits: .text(limitText)))
    }
    
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse) {
        let cryptoModel: SwapCurrencyViewModel
        let cardModel: CardSelectionViewModel
        
        let fromFiatValue = actionResponse.amount?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: actionResponse.amount?.fiatValue)
        let fromTokenValue = actionResponse.amount?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(for: actionResponse.amount?.tokenValue)
        
        let formattedFiatString = ExchangeFormatter.createAmountString(string: fromFiatValue ?? "")
        let formattedTokenString = ExchangeFormatter.createAmountString(string: fromTokenValue ?? "")
        
        cryptoModel = .init(amount: actionResponse.amount,
                            formattedFiatString: formattedFiatString,
                            formattedTokenString: formattedTokenString,
                            title: .text(L10n.Swap.iWant))
        
        if let paymentCard = actionResponse.card {
            cardModel = .init(logo: paymentCard.displayImage,
                              cardNumber: .text(paymentCard.displayName),
                              expiration: .text(CardDetailsFormatter.formatExpirationDate(month: paymentCard.expiryMonth, year: paymentCard.expiryYear)),
                              userInteractionEnabled: true)
        } else {
            cardModel = .init(userInteractionEnabled: true)
        }
        viewController?.displayAssets(responseDisplay: .init(cryptoModel: cryptoModel, cardModel: cardModel))
        
        guard actionResponse.handleErrors else { return }
        let fiat = actionResponse.amount?.fiatValue ?? 0
        let minimumAmount = actionResponse.quote?.minimumUsd ?? 0
        let maximumAmount = actionResponse.quote?.maximumUsd ?? 0
        
        switch fiat {
        case _ where fiat <= 0:
            // Fiat value is below 0
            presentError(actionResponse: .init(error: nil))
            
        case _ where fiat < minimumAmount,
                            _ where minimumAmount > maximumAmount:
            // Value below minimum Fiat
            presentError(actionResponse: .init(error: BuyErrors.tooLow(amount: minimumAmount, currency: C.usdCurrencyCode)))
            
        case _ where fiat > maximumAmount:
            // Over exchange limit ???
            presentError(actionResponse: .init(error: BuyErrors.tooHigh(amount: maximumAmount, currency: C.usdCurrencyCode)))
            
        default:
            // Remove error
            presentError(actionResponse: .init(error: nil))
        }
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
    
    // MARK: - Additional Helpers

}
