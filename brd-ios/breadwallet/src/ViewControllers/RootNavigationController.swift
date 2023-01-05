//
//  RootNavigationController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 07/11/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
    private var backgroundColor = UIColor.clear
    private var tintColor = UIColor.clear
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let vc = topViewController else { return .default }
        return vc.preferredStatusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        decideInterface(for: children.last)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        decideInterface(for: viewController)
    }
    
    func decideInterface(for viewController: UIViewController?) {
        guard let viewController = viewController else {
            backgroundColor = LightColors.Contrast.one
            tintColor = LightColors.Contrast.one
            
            setNormalNavigationBar()
            return
        }
        
        switch viewController {
        case is AccountViewController,
            is HomeScreenViewController:
            backgroundColor = .clear
            tintColor = LightColors.Text.three
            
        case is KYCCameraViewController:
            backgroundColor = .black
            tintColor = LightColors.Background.one
            
        case is OnboardingViewController:
            backgroundColor = .clear
            tintColor = LightColors.Background.two
            
        case is ImportKeyViewController:
            backgroundColor = LightColors.primary
            tintColor = LightColors.Contrast.two
            
        case is ShareDataViewController,
            is DeleteProfileInfoViewController,
            is BuyViewController,
            is SwapViewController,
            is AddCardViewController,
            is ExchangeDetailsViewController,
            is RegistrationViewController,
            is RegistrationConfirmationViewController,
            is AccountVerificationViewController,
            is ProfileViewController,
            is KYCBasicViewController,
            is KYCLevelTwoEntryViewController,
            is KYCDocumentPickerViewController,
            is KYCLevelTwoPostValidationViewController,
            is SimpleWebViewController,
            is VerifyAccountViewController,
            is OrderPreviewViewController,
            is BaseInfoViewController,
            is ItemSelectionViewController,
            is BillingAddressViewController,
            is SellViewController:
            backgroundColor = LightColors.Background.two
            tintColor = LightColors.Text.three
            
        default:
            backgroundColor = LightColors.Background.one
            tintColor = LightColors.Text.three
        }
        
        let item = SimpleBackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        
        setNormalNavigationBar()
    }
    
    func setNormalNavigationBar() {
        let backImage = Asset.back.image
        
        let normalAppearance = UINavigationBarAppearance()
        normalAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        normalAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        normalAppearance.configureWithOpaqueBackground()
        normalAppearance.backgroundColor = backgroundColor
        normalAppearance.shadowColor = nil
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        scrollAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.backgroundColor = backgroundColor
        scrollAppearance.shadowColor = nil
        
        navigationBar.scrollEdgeAppearance = normalAppearance
        navigationBar.standardAppearance = scrollAppearance
        navigationBar.compactAppearance = scrollAppearance
        
        let tint = tintColor
        UIView.animate(withDuration: Presets.Animation.short.rawValue) { [weak self] in
            self?.navigationBar.tintColor = tint
            self?.navigationItem.titleView?.tintColor = tint
            self?.navigationItem.leftBarButtonItems?.forEach { $0.tintColor = tint }
            self?.navigationItem.rightBarButtonItems?.forEach { $0.tintColor = tint }
            self?.navigationItem.leftBarButtonItem?.tintColor = tint
            self?.navigationItem.rightBarButtonItem?.tintColor = tint
            self?.navigationBar.layoutIfNeeded()
        }
        
        navigationBar.prefersLargeTitles = false
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.Title.six,
            NSAttributedString.Key.foregroundColor: tint
        ]
        
        view.backgroundColor = backgroundColor
    }
}
