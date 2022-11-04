//
//  UIButton+BRWAdditions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-24.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

extension UIButton {
    static func vertical(title: String, image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = Fonts.button
        button.contentMode = .center
        button.imageView?.contentMode = .center
        if let imageSize = button.imageView?.image?.size,
            let font = button.titleLabel?.font {
            let spacing: CGFloat = Margins.extraSmall.rawValue
            let titleSize = NSString(string: title).size(withAttributes: [NSAttributedString.Key.font: font])

            // These edge insets place the image vertically above the title label
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(26.0 + spacing), right: 0.0)
            button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
        return button
    }
    
    static func rounded(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Fonts.button
        button.backgroundColor = LightColors.primary
        button.setTitleColor(LightColors.Contrast.two, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        return button
    }
    
    static func outline(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.customBody(size: 14.0)
        button.tintColor = .white
        button.backgroundColor = .outlineButtonBackground
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }
    
    static func buildModernCloseButton(position: NavBarButtonPosition) -> UIButton {
        let button = UIButton.icon(image: UIImage(named: "close"),
                                   accessibilityLabel: L10n.AccessibilityLabels.close,
                                   position: position)
        button.tintColor = LightColors.Text.three
        return button
    }

    static func buildFaqButton(articleId: String, currency: Currency? = nil, position: NavBarButtonPosition, tapped: (() -> Void)? = nil) -> UIButton {
        let button = UIButton.icon(image: #imageLiteral(resourceName: "faqIcon"), accessibilityLabel: L10n.AccessibilityLabels.faq, position: position)
        button.tintColor = LightColors.Text.three
        
        button.tap = {
            Store.trigger(name: .presentFaq(articleId, currency))
            tapped?()
        }
        
        return button
    }
    
    static func icon(image: UIImage?, accessibilityLabel: String, position: NavBarButtonPosition) -> UIButton {
        guard let image = image else { return UIButton() }
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(image, for: .normal)
        
        switch position {
        case .left:
            button.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: 12.0, right: 24)
        case .middle:
            button.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12, bottom: 12.0, right: 12)
        case .right:
            button.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 24, bottom: 12.0, right: 0)
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.accessibilityLabel = accessibilityLabel
        return button
    }
    
    func tempDisable() {
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            self?.isEnabled = true
        })
    }
}
