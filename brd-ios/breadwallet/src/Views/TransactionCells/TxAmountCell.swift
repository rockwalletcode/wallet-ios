//
//  TxAmountCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2017-12-21.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxAmountCell: UITableViewCell, Subscriber {
    
    // MARK: - Vars
    
    private let container = UIView()
    private lazy var tokenAmountLabel: UILabel = {
        let label = UILabel(font: Fonts.Title.five)
        label.textColor = LightColors.secondary
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var fiatAmountLabel: UILabel = {
        let label = UILabel(font: Fonts.Body.one)
        label.textColor = LightColors.Text.two
        label.textAlignment = .center
        return label
    }()
    private let separator = UIView(color: LightColors.Outline.one)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(container)
        contentView.addSubview(separator)
        container.addSubview(fiatAmountLabel)
        container.addSubview(tokenAmountLabel)
    }
    
    private func addConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: 0,
                                                           left: Margins.huge.rawValue,
                                                           bottom: 0,
                                                           right: -Margins.huge.rawValue))
        
        tokenAmountLabel.constrain([
            tokenAmountLabel.constraint(.top, toView: container, constant: Margins.small.rawValue),
            tokenAmountLabel.constraint(.leading, toView: container),
            tokenAmountLabel.constraint(.trailing, toView: container)
            ])
        fiatAmountLabel.constrain([
            fiatAmountLabel.constraint(toBottom: tokenAmountLabel, constant: Margins.extraSmall.rawValue),
            fiatAmountLabel.constraint(.leading, toView: container),
            fiatAmountLabel.constraint(.trailing, toView: container),
            fiatAmountLabel.constraint(.bottom, toView: container, constant: -Margins.small.rawValue)
            ])
        
        separator.constrainBottomCorners(height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: TxDetailViewModel) {
        tokenAmountLabel.text = viewModel.amount
        fiatAmountLabel.text = viewModel.fiatAmount
    }
}
