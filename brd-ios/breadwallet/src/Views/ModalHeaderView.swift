//
//  ModalHeaderView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-01.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class ModalHeaderView: UIView {
    // MARK: - Public
    
    var closeCallback: (() -> Void)? {
        didSet { close.tap = closeCallback }
    }
    
    init(title: String, faqInfo: String? = nil, currency: Currency? = nil) {
        self.titleLabel.text = title
        
        if let faqInfo = faqInfo {
            self.faq = UIButton.buildFaqButton(articleId: faqInfo, currency: currency, position: .middle)
        }

        super.init(frame: .zero)
        
        setupSubviews()
        addFaqButtonIfNeeded()
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    // MARK: - Private
    
    private let titleLabel = UILabel()
    private let close = UIButton.buildModernCloseButton(position: .middle)
    private var faq: UIButton?
    private let border = UIView()
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(close)
        addSubview(border)
        
        titleLabel.constrain([
            titleLabel.constraint(.centerX, toView: self),
            titleLabel.constraint(.centerY, toView: self)])
        
        border.constrain([
            border.constraint(.leading, toView: self, constant: Margins.large.rawValue),
            border.constraint(.trailing, toView: self, constant: -Margins.large.rawValue),
            border.constraint(.bottom, toView: self),
            border.constraint(.height, constant: ViewSizes.minimum.rawValue)])
        
        close.constrain([
            close.constraint(.leading, toView: self),
            close.constraint(.centerY, toView: self),
            close.constraint(.height, constant: ViewSizes.Common.largeButton.rawValue),
            close.constraint(.width, constant: ViewSizes.Common.largeButton.rawValue)])

        backgroundColor = LightColors.Background.one
        
        setColors()
    }

    private func addFaqButtonIfNeeded() {
        guard let faq = faq else { return }
        
        addSubview(faq)
        
        faq.constrain([
            faq.constraint(.trailing, toView: self),
            faq.constraint(.centerY, toView: self),
            faq.constraint(.height, constant: ViewSizes.Common.largeButton.rawValue),
            faq.constraint(.width, constant: ViewSizes.Common.largeButton.rawValue) ])
    }

    private func setColors() {
        titleLabel.font = Fonts.Title.six
        titleLabel.textColor = LightColors.Text.three
        border.backgroundColor = LightColors.Outline.one
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
