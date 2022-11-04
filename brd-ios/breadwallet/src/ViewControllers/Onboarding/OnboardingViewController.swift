//
//  OnboardingViewController.swift
//  breadwallet
//
//  Created by Ray Vander Veen on 2018-10-30.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import AVKit

enum OnboardingExitAction {
    case restoreWallet
    case createWallet
    case restoreCloudBackup
}

typealias DidExitOnboardingWithAction = ((OnboardingExitAction) -> Void)

struct OnboardingPage {
    var heading: String
    var subheading: String
}

// swiftlint:disable type_body_length

/**
*  Takes the user through a sequence of onboarding screens (product walkthrough)
*  and allows the user to either create a new wallet or restore an existing wallet.
*/
class OnboardingViewController: UIViewController {
    
    // This callback is passed in by the StartFlowPresenter so that actions within 
    // the onboarding screen can be directed to other functions of the app, such as wallet
    // restoration, PIN creation, etc.
    private var didExitWithAction: DidExitOnboardingWithAction?
        
    private let logoImageView: UIImageView = .init(image: .init(named: "logo_vertical_white"))
    
    private var showingLogo: Bool = false {
        didSet {
            let alpha: CGFloat = showingLogo ? 1 : 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
                self.logoImageView.alpha = alpha
            }, completion: nil)
        }
    }
    
    // page content
    var pages: [OnboardingPage] = [OnboardingPage]()
    
    // controls how far the heading/subheading labels animate up from the constraint anchor
    var fadeInOffsetFactors: [CGFloat] = [2.0, 2.0, 3.0, 2.0]
    
    let firstTransitionDelay: TimeInterval = 1.2
    
    // Heading and subheading labels and the constraints used to animate them.
    var headingLabels: [UILabel] = [UILabel]()
    var subheadingLabels: [UILabel] = [UILabel]()    
    var headingConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var subheadingConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    let headingLabelAnimationOffset: CGFloat = 60
    let subheadingLabelAnimationOffset: CGFloat = 30
    let headingSubheadingMargin: CGFloat = 22
    private var iconImageViews = [UIImageView]()
    
    var headingInset: CGFloat = Margins.extraExtraHuge.rawValue
    var subheadingInset: CGFloat {
        return headingInset - 10
    }
    
    // Used to ensure we only animate the landing page on the first appearance.
    var appearanceCount: Int = 0
    
    let pageCount: Int = 3
    
    let globePageIndex = 1
    let coinsPageIndex = 2
    let finalPageIndex = 3
    
    // Whenever we're animating from page to page this is set to true
    // to prevent additional taps on the Next button during the transition.
    var isPaging: Bool = false {
        didSet {
            [createWalletButton, restoreButton, skipButton, backButton].forEach { (button) in
                button.isUserInteractionEnabled = !isPaging
            }
        }
    }
    
    var pageIndex: Int = 0 {
        didSet {
            // Show/hide the Back and Skip buttons.
            let backAlpha: CGFloat = (pageIndex == 1) ? 1.0 : 0.0
            let skipAlpha: CGFloat = (pageIndex == 1) ? 1.0 : 0.0

            let delay = (pageIndex == 1) ? firstTransitionDelay : 0.0
            
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseIn, animations: { 
                self.backButton.alpha = backAlpha
                self.skipButton.alpha = skipAlpha                                
            }, completion: nil)
        }
    }
    
    var lastPageIndex: Int { return pageCount - 1 }
    
    // CTA's that appear at the bottom of the screen
    private let createWalletButton = BRDButton(title: "", type: .secondary)
    private let recoverButton = BRDButton(title: "", type: .blackTransparent)
    private let restoreButton = BRDButton(title: "", type: .blackTransparent)
    
    // Constraints used to show and hide the bottom buttons.
    private var topButtonAnimationConstraint: NSLayoutConstraint?
    private var middleButtonAnimationConstraint: NSLayoutConstraint?
    private var bottomButtonAnimationConstraint: NSLayoutConstraint?
    private var nextButtonAnimationConstraint: NSLayoutConstraint?
    
    private let backButton = UIButton(type: .custom)
    private let skipButton = UIButton(type: .custom)
        
    private let cloudBackupExists: Bool
    
    required init(doesCloudBackupExist: Bool, didExitOnboarding: DidExitOnboardingWithAction?) {
        self.cloudBackupExists = doesCloudBackupExist
        super.init(nibName: nil, bundle: nil)
        didExitWithAction = didExitOnboarding
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func exitWith(action exitAction: OnboardingExitAction) {
        didExitWithAction?(exitAction)
    }
            
    @objc private func backTapped(sender: Any) {
        
        let headingLabel = headingLabels[pageIndex]
        let subheadingLabel = subheadingLabels[pageIndex]
        let headingConstraint = headingConstraints[pageIndex]
        
        UIView.animate(withDuration: 0.4, animations: { 
            // make sure next or top/bottom buttons are animated out
            self.topButtonAnimationConstraint?.constant = self.buttonsHiddenYOffset
            self.nextButtonAnimationConstraint?.constant = self.buttonsHiddenYOffset
            
            headingLabel.alpha = 0
            subheadingLabel.alpha = 0
            headingConstraint.constant -= (self.headingLabelAnimationOffset)
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.reset(completion: { 
                self.animateLandingPage()
            })
        })
    }
    
    @objc private func skipTapped(sender: Any) {
        exitWith(action: .createWallet)
    }
    
    private func reset(completion: @escaping () -> Void) {
        
        for (index, constraint) in self.headingConstraints.enumerated() {
            constraint.constant = (index == 0) ? 0 : -(headingLabelAnimationOffset)
        }
                
        self.subheadingConstraints.forEach { $0.constant = headingSubheadingMargin }
        self.headingLabels.forEach { $0.alpha = 0 }
        self.subheadingLabels.forEach { $0.alpha = 0 }
        
        view.layoutIfNeeded()
        
        self.pageIndex = 0

        self.createWalletButton.title = createWalletButtonText(pageIndex: 0)
        self.restoreButton.title = restoreButtonText(pageIndex: 0)

        completion()        
    }
    
    private func setUpLogo() {
        logoImageView.alpha = 0
        view.addSubview(logoImageView)
        
//        let screenHeight = UIScreen.main.bounds.height
//        let offset = (screenHeight / 4.0) + 20
        
        logoImageView.constrain([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160)
            ])
    }
    
