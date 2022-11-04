// 
//  SwapConfirmationView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapConfimationConfiguration: Configurable {
    var from: TitleValueConfiguration = Presets.TitleValue.vertical.withTextAlign(textAlign: .left)
    var to: TitleValueConfiguration = Presets.TitleValue.vertical.withTextAlign(textAlign: .left)
    var rate: TitleValueConfiguration = Presets.TitleValue.horizontal
    var sendingFee: TitleValueConfiguration = Presets.TitleValue.horizontal
    var receivingFee: TitleValueConfiguration = Presets.TitleValue.horizontal
    var totalCost: TitleValueConfiguration = Presets.TitleValue.horizontal
    var info: IconDescriptionConfiguration = .init()
}

struct SwapConfirmationViewModel: ViewModel {
    var from: TitleValueViewModel
    var to: TitleValueViewModel
    var rate: TitleValueViewModel
    var sendingFee: TitleValueViewModel
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
    
    private lazy var sendingFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var receivingFeeView: TitleValueView = {
        let view = TitleValueView()
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
        
        mainStack.addArrangedSubview(sendingFeeView)
        sendingFeeView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        mainStack.addArrangedSubview(receivingFeeView)
        receivingFeeView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
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
        sendingFeeView.configure(with: config?.sendingFee)
        receivingFeeView.configure(with: config?.receivingFee)
        costView.configure(with: config?.totalCost)
    }
    
    override func setup(with viewModel: SwapConfirmationViewModel?) {
        super.setup(with: viewModel)
        
        fromView.setup(with: viewModel?.from)
        toView.setup(with: viewModel?.to)
        rateView.setup(with: viewModel?.rate)
        sendingFeeView.setup(with: viewModel?.sendingFee)
        receivingFeeView.setup(with: viewModel?.receivingFee)
        costView.setup(with: viewModel?.totalCost)
    }
}
