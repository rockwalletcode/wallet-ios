// 
//  ItemView.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
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
        content.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(Margins.extraHuge.rawValue)
            make.height.equalTo(Margins.huge.rawValue)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Margins.large.rawValue)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func configure(with config: ItemViewConfiguration?) {
        super.configure(with: config)
    }
    
    override func setup(with viewModel: ItemViewModel?) {
        guard let viewModel = viewModel else { return }
        
        titleLabel.setup(with: .text(viewModel.title))

        let image = viewModel.image ?? .imageName("logo_icon")
        imageView.setup(with: image)
    }
}
