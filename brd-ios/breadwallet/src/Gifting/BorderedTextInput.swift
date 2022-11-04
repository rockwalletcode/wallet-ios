// 
//  BorderedTextInput.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-11-20.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class BorderedTextInput: UIView {
    
    private let placeholder = UILabel(font: Fonts.Title.one, color: LightColors.Contrast.two)
    private let placeholderText: String
    private let keyboardType: UIKeyboardType
    private let unit = UILabel(font: Fonts.Body.one, color: LightColors.Contrast.two)
    var didUpdate: ((String?) -> Void)?
    let textField = UITextField()
    
    func setInvalid() {
        textField.textColor = UIColor.red
    }
    
    func setValid() {
        textField.textColor = .black
    }
    
    func clear() {
        textField.text = nil
    }
    
    init(placeholder: String,
         keyboardType: UIKeyboardType) {
        self.placeholderText = placeholder
        self.keyboardType = keyboardType
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        addSubview(placeholder)
        addSubview(textField)
        addSubview(unit)
    }
    
    private func setupConstraints() {
        placeholder.constrain([
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.small.rawValue),
            placeholder.topAnchor.constraint(equalTo: topAnchor, constant: Margins.small.rawValue)])
        unit.constrain([
            unit.leadingAnchor.constraint(equalTo: placeholder.leadingAnchor),
            unit.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
        textField.constrain([
            textField.leadingAnchor.constraint(equalTo: placeholder.leadingAnchor, constant: Margins.large.rawValue),
            textField.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: Margins.small.rawValue),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            textField.heightAnchor.constraint(equalToConstant: 44.0),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Margins.small.rawValue)])
        if keyboardType == .decimalPad {
            unit.text = "$"
        }
    }
    
    private func setInitialData() {
        if keyboardType == .decimalPad {
            let toolBar = UIToolbar()
                 toolBar.sizeToFit()
                 let button = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                                  action: #selector(dismiss))
                 toolBar.setItems([button], animated: true)
                 toolBar.isUserInteractionEnabled = true
                 textField.inputAccessoryView = toolBar
        }
        
        textField.keyboardType = keyboardType
        textField.font = Fonts.Body.one
        textField.textColor = LightColors.Text.one
        textField.returnKeyType = .done
        textField.delegate = self
        placeholder.text = placeholderText
        backgroundColor = LightColors.Background.one.withAlphaComponent(0.1)
        layer.cornerRadius = 4
        layer.borderWidth = 0.5
        layer.borderColor = LightColors.Background.one.withAlphaComponent(0.85).cgColor
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func dismiss() {
        textField.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        let maxLength = 100
        guard let newText = textField.text, newText.utf8.count > maxLength else {
            didUpdate?(textField.text)
            return }
        textField.text = String(newText[newText.startIndex..<newText.index(newText.startIndex, offsetBy: maxLength)])
        didUpdate?(textField.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BorderedTextInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
