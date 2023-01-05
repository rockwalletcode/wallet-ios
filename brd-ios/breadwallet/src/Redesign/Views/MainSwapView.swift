//
//  MainSwapView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct MainSwapConfiguration: Configurable {
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
}

struct MainSwapViewModel: ViewModel {
    var from: SwapCurrencyViewModel?
    var to: SwapCurrencyViewModel?
    var hideSwapButton = false
}

class MainSwapView: FEView<MainSwapConfiguration, MainSwapViewModel> {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var baseSwapCurrencyView: SwapCurrencyView = {
        let view = SwapCurrencyView()
        return view
    }()
    
    private lazy var termSwapCurrencyView: SwapCurrencyView = {
        let view = SwapCurrencyView()
        return view
    }()
    
    private lazy var dividerWithButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.one
        return view
    }()
    
    private lazy var switchPlacesButton: FEButton = {
        let view = FEButton()
        view.setImage(Asset.swap.image, for: .normal)
        view.addTarget(self, action: #selector(switchPlacesButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var didChangeFromFiatAmount: ((String?) -> Void)?
    var didChangeFromCryptoAmount: ((String?) -> Void)?
    var didTapFromAssetsSelection: (() -> Void)? {
        get {
            return baseSwapCurrencyView.didTapSelectAsset
        }
        set {
            baseSwapCurrencyView.didTapSelectAsset = newValue
        }
    }
    var didChangeToFiatAmount: ((String?) -> Void)?
    var didChangeToCryptoAmount: ((String?) -> Void)?
    var didTapToAssetsSelection: (() -> Void)? {
        get {
            return termSwapCurrencyView.didTapSelectAsset
        }
        set {
            termSwapCurrencyView.didTapSelectAsset = newValue
        }
    }
    var didFinish: ((_ didSwitchPlaces: Bool) -> Void)?
    var contentSizeChanged: (() -> Void)? {
        didSet {
            baseSwapCurrencyView.didChangeContent = contentSizeChanged
            termSwapCurrencyView.didChangeContent = contentSizeChanged
        }
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.leading.equalTo(content.snp.leadingMargin)
            make.trailing.equalTo(content.snp.trailingMargin)
            make.top.equalTo(content.snp.topMargin)
            make.bottom.equalTo(content.snp.bottomMargin)
        }
        
        containerStackView.addArrangedSubview(baseSwapCurrencyView)
        containerStackView.addArrangedSubview(dividerWithButtonView)
        containerStackView.addArrangedSubview(termSwapCurrencyView)
        
        dividerWithButtonView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        dividerWithButtonView.addSubview(switchPlacesButton)
        switchPlacesButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(ViewSizes.medium.rawValue)
            make.top.equalToSuperview()
        }
        
        getAmounts()
    }
    
    private func getAmounts() {
        baseSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeFromFiatAmount?(amount)
        }
        
        baseSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeFromCryptoAmount?(amount)
        }
        
        termSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeToFiatAmount?(amount)
        }
        
        termSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeToCryptoAmount?(amount)
        }
    }
    
    override func configure(with config: MainSwapConfiguration?) {
        super.configure(with: config)
        
        baseSwapCurrencyView.configure(with: .init())
        termSwapCurrencyView.configure(with: .init())
        
        backgroundView = containerStackView
        shadowView = containerStackView
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: MainSwapViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        // There could be a better way
        if baseSwapCurrencyView.selectorStackView.transform != .identity {
            baseSwapCurrencyView.selectorStackView.transform = .identity
            termSwapCurrencyView.selectorStackView.transform = .identity
        }
        
        baseSwapCurrencyView.setup(with: viewModel.from)
        termSwapCurrencyView.setup(with: viewModel.to)
        
        baseSwapCurrencyView.didChangeContent = contentSizeChanged
        baseSwapCurrencyView.didFinish = didFinish
        termSwapCurrencyView.didChangeContent = contentSizeChanged
        termSwapCurrencyView.didFinish = didFinish
        switchPlacesButton.isHidden = viewModel.hideSwapButton
        
        setToggleSwitchPlacesButtonState(viewModel.from?.formattedFiatString != nil)
        
        contentSizeChanged?()
    }
    
    // MARK: - User interaction
    
    @objc private func topCurrencyTapped(_ sender: Any?) {
        endEditing(true)
        
        didTapFromAssetsSelection?()
    }
    
    @objc private func bottomCurrencyTapped(_ sender: Any?) {
        endEditing(true)
        
        didTapToAssetsSelection?()
    }
    
    @objc private func switchPlacesButtonTapped(_ sender: UIButton?) {
        if !baseSwapCurrencyView.isFeeAndAmountsStackViewHidden || !termSwapCurrencyView.isFeeAndAmountsStackViewHidden {
            UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
                self?.baseSwapCurrencyView.hideFeeAndAmountsStackView(noFee: true)
                self?.termSwapCurrencyView.hideFeeAndAmountsStackView(noFee: true)
            } completion: { [weak self] _ in
                self?.contentSizeChanged?()
                self?.animateSwitchPlaces()
            }
        } else {
            contentSizeChanged?()
            animateSwitchPlaces()
        }
    }
    
    func setToggleSwitchPlacesButtonState(_ value: Bool) {
        UIView.transition(with: switchPlacesButton,
                          duration: Presets.Animation.short.rawValue) { [weak self] in
            self?.switchPlacesButton.alpha = value ? 1.0 : 0.5
            self?.switchPlacesButton.isUserInteractionEnabled = value
        }
    }
    
    func animateSwitchPlaces() {
        setToggleSwitchPlacesButtonState(false)
        
        let isNormal = switchPlacesButton.transform == .identity
        let topFrame = isNormal ? baseSwapCurrencyView.selectorStackView : termSwapCurrencyView.selectorStackView
        let bottomFrame = isNormal ? termSwapCurrencyView.selectorStackView : baseSwapCurrencyView.selectorStackView
        
        let convertedFrame = termSwapCurrencyView.selectorStackView.convert(baseSwapCurrencyView.selectorStackView.bounds, from: baseSwapCurrencyView.selectorStackView)
        let verticalDistance = convertedFrame.minY - termSwapCurrencyView.selectorStackView.bounds.maxY + baseSwapCurrencyView.selectorStackView.frame.height
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue,
                       delay: 0.0,
                       options: .curveLinear) { [weak self] in
            topFrame.transform = CGAffineTransform(translationX: 0, y: isNormal ?  -verticalDistance : verticalDistance)
            bottomFrame.transform = CGAffineTransform(translationX: 0, y: isNormal ? verticalDistance : -verticalDistance)
            self?.switchPlacesButton.transform = isNormal ? CGAffineTransform(rotationAngle: .pi) : .identity
            
            self?.baseSwapCurrencyView.setAlphaToLabels(alpha: 0.2)
            self?.termSwapCurrencyView.setAlphaToLabels(alpha: 0.2)
            self?.baseSwapCurrencyView.resetTextFieldValues()
            self?.termSwapCurrencyView.resetTextFieldValues()
        }
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue,
                       delay: Presets.Animation.short.rawValue) { [weak self] in
            self?.baseSwapCurrencyView.setAlphaToLabels(alpha: 1.0)
            self?.termSwapCurrencyView.setAlphaToLabels(alpha: 1.0)
        } completion: { [weak self] _ in
            self?.didFinish?(true)
        }
    }
}
