//
//  EnableSegwitView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-10-11.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class EnableSegwitView: UIView {
    
    private let label = UILabel.wrapping(font: .customBody(size: 13.0), color: .white)
    private let cancel = BRDButton(title: L10n.Button.cancel, type: .secondary)
    private let continueButton = BRDButton(title: L10n.Button.continueAction, type: .primary)
    
    var didCancel: (() -> Void)? {
        didSet { cancel.tap = didCancel }
    }
    var didContinue: (() -> Void)? {
        didSet { continueButton.tap = didContinue }
    }
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(label)
        addSubview(cancel)
        addSubview(continueButton)
    }
    
    private func addConstraints() {
        label.constrain([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Margins.large.rawValue),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue) ])
        cancel.constrain([
            cancel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Margins.large.rawValue),
            cancel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -Margins.small.rawValue),
            cancel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            cancel.heightAnchor.constraint(equalToConstant: 48.0),
            cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.large.rawValue)])
        continueButton.constrain([
            continueButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Margins.large.rawValue),
            continueButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: Margins.small.rawValue),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            continueButton.heightAnchor.constraint(equalToConstant: 48.0)])
    }
    
    private func setInitialData() {
        backgroundColor = LightColors.Background.three
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        label.text = L10n.Segwit.confirmChoiceLayout
    }
    
}
