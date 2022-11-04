//
//  AddressCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class AddressCell: UIView {

    init(currency: Currency) {
        self.currency = currency
        super.init(frame: .zero)
        setupViews()
    }

    var address: String? {
        return contentLabel.text
    }

    var textDidChange: ((String?) -> Void)?
    var didBeginEditing: (() -> Void)?
    var didReceivePaymentRequest: ((PaymentRequest) -> Void)?
    var didReceiveResolvedAddress: ((Result<(String, String?), ResolvableError>, ResolvableType) -> Void)?
    
    func setContent(_ content: String?) {
        contentLabel.text = content
        textField.text = content
        textDidChange?(content)
    }

    var isEditable = false {
        didSet {
            gr.isEnabled = isEditable
        }
    }
    
    func hideActionButtons() {
        paste.isHidden = true
        paste.isEnabled = false
        scan.isHidden = true
        scan.isEnabled = false
    }
    
    func showActionButtons() {
        paste.isHidden = false
        paste.isEnabled = true
        scan.isHidden = false
        scan.isEnabled = true
    }

    let textField = UITextField()
    let paste = BRDButton(title: L10n.Send.pasteLabel, type: .tertiary)
    let scan = BRDButton(title: "", type: .tertiary, image: .init(named: "qr"))
    fileprivate let contentLabel = UILabel(font: Fonts.Body.one, color: LightColors.Text.two)
    private let label = UILabel(font: Fonts.Subtitle.two, color: LightColors.Text.two)
    fileprivate let gr = UITapGestureRecognizer()
    fileprivate let tapView = UIView()
    private let border = UIView(color: LightColors.Outline.one)
    private let resolvedAddressLabel = ResolvedAddressLabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    func showResolveableState(type: ResolvableType, address: String) {
        textField.resignFirstResponder()
        label.isHidden = true
        resolvedAddressLabel.isHidden = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        isEditable = true
        resolvedAddressLabel.type = type
        resolvedAddressLabel.address = address
    }
    
    func hideResolveableState() {
        label.isHidden = false
        resolvedAddressLabel.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        isEditable = true
    }
    
    func showResolvingSpinner() {
        label.isHidden = true
        addSubview(activityIndicator)
        activityIndicator.constrain([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: Margins.small.rawValue),
            activityIndicator.constraint(.leading, toView: self, constant: Margins.large.rawValue) ])
        activityIndicator.startAnimating()
    }
    
    fileprivate let currency: Currency

    private func setupViews() {
        addSubviews()
        addConstraints()
        setInitialData()
    }

    private func addSubviews() {
        addSubview(resolvedAddressLabel)
        addSubview(label)
        addSubview(contentLabel)
        addSubview(textField)
        addSubview(tapView)
        addSubview(border)
        addSubview(paste)
        addSubview(scan)
    }

    private func addConstraints() {
        label.constrain([
            label.constraint(.leading, toView: self, constant: Margins.large.rawValue),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Margins.small.rawValue)])
        resolvedAddressLabel.constrain([
            resolvedAddressLabel.topAnchor.constraint(equalTo: topAnchor, constant: Margins.small.rawValue),
            resolvedAddressLabel.constraint(.leading, toView: self, constant: Margins.large.rawValue) ])
        resolvedAddressLabel.isHidden = true
        
        contentLabel.constrain([
            contentLabel.constraint(.leading, toView: label),
            contentLabel.constraint(toBottom: label),
            contentLabel.trailingAnchor.constraint(equalTo: paste.leadingAnchor, constant: -Margins.small.rawValue) ])
        textField.constrain([
            textField.constraint(.leading, toView: label),
            textField.constraint(toBottom: label),
            textField.trailingAnchor.constraint(equalTo: paste.leadingAnchor, constant: -Margins.small.rawValue) ])
        tapView.constrain([
            tapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapView.topAnchor.constraint(equalTo: topAnchor),
            tapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tapView.trailingAnchor.constraint(equalTo: paste.leadingAnchor) ])
        scan.constrain([
            scan.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            scan.centerYAnchor.constraint(equalTo: centerYAnchor),
            scan.widthAnchor.constraint(equalToConstant: 56.0),
            scan.heightAnchor.constraint(equalToConstant: 32.0)])
        paste.constrain([
            paste.centerYAnchor.constraint(equalTo: centerYAnchor),
            paste.trailingAnchor.constraint(equalTo: scan.leadingAnchor, constant: -Margins.small.rawValue),
            paste.heightAnchor.constraint(equalToConstant: 33.0)
        ])
        border.constrain([
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1.0) ])
    }

    private func setInitialData() {
        label.text = L10n.Send.toLabel
        textField.font = contentLabel.font
        textField.textColor = contentLabel.textColor
        textField.isHidden = true
        textField.returnKeyType = .done
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentLabel.lineBreakMode = .byTruncatingMiddle

        textField.editingChanged = { [weak self] in
            guard let self = self else { return }
            self.contentLabel.text = self.textField.text
        }

        //GR to start editing label
        gr.addTarget(self, action: #selector(didTap))
        tapView.addGestureRecognizer(gr)
    }

    @objc private func didTap() {
        textField.becomeFirstResponder()
        contentLabel.isHidden = true
        textField.isHidden = false
        showActionButtons()
        resolvedAddressLabel.type = nil
        resolvedAddressLabel.address = nil
    }
    
    @objc private func textFieldDidChange() {
        textDidChange?(textField.text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
        contentLabel.isHidden = true
        gr.isEnabled = false
        tapView.isUserInteractionEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        contentLabel.isHidden = false
        textField.isHidden = true
        gr.isEnabled = true
        tapView.isUserInteractionEnabled = true
        contentLabel.text = textField.text
        
        if let text = textField.text, let resolver = ResolvableFactory.resolver(text) {
            showResolvingSpinner()
            resolver.fetchAddress(forCurrency: currency) { result in
                DispatchQueue.main.async {
                    self.didReceiveResolvedAddress?(result, resolver.type)
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let request = PaymentRequest(string: string, currency: currency) {
            didReceivePaymentRequest?(request)
            return false
        } else {
            return true
        }
    }
}
