//
//  AccountFooterView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class AccountFooterView: UIView, Subscriber {
    
    static let height: CGFloat = 72.0

    var sendCallback: (() -> Void)?
    var receiveCallback: (() -> Void)?
    
    private var hasSetup = false
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
        super.init(frame: .zero)
        setup()
    }

    private func toRadian(value: Int) -> CGFloat {
        return CGFloat(Double(value) / 180.0 * .pi)
    }
    
    private func setup() {
        let separator = UIView(color: LightColors.Outline.one)
        addSubview(separator)
        backgroundColor = LightColors.Background.one
        separator.constrainTopCorners(height: 0.5)
        layer.cornerRadius = CornerRadius.large.rawValue
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupToolbarButtons()
    }
    
    private func setupToolbarButtons() {
        let buttons = [
            (L10n.Button.send, #selector(AccountFooterView.send)),
            (L10n.Button.receive, #selector(AccountFooterView.receive))
        ].compactMap { (title, selector) -> UIButton in
            let button = UIButton.rounded(title: title.uppercased())
            button.addTarget(self, action: selector, for: .touchUpInside)
            return button
        }
        buttons.first?.isEnabled = currency.wallet?.balance.isZero != true
        let buttonsView = UIStackView(arrangedSubviews: buttons)
        buttonsView.spacing = Margins.small.rawValue
        buttonsView.distribution = .fillEqually
        
        addSubview(buttonsView)
        buttonsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Margins.medium.rawValue)
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
            make.leading.equalToSuperview().offset(Margins.large.rawValue)
            make.trailing.equalToSuperview().offset(-Margins.large.rawValue)
            make.bottom.equalToSuperview()
        }
    }

    @objc private func send() { sendCallback?() }
    @objc private func receive() { receiveCallback?() }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
