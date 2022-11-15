// 
//  FEView.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class FEView<C: Configurable, M: ViewModel>: UIView,
                                             ViewProtocol,
                                             Shadable,
                                             Borderable,
                                             Reusable {
    // MARK: NCViewProtocol
    
    var config: C?
    var viewModel: M?
    
    private var shadow: ShadowConfiguration?
    private var background: BackgroundConfiguration?
    
    // MARK: Lazy UI
    
    var backgroundView: UIView?
    
    lazy var content: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Initializers
    required override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init(config: C) {
        self.config = config
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    // MARK: View setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(with: config)
        configure(background: background)
        configure(shadow: shadow)
    }
    
    func setupSubviews() {
        addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(snp.margins)
        }
        
        shadowView.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalTo(shadowView)
        }
        
        setupClearMargins()
        shadowView.setupClearMargins()
        content.setupClearMargins()
    }
    
    func setup(with viewModel: M?) {
        self.viewModel = viewModel
    }
    
    func configure(with config: C?) {
        self.config = config
    }
    
    func prepareForReuse() {
        config = nil
        viewModel = nil
    }
    
    func configure(shadow: ShadowConfiguration?) {
        guard let shadow = shadow else { return }
        
        self.shadow = shadow
        
        shadowView.layer.setShadow(with: shadow)
    }
    
    func configure(background: BackgroundConfiguration?) {
        guard let background = background else { return }
        
        self.background = background
        
        layoutIfNeeded()
        
        (backgroundView ?? content).setBackground(with: background)
    }
}
