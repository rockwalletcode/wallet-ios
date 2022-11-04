// 
//  FELink.swift
//  breadwallet
//
//  Created by Rok on 03/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

struct LinkConfiguration: Configurable {
    var title: LabelConfiguration?
    var normal: BackgroundConfiguration?
    var selected: BackgroundConfiguration?
    var disabled: BackgroundConfiguration?
}

struct LinkViewModel: ViewModel {
    var title: LabelViewModel?
    var image: ImageViewModel?
}

class FELink: FEView<LinkConfiguration, LinkViewModel>, StateDisplayable {
    var displayState: DisplayState = .normal
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var imageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
            make.height.equalTo(Margins.extraLarge.rawValue)
        }
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
    }
    
    override func configure(with config: LinkConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: config?.title)
    }
    
    override func setup(with viewModel: LinkViewModel?) {
        super.setup(with: viewModel)
        guard let viewModel = viewModel else { return }

        titleLabel.setup(with: viewModel.title)
        titleLabel.isHidden = viewModel.title == nil
        
        imageView.setup(with: viewModel.image)
        imageView.isHidden = viewModel.image == nil
    }
    
    func animateTo(state: DisplayState, withAnimation: Bool) {
        let background: BackgroundConfiguration?
        
        switch state {
        case .selected:
            background = config?.selected
            
        case .disabled:
            background = config?.disabled
            
        default:
            background = config?.normal
        }
        
        configure(background: background)
        imageView.configure(with: background)
        var label = config?.title
        label?.textColor = background?.tintColor
        titleLabel.configure(with: label)
    }
}
