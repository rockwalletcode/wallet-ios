//
//  PushNotificationsViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-05.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import UserNotifications

class PushNotificationsViewController: UIViewController {

    private let toggleLabel = UILabel.wrapping(font: Fonts.Body.one, color: LightColors.Text.one)
    private let body = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    private let toggle = UISwitch()
    private let separator = UIView()
    private let openSettingsButton = BRDButton(title: L10n.Button.openSettings, type: .primary)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var areNotificationsEnabled: Bool {
        return Store.state.isPushNotificationsEnabled
    }
    
    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setData()
        listenForForegroundNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNotificationsSettings()
    }
    
    private func checkNotificationsSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateForNotificationStatus(status: settings.authorizationStatus)
            }
        }
    }

    private func updateForNotificationStatus(status: UNAuthorizationStatus) {
        self.body.text = bodyText(notificationsStatus: status)
        toggle.isEnabled = (status == .authorized)
        if !toggle.isEnabled {
            toggle.setOn(false, animated: false)
        }
        openSettingsButton.isHidden = (status == .authorized)
    }
    
    @objc private func willEnterForeground() {
        checkNotificationsSettings()
    }
    
    private func listenForForegroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func addSubviews() {
        view.addSubview(body)
        view.addSubview(toggleLabel)
        view.addSubview(toggle)
        view.addSubview(separator)
        view.addSubview(openSettingsButton)
    }

    private func addConstraints() {
        
        toggle.constrain([
            toggle.centerYAnchor.constraint(equalTo: toggleLabel.centerYAnchor),
            toggle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Margins.large.rawValue)
            ])
        
        toggle.setContentCompressionResistancePriority(.required, for: .horizontal)

        toggleLabel.constrain([
            toggleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.large.rawValue),
            toggleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Margins.large.rawValue),
            toggleLabel.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -Margins.large.rawValue)
            ])
        
        separator.constrain([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: Margins.large.rawValue),
            separator.leftAnchor.constraint(equalTo: view.leftAnchor),
            separator.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        body.constrain([
            body.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Margins.large.rawValue),
            body.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Margins.small.rawValue),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.large.rawValue)
            ])
        
        openSettingsButton.constrain([
            openSettingsButton.heightAnchor.constraint(equalToConstant: ViewSizes.Common.defaultCommon.rawValue),
            openSettingsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Margins.large.rawValue),
            openSettingsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Margins.large.rawValue),
            openSettingsButton.topAnchor.constraint(equalTo: body.bottomAnchor, constant: Margins.huge.rawValue)
            ])
    }
    
    private func bodyText(notificationsStatus: UNAuthorizationStatus) -> String {
        if notificationsStatus == .authorized {
            return areNotificationsEnabled ? L10n.PushNotifications.enabledBody : L10n.PushNotifications.disabledBody
        } else {
            return L10n.PushNotifications.enableInstructions
        }
    }
    
    private func setData() {
        title = L10n.Settings.notifications
        
        view.backgroundColor = LightColors.Background.one
        separator.backgroundColor = LightColors.Text.three
        
        toggleLabel.text = L10n.PushNotifications.label
        toggleLabel.textColor = LightColors.Text.one
        
        toggle.isOn = areNotificationsEnabled
        toggle.sendActions(for: .valueChanged)
        
        toggle.valueChanged = { [weak self] in
            guard let self = self else { return }
            if self.toggle.isOn {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        let status = settings.authorizationStatus
                        switch status {
                        case .authorized:
                            Store.perform(action: PushNotifications.SetIsEnabled(true))
                            Store.trigger(name: .registerForPushNotificationToken)
                            self.updateForNotificationStatus(status: .authorized)
                        default:
                            break
                        }
                    }
                }
            } else {
                Store.perform(action: PushNotifications.SetIsEnabled(false))
                if let token = UserDefaults.pushToken {
                    Backend.apiClient.deletePushNotificationToken(token)
                }
                self.updateForNotificationStatus(status: .authorized)
            }
        }
        
        openSettingsButton.tap = {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
    }
}
