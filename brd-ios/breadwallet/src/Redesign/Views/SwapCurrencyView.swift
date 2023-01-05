//
//  SwapCurrencyView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

// TODO: Refactor configs and models.

import UIKit

struct SwapCurrencyConfiguration: Configurable {
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
    var currencyIconBackground = BackgroundConfiguration(border: BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius))
}

struct SwapCurrencyViewModel: ViewModel {
    var amount: Amount?
    var currencyCode: String?
    var currencyImage: UIImage?
    var formattedFiatString: NSMutableAttributedString?
    var formattedTokenString: NSMutableAttributedString?
    var fee: Amount?
    var formattedTokenFeeString: String?
    var title: LabelViewModel?
    var feeDescription: LabelViewModel?
    var selectionDisabled = false
}

class SwapCurrencyView: FEView<SwapCurrencyConfiguration, SwapCurrencyViewModel>, UITextFieldDelegate {
    var didTapSelectAsset: (() -> Void)?
    var didChangeFiatAmount: ((String?) -> Void)?
    var didChangeCryptoAmount: ((String?) -> Void)?
    var didChangeContent: (() -> Void)?
    var didFinish: ((_ didSwitchPlaces: Bool) -> Void)?
    
    var isFeeAndAmountsStackViewHidden = true
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var headerStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Body.three
        view.textColor = LightColors.Text.three
        view.textAlignment = .left
        return view
    }()
    
    private lazy var fiatStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var fiatAmountField: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Text.three
        view.font = Fonts.Subtitle.one
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .decimalPad
        view.delegate = self
        view.addTarget(self, action: #selector(fiatAmountDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    private lazy var cryptoAmountField: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Text.three
        view.font = Fonts.Title.five
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .decimalPad
        view.delegate = self
        view.addTarget(self, action: #selector(cryptoAmountDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    private lazy var fiatLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var fiatCurrencyLabel: FELabel = {
        let view = FELabel()
        view.text = Constant.usdCurrencyCode
        view.font = Fonts.Subtitle.three
        view.textColor = LightColors.Text.two
        view.textAlignment = .right
        return view
    }()
    
    private lazy var cryptoStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    lazy var selectorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Margins.small.rawValue
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectorTapped(_:))))
        return view
    }()
    
    private lazy var currencyIconImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        return view
    }()
    
    private lazy var codeLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Title.five
        view.textColor = LightColors.Text.three
        view.textAlignment = .left
        return view
    }()
    
    private lazy var selectorImageView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .image(Asset.chevronDown.image))
        view.setupCustomMargins(all: .extraSmall)
        view.tintColor = LightColors.Text.three
        return view
    }()
    
    private lazy var cryptoLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var feeAndAmountsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var feeLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Subtitle.three
        view.textColor = LightColors.Text.two
        view.textAlignment = .left
        return view
    }()
    
    private lazy var feeAmountLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Subtitle.three
        view.textColor = LightColors.Text.two
        view.textAlignment = .right
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        content.setupCustomMargins(all: .extraLarge)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        mainStack.addArrangedSubview(feeAndAmountsStackView)
        feeAndAmountsStackView.addArrangedSubview(feeLabel)
        feeAndAmountsStackView.addArrangedSubview(feeAmountLabel)
        
        hideFeeAndAmountsStackView(noFee: true)
        
        mainStack.addArrangedSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.small.rawValue)
        }
        headerStack.addArrangedSubview(titleLabel)
        
        fiatAmountField.addSubview(fiatLineView)
        fiatLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(cryptoStack)
        cryptoStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        cryptoStack.addArrangedSubview(selectorStackView)
        selectorStackView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.extraExtraHuge.rawValue + ViewSizes.large.rawValue)
        }
        
        selectorStackView.addArrangedSubview(currencyIconImageView)
        currencyIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        selectorStackView.addArrangedSubview(codeLabel)
        selectorStackView.addArrangedSubview(selectorImageView)
        selectorImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.small.rawValue)
        }
        
        let cryptoSpacer = UIView()
        cryptoStack.addArrangedSubview(cryptoSpacer)
        cryptoSpacer.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.required)
        }
        
        cryptoStack.addArrangedSubview(cryptoAmountField)
        cryptoAmountField.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview()
        }
        
        cryptoAmountField.setContentHuggingPriority(.required, for: .horizontal)
        
        cryptoAmountField.addSubview(cryptoLineView)
        cryptoLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(fiatStack)
        
        let fiatSpacer = UIView()
        cryptoStack.addArrangedSubview(fiatSpacer)
        fiatSpacer.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.required)
        }
        
        fiatStack.addArrangedSubview(fiatSpacer)
        fiatStack.addArrangedSubview(fiatAmountField)
        fiatStack.addArrangedSubview(fiatCurrencyLabel)
        
        decidePlaceholder()
    }
    
    @objc func fiatAmountDidChange(_ textField: UITextField) {
        decidePlaceholder()
        
        let cleanedText = textField.text?.cleanupFormatting(forFiat: true)
        didChangeFiatAmount?(cleanedText)
        
        didChangeContent?()
    }
    
    @objc func cryptoAmountDidChange(_ textField: UITextField) {
        decidePlaceholder()
        
        let cleanedText = textField.text?.cleanupFormatting(forFiat: false)
        didChangeCryptoAmount?(cleanedText)
        
        didChangeContent?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        decidePlaceholder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fiatAmountField {
            let cleanedText = textField.text?.cleanupFormatting(forFiat: true)
            
            didChangeFiatAmount?(cleanedText)
        } else if textField == cryptoAmountField {
            let cleanedText = textField.text?.cleanupFormatting(forFiat: false)
            
            didChangeCryptoAmount?(cleanedText)
        }
        
        didFinish?(false)
        
        decidePlaceholder()
    }
    override func configure(with config: SwapCurrencyConfiguration?) {
        super.configure(with: config)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
        
        currencyIconImageView.wrappedView.configure(background: config?.currencyIconBackground)
    }
    
    override func setup(with viewModel: SwapCurrencyViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel.title)
        
        if !fiatAmountField.isFirstResponder {
            fiatAmountField.attributedText = viewModel.formattedFiatString
        }
        fiatStack.isHidden = viewModel.formattedFiatString == nil
        
        if !cryptoAmountField.isFirstResponder {
            cryptoAmountField.attributedText = viewModel.formattedTokenString
        }
        
        codeLabel.text = viewModel.amount?.currency.code ?? viewModel.currencyCode
        codeLabel.sizeToFit()

        currencyIconImageView.wrappedView.setup(with: .image(viewModel.amount?.currency.imageSquareBackground ?? viewModel.currencyImage))
        if viewModel.amount == nil {
            currencyIconImageView.wrappedView.contentMode = .scaleAspectFill
        }
        
        if let tokenFee = viewModel.formattedTokenFeeString {
            feeAmountLabel.text = "\(tokenFee)"
        }
        
        feeLabel.setup(with: viewModel.feeDescription)
        
        let noFee = viewModel.fee == nil || viewModel.fee?.tokenValue == 0 || viewModel.amount?.tokenValue == 0
        hideFeeAndAmountsStackView(noFee: noFee)
        
        decidePlaceholder()
        let image: UIImage? = viewModel.selectionDisabled ? nil : Asset.chevronDown.image
        selectorImageView.setup(with: .image(image))
    }
    
    func hideFeeAndAmountsStackView(noFee: Bool) {
        isFeeAndAmountsStackViewHidden = noFee
        
        feeAndAmountsStackView.alpha = isFeeAndAmountsStackViewHidden ? 0 : 1
        feeAndAmountsStackView.isHidden = isFeeAndAmountsStackViewHidden
    }
    
    func resetTextFieldValues() {
        fiatAmountField.text = nil
        cryptoAmountField.text = nil
    }
    
    @objc private func selectorTapped(_ sender: Any) {
        endEditing(true)
        
        didTapSelectAsset?()
    }
    
    private func setPlaceholder(for field: UITextField) {
        let isActive = field.isFirstResponder && field.text?.isEmpty == true
        if let textColor = field.textColor,
           let lineViewColor = fiatLineView.backgroundColor,
           let font = field.font {
            field.attributedPlaceholder = NSAttributedString(string: ExchangeFormatter.fiat.string(for: 0) ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: isActive ? lineViewColor : textColor,
                                                                          NSAttributedString.Key.font: font]
            )
        }
    }
    
    private func decidePlaceholder() {
        setPlaceholder(for: fiatAmountField)
        setPlaceholder(for: cryptoAmountField)
    }
    
    func setAlphaToLabels(alpha value: Double) {
        titleLabel.alpha = value
        fiatStack.alpha = value
        fiatAmountField.alpha = value
        fiatCurrencyLabel.alpha = value
        cryptoAmountField.alpha = value
        feeAndAmountsStackView.alpha = value
    }
}
