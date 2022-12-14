// 
//  ExchangeRateView.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ExchangeRateConfiguration: Configurable {
    var title = LabelConfiguration(font: Fonts.Subtitle.two, textColor: LightColors.Text.one)
    var value = LabelConfiguration(font: Fonts.Body.two, textColor: LightColors.secondary)
    var background = BackgroundConfiguration()
    var timer = TimerConfiguration(background: .init(tintColor: LightColors.secondary), font: Fonts.Body.two)
}

struct ExchangeRateViewModel: ViewModel {
    var exchangeRate: String?
    var timer: TimerViewModel? = TimerViewModel(till: 0, image: .image(Asset.timelapse.image), repeats: true)
    var showTimer = true
}

class ExchangeRateView: FEView<ExchangeRateConfiguration, ExchangeRateViewModel> {
    
    var completion: (() -> Void)? {
        get {
            return timerView.completion
        }
        set {
            timerView.completion = newValue
        }
    }
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var valueLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var timerView: FETimerView = {
        let view = FETimerView()
        view.alpha = 0
        return view
    }()
    
    private lazy var refreshImageView: FEImageView = {
        let view = FEImageView()
        view.alpha = 0
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        content.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Margins.extraSmall.rawValue)
            make.top.bottom.equalToSuperview()
        }
        
        content.addSubview(refreshImageView)
        refreshImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Margins.extraSmall.rawValue)
            make.top.bottom.equalToSuperview()
        }
        
        content.addSubview(timerView)
        timerView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.lessThanOrEqualTo(valueLabel.snp.trailing).priority(.low)
        }
    }
    
    override func configure(with config: ExchangeRateConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(background: config.background)
        titleLabel.configure(with: config.title)
        valueLabel.configure(with: config.value)
        timerView.configure(with: config.timer)
    }
    
    override func setup(with viewModel: ExchangeRateViewModel?) {
        guard let viewModel = viewModel else { return }
        
        super.setup(with: viewModel)
        
        valueLabel.text = viewModel.exchangeRate
        valueLabel.isHidden = viewModel.exchangeRate == nil
        titleLabel.isHidden = viewModel.exchangeRate == nil
        
        timerView.setup(with: viewModel.timer)
        timerView.alpha = viewModel.timer == nil || viewModel.showTimer ? 1 : 0
        
        UIView.transition(with: content, duration: Presets.Animation.duration, options: .transitionCrossDissolve) {}
    }
    
    func invalidate() {
        timerView.invalidate()
    }
}
