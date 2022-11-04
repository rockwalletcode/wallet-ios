//
//  TxDetailRowCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2017-12-21.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxDetailRowCell: UITableViewCell {
    
    // MARK: - Accessors
    
    public var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    // MARK: - Views
    
    internal let container = UIView()
    internal let titleLabel = UILabel(font: Fonts.Body.two, color: LightColors.Text.two)
    internal let separator = UIView(color: LightColors.Outline.one)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubviews()
        addConstraints()
        setupStyle()
    }
    
    internal func addSubviews() {
        contentView.addSubview(container)
        contentView.addSubview(separator)
        container.addSubview(titleLabel)
    }
    
    internal func addConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.small.rawValue,
                                                           left: Margins.huge.rawValue,
                                                           bottom: -Margins.small.rawValue,
                                                           right: -Margins.huge.rawValue))
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.constrain([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor)
            ])
        separator.constrainTopCorners(height: 0.5)
    }
    
    internal func setupStyle() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
