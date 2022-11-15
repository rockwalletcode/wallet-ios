// 
//  VerticalButtonsView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 14/11/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct VerticalButtonsConfiguration: Configurable {
    var background: BackgroundConfiguration?
    var buttons: [ButtonConfiguration] = []
}

struct VerticalButtonsViewModel: ViewModel {
    var buttons: [ButtonViewModel] = []
}

class VerticalButtonsView: FEView<VerticalButtonsConfiguration, VerticalButtonsViewModel> {
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    override func configure(with config: VerticalButtonsConfiguration?) {
        super.configure(with: config)
        
        configure(background: config?.background)
        
        setupButtons()
    }
    
    private func setupButtons() {
        guard let viewModel = viewModel, let config = config else { return }
        
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, model) in viewModel.buttons.enumerated() {
            let button = FEButton()
            
            button.configure(with: config.buttons[index])
            button.setup(with: model)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(model.isUnderlined ? ViewSizes.medium.rawValue : ViewSizes.Common.largeCommon.rawValue)
            }
            
            stack.addArrangedSubview(button)
        }
        
        stack.layoutIfNeeded()
    }
    
    // MARK: Helpers
    
    func getButton(_ from: FEButton) -> FEButton? {
        return (stack.arrangedSubviews as? [FEButton])?.first(where: { $0.viewModel?.title == from.viewModel?.title && $0.viewModel?.image == from.viewModel?.image }) as? FEButton
    }
}
