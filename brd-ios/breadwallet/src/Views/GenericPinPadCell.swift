//
//  GenericPinPadCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-15.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class GenericPinPadCell: UICollectionViewCell {

    var text: String? {
        didSet {
            if let specialKey = PinPadViewController.SpecialKeys(rawValue: text!) {
                imageView.image = specialKey.image(forStyle: style)
                label.text = ""
            } else {
                imageView.image = nil
                label.text = text
            }
            setAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard !text.isNilOrEmpty else { return } //We don't want the blank cell to highlight
            setAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    internal var label = UILabel(font: Fonts.Title.three, color: LightColors.Text.three)
    internal let imageView = UIImageView()
    var style: PinPadStyle = .clear

    private func setup() {
        setAppearance()
        label.textAlignment = .center
        addSubview(imageView)
        addSubview(label)
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        
        addConstraints()
    }

    func addConstraints() {
        imageView.constrain([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)])
        label.constrain(toSuperviewEdges: nil)
    }

    override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set { }
    }

    override var accessibilityLabel: String? {
        get {
            return label.text
        }
        set { }
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraits.staticText
        }
        set { }
    }

    func setAppearance() {
        backgroundColor = LightColors.Background.one
        let color: UIColor
        if isHighlighted {
            color = LightColors.primaryPressed
        } else {
            color = LightColors.Text.three
        }
        imageView.tintColor = color
        label.textColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
