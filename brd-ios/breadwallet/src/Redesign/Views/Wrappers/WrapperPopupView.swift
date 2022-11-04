// 
//  WrapperPopupView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct WrapperPopupConfiguration<C: Configurable>: Configurable {
    var background: BackgroundConfiguration = .init(backgroundColor: .white, tintColor: .black, border: Presets.Border.zero)
    var leading: BackgroundConfiguration?
    var title = LabelConfiguration(font: Fonts.Title.six, textColor: LightColors.Text.one, textAlignment: .center)
    var trailing = Presets.Button.blackIcon
    var confirm = Presets.Button.primary
    var cancel = Presets.Button.secondary
    var wrappedView: C?
}

struct WrapperPopupViewModel<VM: ViewModel>: ViewModel {
    var leading: ImageViewModel?
    var title: LabelViewModel?
    var trailing: ButtonViewModel?
    
    var confirm: ButtonViewModel?
    var cancel: ButtonViewModel?
    
    var wrappedView: VM?
}

class WrapperPopupView<T: ViewProtocol & UIView>: UIView,
                                         Wrappable,
                                         Reusable,
                                         Borderable {
    
    // MARK: Lazy UI
    lazy var content: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    var cancelCallback: (() -> Void)?
    var confirmCallback: (() -> Void)?
    var config: WrapperPopupConfiguration<T.C>?
    var viewModel: WrapperPopupViewModel<T.VM>?
    
    lazy var wrappedView = T()
    
    private lazy var blurView: UIView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
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
    
    private lazy var headerTrailingView: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var confirmButton: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(confirmTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var cancelButton: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
    }

    func setupSubviews() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(snp.leadingMargin)
            make.top.greaterThanOrEqualToSuperview()
        }
        content.layoutMargins = UIEdgeInsets(top: Margins.large.rawValue,
                                             left: Margins.huge.rawValue,
                                             bottom: Margins.large.rawValue,
                                             right: Margins.huge.rawValue)
        content.isLayoutMarginsRelativeArrangement = true
        
        setupCustomMargins(vertical: .extraHuge)

        content.addArrangedSubview(headerStackView)
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
        
        headerStackView.addArrangedSubview(headerTrailingView)
        headerTrailingView.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        content.addArrangedSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        content.addArrangedSubview(wrappedView)
        content.addArrangedSubview(buttonStack)
        
        buttonStack.addArrangedSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
        }
        buttonStack.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
        }
        
        isUserInteractionEnabled = true
        content.isUserInteractionEnabled = true
        wrappedView.isUserInteractionEnabled = true
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }
    
    func configure(with config: WrapperPopupConfiguration<T.C>?) {
        guard let config = config else { return }
        self.config = config
        
        configure(background: config.background)
        headerLeadingView.configure(with: config.leading)
        headerTitleLabel.configure(with: config.title)
        headerTrailingView.configure(with: config.trailing)
        wrappedView.configure(with: config.wrappedView)
        confirmButton.configure(with: config.confirm)
        cancelButton.configure(with: config.cancel)
    }
    
    func setup(with viewModel: WrapperPopupViewModel<T.VM>?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel

        headerLeadingView.setup(with: viewModel.leading)
        headerTitleLabel.setup(with: viewModel.title)
        headerTrailingView.setup(with: viewModel.trailing)
        wrappedView.setup(with: viewModel.wrappedView)
        
        confirmButton.setup(with: viewModel.confirm)
        cancelButton.setup(with: viewModel.cancel)
        
        guard headerLeadingView.isHidden,
              headerTitleLabel.isHidden,
              headerTrailingView.isHidden else {
            return
        }
        lineView.isHidden = true
        headerStackView.isHidden = true
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        guard subview == wrappedView else { return }
        
        removeFromSuperview()
    }
    
    func prepareForReuse() {
        (wrappedView as? Reusable)?.prepareForReuse()
    }
    
    func configure(background: BackgroundConfiguration?) {
        guard let background = background else { return }
        
        tintColor = background.tintColor
        
        layoutIfNeeded()
        
        content.setBackground(with: background)
    }
    
    @objc private func headerButtonTapped(sender: Any?) {
        hide()
    }
    
    @objc private func confirmTapped(_ sender: Any?) {
        hide()
        confirmCallback?()
    }
    
    @objc private func cancelTapped(_ sender: Any?) {
        hide()
        cancelCallback?()
    }
    
    private func hide() {
        UIView.animate(withDuration: Presets.Animation.duration, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
}
