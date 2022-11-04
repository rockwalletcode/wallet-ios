//
//  MenuItem.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-01.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

struct MenuItem {
    
    enum Icon {
        static let scan = UIImage(named: "qr")
        static let feedback = UIImage(named: "love")
        static let wallet = UIImage(named: "wallet")
        static let preferences = UIImage(named: "settings")
        static let security = UIImage(named: "lock")
        static let support = UIImage(named: "chat")
        static let rewards = UIImage(named: "Star")
        static let about = UIImage(named: "info")
        static let atmMap = UIImage(named: "placemark")
        static let export = UIImage(named: "withdrawal")
    }
    
    var title: String
    var subTitle: String?
    let icon: UIImage?
    var color: UIColor?
    let accessoryText: (() -> String)?
    let callback: () -> Void
    let faqButton: UIButton? = nil
    var shouldShow: () -> Bool = { return true }
    
    init(title: String, subTitle: String? = nil, icon: UIImage? = nil, color: UIColor? = nil, accessoryText: (() -> String)? = nil, callback: @escaping () -> Void) {
        self.title = title
        self.subTitle = subTitle
        self.icon = icon?.withRenderingMode(.alwaysTemplate)
        self.color = color
        self.accessoryText = accessoryText
        self.callback = callback
    }
    
    init(title: String, icon: UIImage? = nil, color: UIColor? = nil, subMenu: [MenuItem], rootNav: UINavigationController, faqButton: UIButton? = nil) {
        let subMenuVC = MenuViewController(items: subMenu, title: title, faqButton: faqButton)
        self.init(title: title, icon: icon, color: color, accessoryText: nil) {
            rootNav.pushViewController(subMenuVC, animated: true)
        }
    }
}
