//
//  MenuCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-31.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    static let cellIdentifier = "MenuCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: MenuItem) {
        textLabel?.text = item.title
        textLabel?.font = Fonts.Subtitle.one
        textLabel?.textColor = item.color ?? LightColors.Text.three
        
        imageView?.image = item.icon
        imageView?.tintColor = LightColors.Text.three
        
        if let accessoryText = item.accessoryText?() {
            let label = UILabel(font: Fonts.Subtitle.one, color: LightColors.Text.three)
            label.text = accessoryText
            label.sizeToFit()
            accessoryView = label
        } else {
            accessoryView = nil
            accessoryType = .none
        }
        
        if let subTitle = item.subTitle {
            detailTextLabel?.text = subTitle
            detailTextLabel?.font = Fonts.Subtitle.two
            detailTextLabel?.textColor = LightColors.Text.three
        } else {
            detailTextLabel?.text = nil
        }
    }
}
