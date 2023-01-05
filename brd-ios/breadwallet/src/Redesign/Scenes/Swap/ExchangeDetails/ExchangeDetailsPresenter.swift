//
//  ExchangeDetailsPresenter.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

final class ExchangeDetailsPresenter: NSObject, Presenter, ExchangeDetailsActionResponses {
    typealias Models = ExchangeDetailsModels

    weak var viewController: ExchangeDetailsViewController?

    // MARK: - ExchangeDetailsActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let detail = item.detail
        let type = item.type
        
        var sections = [AnyHashable]()
        
        switch type {
        case .swapTransaction:
            sections = [
                Models.Section.header,
                Models.Section.order,
                Models.Section.fromCurrency,
                Models.Section.image,
                Models.Section.toCurrency,
                Models.Section.timestamp,
                Models.Section.transactionFrom,
                Models.Section.transactionTo
            ]
            
        case .buyTransaction, .buyAchTransaction, .sellTransaction:
            sections = [
                Models.Section.header,
                Models.Section.toCurrency,
                Models.Section.buyOrder,
                Models.Section.order,
                Models.Section.timestamp,
                Models.Section.transactionTo
            ]
            
        default:
            break
        }
        
        guard let header = detail.status.viewModel else { return }
        
        let fromImage = getBaseCurrencyImage(currencyCode: detail.source.currency)
        let toImage = getBaseCurrencyImage(currencyCode: detail.destination.currency)
        
        let currencyCode = C.usdCurrencyCode
        
        let formattedUsdAmountString = ExchangeFormatter.fiat.string(for: detail.source.usdAmount) ?? ""
        let formattedCurrencyAmountString = ExchangeFormatter.crypto.string(for: detail.source.currencyAmount) ?? ""
        let formattedCurrencyAmountDestination = ExchangeFormatter.crypto.string(for: detail.destination.currencyAmount) ?? ""
        
        let timestamp = TimeInterval(detail.timestamp) / 1000
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY, H:mm a"
        let dateString = formatter.string(from: date)
        
        let orderValue = "\(detail.orderId)"
        let transactionFromValue = String(describing: detail.source.transactionId ?? "")
        let transactionToValue = String(describing: detail.destination.transactionId ?? detail.status.rawValue.localizedCapitalized)
        let transactionToValueIsCopyable = detail.destination.transactionId != nil
        
        var toCurrencyAssetViewModel = AssetViewModel()
        
        switch type {
        case .swapTransaction:
            toCurrencyAssetViewModel = AssetViewModel(icon: toImage,
                                                      title: "\(L10n.TransactionDetails.addressToHeader) \(detail.destination.currency)",
                                                      topRightText: "\(formattedCurrencyAmountDestination) \(detail.destination.currency)")
            
        case .buyTransaction, .buyAchTransaction, .sellTransaction:
            toCurrencyAssetViewModel = AssetViewModel(icon: toImage,
                                                      title: "\(formattedCurrencyAmountDestination) \(detail.destination.currency)",
                                                      topRightText: nil)
        
        default:
            break
        }
        
