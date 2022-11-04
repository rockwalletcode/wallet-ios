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
    
    let imageView = UIImageView()
    let title = UILabel(font: Fonts.Subtitle.two, color: LightColors.Text.three)
    let body = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.one)
    let container = UIView()
    
    private let imageViewSize: CGFloat = 32.0
    
    var type: PromptType? {
        return prompt?.type
    }
    
    var shouldHandleTap: Bool {
        return false
    }
    
    var shouldAddContinueButton: Bool {
        return true
    }
    
    func setup() {
        addSubviews()
        setupConstraints()
        setupStyle()
        
        title.numberOfLines = 0
        
        title.text = prompt?.title ?? ""
        body.text = prompt?.body ?? ""
    }
    
    var containerBackgroundColor: UIColor {
        return LightColors.Background.one
    }
    
    func addSubviews() {
        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(title)
        container.addSubview(body)
        container.addSubview(dismissButton)
        if shouldAddContinueButton {
            container.addSubview(continueButton)
        }
    }
    
    func setupConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.large.rawValue,
                                                           left: 0,
                                                           bottom: -Margins.large.rawValue,
                                                           right: 0))
        
        imageView.constrain([
            imageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: imageViewSize),
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
        }
    }
    
    func styleDismissButton() {
        let normalImg = UIImage(named: "close")?.tinted(with: LightColors.Text.three)
        let highlightedImg = UIImage(named: "close")?.tinted(with: LightColors.Text.three.withAlphaComponent(0.5))
        
        dismissButton.setImage(normalImg, for: .normal)
        dismissButton.setImage(highlightedImg, for: .highlighted)
    }
    
    func styleContinueButton() {
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
        imageView.layer.cornerRadius = imageViewSize / 2.0
        imageView.contentMode = .center
        imageView.image = UIImage(named: "alert")?.tinted(with: LightColors.primary)
        
        container.backgroundColor = LightColors.Background.three
        container.layer.cornerRadius = CornerRadius.common.rawValue
    }
}
