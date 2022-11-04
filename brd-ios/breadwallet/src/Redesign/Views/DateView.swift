// 
//  DateView.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct DateConfiguration: Configurable {
    var normal: BackgroundConfiguration = Presets.Background.Primary.normal
    var selected: BackgroundConfiguration = Presets.Background.Primary.selectedPickerTextField
}

struct DateViewModel: ViewModel {
    var date: Date?
    var title: LabelViewModel?
    var month: TextFieldModel?
    var day: TextFieldModel?
    var year: TextFieldModel?
}

class DateView: FEView<DateConfiguration, DateViewModel>, StateDisplayable {
    
    var contentSizeChanged: (() -> Void)?
    var didPresentPicker: (() -> Void)?
    var displayState: DisplayState = .normal
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var dateStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var monthTextfield: FETextField = {
        let view = FETextField()
        view.isUserInteractionEnabled = false
        view.hideTitleForState = .filled
        return view
    }()
    
    private lazy var dayTextField: FETextField = {
        let view = FETextField()
        view.isUserInteractionEnabled = false
        view.hideTitleForState = .filled
        return view
    }()
    
    private lazy var yearTextField: FETextField = {
        let view = FETextField()
        view.isUserInteractionEnabled = false
        view.hideTitleForState = .filled
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        stack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        stack.addArrangedSubview(dateStack)
        dateStack.addArrangedSubview(monthTextfield)
        dateStack.addArrangedSubview(dayTextField)
        dateStack.addArrangedSubview(yearTextField)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerPresentPicker)))
    }
    
    override func configure(with config: DateConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        
        monthTextfield.configure(with: Presets.TextField.primary)
        dayTextField.configure(with: Presets.TextField.primary)
        yearTextField.configure(with: Presets.TextField.primary)
    }
    
    override func setup(with viewModel: DateViewModel?) {
        super.setup(with: viewModel)

        titleLabel.setup(with: viewModel?.title)
        monthTextfield.setup(with: viewModel?.month)
        dayTextField.setup(with: viewModel?.day)
        yearTextField.setup(with: viewModel?.year)
        
        animateTo(state: .normal)
    }
    
    @objc private func triggerPresentPicker() {
        didPresentPicker?()
        
        animateTo(state: .selected)
    }
    
    func animateTo(state: DisplayState, withAnimation: Bool = true) {
        guard let config = config else { return }
        
        let background: BackgroundConfiguration?
        
        switch state {
        case .selected:
            background = config.selected
            
        default:
            background = config.normal
        }
        
        displayState = state
        monthTextfield.configure(background: background)
        dayTextField.configure(background: background)
        yearTextField.configure(background: background)
    }
}
