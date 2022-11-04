// 
// Created by Equaleyes Solutions Ltd
// 

import UIKit

protocol Identifiable {
    static var identifier: String { get }
    static var className: AnyClass { get }
}

extension Identifiable where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var className: AnyClass {
        return Self.self
    }
}

extension UITableView {
    func register<T: Identifiable>(_ cell: T.Type) {
        register(cell.className, forCellReuseIdentifier: cell.identifier)
    }
    
    func dequeueReusableCell<T: Identifiable>(for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }
    
    func registerAccessoryView<T: Identifiable>(_ cell: T.Type) {
        register(cell.className, forHeaderFooterViewReuseIdentifier: cell.identifier)
    }
    
    func dequeueAccessoryView<T: Identifiable>() -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T
    }
}

extension UICollectionView {
    func register<T: Identifiable>(_ cell: T.Type) {
        register(cell.className, forCellWithReuseIdentifier: cell.identifier)
    }
    
    func dequeueReusableCell<T: Identifiable>(for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}

// MARK: - UI Tweaks

extension UITableView {
    func emptyHeaderFooterView() {
        tableHeaderView = UIView(frame: CGRect(origin: .zero,
                                               size: CGSize(width: 0,
                                                            height: CGFloat.leastNonzeroMagnitude)))
        tableFooterView = UIView(frame: CGRect(origin: .zero,
                                               size: CGSize(width: 0,
                                                            height: CGFloat.leastNonzeroMagnitude)))
    }
}

extension UITableViewCell {
    func addSeparator() {
        lazy var separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = LightColors.Outline.one
            return view
        }()
        
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(-Margins.extraExtraHuge.rawValue)
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
    }
}
