//
//  DoubleHorizontalTextboxView.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct DoubleHorizontalTextboxViewConfiguration: Configurable {
}

struct DoubleHorizontalTextboxViewModel: ViewModel {
    var primaryTitle: LabelViewModel?
    var secondaryTitle: LabelViewModel?
    var primary: TextFieldModel?
    var secondary: TextFieldModel?
}

class DoubleHorizontalTextboxView: FEView<DoubleHorizontalTextboxViewConfiguration, DoubleHorizontalTextboxViewModel> {
    var contentSizeChanged: (() -> Void)?
    var valueChanged: ((_ first: String?, _ second: String?) -> Void)?
    var didTriggerDateField: (() -> Void)?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var contentStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var titleStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    private lazy var mainTitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var secondaryTitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var primaryTextField: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private lazy var secondaryTextField: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private var first: String?
    private var second: String?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        stack.addArrangedSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        titleStack.addArrangedSubview(mainTitleLabel)
        titleStack.addArrangedSubview(secondaryTitleLabel)
        
        stack.addArrangedSubview(contentStack)
        contentStack.addArrangedSubview(primaryTextField)
        contentStack.addArrangedSubview(secondaryTextField)
    }
    
    override func configure(with config: DoubleHorizontalTextboxViewConfiguration?) {
        super.configure(with: config)
        
        mainTitleLabel.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        secondaryTitleLabel.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        primaryTextField.configure(with: Presets.TextField.primary)
        secondaryTextField.configure(with: Presets.TextField.primary)
    }
    
    override func setup(with viewModel: DoubleHorizontalTextboxViewModel?) {
        super.setup(with: viewModel)
        
        mainTitleLabel.setup(with: viewModel?.primaryTitle)
        secondaryTitleLabel.setup(with: viewModel?.secondaryTitle)
        
        mainTitleLabel.isHidden = viewModel?.primaryTitle == nil
        secondaryTitleLabel.isHidden = viewModel?.secondaryTitle == nil
        titleStack.isHidden = viewModel?.primaryTitle == nil && viewModel?.secondaryTitle == nil
        
        first = viewModel?.primary?.value
        second = viewModel?.secondary?.value
        primaryTextField.setup(with: viewModel?.primary)
        secondaryTextField.setup(with: viewModel?.secondary)
        
        primaryTextField.valueChanged = { [weak self] in
            self?.first = $0
            self?.stateChanged()
        }
        
        secondaryTextField.valueChanged = { [weak self] in
            self?.second = $0
            self?.stateChanged()
        }
        
        stack.layoutIfNeeded()
    }
    
    private func stateChanged() {
        valueChanged?(first, second)
        
        Self.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.content.layoutIfNeeded()
            self?.contentSizeChanged?()
        }
    }
}
