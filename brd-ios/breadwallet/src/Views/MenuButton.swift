//
//  MenuButton.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-04-27.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class MenuButton: UIControl {

    private let container = UIView(color: .grayBackground)
    private let iconView = UIImageView()
    private let label = UILabel(font: .customBody(size: 16.0), color: .darkGray)
    private let arrow = UIImageView(image: #imageLiteral(resourceName: "RightArrow").withRenderingMode(.alwaysTemplate))

    init(title: String, icon: UIImage) {
        label.text = title
        iconView.image = icon.withRenderingMode(.alwaysTemplate)
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubviews()
        addConstraints()
        setupStyle()
    }

    private func addSubviews() {
        container.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
        addSubview(container)
        container.addSubview(iconView)
        container.addSubview(label)
        container.addSubview(arrow)
    }

    private func addConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.small.rawValue,
                                                           left: Margins.large.rawValue,
                                                           bottom: 0.0,
                                                           right: -Margins.large.rawValue))
        iconView.constrain([
            iconView.heightAnchor.constraint(equalToConstant: 16.0),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margins.large.rawValue),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])

        label.constrain([
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Margins.small.rawValue),
            label.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: Margins.small.rawValue),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])

        arrow.constrain([
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Margins.large.rawValue),
            arrow.widthAnchor.constraint(equalToConstant: 3.5),
            arrow.heightAnchor.constraint(equalToConstant: 6.0),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
    }

    private func setupStyle() {
        container.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        container.clipsToBounds = true
        iconView.tintColor = .darkGray
        arrow.tintColor = .darkGray
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                container.backgroundColor = .lightGray
            } else {
                container.backgroundColor = .grayBackground
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
