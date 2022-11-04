//
//  ReScanViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-10.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class ReScanViewController: UIViewController, Subscriber {

    init(system: CoreSystem, wallet: Wallet) {
        self.system = system
        self.wallet = wallet
        self.faq = .buildFaqButton(articleId: ArticleIds.reScan, currency: wallet.currency, position: .middle)
        super.init(nibName: nil, bundle: nil)
    }

    private let system: CoreSystem
    private let wallet: Wallet
    private let header = UILabel.wrapping(font: .customBold(size: 26.0), color: .white)
    private let body = UILabel.wrapping(font: .systemFont(ofSize: 15.0))
    private let button = BRDButton(title: L10n.ReScan.buttonTitle, type: .primary)
    private let footer = UILabel.wrapping(font: .customBody(size: 16.0), color: .white)
    private let faq: UIButton

    deinit {
        Store.unsubscribe(self)
    }

    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setInitialData()
        
        Store.subscribe(self,
                        selector: { [weak self] oldState, newState in
                            guard let self = self else { return false }
                            return oldState[self.wallet.currency]?.syncState != newState[self.wallet.currency]?.syncState },
                        callback: { [weak self] state in
                            guard let self = self,
                                let walletState = state[self.wallet.currency] else { return }
                            let enabled = walletState.syncState == .success
                                && walletState.isRescanning == false
                                && (self.wallet.networkPrimaryWallet?.manager.isConnected ?? false)
                            self.button.isEnabled = enabled
                            if walletState.syncState == .syncing {
                                self.button.title = L10n.SyncingView.syncing
                            } else {
                                self.button.title = L10n.ReScan.buttonTitle
                            }
        })
    }

    private func addSubviews() {
        view.addSubview(header)
        view.addSubview(faq)
        view.addSubview(body)
        view.addSubview(button)
        view.addSubview(footer)
    }

    private func addConstraints() {
        header.constrain([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.large.rawValue),
            header.trailingAnchor.constraint(equalTo: faq.leadingAnchor, constant: -Margins.large.rawValue)])
        faq.constrain([
            faq.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            faq.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            faq.widthAnchor.constraint(equalToConstant: 44.0),
            faq.heightAnchor.constraint(equalToConstant: 44.0) ])
        body.constrain([
            body.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            body.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Margins.large.rawValue),
            body.trailingAnchor.constraint(equalTo: faq.trailingAnchor) ])
        footer.constrain([
            footer.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: faq.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.huge.rawValue) ])
        button.constrain([
            button.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: footer.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: -Margins.large.rawValue),
            button.heightAnchor.constraint(equalToConstant: ViewSizes.Common.defaultCommon.rawValue) ])
    }

    private func setInitialData() {
        view.backgroundColor = .darkBackground
        faq.tintColor = .navigationTint
        header.text = L10n.ReScan.header
        body.attributedText = bodyText
        footer.text = L10n.ReScan.footer
        button.tap = { [weak self] in
            self?.presentRescanAlert()
        }
    }

    private func presentRescanAlert() {
        let alert = UIAlertController(title: L10n.ReScan.alertTitle, message: L10n.ReScan.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: L10n.ReScan.alertAction, style: .default, handler: { _ in
            RescanCoordinator.initiateRescan(system: self.system, wallet: self.wallet)
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    private var bodyText: NSAttributedString {
        let body = NSMutableAttributedString()
        let headerAttributes = [ NSAttributedString.Key.font: UIFont.customBold(size: 16.0),
                                 NSAttributedString.Key.foregroundColor: UIColor.white ]
        let bodyAttributes = [ NSAttributedString.Key.font: UIFont.customBody(size: 16.0),
                               NSAttributedString.Key.foregroundColor: UIColor.white ]

        body.append(NSAttributedString(string: "\(L10n.ReScan.subheader2)\n", attributes: headerAttributes))
        body.append(NSAttributedString(string: "\(L10n.ReScan.body2)\n\n\(L10n.ReScan.body3)", attributes: bodyAttributes))
        return body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