        let sectionRows = [
            Models.Section.header: [header],
            Models.Section.order: [
                OrderViewModel(title: L10n.Swap.transactionID,
                               value: ExchangeDetailsPresenter.generateAttributedOrderValue(with: orderValue, isCopyable: true),
                               isCopyable: true)
            ],
            Models.Section.buyOrder: [
                prepareOrderViewModel(detail, for: type)
            ],
            Models.Section.fromCurrency: [
                AssetViewModel(icon: fromImage,
                               title: "\(L10n.TransactionDetails.addressFromHeader) \(detail.source.currency)",
                               topRightText: "\(formattedCurrencyAmountString) / $\(formattedUsdAmountString) \(currencyCode)")
            ],
            Models.Section.image: [
                ImageViewModel.image(Asset.arrowDown.image.tinted(with: LightColors.Text.three))
            ],
            Models.Section.toCurrency: [
                toCurrencyAssetViewModel
            ],
            Models.Section.timestamp: [
                OrderViewModel(title: L10n.Swap.timestamp,
                               value: ExchangeDetailsPresenter.generateAttributedOrderValue(with: dateString, isCopyable: false),
                               isCopyable: false)
            ],
            Models.Section.transactionFrom: [
                OrderViewModel(title: "\(detail.source.currency) \(L10n.TransactionDetails.txHashHeader)",
                               value: ExchangeDetailsPresenter.generateAttributedOrderValue(with: transactionFromValue, isCopyable: true),
                               isCopyable: true)
            ],
            Models.Section.transactionTo: [
                OrderViewModel(title: "\(detail.destination.currency) \(L10n.TransactionDetails.txHashHeader)",
                               value: ExchangeDetailsPresenter.generateAttributedOrderValue(with: transactionToValue,
                                                                                            isCopyable: transactionToValueIsCopyable),
                               isCopyable: transactionToValueIsCopyable)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCopyValue(actionResponse: ExchangeDetailsModels.CopyValue.ActionResponse) {
        viewController?.displayMessage(responseDisplay: .init(model: .init(description: .text(L10n.Receive.copied)),
                                                              config: Presets.InfoView.verification))
    }
    
    func presentInfoPopup(actionResponse: ExchangeDetailsModels.InfoPopup.ActionResponse) {
        let model: PopupViewModel = .init(title: .text(L10n.Buy.networkFees),
                                          body: L10n.Buy.networkFeeMessage)
        
        viewController?.displayInfoPopup(responseDisplay: .init(model: model))
    }

    // MARK: - Additional Helpers
    
    private static func generateAttributedOrderValue(with value: String, isCopyable: Bool) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = Asset.copy.image.withRenderingMode(.alwaysOriginal)
        imageAttachment.bounds = CGRect(x: 0,
                                        y: -Margins.extraSmall.rawValue,
                                        width: ViewSizes.extraSmall.rawValue,
                                        height: ViewSizes.extraSmall.rawValue)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(NSAttributedString(string: value))
        
        if isCopyable {
            completeText.append(NSAttributedString(string: "  "))
            completeText.append(attachmentString)
        }
        
        return completeText
    }
    
    private func getBaseCurrencyImage(currencyCode: String) -> UIImage? {
        guard let currency = Store.state.currencies.first(where: { $0.code == currencyCode }) else { return nil }
        
        return currency.imageSquareBackground
    }
    
    private func prepareOrderViewModel(_ detail: SwapDetail, for type: TransactionType) -> BuyOrderViewModel {
        let currencyCode = C.usdCurrencyCode
        let card = detail.destination.paymentInstrument
        let infoImage = Asset.help.image.withRenderingMode(.alwaysOriginal)
        
        let currencyFormat = "%@ %@"
        let rate = String(format: "1 %@ = %@ %@", detail.destination.currency, RWFormatter().string(for: 1 / detail.rate) ?? "",
                          currencyCode)
        let totalText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.source.currencyAmount) ?? "",
                               currencyCode)
        let amountValue = detail.source.currencyAmount - detail.source.usdFee - detail.destination.usdFee
        let amountText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: amountValue) ?? "",
                                currencyCode)
        let cardFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.source.usdFee) ?? "",
                                 currencyCode)
        let networkFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.destination.usdFee) ?? "",
                                    currencyCode)
        let displayFeeTitle = detail.source.paymentInstrument.type == .card ? L10n.Swap.cardFee :
        L10n.Buy.achFee("$\(String(format: "%.2f", detail.destination.feeFixedRate?.doubleValue ?? 0.0)) + \(detail.destination.feeRate ?? 0)%")
        
        let method = PaymentMethodViewModel(methodTitle: .text(L10n.Buy.paymentMethod),
                                            logo: card.displayImage,
                                            type: card.type,
                                            previewFor: .sell,
                                            cardNumber: .text(card.displayName),
                                            expiration: .text(CardDetailsFormatter.formatExpirationDate(month: card.expiryMonth, year: card.expiryYear)))
        
        let model: BuyOrderViewModel
        switch type {
        case .sellTransaction:
            model = BuyOrderViewModel(rateValue: .init(title: .text(L10n.Sell.rate), value: .text(rate), infoImage: nil),
                                      amount: .init(title: .text("\(L10n.Sell.subtotal)"), value: .text(amountText), infoImage: nil),
                                      cardFee: .init(title: .text(displayFeeTitle),
                                                     value: .text(cardFeeText),
                                                     infoImage: nil),
                                      networkFee: .init(title: .text(""), value: .text("")),
                                      totalCost: .init(title: .text(L10n.Sell.youWillReceive), value: .text(totalText)),
                                      paymentMethod: method)
            
        default:
            model = BuyOrderViewModel(rateValue: .init(title: .text(L10n.Swap.rateValue), value: .text(rate), infoImage: nil),
                                      amount: .init(title: .text("\(L10n.Swap.amountPurchased)"), value: .text(amountText), infoImage: nil),
                                      cardFee: .init(title: .text(displayFeeTitle),
                                                     value: .text(cardFeeText),
                                                     infoImage: nil),
                                      networkFee: .init(title: .text(L10n.Swap.miningNetworkFee), value: .text(networkFeeText), infoImage: .image(infoImage)),
                                      totalCost: .init(title: .text(L10n.Swap.total), value: .text(totalText)),
                                      paymentMethod: .init(methodTitle: .text(L10n.Swap.paidWith),
                                                           logo: detail.source.paymentInstrument.displayImage,
                                                           type: detail.source.paymentInstrument.type,
                                                           cardNumber: .text(detail.source.paymentInstrument.displayName),
                                                           expiration: .text(CardDetailsFormatter.formatExpirationDate(month: detail.source.paymentInstrument.expiryMonth,
                                                                                                                       year: detail.source.paymentInstrument.expiryYear)),
                                                           cvvTitle: nil, cvv: nil))
        }
        return model
    }
}
