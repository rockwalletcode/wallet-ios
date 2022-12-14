// 
//  Dot.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-09-05.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class Dot: UIView {
    
    private let size: CGFloat = 2.0
    private let shadowSize: CGFloat = 10.0
    private var startFrame: CGRect?
    private var endFrame: CGRect?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: size - shadowSize, dy: size - shadowSize), cornerRadius: shadowSize).cgPath
        layer.cornerRadius = size/2.0
        alpha = 0.0
    }
    
    func addTo(_ view: UIView) {
        let startX = CGFloat.random(in: 0.0...view.bounds.width)
        let startY = CGFloat.random(in: (view.bounds.height - 25.0)...view.bounds.height)
        let endY = CGFloat.random(in: (startY - 80.0)...(startY - 40.0))
        frame = CGRect(x: startX, y: startY, width: size, height: size)
        startFrame = frame
        endFrame = CGRect(x: startX, y: endY, width: size, height: size)
        view.addSubview(self)
    }
    
    func animate(withDelay delay: TimeInterval) {
        UIView.animateKeyframes(withDuration: 4.0, delay: delay, options: .calculationModeCubic, animations: { [weak self] in
             UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.05, animations: {
                self?.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.7, animations: {
                if let endFrame = self?.endFrame {
                    self?.frame = endFrame
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2, animations: {
                self?.alpha = 0.0
            })
        }, completion: { [weak self] _ in
            self?.reset()
            self?.animate(withDelay: delay)
        })
    }
    
    func reset() {
        self.frame = startFrame!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
