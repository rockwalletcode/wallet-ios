//
//  UIViewController+Alerts.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-07-04.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: L10n.Alert.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessageAndDismiss(_ message: String) {
        let alert = UIAlertController(title: L10n.Alert.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.ok, style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String, buttonLabel: String = L10n.Button.ok) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndDismiss(title: String, message: String, buttonLabel: String = L10n.Button.ok) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showToastMessage(message: String) {
        let messageView = UIView()
        messageView.setupCustomMargins(all: .large)
        messageView.backgroundColor = LightColors.Error.one
        messageView.layer.cornerRadius = CornerRadius.common.rawValue
        
        let textLabel = UILabel()
        textLabel.textColor = LightColors.Background.one
        textLabel.font = Fonts.Body.two
        textLabel.text = message
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.clipsToBounds = true
        
        view.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Margins.large.rawValue)
            make.leading.equalToSuperview().offset(Margins.large.rawValue)
            make.trailing.equalToSuperview().offset(-Margins.large.rawValue)
            make.height.equalTo(72)
        }
        messageView.layoutIfNeeded()
        messageView.alpha = 1
        
        messageView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(messageView.snp.margins)
        }
            
        UIView.animate(withDuration: 6.0) {
            messageView.alpha = 0
        } completion: { _ in
            messageView.removeFromSuperview()
        }
    }
    
    func showInfoPopup(with model: PopupViewModel, callbacks: [(() -> Void)] = []) {
        
        let blurView = UIVisualEffectView()
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let popup = FEPopupView()
        view.addSubview(popup)
        popup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(view.snp.leadingMargin)
            make.trailing.greaterThanOrEqualTo(view.snp.trailingMargin)
        }
        popup.alpha = 1
        popup.layer.shadowColor = UIColor.black.cgColor
        popup.layer.shadowOpacity = 0.15
        popup.layer.shadowRadius = 4.0
        popup.layer.shadowOffset = .zero
        popup.layoutIfNeeded()
        
        popup.configure(with: Presets.Popup.white)
        popup.setup(with: model)
        
        popup.buttonCallbacks = callbacks
        popup.closeCallback = { [weak self] in
            self?.hidePopup()
        }
        
        UIView.animate(withDuration: Presets.Animation.duration,
                       delay: 0,
                       options: .transitionFlipFromBottom) {
            blurView.effect = UIBlurEffect(style: .regular)
            popup.alpha = 1
        }
    }
    
    // MARK: - Additional Helpers
    @objc func hidePopup() {
        guard let popup = view.subviews.first(where: { $0 is FEPopupView })
        else { return }
        let blur = view.subviews.first(where: { $0 is UIVisualEffectView })
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            popup.alpha = 0
            blur?.alpha = 0
        } completion: { _ in
            popup.removeFromSuperview()
            blur?.removeFromSuperview()
        }
    }
}
