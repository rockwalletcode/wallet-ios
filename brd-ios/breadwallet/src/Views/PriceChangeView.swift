//
//  PriceChangeView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-04-01.
//  Copyright © 2019 breadwallet LLC. All rights reserved.
//

import UIKit

enum PriceChangeViewStyle {
    case percentOnly
    case percentAndAbsolute
}

class PriceChangeView: UIView, Subscriber {
    var currency: Currency? {
        didSet {
            //These cells get recycled, so we need to cancel any previous subscriptions
            Store.unsubscribe(self)
            subscribeToPriceChange()
        }
    }
    
    private let priceText = UILabel(font: Fonts.Subtitle.two, color: LightColors.Success.one)
    
    private var priceInfo: FiatPriceInfo? {
        didSet {
            handlePriceChange()
        }
    }
    
    private var prefixValue: String? {
        guard let change24Hrs = priceInfo?.change24Hrs else { return nil }
        
        if change24Hrs > 0 {
            return "+"
        } else if change24Hrs < 0 {
            return "-"
        }
        
        return nil
    }
    
    private var valueColor: UIColor? {
        guard let change24Hrs = priceInfo?.change24Hrs else { return nil }
        
        if change24Hrs > 0 {
            return LightColors.Success.one
        } else if change24Hrs < 0 {
            return LightColors.Error.one
        }
        
        return LightColors.Text.one
    }
    
    private var currencyNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = Rate.symbolMap[Store.state.defaultCurrencyCode]
        return formatter
    }
    
    private let style: PriceChangeViewStyle
    
    init(style: PriceChangeViewStyle) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        priceText.constrain([
            priceText.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceText.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceText.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
    private func addSubviews() {
        addSubview(priceText)
    }
    
    private func handlePriceChange() {
        guard let priceChange = priceInfo else { return }
        
        let percentText = String(format: "%.2f%%", fabs(priceChange.changePercentage24Hrs))
        var text = (prefixValue ?? "") + percentText
        var color = valueColor
        
        if style == .percentAndAbsolute,
            let absoluteString = currencyNumberFormatter.string(from: NSNumber(value: abs(priceChange.change24Hrs))) {
            text += " (\(absoluteString))"
            color = LightColors.Text.one
        }
        
        priceText.text = text
        priceText.textColor = color
        priceText.textAlignment = .center
        
        layoutIfNeeded()
    }
    
    private func subscribeToPriceChange() {
        guard let currency = currency else { return }
        Store.subscribe(self, selector: { $0[currency]?.fiatPriceInfo != $1[currency]?.fiatPriceInfo }, callback: {
            self.priceInfo = $0[currency]?.fiatPriceInfo
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
