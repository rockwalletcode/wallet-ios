// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import UIKit

class AboutHeaderView: UIView {
    private lazy var mainLogoView: UIImageView = {
        let mainLogoView = UIImageView(image: UIImage(named: "logo_icon"))
        mainLogoView.translatesAutoresizingMaskIntoConstraints = false
        mainLogoView.contentMode = .scaleAspectFit
        
        return mainLogoView
    }()
    
    private lazy var mainLogoTextView: UIImageView = {
        let mainLogoTextView = UIImageView(image: UIImage(named: "logo"))
        mainLogoTextView.translatesAutoresizingMaskIntoConstraints = false
        mainLogoTextView.contentMode = .scaleAspectFit
        
        return mainLogoTextView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView(color: LightColors.Outline.two)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(mainLogoView)
        addSubview(mainLogoTextView)
        addSubview(separator)
        
        mainLogoView.constrain([
            mainLogoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLogoView.topAnchor.constraint(equalTo: topAnchor, constant: Margins.large.rawValue),
            mainLogoView.widthAnchor.constraint(equalToConstant: 50),
            mainLogoView.heightAnchor.constraint(equalToConstant: 50) ])
        mainLogoTextView.constrain([
            mainLogoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            mainLogoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            mainLogoTextView.topAnchor.constraint(equalTo: mainLogoView.bottomAnchor, constant: Margins.large.rawValue),
            mainLogoTextView.heightAnchor.constraint(equalTo: mainLogoView.heightAnchor) ])
        separator.constrain([
            separator.topAnchor.constraint(equalTo: mainLogoTextView.bottomAnchor, constant: Margins.huge.rawValue),
            separator.leadingAnchor.constraint(equalTo: mainLogoTextView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: mainLogoTextView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0) ])
    }
}
