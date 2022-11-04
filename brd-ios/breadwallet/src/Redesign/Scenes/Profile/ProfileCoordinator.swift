//
//  ProfileCoordinator.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

class ProfileCoordinator: BuyCoordinator, ProfileRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.Profile)
    }
    
    func showVerificationScreen(for profile: Profile?) {
        openModally(coordinator: KYCCoordinator.self, scene: Scenes.AccountVerification) { vc in
            vc?.dataStore?.profile = profile
            vc?.prepareData()
        }
    }
    
    func showAvatarSelection() {
        showUnderConstruction("avatar selection")
    }
    
    func showSecuirtySettings() {
        modalPresenter?.presentSecuritySettings()
    }
    
    func showPreferences() {
        modalPresenter?.presentPreferences()
    }
    
    func showExport() {}
}

extension BaseCoordinator {
    func showPopup(on viewController: UIViewController? = nil,
                   blurred: Bool = true,
                   with model: PopupViewModel,
                   config: PopupConfiguration = Presets.Popup.normal,
                   closeButtonCallback: (() -> Void)? = nil,
                   callbacks: [(() -> Void)] = []) {
        guard let view = viewController?.navigationController?.view ?? navigationController.view else { return }
        
        let blur = UIBlurEffect(style: blurred ? .regular : .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let popup = FEPopupView()
        view.addSubview(popup)
        view.bringSubviewToFront(popup)
        
        popup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualTo(view.snp.topMargin)
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        popup.alpha = 0.0
        popup.layoutIfNeeded()
        popup.configure(with: config)
        popup.setup(with: model)
        popup.configure(shadow: Presets.Shadow.normal)
        popup.buttonCallbacks = callbacks
        
        popup.closeCallback = { [weak self] in
            self?.hidePopup()
            closeButtonCallback?()
        }
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            popup.alpha = 1.0
            blurView.alpha = blurred ? 0.88 : 0.70
        }
    }
    
    // MARK: - Additional Helpers
    @objc func hidePopup() {
        guard let view = navigationController.view,
              let popup = view.subviews.first(where: { $0 is FEPopupView }) else { return }
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
