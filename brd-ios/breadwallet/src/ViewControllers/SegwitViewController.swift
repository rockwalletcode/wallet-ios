//
//  SegwitViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-10-11.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class SegwitViewController: UIViewController {
    
    let logo = UIImageView(image: UIImage(named: "SegWitLogo"))
    let label = UILabel.wrapping(font: .customBody(size: 14.0), color: LightColors.Text.one)
    let button = BRDButton(title: L10n.Segwit.enable, type: .primary)
    let confirmView = EnableSegwitView()
    let enabled = SegwitEnabledView()
    
    var buttonXConstraintStart: NSLayoutConstraint?
    var buttonXConstraintEnd: NSLayoutConstraint?
    var confirmXConstraintStart: NSLayoutConstraint?
    var confirmXConstraintEnd: NSLayoutConstraint?
    var confirmXConstraintFinal: NSLayoutConstraint?
    var enabledYConstraintStart: NSLayoutConstraint?
    var enabledYConstraintEnd: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        view.addSubview(logo)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(confirmView)
        view.addSubview(enabled)
    }
    
    private func addConstraints() {
        logo.constrain([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 160.0),
            logo.heightAnchor.constraint(equalToConstant: 40.0),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.large.rawValue)])
        label.constrain([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.huge.rawValue),
            label.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: Margins.huge.rawValue),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.huge.rawValue)])
        
        buttonXConstraintStart = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        buttonXConstraintEnd = button.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Margins.large.rawValue)
        button.constrain([
            buttonXConstraintStart,
            button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Margins.custom(6)),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.huge.rawValue),
            button.heightAnchor.constraint(equalToConstant: 48.0)])
        
        confirmXConstraintStart = confirmView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: Margins.large.rawValue)
        confirmXConstraintEnd = confirmView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        confirmXConstraintFinal = confirmView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Margins.large.rawValue)
        confirmView.constrain([
            confirmView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.huge.rawValue),
            confirmXConstraintStart,
            confirmView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Margins.custom(6))])
        
        enabledYConstraintStart = enabled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50.0)
        enabledYConstraintEnd = enabled.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.large.rawValue)
        enabled.constrain([
            enabledYConstraintStart,
            enabled.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enabled.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Margins.custom(6))])
    }
    
    private func setInitialData() {
        view.backgroundColor = LightColors.Background.one
        view.clipsToBounds = true //Some subviews are placed just offscreen so they can be animated into view
        label.text = L10n.Segwit.confirmationInstructionsInstructions
        logo.tintColor = LightColors.Text.one
        
        button.tap = { [weak self] in
            self?.showConfirmView()
        }
        
        confirmView.didCancel = { [weak self] in
            self?.hideConfirmView()
        }
        
        confirmView.didContinue = { [weak self] in
            self?.didContinue()
        }
        
        enabled.home.tap = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func didContinue() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        UserDefaults.hasOptedInSegwit = true
        Store.trigger(name: .optInSegWit)
        UIView.spring(0.6, animations: {
            self.confirmXConstraintEnd?.isActive = false
            self.enabledYConstraintStart?.isActive = false
            NSLayoutConstraint.activate([self.confirmXConstraintFinal!, self.enabledYConstraintEnd!])
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.enabled.checkView.drawCircle()
            self.enabled.checkView.drawCheckBox()
        })
    }
    
    private func hideConfirmView() {
        UIView.spring(Presets.Animation.duration, animations: {
            self.button.isHidden = false
            self.confirmXConstraintEnd?.isActive = false
            self.buttonXConstraintEnd?.isActive = false
            NSLayoutConstraint.activate([self.confirmXConstraintStart!, self.buttonXConstraintStart!])
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }
    
    private func showConfirmView() {
        UIView.spring(Presets.Animation.duration, animations: {
            self.buttonXConstraintStart?.isActive = false
            self.confirmXConstraintStart?.isActive = false
            NSLayoutConstraint.activate([self.confirmXConstraintEnd!, self.buttonXConstraintEnd!])
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }
    
}
