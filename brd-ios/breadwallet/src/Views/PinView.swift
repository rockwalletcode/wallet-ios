//
//  PinView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-28.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum PinViewStyle {
    case create
    case login
    case verify
    case confirm
}

class PinView: UIView {

    // MARK: - Public
    var width: CGFloat {
        return CGFloat(length) * ViewSizes.small.rawValue + CGFloat(length - 1) * Margins.large.rawValue
    }
    
    let shakeDuration: CFTimeInterval = 0.6
    fileprivate var shakeCompletion: (() -> Void)?

    init(style: PinViewStyle, length: Int) {
        self.style = style
        self.length = length
        
        filled = (0...(length-1)).map { _ in Circle(color: LightColors.primary, style: .filled) }
        unFilled = (0...(length-1)).map { _ in Circle(color: LightColors.primary, style: .unfilled) }

        super.init(frame: CGRect())
        setupSubviews()
    }

    func fill(_ number: Int) {
        filled.enumerated().forEach { index, circle in
            circle.isHidden = index > number-1
        }
        unFilled.enumerated().forEach { index, circle in
            circle.isHidden = index <= number-1
        }
    }

    func shake(completion: (() -> Void)? = nil) {
        shakeCompletion = completion
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.y")
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            self.toRadian(value: $0)
        }
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = shakeDuration
        shakeGroup.delegate = self
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }

    // MARK: - Private
    private let unFilled: [UIView]
    private var filled: [UIView]
    private let style: PinViewStyle
    private let length: Int
    private let gradientView = MotionGradientView()

    private func toRadian(value: Int) -> CGFloat {
        return CGFloat(Double(value) / 180.0 * .pi)
    }

    private func setupSubviews() {
        addCircleContraints(unFilled)
        addCircleContraints(filled)
        filled.forEach { $0.isHidden = true }
    }

    private func addCircleContraints(_ circles: [UIView]) {
        let padding: CGFloat = Margins.large.rawValue
        let extraWidth: CGFloat = 0.0
        circles.enumerated().forEach { index, circle in
            addSubview(circle)
            let leadingConstraint: NSLayoutConstraint?
            if index == 0 {
                leadingConstraint = circle.constraint(.leading, toView: self)
            } else {
                leadingConstraint = NSLayoutConstraint(item: circle,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: circles[index - 1],
                                                       attribute: .trailing,
                                                       multiplier: 1.0,
                                                       constant: padding)
            }
            circle.constrain([
                circle.constraint(.width, constant: ViewSizes.small.rawValue + extraWidth),
                circle.constraint(.height, constant: ViewSizes.small.rawValue),
                circle.constraint(.centerY, toView: self, constant: nil),
                leadingConstraint ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PinView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        shakeCompletion?()
    }
}
