// 
//  FEInfoView.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum DismissType {
    /// After 5 sec
    case auto
    /// Tap to remove
    case tapToDismiss
    /// Non interactable
    case persistent
}

struct InfoViewConfiguration: Configurable {
    var headerLeadingImage: BackgroundConfiguration?
    var headerTitle: LabelConfiguration?
    var headerTrailing: ButtonConfiguration?
    var status: StatusViewConfiguration?
    
    var title: LabelConfiguration?
    var description: LabelConfiguration?
    var button: ButtonConfiguration?
    
    var background: BackgroundConfiguration?
    var shadow: ShadowConfiguration?
}

struct InfoViewModel: ViewModel {
    var kyc: KYC?
    var headerLeadingImage: ImageViewModel?
    var headerTitle: LabelViewModel?
    var headerTrailing: ButtonViewModel?
    var status: VerificationStatus?
    
    var title: LabelViewModel?
    var description: LabelViewModel?
    var button: ButtonViewModel?
    
    var dismissType: DismissType = .auto
}

class FEInfoView: FEView<InfoViewConfiguration, InfoViewModel> {
    var headerButtonCallback: (() -> Void)?
    var trailingButtonCallback: (() -> Void)?
    
    // MARK: Lazy UI
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Margins.medium.rawValue
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = Margins.small.rawValue
        return stack
    }()
    
    private lazy var headerLeadingView: FEImageView = {
        let view = FEImageView()
        view.setupCustomMargins(all: .extraSmall)
        return view
    }()
    
    private lazy var headerTitleLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var statusView: WrapperView<FELabel> = {
        let view = WrapperView<FELabel>()
        return view
    }()
    
    private lazy var headerTrailingButton: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var descriptionLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var bottomButton: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.lineBreakMode = .byWordWrapping
        return view
    }()
    
    var didFinish: (() -> Void)?
    
    // MARK: Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        verticalStackView.addArrangedSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.height.equalTo(Margins.huge.rawValue)
        }
        
        headerStackView.addArrangedSubview(headerLeadingView)
        headerLeadingView.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        
        headerStackView.addArrangedSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().priority(.low)
        }
        
        headerStackView.addArrangedSubview(statusView)
        statusView.content.setupCustomMargins(vertical: .zero, horizontal: .small)
        statusView.snp.makeConstraints { make in
            make.width.equalTo(Margins.extraLarge.rawValue * 4)
        }
        
        headerStackView.addArrangedSubview(headerTrailingButton)
        headerTrailingButton.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        
        verticalStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(Margins.large.rawValue)
        }

        verticalStackView.addArrangedSubview(descriptionLabel)
        
        verticalStackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            // TODO: Height is not working. 
            make.height.greaterThanOrEqualTo(ViewSizes.medium.rawValue).priority(.low)
            make.width.equalToSuperview()
        }
        
        buttonsStackView.addArrangedSubview(bottomButton)
        
        let fillerView = UIView()
        buttonsStackView.addArrangedSubview(fillerView)
        fillerView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualToSuperview().priority(.medium)
        }
    }
    
    override func configure(with config: InfoViewConfiguration?) {
        toggleVisibility(isShown: config != nil)
        
        guard let config = config else { return }
        
        super.configure(with: config)
        
        backgroundColor = config.background?.backgroundColor
        headerLeadingView.configure(with: config.headerLeadingImage)
        headerTitleLabel.configure(with: config.headerTitle)
        headerTrailingButton.configure(with: config.headerTrailing)
        statusView.wrappedView.configure(with: config.status?.title)
        statusView.configure(background: config.status?.background)
        
        titleLabel.configure(with: config.title)
        descriptionLabel.configure(with: config.description)
        bottomButton.configure(with: config.button)
        
        shadowView = self
        backgroundView = self
        
        configure(background: config.background)
        configure(shadow: config.shadow)
    }
    
    override func setup(with viewModel: InfoViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        headerLeadingView.setup(with: viewModel.headerLeadingImage)
        headerLeadingView.isHidden = viewModel.headerLeadingImage == nil
        
        headerTitleLabel.setup(with: viewModel.headerTitle)
        headerTitleLabel.isHidden = viewModel.headerTitle == nil
        
        headerTrailingButton.setup(with: viewModel.headerTrailing)
        headerTrailingButton.isHidden = viewModel.headerTrailing == nil
        
        statusView.wrappedView.setup(with: .text(viewModel.status?.title))
        statusView.isHidden = viewModel.status == VerificationStatus.none
        
        titleLabel.setup(with: viewModel.title)
        titleLabel.isHidden = viewModel.title == nil
        
        descriptionLabel.setup(with: viewModel.description)
        descriptionLabel.isHidden = viewModel.description == nil
        
        bottomButton.setup(with: viewModel.button)
        buttonsStackView.isHidden = viewModel.button == nil
        
        switch viewModel.dismissType {
        case .auto:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.viewTapped()
            }
            
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
            
        case .tapToDismiss:
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
            
        default:
            break
        }
        
        guard headerLeadingView.isHidden,
              headerTitleLabel.isHidden,
              headerTrailingButton.isHidden else {
            layoutIfNeeded()
            
            return
        }
        
        headerStackView.isHidden = true
        
        layoutIfNeeded()
    }
    
    @objc private func headerButtonTapped(_ sender: UIButton?) {
        headerButtonCallback?()
    }
    
    @objc private func trailingButtonTapped(_ sender: UIButton?) {
        trailingButtonCallback?()
    }
    
    @objc private func viewTapped() {
        didFinish?()
    }
    
    private func toggleVisibility(isShown: Bool) {
        Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.alpha = isShown ? 1.0 : 0.0
        }
    }
}
