// 
//  WalletConnectionSettingsViewController.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2019-08-28.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit
import SafariServices

class WalletConnectionSettingsViewController: UIViewController {

    private let walletConnectionSettings: WalletConnectionSettings
    private var currency: Currency? {
        return Currencies.shared.btc
    }
    private let modeChangeCallback: (WalletConnectionMode) -> Void

    // views
    private let animatedBlockSetLogo = AnimatedBlockSetLogo()
    private let header = UILabel.wrapping(font: Fonts.Title.three, color: LightColors.Text.one)
    private let explanationLabel = UITextView()
    private let footerLabel = UILabel.wrapping(font: Fonts.Body.three, color: LightColors.Text.two)
    private let toggleSwitch = UISwitch()
    private let footerLogo = UIImageView(image: UIImage(named: "BlocksetLogoWhite"))
    private let mainBackground = UIView(color: LightColors.primary.withAlphaComponent(0.5))
    private let footerBackground = UIView(color: .clear)
    
    // MARK: - Lifecycle

    init(walletConnectionSettings: WalletConnectionSettings,
         modeChangeCallback: @escaping (WalletConnectionMode) -> Void) {
        self.walletConnectionSettings = walletConnectionSettings
        self.modeChangeCallback = modeChangeCallback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [mainBackground, footerBackground, animatedBlockSetLogo, header, explanationLabel, toggleSwitch, footerLabel, footerLogo].forEach { view.addSubview($0) }
        setUpAppearance()
        addConstraints()
        bindData()
    }

    private func setUpAppearance() {
        view.backgroundColor = LightColors.Background.one
        explanationLabel.textAlignment = .center
        mainBackground.layer.cornerRadius = 4.0
        footerBackground.layer.cornerRadius = 4.0
        mainBackground.clipsToBounds = true
        footerBackground.clipsToBounds = true
        
        // Clip the main view so that the block animation doesn't show when back gesture is active
        view.clipsToBounds = true
        
        if E.isIPhone5 {
            animatedBlockSetLogo.isHidden = true
            animatedBlockSetLogo.constrain([
                animatedBlockSetLogo.heightAnchor.constraint(equalToConstant: 0.0),
                animatedBlockSetLogo.widthAnchor.constraint(equalToConstant: 0.0)])
        }
    }

    private func addConstraints() {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let topMarginPercent: CGFloat = 0.08
        let imageTopMargin: CGFloat = E.isIPhone6 ? 8.0 : (screenHeight * topMarginPercent)
        let containerTopMargin: CGFloat = E.isIPhone6 ? 0.0 : -Margins.large.rawValue
        let leftRightMargin: CGFloat = 54.0

        mainBackground.constrain([
            mainBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            mainBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            mainBackground.topAnchor.constraint(equalTo: animatedBlockSetLogo.topAnchor, constant: containerTopMargin),
            mainBackground.bottomAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: Margins.extraHuge.rawValue) ])
        
        animatedBlockSetLogo.constrain([
            animatedBlockSetLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedBlockSetLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: imageTopMargin)
            ])

        header.constrain([
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.topAnchor.constraint(equalTo: animatedBlockSetLogo.bottomAnchor, constant: E.isIPhone5 ? Margins.large.rawValue : Margins.extraHuge.rawValue)])
        
        explanationLabel.constrain([
            explanationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftRightMargin),
            explanationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -leftRightMargin),
            explanationLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Margins.large.rawValue)
            ])

        toggleSwitch.constrain([
            toggleSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleSwitch.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Margins.huge.rawValue)
            ])
        
        footerLabel.constrain([
            footerLabel.bottomAnchor.constraint(equalTo: footerBackground.topAnchor, constant: -Margins.small.rawValue),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        footerLogo.constrain([
            footerLogo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52.0),
            footerLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        footerBackground.constrain([
            footerBackground.topAnchor.constraint(equalTo: footerLogo.topAnchor, constant: -Margins.large.rawValue),
            footerBackground.leadingAnchor.constraint(equalTo: footerLogo.leadingAnchor, constant: -Margins.large.rawValue),
            footerBackground.trailingAnchor.constraint(equalTo: footerLogo.trailingAnchor, constant: Margins.large.rawValue),
            footerBackground.bottomAnchor.constraint(equalTo: footerLogo.bottomAnchor, constant: Margins.large.rawValue)
            ])
    }

    private func bindData() {
        guard let currency = currency else { return }
        
        title = L10n.WalletConnectionSettings.viewTitle
        header.text = L10n.WalletConnectionSettings.header
        footerLabel.text = L10n.WalletConnectionSettings.footerTitle
        footerLogo.tintColor = LightColors.primary
        
        let selectedMode = walletConnectionSettings.mode(for: currency)
        toggleSwitch.isOn = selectedMode == WalletConnectionMode.api_only
        
        //This needs to be done in the next run loop or else the animations don't
        //start in the right spot
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.animatedBlockSetLogo.isOn = self.toggleSwitch.isOn
        }
        
        toggleSwitch.valueChanged = { [weak self] in
            guard let self = self else { return }
            
            // Fast sync can only be turned on via the toggle.
            // It needs to be turned off by the confirmation alert.
            if self.toggleSwitch.isOn {
                self.setMode()
            } else {
                self.confirmToggle()
            }
        }
        
        setupLink()
    }
    
    private func setMode() {
        guard let currency = currency else { return }
        
        let newMode = toggleSwitch.isOn
            ? WalletConnectionMode.api_only
            : WalletConnectionMode.p2p_only
        walletConnectionSettings.set(mode: newMode, for: currency)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        animatedBlockSetLogo.isOn.toggle()
        self.modeChangeCallback(newMode)
    }
    
    private func confirmToggle() {
        let alert = UIAlertController(title: "", message: L10n.WalletConnectionSettings.confirmation, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: { _ in
            self.toggleSwitch.setOn(true, animated: true)
        }))
        alert.addAction(UIAlertAction(title: L10n.WalletConnectionSettings.turnOff, style: .default, handler: { _ in
            self.setMode()
        }))
        present(alert, animated: true)
    }
    
    private func setupLink() {
        let string = NSMutableAttributedString(string: L10n.WalletConnectionSettings.explanatoryText)
        let linkRange = string.mutableString.range(of: L10n.WalletConnectionSettings.link)
        if linkRange.location != NSNotFound {
            string.addAttribute(.link, value: NSURL(string: "https://www.brd.com/blog/fastsync-explained")!, range: linkRange)
        }
        explanationLabel.attributedText = string
        explanationLabel.delegate = self
        
        explanationLabel.isEditable = false
        explanationLabel.backgroundColor = .clear
        explanationLabel.font = Fonts.Body.one
        explanationLabel.textColor = LightColors.Text.two
        explanationLabel.textAlignment = .center
        
        //TODO:CYRPTO - is there a way to make this false but also
        // keep the link working?
        //explanationLabel.isSelectable = false
        explanationLabel.isScrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletConnectionSettingsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController(url: URL)
        self.present(vc, animated: true, completion: nil)
        return false
    }
}
