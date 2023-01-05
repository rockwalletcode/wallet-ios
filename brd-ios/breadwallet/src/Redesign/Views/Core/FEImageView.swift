// 
//  ImageView.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum ImageViewModel: ViewModel {
    case animation(String?)
    case imageName(String?)
    case image(UIImage?)
    case photo(UIImage?)
    case url(String?)
}

class FEImageView: FEView<BackgroundConfiguration, ImageViewModel> {
    
    override var contentMode: UIView.ContentMode {
        get { return imageView.contentMode }
        set { imageView.contentMode = newValue }
    }
    
    // MARK: Lazy UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View setup
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        content.setupClearMargins()
    }
    
    // MARK: ViewModelable
    public override func setup(with viewModel: ImageViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        switch viewModel {
        case .photo(let image):
            imageView.image = image
            layoutViews(image: image)
            
        case .image(let image):
            imageView.image = image
            
        case .imageName(let name):
            imageView.image = .init(named: name ?? "")
            
        default:
            return
        }
        
        imageView.tintColor = config?.tintColor
        
        layoutIfNeeded()
    }
    
    // TODO: what is this magic? :o
    private func layoutViews(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        var imageAspectRatio = image.size.height / image.size.width
        if imageAspectRatio >= 1.5 {
            imageAspectRatio = 1.5
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(self.imageView.snp.width).multipliedBy(imageAspectRatio)
        }
        
        imageView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
