//
//  SegwitViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-10-11.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class SegwitViewController: UIViewController {
    
    let logo = UIImageView(image: Asset.segWitLogo.image)
    let label = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.one)
    let button = BRDButton(title: L10n.Segwit.enable, type: .secondary)
    private lazy var enabledView: WrapperView<FEInfoView> = {
        let view = WrapperView<FEInfoView>()
        view.configure(background: .init(backgroundColor: LightColors.Background.three, border: Presets.Border.commonPlain))
        view.wrappedView.configure(with: .init(title: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.three),
                                               description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one)))
        view.wrappedView.setup(with: .init(title: .text(L10n.Segwit.confirmationConfirmationTitle),
                                           description: .text(L10n.Segwit.confirmationConfirmationBody)))
        view.content.setupCustomMargins(all: .extraLarge)
        view.alpha = 0
        return view
    }()
    
    private lazy var segwitAlert: WrapperPopupView<FELabel> = {
        let alert = WrapperPopupView<FELabel>()
        alert.configure(with: .init(background: .init(backgroundColor: LightColors.Background.one, border: Presets.Border.commonPlain),
                                    trailing: Presets.Button.blackIcon,
                                    confirm: Presets.Button.primary,
                                    cancel: Presets.Button.secondary,
                                    wrappedView: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .center)))
        
        alert.setup(with: .init(trailing: .init(image: Asset.close.image),
                                confirm: .init(title: L10n.Button.continueAction),
                                cancel: .init(title: L10n.Button.cancel),
                                wrappedView: .text(L10n.Segwit.confirmChoiceLayout),
                                hideSeparator: true))
        alert.confirmCallback = didContinue
        alert.alpha = 0
        return alert
    }()
    
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
        
        button.constrain([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Margins.custom(6)),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.huge.rawValue),
            button.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeCommon.rawValue)])
    }
    
    private func setInitialData() {
        view.backgroundColor = LightColors.Background.one
        view.clipsToBounds = true //Some subviews are placed just offscreen so they can be animated into view
        label.text = L10n.Segwit.confirmationInstructionsInstructions
        logo.tintColor = LightColors.Text.one
        
        button.tap = { [weak self] in
            self?.showConfirmView()
        }
    }
    
    private func didContinue() {
        button.title = L10n.Segwit.homeButton.uppercased()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        UserDefaults.hasOptedInSegwit = true
        Store.trigger(name: .optInSegWit)
        
        view.addSubview(enabledView)
        
        enabledView.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-Margins.huge.rawValue)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(Margins.large.rawValue)
            make.height.equalTo(ViewSizes.extraExtraHuge.rawValue)
        }
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.enabledView.alpha = 1
        }
    }
    
    private func showConfirmView() {
        guard enabledView.superview == nil else {
            navigationController?.dismiss(animated: true)
            return
        }
        navigationController?.view.addSubview(segwitAlert)
        segwitAlert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.segwitAlert.alpha = 1
        }
    }
    
}
