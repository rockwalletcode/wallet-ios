//
//  WalletDisabledView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-05-01.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class WalletDisabledView: UIView {

    func setTimeLabel(string: String) {
        timeLabel.text = string
    }

    init() {
        blur = UIVisualEffectView()
        super.init(frame: .zero)
        setup()
    }

    func show() {
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.blur.effect = self.effect
        })
    }

    func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.blur.effect = nil
        }, completion: { _ in
            completion()
        })
    }

    var didTapReset: (() -> Void)? {
        didSet {
            reset.tap = didTapReset
        }
    }
    
    var didTapFaq: (() -> Void)? {
        didSet {
            faq.tap = didTapFaq
        }
    }
    
    var didCompleteWipeGesture: (() -> Void)?

    private let timeLabel = UILabel(font: Fonts.Body.two, color: LightColors.Text.two)
    private let blur: UIVisualEffectView
    private let reset = BRDButton(title: L10n.UnlockScreen.resetPin.uppercased(), type: .secondary)
    private let effect = UIBlurEffect(style: .regular)
    private let gr = UITapGestureRecognizer()
    private var tapCount = 0
    private let tapWipeCount = 12
    
    private lazy var faq: UIButton = {
        let faq = UIButton()
        faq.tintColor = LightColors.Text.one
        faq.setBackgroundImage(UIImage(named: "faqIcon"), for: .normal)
        
        return faq
    }()
    
    private lazy var title: UILabel = {
        let header = UILabel()
        header.textColor = LightColors.Text.three
        header.font = Fonts.Title.six
        header.textAlignment = .center
        header.text = L10n.UnlockScreen.walletDisabled
        
        return header
    }()
    
    private lazy var unlockWalletImage: UIImageView = {
        let unlockWalletImage = UIImageView(image: UIImage(named: "unlock-wallet-disabled"))
        unlockWalletImage.contentMode = .scaleAspectFit
        
        return unlockWalletImage
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = LightColors.Text.two
        descriptionLabel.font = Fonts.Body.two
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = L10n.UnlockScreen.walletDisabledDescription
        
        return descriptionLabel
    }()
    
    private func setup() {
        addSubviews()
        addConstraints()
        setData()
    }

    private func addSubviews() {
        addSubview(blur)
        addSubview(faq)
        addSubview(title)
        addSubview(timeLabel)
        addSubview(unlockWalletImage)
        addSubview(reset)
        addSubview(descriptionLabel)
    }

    private func addConstraints() {
        blur.constrain(toSuperviewEdges: nil)
        
        faq.constrain([
            faq.topAnchor.constraint(equalTo: blur.topAnchor, constant: Margins.extraExtraHuge.rawValue * 2),
            faq.trailingAnchor.constraint(equalTo: blur.trailingAnchor, constant: -Margins.extraLarge.rawValue),
            faq.widthAnchor.constraint(equalToConstant: ViewSizes.extraSmall.rawValue),
            faq.heightAnchor.constraint(equalToConstant: ViewSizes.extraSmall.rawValue)])
        
        unlockWalletImage.constrain([
            unlockWalletImage.centerXAnchor.constraint(equalTo: blur.centerXAnchor),
            unlockWalletImage.widthAnchor.constraint(equalToConstant: ViewSizes.extralarge.rawValue * 2),
            unlockWalletImage.heightAnchor.constraint(equalToConstant: ViewSizes.extralarge.rawValue * 2)])
        
        title.constrain([
            title.topAnchor.constraint(equalTo: unlockWalletImage.bottomAnchor, constant: Margins.extraExtraHuge.rawValue),
            title.centerYAnchor.constraint(equalTo: blur.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: blur.centerXAnchor)])
        
        timeLabel.constrain([
            timeLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margins.huge.rawValue),
            timeLabel.centerXAnchor.constraint(equalTo: blur.centerXAnchor)])
        
        descriptionLabel.constrain([
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Margins.huge.rawValue),
            descriptionLabel.centerXAnchor.constraint(equalTo: blur.centerXAnchor)])
        
        reset.constrain([
            reset.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.extraHuge.rawValue),
            reset.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            reset.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            reset.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeButton.rawValue)])
        
    }

    private func setData() {
        timeLabel.textAlignment = .center
        timeLabel.addGestureRecognizer(gr)
        timeLabel.isUserInteractionEnabled = true
        gr.addTarget(self, action: #selector(didTap))
        faq.tintColor = .black
    }
    
    @objc private func didTap() {
        tapCount += 1
        if tapCount == tapWipeCount {
            didCompleteWipeGesture?()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
