//
//  TokenCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-04-08.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum EditWalletType {
    case manage
    case add
    
    var addTitle: String {
        return self == .manage ? L10n.TokenList.show : L10n.TokenList.add
    }
    
    var removeTitle: String {
        return self == .manage ? L10n.TokenList.hide : L10n.TokenList.remove
    }
}

class ManageCurrencyCell: UITableViewCell {
    static let cellIdentifier = "ManageCurrencyCell"

    private lazy var iconImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        view.setupClearMargins()
        return view
    }()
    
    private let header = UILabel(font: Fonts.Body.one, color: LightColors.Text.one)
    private let button = ToggleButton(normalTitle: L10n.TokenList.add,
                                      normalColor: LightColors.primary,
                                      selectedTitle: L10n.TokenList.hide,
                                      selectedColor: LightColors.Error.one)
    private var identifier: CurrencyId = ""
    private var listType: EditWalletType = .add
    private var isCurrencyHidden = false
    private var isCurrencyRemovable = true
    
    var didAddIdentifier: ((CurrencyId) -> Void)?
    var didRemoveIdentifier: ((CurrencyId) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func set(currency: CurrencyMetaData, balance: Amount?, listType: EditWalletType, isHidden: Bool, isRemovable: Bool) {
        header.text = currency.name
        iconImageView.wrappedView.setup(with: .image(currency.imageSquareBackground))
        iconImageView.configure(background: BackgroundConfiguration(border: .init(borderWidth: 0, cornerRadius: .fullRadius)))
        isCurrencyHidden = isHidden
        isCurrencyRemovable = isRemovable
        identifier = currency.uid
        self.listType = listType
        setState()
    }

    private func setupViews() {
        header.adjustsFontSizeToFitWidth = true
        selectionStyle = .none
        
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(header)
        contentView.addSubview(iconImageView)
        contentView.addSubview(button)
    }

    private func addConstraints() {
        iconImageView.constrain([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large.rawValue),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue),
            iconImageView.widthAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue)])
        header.constrain([
            header.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Margins.medium.rawValue),
            header.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        button.constrain([
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Margins.huge.rawValue),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue),
            button.widthAnchor.constraint(equalToConstant: 105),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: header.trailingAnchor, constant: Margins.small.rawValue)])
    }
    
    private func setState() {
        if listType == .add {
            button.setTitle(L10n.TokenList.add.uppercased(), for: .normal)
            button.setTitle(L10n.TokenList.remove.uppercased(), for: .selected)
            button.setTitleColor(LightColors.primary, for: .normal)
            button.setTitleColor(LightColors.Error.one, for: .selected)
            button.setTitleColor(LightColors.primary.withAlphaComponent(0.4), for: .disabled)
            button.layer.borderColor = LightColors.primary.cgColor
        } else {
            button.setTitle(L10n.TokenList.remove.uppercased(), for: .normal)
            button.setTitle(L10n.TokenList.remove.uppercased(), for: .selected)
            button.setTitleColor(LightColors.Error.one, for: .normal)
            button.setTitleColor(LightColors.Error.one.withAlphaComponent(0.2), for: .selected)
            button.setTitleColor(LightColors.Error.one.withAlphaComponent(0.4), for: .disabled)
            button.layer.borderColor = LightColors.Error.one.cgColor
        }
        
        button.tap = { [weak self] in
            guard let self = self else { return }
            
            if self.listType == .manage {
                self.didRemoveIdentifier?(self.identifier)
            } else if self.listType == .add {
                let isRemoveButton = self.button.isSelected
                if isRemoveButton {
                    self.didRemoveIdentifier?(self.identifier)
                } else {
                    self.didAddIdentifier?(self.identifier)
                }
                self.button.isSelected = !isRemoveButton
            }
        }
        if listType == .add {
            button.isSelected = !isCurrencyHidden
        } else {
            button.isEnabled = isCurrencyRemovable
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
