// 
//  WrapperView.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

class WrapperView<T: UIView>: UIView,
                              Wrappable,
                              Reusable,
                              Borderable {
    // MARK: Lazy UI
    
    lazy var content = UIView()
    lazy var wrappedView = T()
    private var shadow: ShadowConfiguration?
    private var background: BackgroundConfiguration?
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Overrides
    
    override var tintColor: UIColor! {
        didSet {
            wrappedView.tintColor = tintColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: background)
        configure(shadow: shadow)
    }

    func setupSubviews() {
        addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(snp.margins)
        }
        setupCustomMargins(all: .zero)
        
        shadowView.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalTo(shadowView.snp.margins)
        }
        shadowView.setupCustomMargins(all: .zero)
        
        content.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupCustomMargins(all: .zero)
        
        isUserInteractionEnabled = true
        content.isUserInteractionEnabled = true
        wrappedView.isUserInteractionEnabled = true
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }

    func prepareForReuse() {
        guard let reusable = wrappedView as? Reusable else { return }
        reusable.prepareForReuse()
    }
    
    func configure(shadow: ShadowConfiguration?) {
        guard let shadow = shadow else { return }
        
        self.shadow = shadow
        
        shadowView.layer.setShadow(with: shadow)
    }
    
    func configure(background: BackgroundConfiguration?) {
        guard let background = background else { return }
        
        self.background = background
        
        tintColor = background.tintColor
        
        layoutIfNeeded()
        
        content.setBackground(with: background)
    }
}
