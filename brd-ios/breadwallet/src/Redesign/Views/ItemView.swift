// 
//  ItemView.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ItemViewConfiguration: Configurable {
}

struct ItemViewModel: ViewModel {
    var title: String
    var image: ImageViewModel?
}

class ItemView: FEView<ItemViewConfiguration, ItemViewModel> {
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.large.rawValue
        view.axis = .horizontal
        return view
    }()
    
    private lazy var imageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stack.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(Margins.extraHuge.rawValue)
            make.height.equalTo(Margins.huge.rawValue)
        }
        
        stack.addArrangedSubview(titleLabel)
    }
    
    override func configure(with config: ItemViewConfiguration?) {
        super.configure(with: config)
    }
    
    override func setup(with viewModel: ItemViewModel?) {
        guard let viewModel = viewModel else { return }
        
        titleLabel.setup(with: .text(viewModel.title))

        imageView.isHidden = viewModel.image == nil
        guard let image = viewModel.image else {
            return
        }
        imageView.setup(with: image)
    }
}
