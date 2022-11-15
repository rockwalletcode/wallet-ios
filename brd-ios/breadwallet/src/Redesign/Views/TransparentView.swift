// 
//  TransparentView.swift
//  breadwallet
//
//  Created by Rok on 03/06/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct TransparentViewConfiguration: Configurable {
    var background = BackgroundConfiguration(backgroundColor: LightColors.Contrast.two.withAlphaComponent(0.8),
                                             tintColor: LightColors.Success.one)
    var title: LabelConfiguration?
}

enum TransparentViewModel: ViewModel {
    case success
    case loading
    case blur
    
    var imageName: String? {
        switch self {
        case .success:
            return "check"
            
        default:
            return nil
        }
    }
    
    var duration: Double {
        switch self {
        case .success:
            return 2.0
            
        default:
            return 0.0
        }
    }
    
    var title: String? { return nil }
}

class TransparentView: FEView<TransparentViewConfiguration, TransparentViewModel> {
    
    var didHide: (() -> Void)?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var imageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var blurView: UIView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.alpha = 0
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stack.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.height)
            make.height.equalTo(ViewSizes.extralarge.rawValue)
        }
        
        stack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(Margins.extraLarge.rawValue)
        }
        
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configure(with config: TransparentViewConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        backgroundColor = config.background.backgroundColor
        imageView.configure(with: .init(tintColor: config.background.tintColor))
        titleLabel.configure(with: config.title)
    }
    
    override func setup(with viewModel: TransparentViewModel?) {
        super.setup(with: viewModel)
        
        if let image = viewModel?.imageName {
            imageView.setup(with: .imageName(image))
        }
        imageView.isHidden = viewModel?.imageName == nil
        
        titleLabel.setup(with: .text(viewModel?.title))
        titleLabel.isHidden = viewModel?.title == nil
        
        guard viewModel == .blur else { return }
        blurView.alpha = 1
        bringSubviewToFront(blurView)
    }
    
    func show() {
        alpha = 0
        Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.alpha = 1
        }
        
        // autodismiss
        guard let delay = viewModel?.duration else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        Self.animate(withDuration: Presets.Animation.duration, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
            self?.didHide?()
        })
    }
}
