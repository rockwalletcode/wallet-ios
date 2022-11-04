//
//  Marginable.swift
//  
//
//  Created by Rok Cresnik on 02/09/2021.
//

import UIKit

/// Protocol for updating margins in Views
protocol Marginable {
    /// Sets all margins to zero
    func setupClearMargins()
    /// Sets all margins by the same value
    func setupCustomMargins(all: Margins?)
    /// Sets vertical / horizontal margins
    func setupCustomMargins(vertical: Margins?, horizontal: Margins?)
    /// Sets margins individual margins
    func setupCustomMargins(top: Margins?, leading: Margins?, bottom: Margins?, trailing: Margins?)
    
    /// The view that the layout margins should be set
    var marginableView: UIView { get }
}

extension UIView: Marginable {}

extension Marginable where Self: UITableViewCell {
    var marginableView: UIView { return contentView }
}

extension Marginable where Self: UICollectionViewCell {
    var marginableView: UIView { return contentView }
}

extension Marginable where Self: UITableViewHeaderFooterView {
    var marginableView: UIView { return contentView }
}

extension Marginable where Self: UIView {
    var marginableView: UIView { return self }
}

extension Marginable {
    func setupClearMargins() {
        setupCustomMargins(all: .zero)
    }
    
    func setupCustomMargins(all: Margins?) {
        setupCustomMargins(top: all, leading: all, bottom: all, trailing: all)
    }
    
    func setupCustomMargins(vertical: Margins? = nil, horizontal: Margins? = nil) {
        setupCustomMargins(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    func setupCustomMargins(top: Margins? = nil, leading: Margins? = nil, bottom: Margins? = nil, trailing: Margins? = nil) {
        marginableView.preservesSuperviewLayoutMargins = false
        
        if let top = top {
            marginableView.directionalLayoutMargins.top = top.rawValue
        }
        if let bottom = bottom {
            marginableView.directionalLayoutMargins.bottom = bottom.rawValue
        }
        if let leading = leading {
            marginableView.directionalLayoutMargins.leading = leading.rawValue
        }
        if let trailing = trailing {
            marginableView.directionalLayoutMargins.trailing = trailing.rawValue
        }
    }
}
