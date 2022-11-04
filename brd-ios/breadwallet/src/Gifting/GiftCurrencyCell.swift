// 
//  GiftCurrencyCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-12-08.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class GiftCurrencyCell: UIView {

    private let currency = Currencies.shared.btc
    private let iconContainer = UIView(color: .transparentIconBackground)
    private let icon = UIImageView()
    private let currencyName = UILabel(font: Fonts.Body.one, color: LightColors.Text.one)
    private let price = UILabel(font: Fonts.Body.three, color: LightColors.Text.two)
    private let fiatBalance = UILabel(font: Fonts.Body.one, color: LightColors.Text.one)
    private let tokenBalance = UILabel(font: Fonts.Body.three, color: LightColors.Text.two)
    
    private let rate: Double
    private let amount: Double
    
    init(rate: Double, amount: Double) {
        self.rate = rate
        self.amount = amount
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        addSubview(iconContainer)
        iconContainer.addSubview(icon)
        addSubview(currencyName)
        addSubview(price)
        addSubview(fiatBalance)
        addSubview(tokenBalance)
    }
    
    private func addConstraints() {
        iconContainer.constrain([
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.small.rawValue),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor)])
        icon.constrain(toSuperviewEdges: .zero)
        price.constrain([
            price.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Margins.small.rawValue),
            price.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor)])
        currencyName.constrain([
            currencyName.leadingAnchor.constraint(equalTo: price.leadingAnchor),
            currencyName.bottomAnchor.constraint(equalTo: price.topAnchor)])
        tokenBalance.constrain([
            tokenBalance.bottomAnchor.constraint(equalTo: price.bottomAnchor),
            tokenBalance.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue)])
        fiatBalance.constrain([
            fiatBalance.trailingAnchor.constraint(equalTo: tokenBalance.trailingAnchor),
            fiatBalance.bottomAnchor.constraint(equalTo: tokenBalance.topAnchor)])
    }
    
    private func setInitialData() {
        // TODO: We don't support GIFT functionality. Figure it out.
        /*
         backgroundColor = currency.colors.0
         layer.cornerRadius = 8.0
         
         icon.image = currency.imageNoBackground
         iconContainer.layer.cornerRadius = CornerRadius.common.rawValue
         iconContainer.clipsToBounds = true
         icon.tintColor = .white
         
         let rateAmount = Amount(tokenString: "1", currency: currency)
         price.text = rateAmount.fiatDescription
         currencyName.text = "Bitcoin"
         
         let displayAmount = Amount(tokenString: "\(amount)", currency: currency)
         fiatBalance.text = displayAmount.fiatDescription
         tokenBalance.text = displayAmount.tokenDescription
         */
    }
    
}
