//
//  RecoverWalletIntroViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-02-23.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class RecoverWalletIntroViewController: UIViewController {

    // MARK: - Public
    init(didTapNext: @escaping () -> Void) {
        self.didTapNext = didTapNext
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Private
    private let didTapNext: () -> Void
    private let header = RadialGradientView(backgroundColor: .purple)
    private let nextButton = BRDButton(title: L10n.RecoverWallet.next, type: .primary)
    private let label = UILabel(font: .customBody(size: 16.0), color: .white)
    private let illustration = UIImageView(image: #imageLiteral(resourceName: "RecoverWalletIllustration"))

    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setData()
    }

    private func addSubviews() {
        view.addSubview(header)
        header.addSubview(illustration)
        view.addSubview(nextButton)
        view.addSubview(label)
    }

    private func addConstraints() {
        header.constrainTopCorners(sidePadding: 0.0, topPadding: 0.0)
        header.constrain([header.heightAnchor.constraint(equalToConstant: 220.0)])
        illustration.constrain([
            illustration.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            illustration.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: Margins.large.rawValue) ])
        label.constrain([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            label.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Margins.large.rawValue),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue) ])
        nextButton.constrain([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Margins.huge.rawValue),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            nextButton.heightAnchor.constraint(equalToConstant: ViewSizes.Common.defaultCommon.rawValue) ])
    }

    private func setData() {
        view.backgroundColor = .darkBackground
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = L10n.RecoverWallet.intro
        nextButton.tap = didTapNext
        title = L10n.RecoverWallet.header
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
