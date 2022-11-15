//
//  InAppAlert.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-06-17.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class InAppAlert: UIView {

    init(message: String, image: UIImage) {
        super.init(frame: .zero)
        setup()
        self.image.image = image
        self.message.text = message
    }

    static let height: CGFloat = 162.0
    var bottomConstraint: NSLayoutConstraint?
    var hide: (() -> Void)?

    private let close = UIButton.buildModernCloseButton(position: .middle)
    private let message = UILabel.wrapping(font: .customBody(size: 16.0), color: LightColors.Background.one)
    private let image = UIImageView()

    override func draw(_ rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.blueGradientStart.cgColor, UIColor.blueGradientEnd.cgColor] as CFArray
        let locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.drawLinearGradient(gradient, start: CGPoint(x: rect.midX, y: 0.0), end: CGPoint(x: rect.midX, y: rect.height), options: [])
    }

    private func setup() {
        addSubview(close)
        addSubview(image)
        addSubview(message)
        close.constrain([
            close.topAnchor.constraint(equalTo: topAnchor, constant: E.isIPhoneX ? Margins.extraHuge.rawValue : Margins.large.rawValue),
            close.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            close.widthAnchor.constraint(equalToConstant: 44.0),
            close.heightAnchor.constraint(equalToConstant: 44.0) ])
        image.constrain([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: topAnchor, constant: Margins.extraHuge.rawValue) ])
        message.constrain([
            message.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            message.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Margins.small.rawValue),
            message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue) ])
        close.tap = { [weak self] in
            self?.dismiss()
        }
        close.tintColor = LightColors.Background.one
        message.textAlignment = .center
    }

    func dismiss() {
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.bottomConstraint?.constant = 0.0
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
