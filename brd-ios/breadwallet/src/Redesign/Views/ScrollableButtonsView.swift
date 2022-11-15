// 
//  ScrollableButtonsView.swift
//  breadwallet
//
//  Created by Rok on 03/06/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ScrollableButtonsConfiguration: Configurable {
    var background: BackgroundConfiguration?
    var buttons: [ButtonConfiguration] = []
    var isDoubleButtonStack = false
}

struct ScrollableButtonsViewModel: ViewModel {
    var buttons: [ButtonViewModel] = []
}

class ScrollableButtonsView: FEView<ScrollableButtonsConfiguration, ScrollableButtonsViewModel> {
    var callbacks: [(() -> Void)] = []
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    private var buttons: [FEButton] = []
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.setupClearMargins()
        
        content.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(ViewSizes.Common.largeCommon.rawValue)
        }
        
        scrollView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalToSuperview()
        }
    }
    
    override func configure(with config: ScrollableButtonsConfiguration?) {
        super.configure(with: config)
        
        configure(background: config?.background)
        
        setupButtons()
    }
    
    private func setupButtons() {
        guard let viewModel = viewModel, let config = config else { return }
        
        buttons = []
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, model) in viewModel.buttons.enumerated() {
            let button = FEButton()
            
            var buttonConfig: ButtonConfiguration?
            if index < config.buttons.count {
                buttonConfig = config.buttons[index]
            } else {
                buttonConfig = config.buttons.last
            }
            
            button.configure(with: buttonConfig)
            button.setup(with: model)
            
            buttons.append(button)
            stack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        if config.isDoubleButtonStack {
            stack.distribution = .fillProportionally
            stack.spacing = Margins.medium.rawValue
        } else {
            stack.distribution = .fill
            stack.spacing = Margins.huge.rawValue
            
            let spacer = UIView()
            stack.addArrangedSubview(spacer)
            
            spacer.snp.makeConstraints { make in
                make.width.greaterThanOrEqualToSuperview().priority(.low)
            }
        }
        
        stack.layoutIfNeeded()
    }
    
    // MARK: - User interaction
    @objc private  func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(where: { $0 == sender }) else { return }
        
        if index >= callbacks.count {
            callbacks.last?()
        } else {
            callbacks[index]()
        }
    }
}
