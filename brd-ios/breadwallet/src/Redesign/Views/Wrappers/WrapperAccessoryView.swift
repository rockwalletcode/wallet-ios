// 
//  WrapperAccessoryView.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class WrapperAccessoryView<V: UIView>: UITableViewHeaderFooterView, Wrappable, Identifiable, Reusable {
    
    // MARK: Wrappable
    public lazy var wrappedView = V()
    
    // MARK: Overrides
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        contentView.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.margins)
        }
        
        setupCustomMargins(vertical: .large, horizontal: .small)
    }
    
    func setup(_ closure: (V) -> Void) {
        closure(wrappedView)
    }
    
    public override func prepareForReuse() {
        wrappedView.removeFromSuperview()
        super.prepareForReuse()
    }
}
