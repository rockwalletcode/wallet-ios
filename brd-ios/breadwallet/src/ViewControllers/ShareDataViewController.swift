//
//  ShareDataViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-10.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class ShareDataViewController: UIViewController {

    private let titleLabel = UILabel(font: .customBold(size: 26.0), color: LightColors.Text.one)
    private let body = UILabel.wrapping(font: .customBody(size: 16.0), color: LightColors.Text.one)
    private let label = UILabel(font: .customBold(size: 16.0), color: LightColors.Text.one)
    private let toggle = GradientSwitch()
    private let separator = UIView(color: LightColors.Outline.two)

    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setInitialData()
        navigationItem.leftBarButtonItem?.tintColor = navigationController?.navigationBar.tintColor
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(body)
        view.addSubview(label)
        view.addSubview(toggle)
        view.addSubview(separator)
    }

    private func addConstraints() {
        titleLabel.constrain([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.large.rawValue),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.large.rawValue) ])
        body.constrain([
            body.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            body.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.small.rawValue),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue) ])
        label.constrain([
            label.leadingAnchor.constraint(equalTo: body.leadingAnchor),
            label.topAnchor.constraint(equalTo: body.bottomAnchor, constant: Margins.huge.rawValue) ])
        toggle.constrain([
            toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue),
            toggle.centerYAnchor.constraint(equalTo: label.centerYAnchor) ])
        separator.constrain([
            separator.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            separator.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: Margins.large.rawValue),
            separator.trailingAnchor.constraint(equalTo: toggle.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0) ])
    }

    private func setInitialData() {
        titleLabel.text = L10n.ShareData.header
        body.text = L10n.ShareData.body
        label.text = L10n.ShareData.toggleLabel
        view.backgroundColor = LightColors.Background.two

        if UserDefaults.hasAquiredShareDataPermission {
            toggle.isOn = true
            toggle.sendActions(for: .valueChanged)
        }

        toggle.valueChanged = { [weak self] in
            UserDefaults.hasAquiredShareDataPermission = self?.toggle.isOn ?? false
        }
    }
}
