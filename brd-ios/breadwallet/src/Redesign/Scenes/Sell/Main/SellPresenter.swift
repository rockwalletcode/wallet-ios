//
//  SellPresenter.swift
//  breadwallet
//
//  Created by Rok on 06/12/2022.
//
//

import UIKit

final class SellPresenter: NSObject, Presenter, SellActionResponses {
    
    typealias Models = SellModels

    var paymentModel: CardSelectionViewModel?
    weak var viewController: SellViewController?

    // MARK: - SellActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }

        let sections = [
            Models.Sections.rateAndTimer,
            Models.Sections.swapCard,
            Models.Sections.payoutMethod,
            Models.Sections.accountLimits
        ]

        let sectionRows = [
            Models.Sections.rateAndTimer: [
                ExchangeRateViewModel(timer: TimerViewModel(), showTimer: false)
            ],
            Models.Sections.swapCard: [
                MainSwapViewModel(from: .init(amount: .zero(item),
                                              formattedTokenString: .init(string: ""),
                                              title: .text("I have 10.12000473 USDC"),
                                              selectionDisabled: true),

                                  to: .init(currencyCode: C.usdCurrencyCode,
                                            currencyImage: Asset.us.image,
                                            formattedTokenString: .init(string: ""),
                                            title: .text("I receive"),
                                            selectionDisabled: true),
                                 hideSwapButton: true)
            ],
            Models.Sections.payoutMethod: [
                paymentModel ?? CardSelectionViewModel(userInteractionEnabled: true)
            ],
            Models.Sections.accountLimits: [
                LabelViewModel.text("")
            ]
        ]
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentAmount(actionResponse: Models.Amounts.ActionResponse) {
        guard let from = actionResponse.from else { return }
        let toFiatValue = from.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: from.fiatValue)
        let fromTokenValue = from.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(for: from.tokenValue)

        let fromFormattedTokenString = ExchangeFormatter.createAmountString(string: fromTokenValue ?? "")
        let toFormattedFiatString = ExchangeFormatter.createAmountString(string: toFiatValue ?? "")
        
        let vm = MainSwapViewModel(from: .init(amount: from,
                                          formattedTokenString: fromFormattedTokenString,
                                          title: .text("I have 10.12000473 USDC")),
                              
                              to: .init(currencyCode: C.usdCurrencyCode,
                                        currencyImage: Asset.us.image,
                                        formattedTokenString: toFormattedFiatString,
                                        title: .text("I receive")),
                              
                             hideSwapButton: true)
        viewController?.displayAmount(responseDisplay: .init(continueEnabled: true,
                                                             amounts: vm))
    }
    // MARK: - Additional Helpers

}
