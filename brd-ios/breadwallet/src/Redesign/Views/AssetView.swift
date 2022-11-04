// 
//  AssetView.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct AssetConfiguration: Configurable {
    var topConfiguration: LabelConfiguration?
    var bottomConfiguration: LabelConfiguration?
    var topRightConfiguration: LabelConfiguration?
    var bottomRightConfiguration: LabelConfiguration?
    var backgroundConfiguration: BackgroundConfiguration?
    var imageConfig: BackgroundConfiguration?
    var imageSize: ViewSizes = .medium
    var imageAlpha: CGFloat = 1.0
    var imageBackground = BackgroundConfiguration(border: BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius))
}

struct AssetViewModel: ViewModel, ItemSelectable {
    var icon: UIImage?
    var title: String?
    var subtitle: String?
    var topRightText: String?
    var bottomRightText: String?
    var isDisabled = false
    
    var displayName: String? {
        return title
    }
    
    var displayImage: ImageViewModel? {
        return .image(icon)
    }
}

class AssetView: FEView<AssetConfiguration, AssetViewModel> {
    private lazy var iconView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        return view
    }()
    
    private lazy var titleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var subtitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var valueStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var topRightLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var bottomRightLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(content.snp.leadingMargin)
            make.top.equalTo(content.snp.topMargin).priority(.low)
            make.centerY.equalToSuperview()
            make.height.equalTo(ViewSizes.large.rawValue)
            make.width.equalTo(ViewSizes.large.rawValue)
        }
        
        content.addSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Margins.medium.rawValue)
            make.centerY.equalToSuperview()
            make.top.equalTo(content.snp.topMargin)
            make.width.greaterThanOrEqualTo(ViewSizes.extralarge.rawValue)
        }
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        
        content.addSubview(valueStack)
        valueStack.snp.makeConstraints { make in
            make.trailing.equalTo(content.snp.trailingMargin)
            make.leading.equalTo(titleStack.snp.trailing).offset(Margins.small.rawValue)
            make.centerY.equalToSuperview()
            make.top.equalTo(content.snp.topMargin)
            make.width.lessThanOrEqualToSuperview().priority(.low)
        }
        
        valueStack.addArrangedSubview(topRightLabel)
        valueStack.addArrangedSubview(bottomRightLabel)
    }
    
    override func configure(with config: AssetConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        titleLabel.configure(with: config.topConfiguration)
        topRightLabel.configure(with: config.topRightConfiguration)
        
        subtitleLabel.configure(with: config.bottomConfiguration)
        bottomRightLabel.configure(with: config.bottomRightConfiguration)
        
        iconView.wrappedView.configure(background: config.imageBackground)
        iconView.content.alpha = config.imageAlpha
        iconView.snp.updateConstraints { make in
            make.height.equalTo(config.imageSize.rawValue)
            make.width.equalTo(config.imageSize.rawValue)
        }
        
        configure(background: config.backgroundConfiguration)
    }
    
    override func setup(with viewModel: AssetViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        iconView.wrappedView.setup(with: .image(viewModel.icon))
        
        titleLabel.setup(with: .text(viewModel.title))
        titleLabel.isHidden = viewModel.title == nil
        
        subtitleLabel.setup(with: .text(viewModel.subtitle))
        subtitleLabel.isHidden = viewModel.subtitle == nil
        
        topRightLabel.setup(with: .text(viewModel.topRightText))
        topRightLabel.isHidden = viewModel.topRightText == nil || viewModel.isDisabled
        
        bottomRightLabel.setup(with: .text(viewModel.bottomRightText))
        bottomRightLabel.isHidden = viewModel.bottomRightText == nil || viewModel.isDisabled
        
        valueStack.isHidden = topRightLabel.isHidden && bottomRightLabel.isHidden
    }
}
