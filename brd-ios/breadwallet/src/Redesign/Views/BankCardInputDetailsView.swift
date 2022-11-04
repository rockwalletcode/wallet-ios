// 
//  BankCardInputDetailsView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 04/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct BankCardInputDetailsViewConfiguration: Configurable {
}

struct BankCardInputDetailsViewModel: ViewModel {
    var number: TextFieldModel?
    var expiration: TextFieldModel?
    var cvv: TextFieldModel?
}

class BankCardInputDetailsView: FEView<BankCardInputDetailsViewConfiguration, BankCardInputDetailsViewModel>, UITextFieldDelegate {
    var contentSizeChanged: (() -> Void)?
    var valueChanged: ((_ number: String?, _ cvv: String?) -> Void)?
    var didTriggerExpirationField: (() -> Void)?
    var didTapCvvInfo: (() -> Void)?
    
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
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    private lazy var expirationStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    private lazy var securityStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    private lazy var numberTextField: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private lazy var expirationTextField: FETextField = {
        let view = FETextField()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var cvvTextField: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private var number: String?
    private var expiration: String?
    private var cvv: String?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        stack.addArrangedSubview(contentStack)
        contentStack.addArrangedSubview(numberTextField)
        contentStack.addArrangedSubview(securityStack)
        securityStack.addArrangedSubview(expirationStack)
        expirationStack.addArrangedSubview(expirationTextField)
        securityStack.addArrangedSubview(cvvTextField)
        
        expirationStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerExpirationField)))
    }
    
    override func configure(with config: BankCardInputDetailsViewConfiguration?) {
        super.configure(with: config)
        
        numberTextField.configure(with: Presets.TextField.number)
        expirationTextField.configure(with: Presets.TextField.number)
        cvvTextField.configure(with: Presets.TextField.number.setSecure(true))
    }
    
    override func setup(with viewModel: BankCardInputDetailsViewModel?) {
        super.setup(with: viewModel)
        
        number = viewModel?.number?.value
        expiration = viewModel?.expiration?.value
        cvv = viewModel?.cvv?.value
        
        numberTextField.setup(with: viewModel?.number)
        expirationTextField.setup(with: viewModel?.expiration)
        cvvTextField.setup(with: viewModel?.cvv)
        
        numberTextField.valueChanged = { [weak self] in
            self?.number = $0
            self?.stateChanged()
        }
        
        cvvTextField.valueChanged = { [weak self] in
            self?.cvv = $0
            self?.stateChanged()
        }
        
        cvvTextField.didTapTrailingView = { [weak self] in
            self?.cvvInfoButtonTapped()
        }
        
        stack.layoutIfNeeded()
    }
    
    @objc private func triggerExpirationField() {
        didTriggerExpirationField?()
        
        endEditing(true)
    }
    
    private func stateChanged() {
        valueChanged?(number, cvv)
    }
    
    private func cvvInfoButtonTapped() {
        didTapCvvInfo?()
    }
}
