//
//  FEPopupView.swift
//  breadwallet
//
//  Created by Rok on 23/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct PopupConfiguration: Configurable {
    var background: BackgroundConfiguration?
    var title: LabelConfiguration?
    var body: LabelConfiguration?
    var buttons: [ButtonConfiguration] = []
    var closeButton: ButtonConfiguration?
}

struct PopupViewModel: ViewModel {
    var title: LabelViewModel?
    var imageName: String?
    var body: String?
    var buttons: [ButtonViewModel] = []
    var closeButton: ButtonViewModel? = .init(image: Asset.close.image)
}

class FEPopupView: FEView<PopupConfiguration, PopupViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var imageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var scrollingStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var closeButtonContainer: WrapperView<FEButton> = {
        let view = WrapperView<FEButton>()
        view.wrappedView.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var closeButton: WrapperView<FEButton> = {
        let view = WrapperView<FEButton>()
        view.wrappedView.setupCustomMargins(all: .large)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .init(top: Margins.zero.rawValue,
                                        left: Margins.zero.rawValue,
                                        bottom: Margins.medium.rawValue,
                                        right: Margins.zero.rawValue)
        return view
    }()
    
    private lazy var buttons: [FEButton] = []
    
    var closeCallback: (() -> Void)?
    var buttonCallbacks: [() -> Void] = []
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(Margins.extraHuge.rawValue + Margins.huge.rawValue)
            make.leading.trailing.bottom.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        content.addSubview(closeButtonContainer)
        closeButtonContainer.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.width.height.equalTo(Margins.huge.rawValue * 2 + ViewSizes.extraSmall.rawValue)
        }
        
        closeButtonContainer.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(Margins.huge.rawValue)
            make.width.height.equalTo(ViewSizes.small.rawValue)
        }
        
        mainStack.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Margins.small.rawValue)
        }
        
        mainStack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().priority(.low)
        }
        
        mainStack.addArrangedSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(Int.max).priority(.low)
        }
        
        scrollView.addSubview(scrollingStack)
        scrollingStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStack).inset(Margins.small.rawValue)
            make.top.equalToSuperview().inset(Margins.medium.rawValue)
            make.bottom.equalToSuperview()
        }
        
        scrollingStack.addArrangedSubview(textView)
    }
    
    override func configure(with config: PopupConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        titleLabel.configure(with: config.title)
        configure(background: config.background)
        
        closeButton.wrappedView.configure(with: config.closeButton)
        
        guard let body = config.body else { return }
        textView.font = body.font
        textView.textColor = body.textColor
        textView.textAlignment = body.textAlignment
        textView.textContainer.lineBreakMode = body.lineBreakMode
    }
    
    override func setup(with viewModel: PopupViewModel?) {
        guard let viewModel = viewModel else { return }
        
        super.setup(with: viewModel)
        titleLabel.setup(with: viewModel.title)
        titleLabel.isHidden = viewModel.title == nil
        
        closeButton.wrappedView.setup(with: viewModel.closeButton)
        
        imageView.setup(with: .imageName(viewModel.imageName))
        imageView.isHidden = viewModel.imageName == nil
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        textView.attributedText = NSAttributedString(string: viewModel.body ?? "", attributes: attributes)
        textView.isHidden = viewModel.body == nil
        textView.sizeToFit()
        
        layoutIfNeeded()
        
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        let buttonHeight = ViewSizes.Common.largeCommon.rawValue
        
        if viewModel.buttons.isEmpty == false {
            for i in (0...viewModel.buttons.count - 1) {
                guard let buttonConfigs = config?.buttons else { return }
                let model = viewModel.buttons[i]
                let config = buttonConfigs.count <= i ? config?.buttons.last : buttonConfigs[i]
                
                let button = FEButton()
                button.configure(with: config)
                button.snp.makeConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
                button.setup(with: model)
                scrollingStack.addArrangedSubview(button)
                buttons.append(button)
                button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
        
        scrollingStack.layoutIfNeeded()
        
        var newHeight = textView.contentSize.height
        newHeight += (CGFloat(viewModel.buttons.count) * buttonHeight) + Margins.extraHuge.rawValue
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(newHeight)
        }
    }
    
    @objc private func closeTapped() {
        closeCallback?()
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let index = buttons.firstIndex(where: { $0 == sender }),
              index < buttonCallbacks.count
        else { return }
        
        buttonCallbacks[index]()
    }
}
