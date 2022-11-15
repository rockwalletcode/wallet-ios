//
//  DelistedTokenView.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-10-17.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class DelistedTokenView: UIView {
    
    private let currency: Currency
    private let label = UILabel(font: .customBody(size: 14.0), color: .white)
    private let button = UIButton.outline(title: L10n.Button.moreInfo)
    
    init(currency: Currency) {
        self.currency = currency
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    private func setupViews() {
        addSubviews()
        addConstraints()
        
        backgroundColor = LightColors.Disabled.one
        
        label.numberOfLines = 0
        label.text = L10n.Account.delistedToken
        
        button.tap = {
            Store.trigger(name: .presentFaq(ArticleIds.unsupportedToken, self.currency))
        }
    }
    
    private func addSubviews() {
        addSubview(label)
        addSubview(button)
    }
    
    private func addConstraints() {
        label.constrain([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.huge.rawValue),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.huge.rawValue),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Margins.huge.rawValue)])
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        button.constrain([
            button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Margins.huge.rawValue),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.huge.rawValue),
            button.heightAnchor.constraint(equalToConstant: 28),
            button.widthAnchor.constraint(equalToConstant: 111)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
