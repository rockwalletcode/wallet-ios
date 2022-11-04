// 
//  IconDescriptionView.swift
//  breadwallet
//
//  Created by Rok on 21/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct IconDescriptionConfiguration: Configurable {
    var image: BackgroundConfiguration = .init(tintColor: LightColors.Text.two)
    var description: LabelConfiguration = .init(font: Fonts.Body.two,
                                                textColor: LightColors.Text.two,
                                                numberOfLines: 0)
}

struct IconDescriptionViewModel: ViewModel {
    var image: ImageViewModel = .imageName("infoIcon")
    var description: LabelViewModel
}

class IconDescriptionView: FEView<IconDescriptionConfiguration, IconDescriptionViewModel> {
    
    var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            mainStack.axis = axis
            layoutIfNeeded()
        }
    }
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var imageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var descriptionLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(imageView)
        mainStack.addArrangedSubview(descriptionLabel)
    }
    
    override func configure(with config: IconDescriptionConfiguration?) {
        super.configure(with: config)
        imageView.configure(with: config?.image)
        descriptionLabel.configure(with: config?.description)
    }
    
    override func setup(with viewModel: IconDescriptionViewModel?) {
        super.setup(with: viewModel)
        imageView.setup(with: viewModel?.image)
        descriptionLabel.setup(with: viewModel?.description)
    }
}
