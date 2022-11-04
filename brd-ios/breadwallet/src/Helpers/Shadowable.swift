// 
// Created by Equaleyes Solutions Ltd
//

import UIKit

protocol Shadowable {
    var shadowColor: CGColor { get set }
    var shadowOpacity: Float { get set }
    var shadowOffset: CGSize { get set }
    var shadowRadius: CGFloat { get set }
}

extension Shadowable where Self: UIView {
    func setupLayer() {
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
