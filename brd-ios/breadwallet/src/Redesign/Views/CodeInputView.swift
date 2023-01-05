// 
//  CodeInputView.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct CodeInputConfiguration: Configurable {
    var normal: BackgroundConfiguration? = Presets.Background.TextField.normal
    var selected: BackgroundConfiguration? = Presets.Background.TextField.selected
    var error: BackgroundConfiguration? = Presets.Background.TextField.error
    var input: TextFieldConfiguration = .init(textConfiguration: .init(font: Fonts.Subtitle.one,
                                                                       textColor: LightColors.Text.one,
                                                                       textAlignment: .center,
                                                                       numberOfLines: 1))
    var errorLabel: LabelConfiguration = .init(font: Fonts.Body.three, textColor: LightColors.Error.one)
}

struct CodeInputViewModel: ViewModel {}

class CodeInputView: FEView<CodeInputConfiguration, CodeInputViewModel>, StateDisplayable {
    
    var numberOfFields: Int { return 6 }
    
    var contentSizeChanged: (() -> Void)?
    var valueChanged: ((String?) -> Void)?
    var displayState: DisplayState = .normal
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var inputStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var errorLabel: FELabel = {
        let view = FELabel()
        view.text = L10n.InputView.invalidCode
        view.isHidden = true
        return view
    }()
    
    private lazy var hiddenTextField: UITextField = {
        let view = UITextField()
        view.keyboardType = .numberPad
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(hiddenTextField)
        hiddenTextField.alpha = 0
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        stack.addArrangedSubview(inputStack)
        stack.addArrangedSubview(errorLabel)
        
        for _ in (0..<numberOfFields) {
            let view = FETextField()
            view.hideTitleForState = .filled
            view.isUserInteractionEnabled = false
            inputStack.addArrangedSubview(view)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        hiddenTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func configure(background: BackgroundConfiguration? = nil) {
        guard let background = background else { return }
        
        inputStack.arrangedSubviews.forEach { textField in
            textField.setBackground(with: background)
        }
    }
    
    override func configure(with config: CodeInputConfiguration?) {
        super.configure(with: config)
        
        errorLabel.configure(with: config?.errorLabel)
        configure(background: config?.normal)
        
        inputStack.arrangedSubviews.forEach { field in
            (field as? FETextField)?.configure(with: config?.input)
        }
    }
    
    @objc private func tapped() {
        hiddenTextField.becomeFirstResponder()
        animateTo(state: .selected)
    }
    
    @objc func keyboardWillHide() {
        animateTo(state: .normal)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        valueChanged?(textField.text)
        
        guard let text = textField.text,
              text.count <= numberOfFields else {
            if let text = textField.text?.prefix(numberOfFields) {
                textField.text = String(text)
            }
            return
        }
        
        animateTo(state: .selected)
        
        let textArray = Array(text)
        for (index, field) in inputStack.arrangedSubviews.enumerated() {
            var value: String?
            if textArray.count > index {
                value = String(textArray[index])
            }
            
            (field as? FETextField)?.setup(with: .init(value: value))
        }
    }
    
    func animateTo(state: DisplayState, withAnimation: Bool = true) {
        guard let config = config else { return }
        
        let background: BackgroundConfiguration?
        switch state {
        case .selected:
            background = config.selected
            
        case .error:
            background = config.error
            
        default:
            background = config.normal
        }
        
        displayState = state
        configure(background: background)
        
        UIView.setAnimationsEnabled(withAnimation)
        
        Self.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.errorLabel.isHidden = state != .error
            
            self?.layoutIfNeeded()
            self?.contentSizeChanged?()
        }
        
        UIView.setAnimationsEnabled(true)
    }
    
    func showErrorMessage() {
        errorLabel.text = L10n.InputView.invalidCode
        animateTo(state: .error)
    }
}
