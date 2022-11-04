// 
//  KYCCameraShutter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 14/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

open class KYShutterButton: UIButton {
    private let _kstartAnimateDuration: CFTimeInterval = 0.5
    
    /**************************************************************************/
     // MARK: - Properties
     /**************************************************************************/
    
    public var buttonColor: UIColor = UIColor.red {
        didSet {
            _circleLayer.fillColor = buttonColor.cgColor
        }
    }
    
    public var arcColor: UIColor = UIColor.white {
        didSet {
            _arcLayer.strokeColor = arcColor.cgColor
        }
    }
    
    public var progressColor: UIColor = UIColor.white {
        didSet {
            _progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    private var _arcWidth: CGFloat {
        return bounds.width * 0.09090
    }
    
    private var _arcMargin: CGFloat {
        return bounds.width * 0.03030
    }
    
    lazy private var _circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path      = self._circlePath.cgPath
        layer.fillColor = self.buttonColor.cgColor
        return layer
    }()
    
    lazy private var _arcLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path        = self._arcPath.cgPath
        layer.fillColor   = UIColor.clear.cgColor
        layer.strokeColor = self.arcColor.cgColor
        layer.lineWidth   = self._arcWidth
        return layer
    }()
    
    lazy private var _progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path  = self.p_arcPathWithProgress(1.0, clockwise: true)
        layer.path            = path.cgPath
        layer.fillColor       = UIColor.clear.cgColor
        layer.strokeColor     = self.progressColor.cgColor
        layer.lineWidth       = self._arcWidth/1.5
        return layer
    }()
    
    private var _circlePath: UIBezierPath {
        let side = self.bounds.width - self._arcWidth*2 - self._arcMargin*2
        return UIBezierPath(
            roundedRect: CGRect(x: bounds.width/2 - side/2, y: bounds.width/2 - side/2, width: side, height: side),
            cornerRadius: side/2
        )
    }
    
    private var _arcPath: UIBezierPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
            radius: self.bounds.width/2 - self._arcWidth/2,
            startAngle: -.pi/2,
            endAngle: .pi*2 - .pi/2,
            clockwise: true
        )
    }
    
    private var _roundRectPath: UIBezierPath {
        let side = bounds.width * 0.4242
        return UIBezierPath(
            roundedRect: CGRect(x: bounds.width/2 - side/2, y: bounds.width/2 - side/2, width: side, height: side),
            cornerRadius: side * 0.107
        )
    }
    
    /**************************************************************************/
     // MARK: - initialize
     /**************************************************************************/
    
    @objc
    public convenience init(frame: CGRect, buttonColor: UIColor) {
        self.init(frame: frame)
        self.buttonColor = buttonColor
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = _circleLayer.path
        animation.duration  = 0.15
        
        animation.toValue = _circlePath.cgPath
        _circleLayer.add(animation, forKey: "path-anim")
        _circleLayer.path = _circlePath.cgPath
        
        updateLayers()
    }
    
    /**************************************************************************/
     // MARK: - Override
     /**************************************************************************/
    
    @objc
    override open var isHighlighted: Bool {
        didSet {
            _circleLayer.opacity = isHighlighted ? 0.5 : 1.0
        }
    }
    
    @objc
    open override func layoutSubviews() {
        super.layoutSubviews()
        if _arcLayer.superlayer != layer {
            layer.addSublayer(_arcLayer)
        } else {
            _arcLayer.path      = _arcPath.cgPath
            _arcLayer.lineWidth = _arcWidth
        }
        
        if _progressLayer.superlayer != layer {
            layer.addSublayer(_progressLayer)
        } else {
            _progressLayer.path      = p_arcPathWithProgress(1).cgPath
            _progressLayer.lineWidth = _arcWidth/1.5
        }
        
        if _circleLayer.superlayer != layer {
            layer.addSublayer(_circleLayer)
        } else {
            _circleLayer.path = _circlePath.cgPath
        }
        
        updateLayers()
    }
    
    @objc
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle("", for: state)
    }
    
    /**************************************************************************/
     // MARK: - Method
     /**************************************************************************/
    
    private func p_arcPathWithProgress(_ progress: CGFloat, clockwise: Bool = true) -> UIBezierPath {
        let diameter = 2*CGFloat.pi*(self.bounds.width/2 - self._arcWidth/3)
        let startAngle = clockwise ?
            -CGFloat.pi/2 :
            -CGFloat.pi/2 + CGFloat.pi*(540/diameter)/180
        let endAngle   = clockwise ?
            CGFloat.pi*2*progress - CGFloat.pi/2 :
            CGFloat.pi*2*progress - CGFloat.pi/2 + CGFloat.pi*(540/diameter)/180
        let path = UIBezierPath(
            arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
            radius: self.bounds.width/2 - self._arcWidth/3,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        return path
    }
    
    private func updateLayers() {
        _arcLayer.lineDashPattern = nil
        _progressLayer.isHidden = true
    }
    
}
