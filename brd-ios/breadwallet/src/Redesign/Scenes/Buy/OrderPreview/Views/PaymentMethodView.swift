// 
//  PaymentMethodView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 16/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct PaymentMethodConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.Body.three, textColor: LightColors.Text.two)
    var cvvTitle: TitleValueConfiguration? = Presets.TitleValue.verticalSmall
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct PaymentMethodViewModel: ViewModel {
    var methodTitle: LabelViewModel? = .text(L10n.Buy.paymentMethod)
    var logo: ImageViewModel?
    var cardNumber: LabelViewModel?
    var expiration: LabelViewModel?
    var cvvTitle: TitleValueViewModel? = .init(title: .text(L10n.Buy.confirmCVV),
                                               value: .text(""),
                                               infoImage: .image(UIImage(named: "help")?.withRenderingMode(.alwaysOriginal)))
    var cvv: TextFieldModel? = .init(placeholder: L10n.Buy.cardCVV)
}

class PaymentMethodView: FEView<PaymentMethodConfiguration, PaymentMethodViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var methodTitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var selectorStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var cardDetailsView: CardDetailsView = {
        let view = CardDetailsView()
        return view
    }()
    
    private lazy var cvvTitle: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var cvvTextField: FETextField = {
        let view = FETextField()
        view.hideTitleForState = .filled
        return view
    }()
    
    var didTypeCVV: ((String?) -> Void)? {
        get {
            cvvTextField.valueChanged
        }
        
        set {
            cvvTextField.valueChanged = newValue
        }
    }
    
    var didTapCvvInfo: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupCustomMargins(all: .large)
        
        mainStack.addArrangedSubview(methodTitleLabel)
        methodTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(Margins.large.rawValue)
        }
        mainStack.addArrangedSubview(selectorStack)
        selectorStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        selectorStack.addArrangedSubview(cardDetailsView)
        cardDetailsView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        mainStack.addArrangedSubview(cvvTitle)
        mainStack.addArrangedSubview(cvvTextField)
        cvvTextField.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        cvvTitle.didTapInfoButton = { [weak self] in
            self?.cvvInfoButtonTapped()
        }
    }
    
    override func configure(with config: PaymentMethodConfiguration?) {
        super.configure(with: config)
        methodTitleLabel.configure(with: config?.title)
        cvvTitle.configure(with: config?.cvvTitle)
        cardDetailsView.configure(with: .init())
        cvvTitle.configure(with: config?.cvvTitle)
        cvvTextField.configure(with: Presets.TextField.number.setSecure(true))
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: PaymentMethodViewModel?) {
        super.setup(with: viewModel)
        
        methodTitleLabel.setup(with: viewModel?.methodTitle)
        methodTitleLabel.isHidden = viewModel?.methodTitle == nil
        
        cvvTitle.setup(with: viewModel?.cvvTitle)
        cvvTitle.isHidden = viewModel?.cvvTitle == nil
        
        cvvTextField.setup(with: viewModel?.cvv)
        cvvTextField.isHidden = viewModel?.cvv == nil
        
        cardDetailsView.setup(with: .init(logo: viewModel?.logo,
                                          cardNumber: viewModel?.cardNumber,
                                          expiration: viewModel?.expiration))
    }
    
    // MARK: - User interaction
    
    private func cvvInfoButtonTapped() {
        didTapCvvInfo?()
    }
}
