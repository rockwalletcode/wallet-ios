//
//  EnterPhraseCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-02-24.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class EnterPhraseCell: UICollectionViewCell {

    // MARK: - Public
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func cellPlaceHolder(_ index: Int) -> NSAttributedString {
        return NSAttributedString(string: "\(index + 1)", attributes: [NSAttributedString.Key.foregroundColor: LightColors.Text.three])
    }
    
    func updatePlaceholder() {
        if let text = textField.text, text.isEmpty, let index = self.index, !textField.isFirstResponder {
            textField.attributedPlaceholder = self.cellPlaceHolder(index)
        } else {
            textField.attributedPlaceholder = nil
        }
    }
    
    var index: Int? {
        didSet {
            updatePlaceholder()
        }
    }
    
    private(set) var text: String?
    var didEndEditing: (() -> Void)?
    
    var didTapPrevious: (() -> Void)? {
        didSet {
            previousField.tap = didTapPrevious
        }
    }

    var didTapNext: (() -> Void)? {
        didSet {
            nextField.tap = didTapNext
        }
    }

    var didTapDone: (() -> Void)? {
        didSet {
            done.tap = {
                self.textField.resignFirstResponder()
                self.didTapDone?()
            }
        }
    }

    var didEnterSpace: (() -> Void)?
    var isWordValid: ((String) -> Bool)?
    var didPasteWords: (([String]) -> Bool)?

    func disablePreviousButton() {
        previousField.tintColor = LightColors.Disabled.one
        previousField.isEnabled = false
    }

    func disableNextButton() {
        nextField.tintColor = LightColors.Disabled.one
        nextField.isEnabled = false
    }

    // MARK: - Private
    let textField = UITextField()
    private let nextField = UIButton.icon(image: #imageLiteral(resourceName: "RightArrow"), accessibilityLabel: L10n.RecoverWallet.rightArrow, position: .middle)
    private let previousField = UIButton.icon(image: #imageLiteral(resourceName: "LeftArrow"), accessibilityLabel: L10n.RecoverWallet.leftArrow, position: .middle)
    private let done = UIButton(type: .system)
    fileprivate let focusBar = UIView(color: LightColors.primary)
    fileprivate var hasDisplayedInvalidState = false

    private func setup() {
        contentView.layer.borderColor = LightColors.Text.two.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(textField)
        contentView.addSubview(focusBar)
        
        textField.constrain([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        
        focusBar.constrain([
            focusBar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            focusBar.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            focusBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            focusBar.heightAnchor.constraint(equalToConstant: 2)
            ])
        
        hideFocusBar()
        
        setData()
    }
    
    private func showFocusBar() {
        focusBar.isHidden = false
    }
    
    private func hideFocusBar() {
        focusBar.isHidden = true
    }

    private func setData() {
        textField.textColor = LightColors.Text.one
        textField.inputAccessoryView = accessoryView
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.font = Fonts.Body.two
        textField.delegate = self
        textField.addTarget(self, action: #selector(EnterPhraseCell.textChanged(textField:)), for: .editingChanged)

        previousField.tintColor = LightColors.Text.one
        nextField.tintColor = LightColors.Text.one
        done.setTitle(L10n.RecoverWallet.done, for: .normal)
        done.setTitleColor(LightColors.primary, for: .normal)
    }

    private var accessoryView: UIView {
        let view = UIView(color: .secondaryButton)
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        let topBorder = UIView(color: .secondaryShadow)
        view.addSubview(topBorder)
        view.addSubview(previousField)
        view.addSubview(nextField)
        view.addSubview(done)

        topBorder.constrainTopCorners(height: 1.0)
        previousField.constrain([
            previousField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            previousField.topAnchor.constraint(equalTo: view.topAnchor),
            previousField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previousField.widthAnchor.constraint(equalToConstant: 44.0) ])

        nextField.constrain([
            nextField.leadingAnchor.constraint(equalTo: previousField.trailingAnchor),
            nextField.topAnchor.constraint(equalTo: view.topAnchor),
            nextField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nextField.widthAnchor.constraint(equalToConstant: 44.0) ])

        done.constrain([
            done.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            done.topAnchor.constraint(equalTo: view.topAnchor),
            done.bottomAnchor.constraint(equalTo: view.bottomAnchor)])

        return view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EnterPhraseCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setColors(textField: textField)
        didEndEditing?()
        
        if let text = textField.text, let isValid = isWordValid, (isValid(text) || text.isEmpty) {
            hideFocusBar()
        }
        updatePlaceholder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showFocusBar()
        updatePlaceholder()
    }

    @objc func textChanged(textField: UITextField) {
        if let text = textField.text {
            if text.last == " " {
                textField.text = text.replacingOccurrences(of: " ", with: "")
                didEnterSpace?()
            }
        }
        if hasDisplayedInvalidState {
            setColors(textField: textField)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard E.isDebug || E.isTestFlight else { return true }
        if string.count == UIPasteboard.general.string?.count,
            let didPasteWords = didPasteWords,
            string == UIPasteboard.general.string?.replacingOccurrences(of: "\n", with: " ") {
            let words = string.components(separatedBy: " ")
            if didPasteWords(words) {
                return false
            }
        }
        return true
    }

    private func setColors(textField: UITextField) {
        guard let isWordValid = isWordValid else { return }
        guard let word = textField.text else { return }
        if isWordValid(word) || word.isEmpty {
            textField.textColor = LightColors.Text.one
            focusBar.backgroundColor = LightColors.primary
            contentView.layer.borderColor = LightColors.Text.two.cgColor
        } else {
            contentView.layer.borderColor = LightColors.Error.one.cgColor
            hasDisplayedInvalidState = true
        }
    }
    
}
