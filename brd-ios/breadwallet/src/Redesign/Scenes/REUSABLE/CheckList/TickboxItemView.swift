// 
//  TickboxItemView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct TickboxItemConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two)
}

struct TickboxItemViewModel: ViewModel {
    var title: LabelViewModel?
}

class TickboxItemView: FEView<TickboxItemConfiguration, TickboxItemViewModel> {
    private lazy var checkmarkButton: FEButton = {
        let view = FEButton()
        view.setImage(UIImage(named: "checkbox"), for: .normal)
        view.setImage(UIImage(named: "checkbox-selected"), for: .selected)
        view.addTarget(self, action: #selector(tickboxTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    var didToggleTickbox: ((Bool) -> Void)?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(checkmarkButton)
        checkmarkButton.snp.makeConstraints { make in
            make.top.equalTo(content.snp.top).inset(Margins.extraSmall.rawValue)
            make.leading.equalTo(content.snp.leading)
            make.height.equalTo(checkmarkButton.snp.width)
            make.width.equalTo(Margins.extraLarge.rawValue)
        }
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(Margins.medium.rawValue)
            make.trailing.equalTo(content.snp.trailing)
            make.top.equalTo(checkmarkButton.snp.top)
            make.bottom.equalTo(content.snp.bottom)
        }
    }
    
    override func configure(with config: TickboxItemConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: config?.title)
    }
    
    override func setup(with viewModel: TickboxItemViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
    }
    
    // MARK: - User interaction
    
    @objc private func tickboxTapped(_ sender: UIButton?) {
        sender?.isSelected.toggle()
        
        didToggleTickbox?(sender?.isSelected ?? false)
    }
}
