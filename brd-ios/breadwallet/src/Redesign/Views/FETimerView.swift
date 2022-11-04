// 
//  FETimerView.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct TimerConfiguration: Configurable {
    var background: BackgroundConfiguration = .init(backgroundColor: .clear, tintColor: LightColors.primary)
    var font = Fonts.Body.two
}

struct TimerViewModel: ViewModel {
    var till: Double = 0
    var image = ImageViewModel.imageName("timelapse")
    var repeats = false
}

class FETimerView: FEView<TimerConfiguration, TimerViewModel> {
    var completion: (() -> Void)?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.extraSmall.rawValue
        view.alignment = .center
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        view.textAlignment = .right
        return view
    }()
    
    private lazy var iconView: FEImageView = {
        let view = FEImageView()
        return view
    }()
        
    private var timer: Timer?
    private var triggerDate: Date?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
            make.width.lessThanOrEqualTo(content.snp.width)
        }
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(iconView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
    }
    
    override func configure(with config: TimerConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(background: config.background)
        titleLabel.configure(with: .init(font: config.font, textColor: config.background.tintColor))
        iconView.configure(with: config.background)
    }
    
    override func setup(with viewModel: TimerViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        let dateValue = TimeInterval(viewModel.till / 1000.0)
        triggerDate = Date(timeIntervalSince1970: dateValue)
        
        // TODO: replace with animation
        iconView.setup(with: viewModel.image)
        
        invalidate()
        
        guard viewModel.till != 0 else {
            titleLabel.text = "00:00"
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func updateTime() {
        guard let triggerDate = triggerDate else { return }
        
        if triggerDate < Date() {
            invalidate()
            
            completion?()
            
            return
        }
        
        let components = Calendar.current.dateComponents([.minute, .second], from: Date(), to: triggerDate)
        
        guard let minutes = components.minute,
              let seconds = components.second else {
            return
        }
        
        titleLabel.text = String(format: "%02d:%02ds", minutes, seconds)
        
        guard seconds == 0, minutes == 0 else {
            content.layoutIfNeeded()
            return
        }
        
        invalidate()
        
        completion?()
        
        guard viewModel?.repeats == true else {
            content.layoutIfNeeded()
            return
        }
        
        setup(with: viewModel)
        
        content.layoutIfNeeded()
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
