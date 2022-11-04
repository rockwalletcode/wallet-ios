// 
//  CardSelectionView.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct CardSelectionConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.Body.three, textColor: LightColors.Text.two)
    var subtitle: LabelConfiguration? =  .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one)
    var arrow: BackgroundConfiguration? = Presets.Background.Secondary.selected
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct CardSelectionViewModel: ViewModel {
    var title: LabelViewModel? = .text(L10n.Buy.payWith)
    var subtitle: LabelViewModel? = .text(L10n.Buy.selectPayment)
    var logo: ImageViewModel?
    var cardNumber: LabelViewModel?
    var expiration: LabelViewModel?
    var arrow: ImageViewModel? = .imageName("chevron-right")
    var userInteractionEnabled = false
}

class CardSelectionView: FEView<CardSelectionConfiguration, CardSelectionViewModel> {
    
    var moreButtonCallback: (() -> Void)?
    var didTapSelectCard: (() -> Void)?
    
    private lazy var containerStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var subtitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var cardDetailsView: CardDetailsView = {
        let view = CardDetailsView()
        return view
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var arrowImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupCustomMargins(all: .large)
        
        containerStack.addArrangedSubview(mainStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(subtitleLabel)
        mainStack.addArrangedSubview(cardDetailsView)
        
        cardDetailsView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        containerStack.addArrangedSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.low)
        }
        
        containerStack.addArrangedSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.small.rawValue)
        }
        
        cardDetailsView.moreButtonCallback = { [weak self] in
            self?.moreButtonTapped()
        }
    }
    
    override func configure(with config: CardSelectionConfiguration?) {
        super.configure(with: config)
        titleLabel.configure(with: config?.title)
        subtitleLabel.configure(with: config?.subtitle)
        cardDetailsView.configure(with: .init())
        arrowImageView.configure(with: config?.arrow)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: CardSelectionViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
        titleLabel.isHidden = viewModel?.subtitle == nil
        
        subtitleLabel.setup(with: viewModel?.subtitle)
        subtitleLabel.isHidden = viewModel?.logo != nil && viewModel?.cardNumber != nil && viewModel?.expiration != nil
        
        cardDetailsView.isHidden = viewModel?.logo == nil
        
        arrowImageView.setup(with: viewModel?.arrow)
        arrowImageView.isHidden = viewModel?.expiration != nil && titleLabel.isHidden
        
        cardDetailsView.setup(with: .init(logo: viewModel?.logo,
                                          title: titleLabel.isHidden == true ? viewModel?.title : nil,
                                          cardNumber: viewModel?.cardNumber,
                                          expiration: viewModel?.expiration,
                                          moreOption: arrowImageView.isHidden))
        
        spacerView.isHidden = arrowImageView.isHidden
        
        guard viewModel?.userInteractionEnabled == true else {
            gestureRecognizers?.forEach { removeGestureRecognizer($0) }
            return
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardSelectorTapped(_:))))
    }
    
    @objc private func cardSelectorTapped(_ sender: Any) {
        didTapSelectCard?()
    }
    
    private func moreButtonTapped() {
        moreButtonCallback?()
    }
}
