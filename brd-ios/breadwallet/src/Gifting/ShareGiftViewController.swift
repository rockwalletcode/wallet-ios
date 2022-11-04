// 
//  ShareGiftViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-12-06.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
//import CoinGecko

struct GiftInfo {
    let name: String
    let rate: SimplePrice
    let sats: Amount
}

class ShareGiftView: UIView {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let closeButton = UIButton.buildModernCloseButton(position: .middle)
    private let qr = UIImageView()
    private let name = UILabel(font: Fonts.Title.one, color: UIColor.white)
    private let subHeader = UILabel(font: Fonts.Title.two, color: UIColor.white)
    private let separator = UIView(color: UIColor.white.withAlphaComponent(0.15))
    private let logo = UIImageView(image: UIImage(named: "logo"))
    private let totalLabel = UILabel(font: Fonts.Body.one, color: UIColor.white)
    private let total = UILabel(font: Fonts.Title.one, color: UIColor.white)
    private let cell: GiftCurrencyCell
    private let disclaimer = UILabel(font: Fonts.Body.one, color: UIColor.white.withAlphaComponent(0.2))
    private let disclaimer2 = UILabel(font: Fonts.Body.one, color: UIColor.white.withAlphaComponent(0.4))
    private let share = BRDButton(title: "Share", type: .primary)
    private let gift: Gift
    private let showButton: Bool
    
    var didTapShare: (() -> Void)?
    var didTapClose: (() -> Void)?

    init(gift: Gift, showButton: Bool = true) {
        self.gift = gift
        self.showButton = showButton
        self.cell = GiftCurrencyCell(rate: gift.rate ?? 0,
                                     amount: gift.amount ?? 0)
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        addSubview(blurView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(qr)
        contentView.addSubview(name)
        contentView.addSubview(subHeader)
        contentView.addSubview(separator)
        contentView.addSubview(logo)
        contentView.addSubview(totalLabel)
        contentView.addSubview(total)
        contentView.addSubview(cell)
        contentView.addSubview(disclaimer)
        contentView.addSubview(disclaimer2)
        addSubview(share)
    }
    
    private func addConstraints() {
        blurView.constrain(toSuperviewEdges: nil)
        let top = scrollView.topAnchor.constraint(lessThanOrEqualTo: topAnchor)
        let padding = showButton ? Margins.large.rawValue : 0
        if !showButton {
            blurView.isHidden = true
            backgroundColor = LightColors.Background.one
        } else {
            top.priority = .defaultLow
        }
        scrollView.constrain([
            top,
            scrollView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
        
        if showButton {
            scrollView.constrain([
                scrollView.bottomAnchor.constraint(equalTo: share.topAnchor, constant: -padding)
            ])
        } else {
            scrollView.constrain([
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        let contentViewPadding = showButton ? -Margins.extraHuge.rawValue : 0
        contentView.constrain([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(lessThanOrEqualTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: contentViewPadding)
        ])
        qr.constrain([
            qr.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.custom(6)),
            qr.centerXAnchor.constraint(equalTo: centerXAnchor),
            qr.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            qr.heightAnchor.constraint(equalTo: qr.widthAnchor)])
        name.constrain([
            name.topAnchor.constraint(equalTo: qr.bottomAnchor, constant: Margins.large.rawValue),
            name.centerXAnchor.constraint(equalTo: centerXAnchor),
            name.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)])
        subHeader.constrain([
            subHeader.topAnchor.constraint(equalTo: name.bottomAnchor, constant: Margins.small.rawValue),
            subHeader.centerXAnchor.constraint(equalTo: centerXAnchor)])
        separator.constrain([
            separator.topAnchor.constraint(equalTo: subHeader.bottomAnchor, constant: Margins.small.rawValue),
                                separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large.rawValue),
                                separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Margins.large.rawValue),
            separator.heightAnchor.constraint(equalToConstant: 1.0)])
        logo.constrain([
            logo.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Margins.custom(6)),
                        logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large.rawValue)])
        total.constrain([
            total.firstBaselineAnchor.constraint(equalTo: logo.bottomAnchor),
                            total.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Margins.large.rawValue)])
        totalLabel.constrain([
            totalLabel.trailingAnchor.constraint(equalTo: total.trailingAnchor),
            totalLabel.bottomAnchor.constraint(equalTo: total.topAnchor)])
        cell.constrain([
            cell.topAnchor.constraint(equalTo: total.bottomAnchor, constant: Margins.small.rawValue),
            cell.leadingAnchor.constraint(equalTo: logo.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: total.trailingAnchor),
            cell.heightAnchor.constraint(equalToConstant: 80.0)])
        
        disclaimer.constrain([
            disclaimer.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            disclaimer.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: Margins.small.rawValue),
            disclaimer.trailingAnchor.constraint(equalTo: cell.trailingAnchor)])
        disclaimer2.constrain([
            disclaimer2.leadingAnchor.constraint(equalTo: disclaimer.leadingAnchor),
            disclaimer2.topAnchor.constraint(equalTo: disclaimer.bottomAnchor, constant: Margins.small.rawValue),
            disclaimer2.trailingAnchor.constraint(equalTo: disclaimer.trailingAnchor),
            disclaimer2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Margins.large.rawValue)
        ])
        
        share.constrain([
            share.heightAnchor.constraint(equalToConstant: 44.0),
            share.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            share.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            share.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.extraHuge.rawValue)])
        
        if !showButton {
            share.constrain([share.heightAnchor.constraint(equalToConstant: 0.0)])
        }
    }
    
    private func setInitialData() {
        closeButton.tintColor = .white
        closeButton.isHidden = !showButton
        qr.image = gift.qrImage()
        qr.contentMode = .scaleAspectFit
        name.text = gift.name ?? "no name"
        name.textAlignment = .center
        subHeader.text = "Someone gifted you Bitcoin"
        
        if let btc = Currencies.shared.btc {
            let displayAmount = Amount(tokenString: "\(gift.amount ?? 0)", currency: btc)
            total.text = displayAmount.tokenDescription
        }
        total.textAlignment = .right
        
        totalLabel.text = "Approximate Total"
        totalLabel.textAlignment = .right
        
        disclaimer.text = "A network fee will be deducted from the total when claimed. Actual value depends on the current price of bitcoin."
        disclaimer2.text = "Download the BRD app for iPhone or Android. For more information visit brd.com/gift"
        [disclaimer, disclaimer2].forEach {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
        }
        
        name.numberOfLines = 1
        name.lineBreakMode = .byTruncatingTail
        
        contentView.backgroundColor = LightColors.Background.one
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        scrollView.backgroundColor = UIColor.clear
        
        share.tap = { [weak self] in
            self?.didTapShare?()
        }
        closeButton.tap = { [weak self] in
            self?.didTapClose?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareGiftViewController: UIViewController {
    
    private let shareView: ShareGiftView
    private let coordinator: GiftSharingCoordinator
    
    init(gift: Gift) {
        self.shareView = ShareGiftView(gift: gift)
        self.coordinator = GiftSharingCoordinator(gift: gift)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func loadView() {
        view = shareView
        shareView.didTapShare = coordinator.showShare
        coordinator.parent = self
        shareView.didTapClose = coordinator.closeAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
