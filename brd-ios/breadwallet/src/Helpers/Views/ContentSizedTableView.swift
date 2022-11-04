// 
//  ContentSizedTableView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 16/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class ContentSizedTableView: UITableView {
    var heightUpdated: ((CGFloat) -> Void)?
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        heightUpdated?(contentSize.height)
        
        layoutIfNeeded()
        
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
