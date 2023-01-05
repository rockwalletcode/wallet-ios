// 
//  WrapperTableViewCell.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

protocol Wrappable: UIView {
    associatedtype WrappedView: UIView
    
    var wrappedView: WrappedView { get set }
}

class WrapperTableViewCell<T: UIView>: UITableViewCell, Wrappable, Reusable, Identifiable {
    
    // MARK: Variables
    var wrappedView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // TODO: fix this logic to work with selectionStyle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        (wrappedView as? Reusable)?.prepareForReuse()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // TODO: fix this logic to work with selectionStyle
        
        guard shouldHighlight else { return }
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.contentView.backgroundColor = highlighted ? LightColors.Background.three : .clear
        }
    }
    
    var shouldHighlight: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrappedView.layoutSubviews()
    }
    
    private func setupViews() {
        selectionStyle = .none

        contentView.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.margins)
        }
        setupCustomMargins(all: .zero)
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }
}
