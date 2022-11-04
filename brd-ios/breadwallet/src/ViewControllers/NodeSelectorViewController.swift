//
//  NodeSelectorViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-08-03.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class NodeSelectorViewController: UIViewController {

    private let titleLabel = UILabel(font: .customBold(size: 22.0), color: .white)
    private let nodeLabel = UILabel(font: .customBody(size: 14.0), color: .white)
    private let node = UILabel(font: .customBody(size: 14.0), color: .white)
    private let statusLabel = UILabel(font: .customBody(size: 14.0), color: .white)
    private let status = UILabel(font: .customBody(size: 14.0), color: .white)
    private let button: BRDButton
    private let wallet: Wallet
    private var okAction: UIAlertAction?
    private var timer: Timer?
    private let decimalSeparator = NumberFormatter().decimalSeparator ?? "."

    init(wallet: Wallet) {
        self.wallet = wallet
        if UserDefaults.customNodeIP == nil {
            button = BRDButton(title: L10n.NodeSelector.manualButton, type: .primary)
        } else {
            button = BRDButton(title: L10n.NodeSelector.automaticButton, type: .primary)
        }
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setInitialData()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(nodeLabel)
        view.addSubview(node)
        view.addSubview(statusLabel)
        view.addSubview(status)
        view.addSubview(button)
    }

    private func addConstraints() {
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Margins.custom(6)),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue) ])
        nodeLabel.pinTopLeft(toView: titleLabel, topPadding: Margins.large.rawValue)
        node.pinTopLeft(toView: nodeLabel, topPadding: 0)
        statusLabel.pinTopLeft(toView: node, topPadding: Margins.large.rawValue)
        status.pinTopLeft(toView: statusLabel, topPadding: 0)
        button.constrain([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            button.topAnchor.constraint(equalTo: status.bottomAnchor, constant: Margins.large.rawValue),
            button.heightAnchor.constraint(equalToConstant: 44.0) ])
    }

    private func setInitialData() {
        view.backgroundColor = .darkBackground
        titleLabel.text = L10n.NodeSelector.title
        nodeLabel.text = L10n.NodeSelector.nodeLabel
        statusLabel.text = L10n.NodeSelector.statusLabel
        button.tap = { [weak self] in
            if UserDefaults.customNodeIP == nil {
                self?.switchToManual()
            } else {
                self?.switchToAuto()
            }
        }
        setStatusText()
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(setStatusText), userInfo: nil, repeats: true)
    }

    @objc private func setStatusText() {
        switch wallet.manager.state {
        case .disconnected, .deleted:
            status.text = L10n.NodeSelector.notConnected
        case .created:
            status.text = L10n.NodeSelector.connecting
        case .connected:
            status.text = L10n.NodeSelector.connected
        default:
            status.text = L10n.NodeSelector.connected
        }
        
        if let ip = UserDefaults.customNodeIP {
            node.text = "\(ip):\(UserDefaults.customNodePort ?? C.standardPort)"
        } else {
            node.text = L10n.NodeSelector.automatic
        }
    }

    private func switchToAuto() {
        guard UserDefaults.customNodeIP != nil else { return } //noop if custom node is already nil
        UserDefaults.customNodeIP = nil
        UserDefaults.customNodePort = nil
        button.title = L10n.NodeSelector.manualButton
        reconnectWalletManager()
    }

    private func switchToManual() {
        let alert = UIAlertController(title: L10n.NodeSelector.enterTitle, message: L10n.NodeSelector.enterBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard let ip = alert.textFields?.first,
                let port = alert.textFields?.last,
                let addressText = ip.text?.replacingOccurrences(of: self.decimalSeparator, with: ".") else { return }
            UserDefaults.customNodeIP = addressText
            if let portText = port.text {
                UserDefaults.customNodePort = Int(portText)
            }
            self.reconnectWalletManager()
            self.button.title = L10n.NodeSelector.automaticButton
        })
        self.okAction = okAction
        self.okAction?.isEnabled = false
        alert.addAction(okAction)
        alert.addTextField { [unowned self] textField in
            textField.placeholder = "192.168.0.1"
            textField.keyboardType = self.keyboardType
            textField.addTarget(self, action: #selector(self.ipAddressDidChange(textField:)), for: .editingChanged)
        }
        alert.addTextField { [unowned self] textField in
            textField.placeholder = "8333"
            textField.keyboardType = self.keyboardType
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func reconnectWalletManager() {
        DispatchQueue.global(qos: .userInitiated).async {
            let manager = self.wallet.manager
            manager.connect(using: manager.customPeer)
        }
    }
    
    private var keyboardType: UIKeyboardType {
        return decimalSeparator == "." ? .decimalPad : .numbersAndPunctuation
    }

    @objc private func ipAddressDidChange(textField: UITextField) {
        if let text = textField.text?.replacingOccurrences(of: decimalSeparator, with: ".") {
            if text.components(separatedBy: ".").count == 4 && ascii2addr(AF_INET, text, nil) > 0 {
                self.okAction?.isEnabled = true
                return
            }
        }
        self.okAction?.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
