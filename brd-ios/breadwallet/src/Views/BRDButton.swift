//
//  BRDButton.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-15.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum ButtonType {
    case primary
    case secondary
    case tertiary
    case blackTransparent
    case darkOpaque
    case secondaryTransparent
    case search
}

private let minTargetSize: CGFloat = 48.0

class BRDButton: UIControl {

    init(title: String, type: ButtonType) {
        self.title = title
        self.type = type
        super.init(frame: .zero)
        accessibilityLabel = title
        setupViews()
    }

    init(title: String?, type: ButtonType, image: UIImage?) {
        self.title = title ?? ""
        self.type = type
        self.image = image
        super.init(frame: .zero)
        accessibilityLabel = title
        setupViews()
    }

    var isToggleable = false
    var title: String {
        didSet {
            guard type == .blackTransparent else {
                label.text = title.uppercased()
                return
            }
            
            let underlineAttribute = [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
            ]
            let underlineAttributedString = NSAttributedString(string: title.uppercased(), attributes: underlineAttribute)
            label.attributedText = underlineAttributedString
        }
    }
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    private let type: ButtonType
    private let container = UIView()
    private let label = UILabel()
    private var cornerRadius = CornerRadius.common
    private var imageView: UIImageView?

    override var isHighlighted: Bool {
        didSet {
            // Shrinks the button to 97% and drops it down 4 points to give a 3D press-down effect.
            let duration = 0.21
            let scale: CGFloat = 0.97
            let drop: CGFloat = 4.0
            
            if isHighlighted {
                let shrink = CATransform3DMakeScale(scale, scale, 1.0)
                let translate = CATransform3DTranslate(shrink, 0, drop, 0)

                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { 
                    self.container.layer.transform = translate
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    self.container.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            guard isToggleable else { return }
            guard isSelected else {
                setColors()
                return
            }
            
            switch type {
            case .tertiary:
                container.layer.borderColor = UIColor.primaryButton.cgColor
                imageView?.tintColor = .primaryButton
                label.textColor = .primaryButton
                
            case .search:
                imageView?.tintColor = LightColors.Contrast.two
                label.textColor = LightColors.Contrast.two
                container.backgroundColor = LightColors.Text.two
                
            default:
                return
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setColors()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard cornerRadius == .fullRadius else {
            container.layer.cornerRadius = cornerRadius.rawValue
            return
        }
        
        container.layer.cornerRadius = cornerRadius.rawValue * container.frame.height
    }

    private func setupViews() {
        addContent()
        setColors()
        addTarget(self, action: #selector(BRDButton.touchUpInside), for: .touchUpInside)
        setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }

    private func addContent() {
        addSubview(container)
        container.backgroundColor = .primaryButton
        container.isUserInteractionEnabled = false
        container.constrain(toSuperviewEdges: nil)
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = Fonts.button
        configureContentType()
    }

    private func configureContentType() {
        if let icon = image {
            setupImageOption(icon: icon)
        } else {
            setupLabelOnly()
        }
    }

    private func setupImageOption(icon: UIImage) {
        let content = UIView()
        let iconImageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        iconImageView.contentMode = .scaleAspectFit
        container.addSubview(content)
        content.addSubview(label)
        content.addSubview(iconImageView)
        content.constrainToCenter()
        iconImageView.constrainLeadingCorners()
        label.constrainTrailingCorners()
        
        if label.text?.isEmpty == true {
            iconImageView.constrain([
                iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        } else {
            iconImageView.constrain([
                iconImageView.constraint(toLeading: label, constant: -Margins.small.rawValue)
            ])
        }
        imageView = iconImageView
    }

    private func setupLabelOnly() {
        container.addSubview(label)
        label.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.small.rawValue, left: Margins.large.rawValue, bottom: -Margins.small.rawValue, right: -Margins.large.rawValue))
    }

    private func setColors() {
        switch type {
        case .primary:
            container.backgroundColor = .clear
            label.textColor = LightColors.primary
            imageView?.tintColor = LightColors.primary
            container.layer.borderColor = LightColors.primary.cgColor
            container.layer.borderWidth = 1.0
            cornerRadius = .fullRadius
        case .secondary:
            container.backgroundColor = LightColors.primary
            label.textColor = LightColors.Contrast.two
            imageView?.tintColor = LightColors.Contrast.two
            cornerRadius = .fullRadius
        case .tertiary:
            container.backgroundColor = LightColors.Background.one
            label.textColor = LightColors.primary
            container.layer.borderColor = LightColors.primary.cgColor
            container.layer.borderWidth = 1.0
            imageView?.tintColor = LightColors.primary
            cornerRadius = .fullRadius
        case .blackTransparent:
            container.backgroundColor = .clear
            label.textColor = LightColors.Contrast.two
            imageView?.tintColor = LightColors.Contrast.two
        case .darkOpaque:
            container.backgroundColor = .darkOpaqueButton
            label.textColor = .black
        case .secondaryTransparent:
            container.backgroundColor = .transparentButton
            label.textColor = .black
            container.layer.borderColor = nil
            container.layer.borderWidth = 0.0
            imageView?.tintColor = .white
        case .search:
            label.font = Fonts.Body.two
            container.backgroundColor = LightColors.Background.two
            label.textColor = LightColors.Text.three
            imageView?.tintColor = LightColors.Text.three
        }
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden || isUserInteractionEnabled else { return nil }
        let deltaX = max(minTargetSize - bounds.width, 0)
        let deltaY = max(minTargetSize - bounds.height, 0)
        let hitFrame = bounds.insetBy(dx: -deltaX/2.0, dy: -deltaY/2.0)
        return hitFrame.contains(point) ? self : nil
    }

    @objc private func touchUpInside() {
        isSelected = !isSelected
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