//    private func animateIcons(metaData: [CurrencyMetaData]?) {
//        guard pageIndex == 0 else { return }
//        guard let metaData = metaData else {
//            animateIcons(metaData: Currencies.shared.currencies)
//            return
//        }
//
//        // Used to be 20, and the app crashed
//        let iconCount = metaData.count
//        let iconSize: CGFloat = 40
//        let duration = 10.0
//        let maxDelay = 15.0
//
//        let currencies: [CurrencyMetaData] = Array(Array(metaData).sorted { return $0.isPreferred && !$1.isPreferred }[..<iconCount])
//        for currency in currencies {
//
//            //Add icon
//            let imageView = UIImageView(image: currency.imageNoBackground)
//            iconImageViews.append(imageView)
//            imageView.frame = CGRect(x: logoImageView.frame.midX - iconSize/2.0,
//                                     y: logoImageView.frame.midY - iconSize/2.0,
//                                     width: iconSize,
//                                     height: iconSize)
//            self.view.addSubview(imageView)
//            self.view.sendSubviewToBack(imageView)
//            imageView.alpha = 0.0
//            imageView.tintColor = .white
//
//            let delay = Double.random(in: 0.0...maxDelay)
//
//            //Fade in Icon
//            UIView.animate(withDuration: 1.5, delay: delay, animations: {
//                imageView.alpha = 0.2
//            })
//
//            //Animate icon on hypotenuse
//            UIView.animate(withDuration: duration, delay: delay, animations: {
//                let angle = CGFloat.random(in: 0...360.0) * .pi / 180.0
//                let hypotenuse: CGFloat = 700.0
//                imageView.frame = imageView.frame.offsetBy(dx: cos(angle) * hypotenuse, dy: sin(angle) * hypotenuse)
//                let rotationAngle: CGFloat = Bool.random() ? .pi / -1.1 : .pi
//                imageView.transform = imageView.transform.rotated(by: rotationAngle)
//            }, completion: { _ in
//                imageView.alpha = 0.0
//                imageView.removeFromSuperview()
//            })
//        }
//
//        //Repeat
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration + maxDelay, execute: { [weak self] in
//            self?.animateIcons(metaData: metaData)
//        })
//    }
    
    private func hideStarburstIcons() {
        iconImageViews.forEach { $0.layer.removeAllAnimations() }
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.iconImageViews.forEach { $0.alpha = 0.0 }
        })
    }
    
    private func setUpPages() {
        pages.append(OnboardingPage(heading: L10n.OnboardingPageOne.title,
                                    subheading: ""))
        
        pages.append(OnboardingPage(heading: L10n.OnboardingPageTwo.title,
                                    subheading: ""))
        
        pages.append(OnboardingPage(heading: L10n.OnboardingPageThree.title,
                                    subheading: L10n.OnboardingPageThree.subtitle))
    }
    
    private func makeHeadingLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        
        label.alpha = 0
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = color
        label.font = font
        label.text = text
        
        return label
    }
        
    private func setUpHeadingLabels() {

        for (index, page) in pages.enumerated() {
            
            // create the headings
            let headingLabel = makeHeadingLabel(text: page.heading, 
                                                font: Fonts.Title.six,
                                                color: LightColors.Contrast.two)
            view.addSubview(headingLabel)
            
            let offset: CGFloat = (index == 0) ? 0 : -(self.headingLabelAnimationOffset)
            var animationConstraint = headingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, 
                                                                            constant: offset)
            var leading = headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, 
                                                                constant: headingInset)
            var trailing = headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                  constant: -(headingInset))
            let top = headingLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                                        constant: Margins.huge.rawValue * 2)
            
            headingLabel.constrain([leading, trailing, top])
            
            headingConstraints.append(animationConstraint)
            headingLabels.append(headingLabel)

            // create the subheadings
            let subheadingLabel = makeHeadingLabel(text: page.subheading, 
                                                   font: UIFont.onboardingSubheading(),
                                                   color: .onboardingSubheadingText)
            view.addSubview(subheadingLabel)
            
            animationConstraint = subheadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, 
                                                                       constant: headingSubheadingMargin)
            leading = subheadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, 
                                                               constant: subheadingInset)
            trailing = subheadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, 
                                                                 constant: -(subheadingInset))
            
            subheadingLabel.constrain([animationConstraint, leading, trailing])
            
            subheadingConstraints.append(animationConstraint)
            subheadingLabels.append(subheadingLabel)
        }
    }
    
    private func createWalletButtonText(pageIndex: Int) -> String {
        return L10n.CloudBackup.createButton
    }

    private func recoverButtonText(pageIndex: Int) -> String {
        //no middle button if no backup detected
        if pageIndex == 0 && cloudBackupExists {
            return L10n.CloudBackup.recoverButton
        }
        return ""
    }
    
    private func restoreButtonText(pageIndex: Int) -> String {
        if cloudBackupExists {
            return L10n.CloudBackup.restoreButton
        } else {
            return L10n.Onboarding.restoreWallet
        }
    }
    
    let buttonHeight: CGFloat = 48.0
    let buttonsVerticalMargin: CGFloat = 12.0
    let bottomButtonBottomMargin: CGFloat = 10.0
    let nextButtonBottomMargin: CGFloat = 20.0
        
    private var buttonsHiddenYOffset: CGFloat {
        return (buttonHeight + 40.0)
    }
    
    private var bottomButtonVisibleYOffset: CGFloat {
        return -buttonsVerticalMargin
    }
    
    private var middleButtonVisibleYOffset: CGFloat {
        return -(buttonsVerticalMargin*2 + buttonHeight)
    }
    
    private var topButtonVisibleYOffset: CGFloat {
        if cloudBackupExists {
            return middleButtonVisibleYOffset - (buttonsVerticalMargin + buttonHeight)
        } else {
            return middleButtonVisibleYOffset
        }
    }
        
    private var nextButtonVisibleYOffset: CGFloat {
        return -nextButtonBottomMargin
    }
    
    private func setUpBottomButtons() {
        // Set the buttons up for the first page; the title text will be updated
        // once we reach the last page of the onboarding flow.
        createWalletButton.title = createWalletButtonText(pageIndex: 0)
        recoverButton.title = recoverButtonText(pageIndex: 0)
        restoreButton.title = restoreButtonText(pageIndex: 0)
        
        view.addSubview(createWalletButton)
        view.addSubview(recoverButton)
        view.addSubview(restoreButton)
        
        let buttonLeftRightMargin: CGFloat = 24
        let buttonHeight: CGFloat = 48
        
        // Position the top button just below the bottom of the view (or safe area / notch) to start with
        // so that we can animate it up into view.
        topButtonAnimationConstraint = createWalletButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                      constant: buttonsHiddenYOffset)
        
        middleButtonAnimationConstraint = recoverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                      constant: buttonsHiddenYOffset)
        bottomButtonAnimationConstraint = restoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                            constant: buttonsHiddenYOffset)
        createWalletButton.constrain([
            createWalletButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonLeftRightMargin),
            createWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonLeftRightMargin),                
            createWalletButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            topButtonAnimationConstraint
            ])
        
        recoverButton.constrain([
            recoverButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recoverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonLeftRightMargin),
            recoverButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonLeftRightMargin),
            recoverButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            middleButtonAnimationConstraint
            ])
        
        restoreButton.constrain([
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonLeftRightMargin),
            restoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonLeftRightMargin), 
            restoreButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            bottomButtonAnimationConstraint
            ])
        
        createWalletButton.tap = { [unowned self] in
            self.createWalletTapped()
        }
        
        recoverButton.tap = { [unowned self] in
            self.recoverButtonTapped()
        }
        
        restoreButton.tap = { [unowned self] in
            self.restoreButtonTapped()
        }
    }
    
    private func addBackAndSkipButtons() {
        let image = UIImage(named: "BackArrowWhite")
        
        backButton.alpha = 0
        skipButton.alpha = 0
        
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped(sender:)), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        var topAnchor: NSLayoutYAxisAnchor?
        var leadingAnchor: NSLayoutXAxisAnchor?
        
        topAnchor = view.safeAreaLayoutGuide.topAnchor
        leadingAnchor = view.safeAreaLayoutGuide.leadingAnchor

        backButton.constrain([
            backButton.topAnchor.constraint(equalTo: topAnchor!, constant: 30),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor!, constant: Margins.large.rawValue),
            backButton.heightAnchor.constraint(equalToConstant: 13),
            backButton.widthAnchor.constraint(equalToConstant: 20)
            ])
        
        skipButton.setTitle(L10n.Onboarding.skip, for: .normal)
        skipButton.titleLabel?.font = UIFont.onboardingSkipButton()
        skipButton.setTitleColor(.onboardingSkipButtonTitle, for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped(sender:)), for: .touchUpInside)
        
        view.addSubview(skipButton)
        
        var trailingAnchor: NSLayoutXAxisAnchor?
        
        trailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
        
        skipButton.constrain([
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor!, constant: -30),
            skipButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
            ])
    }
            
    private func animateLandingPage() {

        let delay = 0.2
        let duration = 0.3//0.5
                
        // animate heading position
        let constraint = headingConstraints[0]
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            constraint.constant = -(self.headingLabelAnimationOffset)
        })            
            
        // animate heading fade-in
        let label = headingLabels[0]
        UIView.animate(withDuration: duration + 0.2, delay: delay * 2.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            label.alpha = 1
        })            
        
        createWalletButton.alpha = 0
        recoverButton.alpha = 0
        restoreButton.alpha = 0
        
        // fade-in animation for the buttons
        UIView.animate(withDuration: (duration * 1.5), delay: (delay * 2.0), options: UIView.AnimationOptions.curveEaseIn, animations: { 
            self.createWalletButton.alpha = 1
            self.restoreButton.alpha = 1
            self.recoverButton.alpha = 1
        })

        // slide-up animation for the top button
        UIView.animate(withDuration: (duration * 1.5), delay: delay, options: UIView.AnimationOptions.curveEaseInOut, animations: { 
            self.topButtonAnimationConstraint?.constant = self.topButtonVisibleYOffset
            self.view.layoutIfNeeded()
        })
        
        if self.cloudBackupExists {
            middleButtonAnimationConstraint?.constant = (buttonsVerticalMargin * 2.0)
            view.layoutIfNeeded()
            
            // slide-up animation for the middle button
            UIView.animate(withDuration: (duration * 1.5), delay: delay * 1.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.middleButtonAnimationConstraint?.constant = self.middleButtonVisibleYOffset
                self.view.layoutIfNeeded()
            })
        }
        
        bottomButtonAnimationConstraint?.constant = (buttonsVerticalMargin * 3.0)
        view.layoutIfNeeded()
        
        // slide-up animation for the bottom button
        UIView.animate(withDuration: (duration * 1.5), delay: (delay * 2.0), options: UIView.AnimationOptions.curveEaseInOut, animations: { 
            // animate the bottom button up to its correct offset relative to the top button
            self.bottomButtonAnimationConstraint?.constant = self.bottomButtonVisibleYOffset
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: duration * 2.0, delay: delay * 3.0, options: .curveEaseInOut) {
            self.logoImageView.alpha = 1
        }
    }
    
    private func createWalletTapped() {
        exitWith(action: .createWallet)
    }

    private func recoverButtonTapped() {
        showAlert(message: L10n.CloudBackup.recoverWarning,
                  button: L10n.CloudBackup.recoverButton,
                  completion: { [weak self] in
                    self?.exitWith(action: .restoreWallet)
                })
    }

    private func restoreButtonTapped() {
        if cloudBackupExists {
            exitWith(action: .restoreCloudBackup)
        } else {
            // 'Restore wallet'
            exitWith(action: .restoreWallet)
        }
    }
                         
    private func setupSubviews() {
        setUpHeadingLabels()
        
        setUpBottomButtons()
        addBackAndSkipButtons()        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if appearanceCount == 0 {
            animateLandingPage()
        }
        
        appearanceCount += 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make sure we set this in case the user taps Restore Wallet, then comes
        // back to the onboarding flow in case the nav bar hidden status is changed.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = LightColors.Contrast.one
                
        setUpLogo()
        setUpPages()
        setupSubviews()
    }
    
    private func showAlert(message: String, button: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: L10n.Alert.warning,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: {_ in }))
        alert.addAction(UIAlertAction(title: button, style: .default, handler: {_ in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
}
