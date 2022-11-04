// 
//  ChecklistItemView.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ChecklistItemConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.Body.one, textColor: LightColors.Text.two)
    var image: BackgroundConfiguration? = .init(backgroundColor: .clear, tintColor: LightColors.primary)
}

struct ChecklistItemViewModel: ViewModel {
    var title: LabelViewModel?
    var image: ImageViewModel? = .imageName("check")
}

class ChecklistItemView: FEView<ChecklistItemConfiguration, ChecklistItemViewModel> {
    private lazy var checkmarkImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(content.snp.top).inset(Margins.extraSmall.rawValue)
            make.leading.equalTo(content.snp.leading)
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
            make.width.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkImageView.snp.trailing).offset(Margins.medium.rawValue)
            make.trailing.equalTo(content.snp.trailing)
            make.top.equalTo(checkmarkImageView.snp.top)
            make.bottom.equalTo(content.snp.bottom)
        }
    }
    
    override func configure(with config: ChecklistItemConfiguration?) {
        super.configure(with: config)
        checkmarkImageView.configure(with: config?.image)
        titleLabel.configure(with: config?.title)
    }
    
    override func setup(with viewModel: ChecklistItemViewModel?) {
        super.setup(with: viewModel)
        checkmarkImageView.setup(with: viewModel?.image)
        titleLabel.setup(with: viewModel?.title)
        
        guard viewModel?.image == nil else { return }
        
        checkmarkImageView.snp.remakeConstraints { make in
            make.top.equalTo(content.snp.top).inset(Margins.extraSmall.rawValue)
            make.leading.equalTo(content.snp.leading)
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
            make.width.equalTo(0)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(checkmarkImageView.snp.trailing)
            make.trailing.equalTo(content.snp.trailing)
            make.top.equalTo(checkmarkImageView.snp.top)
            make.bottom.equalTo(content.snp.bottom)
        }
    }
}
