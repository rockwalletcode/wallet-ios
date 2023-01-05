//
//  RWDrawer.swift
//  breadwallet
//
//  Created by Rok on 07/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

struct DrawerConfiguration: Configurable {
    var titleConfig = LabelConfiguration(font: Fonts.Subtitle.one,
                                         textColor: LightColors.secondary,
                                         textAlignment: .center)
    var background = BackgroundConfiguration(backgroundColor: LightColors.Background.two)
    var buttons = [
        Presets.Button.primary,
        Presets.Button.primary,
        Presets.Button.secondary
    ]
}

struct DrawerViewModel: ViewModel {
    var title: String? = L10n.Drawer.title
    var drawerImage: ImageViewModel? = .image(Asset.dragControl.image)
    var buttons: [ButtonViewModel] = [
        .init(title: L10n.Buy.buyWithCard, image: Asset.card.image),
        .init(title: L10n.Buy.fundWithAch, image: Asset.bank.image),
        .init(title: L10n.Drawer.Button.buyWithSell, image: Asset.withdrawal.image)
    ]
    var drawerBottomOffset = 0.0
}

class RWDrawer: FEView<DrawerConfiguration, DrawerViewModel> {
    
    var callbacks: [(() -> Void)] = []
    var isShown: Bool { return blurView.alpha == 1 }
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.alpha = 0
        return view
    }()
    
    lazy var drawer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CornerRadius.large.rawValue
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.huge.rawValue
        return view
    }()
    
    lazy var drawerImage: FEImageView = {
        let view = FEImageView()
        view.setup(with: .image(Asset.dragControl.image))
        return view
    }()
    
    lazy var title: WrapperView<FELabel> = {
        let view = WrapperView<FELabel>()
        return view
    }()
    
    lazy var buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        view.distribution = .fillEqually
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        isUserInteractionEnabled = false
        
        content.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        content.addSubview(drawer)
        drawer.snp.makeConstraints { make in
            make.top.equalTo(content.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        drawer.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Margins.huge.rawValue)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(Margins.huge.rawValue)
            make.bottom.equalToSuperview()
        }
        stack.addArrangedSubview(drawerImage)
        drawerImage.snp.makeConstraints { make in
            make.height.equalTo(Margins.extraSmall.rawValue)
        }
        
        stack.addArrangedSubview(title)
        title.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.small.rawValue)
        }
        
        stack.addArrangedSubview(buttonStack)
    }
    
    override func configure(with config: DrawerConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        title.wrappedView.configure(with: config.titleConfig)
        drawer.backgroundColor = config.background.backgroundColor
        content.backgroundColor = nil
    }
    
    override func setup(with viewModel: DrawerViewModel?) {
        guard let viewModel = viewModel, let config = config else { return }
        
        super.setup(with: viewModel)
        drawerImage.setup(with: viewModel.drawerImage)
        drawerImage.isHidden = viewModel.drawerImage == nil
        
        title.isHidden = viewModel.title == nil
        if let text = viewModel.title {
            title.wrappedView.setup(with: .text(text))
        }
        
        for ((vm, conf), callback) in zip(zip(viewModel.buttons, config.buttons), callbacks) {
            let button = FEButton()
            button.configure(with: conf)
            button.setup(with: vm)
            button.viewModel?.callback = { [weak self] in
                self?.hide()
                callback()
            }
            buttonStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(ViewSizes.Common.largeCommon.rawValue)
            }
        }

        buttonStack.isHidden = viewModel.buttons.isEmpty
        
        stack.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(viewModel.drawerBottomOffset)
        }
        
        content.layoutIfNeeded()
    }
    
    var contentChanged: (() -> Void)?
    
    func show() {
        guard blurView.alpha == 0 else { return }
        isUserInteractionEnabled = true
        
        drawer.snp.removeConstraints()
        drawer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        Self.animate(withDuration: Presets.Animation.long.rawValue) { [weak self] in
            self?.blurView.alpha = 1
            self?.drawer.layoutIfNeeded()
            self?.content.layoutIfNeeded()
            self?.layoutIfNeeded()
        }
    }
    
    func hide() {
        guard blurView.alpha == 1 else { return }
        isUserInteractionEnabled = false
        drawer.snp.removeConstraints()
        drawer.snp.makeConstraints { make in
            make.top.equalTo(content.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        Self.animate(withDuration: Presets.Animation.long.rawValue) { [weak self] in
            self?.blurView.alpha = 0
            self?.drawer.layoutIfNeeded()
            self?.content.layoutIfNeeded()
            self?.layoutIfNeeded()
        }
    }
    
    func toggle() {
        guard blurView.alpha == 0 else {
            return hide()
        }
        
        show()
    }
}
