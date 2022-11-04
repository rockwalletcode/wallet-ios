// 
//  TitleValueView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct TitleValueConfiguration: Configurable {
    var title: LabelConfiguration
    var value: LabelConfiguration
    var infoButtonConfiguration: BackgroundConfiguration?
    
    func withTextAlign(textAlign: NSTextAlignment) -> TitleValueConfiguration {
        var copy = self
        copy.value.textAlignment = textAlign
        return copy
    }
}

struct TitleValueViewModel: ViewModel {
    var title: LabelViewModel
    var value: LabelViewModel
    var infoImage: ImageViewModel?
}

class TitleValueView: FEView<TitleValueConfiguration, TitleValueViewModel> {
    
    var didTapInfoButton: (() -> Void)?
    
    var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            mainStack.axis = axis
            layoutIfNeeded()
        }
    }
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        view.distribution = .fill
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var infoButton: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var valueLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.extraSmall.rawValue)
        }
        mainStack.addArrangedSubview(valueLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoButtonTapped))
        infoButton.isUserInteractionEnabled = true
        infoButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func configure(with config: TitleValueConfiguration?) {
        guard let config = config else { return }

        super.configure(with: config)
        titleLabel.configure(with: config.title)
        infoButton.configure(with: config.infoButtonConfiguration)
        valueLabel.configure(with: config.value)
    }
    
    override func setup(with viewModel: TitleValueViewModel?) {
        super.setup(with: viewModel)
        titleLabel.setup(with: viewModel?.title)
        infoButton.setup(with: viewModel?.infoImage)
        infoButton.isHidden = viewModel?.infoImage == nil
        valueLabel.setup(with: viewModel?.value)
        
        titleLabel.snp.remakeConstraints { make in
            make.width.equalTo(titleLabel.frame.width)
        }
        needsUpdateConstraints()
    }
    
    @objc func infoButtonTapped() {
        didTapInfoButton?()
    }
}
