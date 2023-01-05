//
//  PromptView.swift
//  breadwallet
//
//  Created by Ray Vander Veen on 2019-02-07.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import UIKit

/**
 *  A view that is displayed at the top of a screen such as the home screen, typically
 *  alerting the user of some action that needs to be performed, such as adding a device
 *  passcode or writing down the paper key.
 */
class PromptView: UIView {
    init(prompt: Prompt? = nil) {
        self.prompt = prompt
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dismissButton = UIButton(type: .custom)
    let continueButton = UIButton(type: .custom)
    
    let prompt: Prompt?
    let kycStatusView = FEInfoView()
    
    private let imageView = UIImageView()
    private let title = UILabel(font: Fonts.Subtitle.two, color: LightColors.Text.three)
    private let body = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.one)
    private let container = UIView()
    
    var type: PromptType? {
        return prompt?.type
    }
    
    var shouldAddContinueButton: Bool {
        return prompt?.type == .noInternet ? false : true
    }
    
    private func setup() {
        if type == .kyc {
            let infoConfig: InfoViewConfiguration = Presets.InfoView.verification
            var infoViewModel = UserManager.shared.profile?.status.viewModel ?? VerificationStatus.none.viewModel
            infoViewModel?.headerTrailing = .init(image: Asset.close.image)
            
            kycStatusView.configure(with: infoConfig)
            kycStatusView.setup(with: infoViewModel)
            kycStatusView.setupCustomMargins(all: .large)
            
            addSubview(kycStatusView)
            kycStatusView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            addSubviews()
            setupConstraints()
            setupStyle()
            
            title.numberOfLines = 0
            
            title.text = prompt?.title ?? ""
            body.text = prompt?.body ?? ""
        }
    }
    
    private func addSubviews() {
        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(title)
        container.addSubview(body)
        container.addSubview(dismissButton)
        
        if shouldAddContinueButton {
            container.addSubview(continueButton)
        }
    }
    
    private func setupConstraints() {
        container.constrain(toSuperviewEdges: .zero)
        
        imageView.constrain([
            imageView.heightAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue),
            imageView.widthAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margins.large.rawValue),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])

        dismissButton.constrain([
            dismissButton.topAnchor.constraint(equalTo: container.topAnchor, constant: Margins.large.rawValue),
            dismissButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Margins.large.rawValue),
            dismissButton.heightAnchor.constraint(equalToConstant: ViewSizes.extraSmall.rawValue),
            dismissButton.widthAnchor.constraint(equalToConstant: ViewSizes.extraSmall.rawValue)
            ])
        
        title.constrain([
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Margins.medium.rawValue),
            title.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: Margins.small.rawValue),
            title.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor)
            ])

        body.constrain([
            body.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margins.small.rawValue),
            body.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ])

        if shouldAddContinueButton {
            continueButton.constrain([
                continueButton.topAnchor.constraint(equalTo: body.bottomAnchor, constant: Margins.small.rawValue),
                continueButton.leadingAnchor.constraint(equalTo: body.leadingAnchor),
                continueButton.heightAnchor.constraint(equalToConstant: ViewSizes.extraSmall.rawValue),
                continueButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Margins.large.rawValue)
                ])
        } else {
            body.constrain([
                body.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Margins.large.rawValue)
            ])
        }
    }
    
    private func styleDismissButton() {
        let normalImg = Asset.close.image.tinted(with: LightColors.Text.three)
        let highlightedImg = Asset.close.image.tinted(with: LightColors.Text.three.withAlphaComponent(0.5))
        
        dismissButton.setImage(normalImg, for: .normal)
        dismissButton.setImage(highlightedImg, for: .highlighted)
    }
    
    private func styleContinueButton() {
        continueButton.setTitleColor(LightColors.Text.three, for: .normal)
        continueButton.setTitleColor(LightColors.Text.three.withAlphaComponent(0.5), for: .disabled)
        continueButton.setTitleColor(LightColors.Text.two, for: .highlighted)
        continueButton.titleLabel?.font = Fonts.Subtitle.two
        
        let attributeString = NSMutableAttributedString(
            string: L10n.Button.continueAction,
            attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        continueButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func setupStyle() {
        styleDismissButton()
        styleContinueButton()
        
        imageView.backgroundColor = LightColors.Background.cards
        imageView.layer.cornerRadius = ViewSizes.medium.rawValue / 2.0
        imageView.contentMode = .center
        imageView.image = prompt?.alertIcon
        
        container.backgroundColor = prompt?.backgroundColor
        container.layer.cornerRadius = CornerRadius.common.rawValue
    }
}
