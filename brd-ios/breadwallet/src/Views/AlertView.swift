//
//  AlertView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-22.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum AlertType {
    case pinSet(callback: () -> Void)
    case paperKeySet(callback: () -> Void)
    case sendSuccess
    case addressesCopied
    case sweepSuccess(callback: () -> Void)
    case accountCreation
    case cloudBackupRestoreSuccess(callback: () -> Void)
    case cloudBackupSuccess
    case walletRestored(callback: () -> Void)
    case walletUnlinked(callback: () -> Void)
    case none

    var header: String {
        switch self {
        case .pinSet:
            return L10n.Alerts.pinSet
        case .paperKeySet:
            return L10n.Alerts.paperKeySet
        case .sendSuccess:
            return L10n.Alerts.sendSuccess
        case .addressesCopied:
            return L10n.Alerts.copiedAddressesHeader
        case .sweepSuccess:
            return L10n.Import.success
        case .accountCreation, .cloudBackupRestoreSuccess, .cloudBackupSuccess:
            return L10n.Import.success
        case .walletRestored:
            return L10n.Alerts.walletRestored
        case .walletUnlinked:
            return ""
        case .none:
            return "none"
        }
    }

    var subheader: String {
        switch self {
        case .pinSet:
            return ""
        case .paperKeySet:
            return L10n.Alerts.paperKeySetSubheader
        case .sendSuccess:
            return L10n.Alerts.sendSuccessSubheader
        case .addressesCopied:
            return L10n.Alerts.copiedAddressesSubheader
        case .sweepSuccess:
            return L10n.Import.successBody
        case .accountCreation:
            return L10n.Alert.hederaAccount
        case .cloudBackupRestoreSuccess:
            return L10n.Alert.accountRestorediCloud
        case .cloudBackupSuccess:
            return L10n.Alert.accountBackedUpiCloud
        case .walletRestored, .walletUnlinked:
            return ""
        case .none:
            return "none"
        }
    }

    var icon: UIView {
        return CheckView()
    }
}

extension AlertType: Equatable {}

func == (lhs: AlertType, rhs: AlertType) -> Bool {
    switch (lhs, rhs) {
    case (.pinSet, .pinSet):
        return true
    case (.paperKeySet, .paperKeySet):
        return true
    case (.sendSuccess, .sendSuccess):
        return true
    case (.addressesCopied, .addressesCopied):
        return true
    case (.sweepSuccess, .sweepSuccess):
        return true
    case (.accountCreation, .accountCreation):
        return true
    case (.cloudBackupRestoreSuccess, .cloudBackupRestoreSuccess):
        return true
    case (.cloudBackupSuccess, .cloudBackupSuccess):
        return true
    case (.none, .none):
        return true
    default:
        return false
    }
}

class AlertView: UIView {

    private let type: AlertType
    private let header = UILabel()
    private let subheader = UILabel()
    private let separator = UIView()
    private let icon: UIView
    private let iconSize: CGFloat = 96.0
    private let separatorYOffset: CGFloat = 48.0

    init(type: AlertType) {
        self.type = type
        self.icon = type.icon

        super.init(frame: .zero)
        layer.cornerRadius = 6.0
        layer.masksToBounds = true
        setupSubviews()
    }

    func animate() {
        guard let animatableIcon = icon as? AnimatableIcon else { return }
        animatableIcon.startAnimating()
    }

    private func setupSubviews() {
        backgroundColor = LightColors.Success.one
        
        addSubview(header)
        addSubview(subheader)
        addSubview(icon)
        addSubview(separator)

        setData()
        addConstraints()
    }

    private func setData() {
        header.text = type.header
        header.textAlignment = .center
        header.font = Fonts.Title.six
        header.textColor = LightColors.Contrast.two

        icon.backgroundColor = .clear
        separator.backgroundColor = .clear

        subheader.text = type.subheader
        subheader.textAlignment = .center
        subheader.font = Fonts.Title.six
        subheader.textColor = LightColors.Contrast.two
    }

    private func addConstraints() {

        //NB - In this alert view, constraints shouldn't be pinned to the bottom
        //of the view because the bottom actually extends off the bottom of the screen a bit.
        //It extends so that it still covers up the underlying view when it bounces on screen.

        header.constrainTopCorners(sidePadding: Margins.large.rawValue, topPadding: Margins.large.rawValue)
        separator.constrain([
            separator.constraint(.height, constant: 1.0),
            separator.constraint(.width, toView: self),
            separator.constraint(.top, toView: self, constant: separatorYOffset),
            separator.constraint(.leading, toView: self, constant: nil) ])
        icon.constrain([
            icon.constraint(.centerX, toView: self, constant: nil),
            icon.constraint(.centerY, toView: self, constant: nil),
            icon.constraint(.width, constant: iconSize),
            icon.constraint(.height, constant: iconSize) ])
        subheader.constrain([
            subheader.constraint(.leading, toView: self, constant: Margins.large.rawValue),
            subheader.constraint(.trailing, toView: self, constant: -Margins.large.rawValue),
            subheader.constraint(toBottom: icon, constant: Margins.huge.rawValue) ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
