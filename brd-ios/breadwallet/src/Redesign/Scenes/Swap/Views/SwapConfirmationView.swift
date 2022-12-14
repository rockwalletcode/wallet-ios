// 
//  SwapConfirmationView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapConfimationConfiguration: Configurable {
    var from: TitleValueConfiguration = Presets.TitleValue.common.withTextAlign(textAlign: .left)
    var to: TitleValueConfiguration = Presets.TitleValue.common.withTextAlign(textAlign: .left)
    var rate: TitleValueConfiguration = Presets.TitleValue.common
    var sendingFee: TitleValueConfiguration = Presets.TitleValue.common
    var receivingFee: TitleValueConfiguration = Presets.TitleValue.common
    var totalCost: TitleValueConfiguration = Presets.TitleValue.bold
}

struct SwapConfirmationViewModel: ViewModel {
    var from: TitleValueViewModel
    var to: TitleValueViewModel
    var rate: TitleValueViewModel
    var receivingFee: TitleValueViewModel
    var totalCost: TitleValueViewModel
}

class SwapConfirmationView: FEView<SwapConfimationConfiguration, SwapConfirmationViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    private lazy var fromView: TitleValueView = {
        let view = TitleValueView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var toView: TitleValueView = {
        let view = TitleValueView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var rateView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var receivingFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.one
        return view
    }()
    
    private lazy var costView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(fromView)
        fromView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        mainStack.addArrangedSubview(toView)
        toView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        mainStack.addArrangedSubview(rateView)
        rateView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(receivingFeeView)
        receivingFeeView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
        
        mainStack.addArrangedSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(costView)
        costView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
        }
    }
    
    override func configure(with config: SwapConfimationConfiguration?) {
        super.configure(with: config)
        
        fromView.configure(with: config?.from)
        toView.configure(with: config?.to)
        rateView.configure(with: config?.rate)
        receivingFeeView.configure(with: config?.receivingFee)
        costView.configure(with: config?.totalCost)
    }
    
    override func setup(with viewModel: SwapConfirmationViewModel?) {
        super.setup(with: viewModel)
        
        fromView.setup(with: viewModel?.from)
        toView.setup(with: viewModel?.to)
        rateView.setup(with: viewModel?.rate)
        receivingFeeView.setup(with: viewModel?.receivingFee)
        costView.setup(with: viewModel?.totalCost)
    }
}
