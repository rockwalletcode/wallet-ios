// 
//  ProfileView.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

struct ProfileConfiguration: Configurable {
    
}

struct ProfileViewModel: ViewModel {
    var name: String
    var image: String
}

class ProfileView: FEView<ProfileConfiguration, ProfileViewModel> {
    
    // MARK: callbacks:
    var editImageCallback: (() -> Void)?
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    private lazy var imageContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        return view
    }()
    
    private lazy var nameLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var editImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        view.wrappedView.setup(with: .init(.imageName("edit")))
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        content.addSubview(stack)
        setupCustomMargins(all: .medium)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        stack.addArrangedSubview(imageContentView)
        stack.addArrangedSubview(nameLabel)
        imageContentView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        imageContentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(imageContentView.snp.height)
            make.width.equalTo(imageView.snp.height)
        }
        imageView.content.setupClearMargins()
        
        imageContentView.addSubview(editImageView)
        editImageView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        editImageView.setup { view in
            view.snp.remakeConstraints { make in
                make.bottom.trailing.equalToSuperview()
                make.height.equalTo(view.snp.width)
                make.width.equalTo(Margins.large.rawValue)
            }
        }
        editImageView.wrappedView.content.setupCustomMargins(all: .extraSmall)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
        imageView.addGestureRecognizer(tap)
    }
    
    override func configure(with config: ProfileConfiguration?) {
        super.configure(with: config)

        let zeroBorder = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        imageView.wrappedView.configure(with: .init(backgroundColor: .red, tintColor: LightColors.primary, border: zeroBorder))
        editImageView.wrappedView.configure(with: Presets.Background.Primary.normal.withBorder(border: zeroBorder))
        nameLabel.configure(with: .init(font: Fonts.Title.five,
                                        textColor: LightColors.Text.three,
                                        textAlignment: .center,
                                        numberOfLines: 1))
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setup(with viewModel: ProfileViewModel?) {
        super.setup(with: viewModel)
        guard let viewModel = viewModel else { return }

        nameLabel.setup(with: .text(viewModel.name))
        imageView.wrappedView.setup(with: .imageName(viewModel.image))
    }
    
    // MARK: - User interaction
    
    @objc private func changeImageTapped() {
        editImageCallback?()
    }
}
