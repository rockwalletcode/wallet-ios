// 
// Created by Equaleyes Solutions Ltd
//

import UIKit

class ManageAssetsButton: RoundedView {
    var didTap: (() -> Void)?
    
    private lazy var manageAssetsButton: UIButton = {
        let manageAssetsButton = UIButton()
        manageAssetsButton.translatesAutoresizingMaskIntoConstraints = false
        manageAssetsButton.titleLabel?.font = Fonts.button
        manageAssetsButton.tintColor = LightColors.primary
        manageAssetsButton.setTitleColor(LightColors.primary, for: .normal)
        manageAssetsButton.setTitleColor(LightColors.Disabled.one, for: .highlighted)
        
        manageAssetsButton.layer.borderColor = LightColors.primary.cgColor
        manageAssetsButton.layer.borderWidth = 1.5
        manageAssetsButton.layer.cornerRadius = CornerRadius.fullRadius.rawValue
        
        manageAssetsButton.contentHorizontalAlignment = .center
        manageAssetsButton.contentVerticalAlignment = .center
        
        manageAssetsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return manageAssetsButton
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        manageAssetsButton.layer.cornerRadius = manageAssetsButton.frame.height * CornerRadius.fullRadius.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func set(title: String) {
        manageAssetsButton.setTitle(title, for: .normal)
    }
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(manageAssetsButton)
        manageAssetsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        manageAssetsButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        manageAssetsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        manageAssetsButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    @objc private func buttonTapped() {
        didTap?()
    }
}
