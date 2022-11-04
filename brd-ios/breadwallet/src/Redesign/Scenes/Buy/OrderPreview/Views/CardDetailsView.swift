// 
//  CardDetailsView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 16/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct CardDetailsConfiguration: Configurable {
    var logo: BackgroundConfiguration? = .init(tintColor: LightColors.Text.two)
    var title: LabelConfiguration? = .init(font: Fonts.Body.three, textColor: LightColors.Text.two, numberOfLines: 1)
    var cardNumber: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, numberOfLines: 1)
    var expiration: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two)
    var moreButton: BackgroundConfiguration? = Presets.Background.Secondary.selected
}

struct CardDetailsViewModel: ViewModel {
    var logo: ImageViewModel?
    var title: LabelViewModel?
    var cardNumber: LabelViewModel?
    var expiration: LabelViewModel?
    var moreOption: Bool = false
}

class CardDetailsView: FEView<CardDetailsConfiguration, CardDetailsViewModel> {
    var moreButtonCallback: (() -> Void)?
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var selectorStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var logoImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var titleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = Margins.minimum.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var cardNumberLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var expirationLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var moreButton: FEButton = {
        let view = FEButton()
        view.setImage(UIImage(named: "more"), for: .normal)
        return view
    }()

    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(selectorStack)
        
        selectorStack.addArrangedSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(ViewSizes.medium.rawValue)
        }
        
        selectorStack.addArrangedSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.low)
        }
        
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(cardNumberLabel)
        
        let spacer = UIView()
        selectorStack.addArrangedSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.low)
        }
        
        selectorStack.addArrangedSubview(expirationLabel)
        
        selectorStack.addArrangedSubview(moreButton)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        layoutIfNeeded()
    }
    
    override func configure(with config: CardDetailsConfiguration?) {
        super.configure(with: config)
        
        logoImageView.configure(with: config?.logo)
        titleLabel.configure(with: config?.title)
        cardNumberLabel.configure(with: config?.cardNumber)
        expirationLabel.configure(with: config?.expiration)
        moreButton.configure(background: config?.moreButton)
    }
    
    override func setup(with viewModel: CardDetailsViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
        titleLabel.isHidden = viewModel?.title == nil
        
        cardNumberLabel.setup(with: viewModel?.cardNumber)
        cardNumberLabel.isHidden = viewModel?.cardNumber == nil
        
        logoImageView.setup(with: viewModel?.logo)
        logoImageView.isHidden = viewModel?.logo == nil
        
        expirationLabel.setup(with: viewModel?.expiration)
        expirationLabel.isHidden = viewModel?.expiration == nil
        
        guard let moreOption = viewModel?.moreOption else { return }
        moreButton.isHidden = !moreOption
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton?) {
        moreButtonCallback?()
    }
}
