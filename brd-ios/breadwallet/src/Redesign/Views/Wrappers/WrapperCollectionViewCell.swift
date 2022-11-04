// 
//  WrapperCollectionViewCell.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class WrapperCollectionCell<T: UIView>: UICollectionViewCell, Reusable {
    static var identifier: String {
        return (String(describing: T.self))
    }
    
    // MARK: Variables
    
    var wrappedView = T()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    var shouldHighlight: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        (wrappedView as? Reusable)?.prepareForReuse()
    }
    
    func setupSubviews() {
        contentView.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.margins)
        }

        setupCustomMargins(vertical: .zero, horizontal: .small)
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }
}
