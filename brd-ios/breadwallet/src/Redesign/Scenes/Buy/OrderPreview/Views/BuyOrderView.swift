// 
//  BuyOrderView.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct BuyOrderConfiguration: Configurable {
    var title: LabelConfiguration = .init(font: Fonts.Body.two, textColor: LightColors.Text.one)
    var currencyAmountName: LabelConfiguration = .init(font: Fonts.Title.five, textColor: LightColors.Text.one)
    var rate: LabelConfiguration = .init(font: Fonts.Title.five, textColor: LightColors.Text.one)
    var rateValue: TitleValueConfiguration = Presets.TitleValue.horizontal
    var amount: TitleValueConfiguration = Presets.TitleValue.horizontal
    var cardFee: TitleValueConfiguration = Presets.TitleValue.horizontal
    var networkFee: TitleValueConfiguration = Presets.TitleValue.horizontal
    var totalCost: TitleValueConfiguration = Presets.TitleValue.horizontalBold
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
    var currencyIconImage = BackgroundConfiguration(border: BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius))
}

struct BuyOrderViewModel: ViewModel {
    var title: LabelViewModel = .text(L10n.Buy.yourOrder)
    var currencyIcon: ImageViewModel?
    var currencyAmountName: LabelViewModel?
    var rate: ExchangeRateViewModel?
    var rateValue: TitleValueViewModel?
    var amount: TitleValueViewModel
    var cardFee: TitleValueViewModel
    var networkFee: TitleValueViewModel
    var totalCost: TitleValueViewModel
    var paymentMethod: PaymentMethodViewModel?
}

class BuyOrderView: FEView<BuyOrderConfiguration, BuyOrderViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    lazy var currencyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var currencyIconImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        return view
    }()
    
    private lazy var currencyNameLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var rateView: ExchangeRateView = {
        let view = ExchangeRateView()
        return view
    }()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = LightColors.Outline.one.cgColor
        return view
    }()
    
    private lazy var rateValueView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var amountView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var cardFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var networkFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = LightColors.Outline.one.cgColor
        return view
    }()
    
    private lazy var totalCostView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var paymentMethodView: PaymentMethodView = {
        let view = PaymentMethodView()
        return view
    }()
    
    var cardFeeInfoTapped: (() -> Void)?
    var networkFeeInfoTapped: (() -> Void)?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupCustomMargins(all: .huge)
        
        mainStack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(currencyStackView)
        currencyStackView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.small.rawValue)
        }
        
        currencyStackView.addArrangedSubview(currencyIconImageView)
        currencyIconImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.small.rawValue)
        }
        
        currencyStackView.addArrangedSubview(currencyNameLabel)
        
        mainStack.addArrangedSubview(rateView)
        rateView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(topLineView)
        topLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
        
        mainStack.addArrangedSubview(rateValueView)
        rateValueView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(amountView)
        amountView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(cardFeeView)
        cardFeeView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(networkFeeView)
        networkFeeView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
        
        mainStack.addArrangedSubview(totalCostView)
        totalCostView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(paymentMethodView)
        
        cardFeeView.didTapInfoButton = { [weak self] in
            self?.cardFeeInfoButtonTapped()
        }
        
        networkFeeView.didTapInfoButton = { [weak self] in
            self?.networkFeeViewInfoButtonTapped()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: BuyOrderConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: config?.title)
        currencyIconImageView.wrappedView.configure(background: config?.currencyIconImage)
        currencyNameLabel.configure(with: config?.currencyAmountName)
        rateView.configure(with: .init())
        rateValueView.configure(with: config?.rateValue)
        amountView.configure(with: config?.amount)
        cardFeeView.configure(with: config?.cardFee)
        networkFeeView.configure(with: config?.networkFee)
        totalCostView.configure(with: config?.totalCost)
        
        var paymentMethodConfiguration = PaymentMethodConfiguration()
        paymentMethodConfiguration.shadow = nil
        paymentMethodView.configure(with: paymentMethodConfiguration)
        paymentMethodView.content.setupCustomMargins(all: .zero)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: BuyOrderViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
        currencyIconImageView.wrappedView.setup(with: viewModel?.currencyIcon)
        currencyNameLabel.setup(with: viewModel?.currencyAmountName)
        
        rateView.setup(with: viewModel?.rate)
        rateView.isHidden = viewModel?.rate == nil
        
        [titleLabel, currencyStackView, rateView, topLineView].forEach { view in
            view.isHidden = viewModel?.currencyIcon == nil && viewModel?.currencyAmountName == nil && viewModel?.rate == nil
        }
        
        rateValueView.setup(with: viewModel?.rateValue)
        rateValueView.isHidden = viewModel?.rateValue == nil
        
        amountView.setup(with: viewModel?.amount)
        cardFeeView.setup(with: viewModel?.cardFee)
        networkFeeView.setup(with: viewModel?.networkFee)
        totalCostView.setup(with: viewModel?.totalCost)
        
        paymentMethodView.setup(with: viewModel?.paymentMethod)
        paymentMethodView.isHidden = viewModel?.paymentMethod == nil
        
        needsUpdateConstraints()
    }
    
    private func cardFeeInfoButtonTapped() {
        cardFeeInfoTapped?()
    }
    
    private func networkFeeViewInfoButtonTapped() {
        networkFeeInfoTapped?()
    }
}
