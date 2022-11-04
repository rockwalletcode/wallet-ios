//
//  RecoveryKeyIntroViewController.swift
//  breadwallet
//
//  Created by Ray Vander Veen on 2019-03-18.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import UIKit

typealias DidExitRecoveryKeyIntroWithAction = ((ExitRecoveryKeyAction) -> Void)

enum RecoveryKeyIntroExitButtonType {
    case none
    case closeButton
    case backButton
}

//
// Defines the content for a page in the recovery key introductory flow.
//
struct RecoveryKeyIntroPage {
    var title: String
    var subTitle: String
    var stepHint: String    // e.g., "How it works - Step 1
    var imageName: String
    var continueButtonText: String
    var isLandingPage: Bool
    
    init(title: String,
         subTitle: String,
         imageName: String,
         stepHint: String = "",
         continueButtonText: String = L10n.Button.continueAction,
         isLandingPage: Bool = true) {
        
        self.title = title
        self.subTitle = subTitle
        self.stepHint = stepHint
        self.imageName = imageName
        self.continueButtonText = continueButtonText
        self.isLandingPage = isLandingPage
    }
}

//
// Base class for paper key recovery content pages, including the landing page and the
// educational/intro pages.
//
class RecoveryKeyPageCell: UICollectionViewCell {
    
    var page: RecoveryKeyIntroPage?
    var imageView = UIImageView()
    var titleLabel = UILabel.wrapping(font: Fonts.Title.six, color: LightColors.Text.three)
    var subTitleLabel = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
    
    let headingLeftRightMargin: CGFloat = Margins.extraHuge.rawValue

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpSubviews() {
        [titleLabel, subTitleLabel, imageView].forEach({ contentView.addSubview($0) })
        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center
        imageView.contentMode = .scaleAspectFit
    }
    
    func setUpConstraints() {
        // subclasses should position their subviews
    }
    
    func configure(with page: RecoveryKeyIntroPage) {
        titleLabel.text = page.title
        subTitleLabel.text = page.subTitle
        imageView.image = UIImage(named: page.imageName)
    }
}

//
// Full-screen collection view cell for recovery key landing page.
//
class RecoveryKeyLandingPageCell: RecoveryKeyPageCell {
    
    static let lockImageName = "il_shield"
    private let lockImageDefaultSize: (CGFloat, CGFloat) = (100, 144)
    private var lockImageScale: CGFloat = 1.0
    private var lockIconTopConstraintPercent: CGFloat = 0.29
    private let headingTopMargin: CGFloat = 53
    private let subheadingTopMargin: CGFloat = Margins.large.rawValue

    override func setUpSubviews() {
        super.setUpSubviews()
        
        // The lock image is a bit too large at scale for small screens such as the iPhone 5 SE.
        // Here we shrink the image and move it up. See setUpConstraints().
        if E.isIPhone6OrSmaller {
            lockImageScale = 0.8
            lockIconTopConstraintPercent = 0.2
        }
    }
    
    override func setUpConstraints() {
        let lockImageTop = 63.0
        
        imageView.constrain([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: lockImageTop),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        
        if lockImageScale != 1.0 {
            let scaledWidth: CGFloat = (lockImageDefaultSize.0 * lockImageScale)
            let scaledHeight: CGFloat = (lockImageDefaultSize.1 * lockImageScale)
            
            imageView.constrain([
                imageView.widthAnchor.constraint(equalToConstant: scaledWidth),
                imageView.heightAnchor.constraint(equalToConstant: scaledHeight)
                ])
        }
        
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: headingTopMargin),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: headingLeftRightMargin),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -headingLeftRightMargin)
            ])
        
        subTitleLabel.constrain([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: subheadingTopMargin),
            subTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: headingLeftRightMargin),
            subTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -headingLeftRightMargin)
            ])
    }
}

//
// Full-screen collection view cell for the recovery key educational/intro pages.
//
class RecoveryKeyIntroCell: RecoveryKeyPageCell {

    private var introStepLabel = UILabel()
    private var contentTopConstraintPercent: CGFloat = 0.3
    private let imageWidth: CGFloat = 52
    private let imageHeight: CGFloat = 44
    private let imageTopMarginToTitle: CGFloat = 42
    private let subtitleTopMarginToImage: CGFloat = 20
    
    override func setUpSubviews() {
        super.setUpSubviews()
        
        introStepLabel.font = Fonts.Body.two
        introStepLabel.textColor = LightColors.Text.two
        introStepLabel.textAlignment = .center
        introStepLabel.numberOfLines = 0
        
        contentView.addSubview(introStepLabel)
        
        if E.isSmallScreen {
            contentTopConstraintPercent = 0.22
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let screenHeight = UIScreen.main.bounds.height
        let statusBarHeight = self.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let contentTop = (screenHeight * contentTopConstraintPercent) - statusBarHeight
        
        introStepLabel.constrain([
            introStepLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentTop),
            introStepLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Margins.large.rawValue),
            introStepLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Margins.large.rawValue)
            ])
        
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: introStepLabel.bottomAnchor, constant: Margins.small.rawValue),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: headingLeftRightMargin),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -headingLeftRightMargin)
            ])
        
        imageView.constrain([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: imageTopMarginToTitle)
            ])
        
        subTitleLabel.constrain([
            subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: subtitleTopMarginToImage),
            subTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: headingLeftRightMargin),
            subTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -headingLeftRightMargin)
            ])
    }
    
    override func configure(with page: RecoveryKeyIntroPage) {
        super.configure(with: page)
        introStepLabel.text = page.stepHint
    }
}

//
// Screen displayed when the user wants to generate a recovery key or view the words and
// write it down again.
//
class RecoveryKeyIntroViewController: BaseRecoveryKeyViewController {

    private var mode: EnterRecoveryKeyMode = .generateKey

    private var landingPage: RecoveryKeyIntroPage {
        switch mode {
        case .generateKey:
            return RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.generateKeyTitle,
                                        subTitle: L10n.RecoveryKeyFlow.generateKeyExplanation,
                                        imageName: "il_shield",
                                        continueButtonText: L10n.Button.continueAction)
        case .writeKey:
            return RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.writeKeyAgain,
                                        subTitle: UserDefaults.writePaperPhraseDateString,
                                        imageName: "il_setup",
                                        continueButtonText: L10n.Button.continueAction)
        case .unlinkWallet:
            return RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.unlinkWallet,
                                        subTitle: L10n.RecoveryKeyFlow.unlinkWalletSubtext,
                                        imageName: "il_security",
                                        continueButtonText: L10n.Swap.gotItButton)
        }
    }
    
    // View that appears above the 'Generate Recovery Key' button on the final intro
    // page, explaining to the user that the recovery key is not required for everyday
    // wallet access.
    private let keyUseInfoView = InfoView()
    
    private let continueButton = BRDButton(title: L10n.Button.continueAction, type: .secondary)
    private var pagingView: UICollectionView?
    private var pagingViewContainer: UIView = UIView()
    
    private var pages: [RecoveryKeyIntroPage] = [RecoveryKeyIntroPage]()
    
    private var pageIndex: Int = 0 {
        willSet {
            if newValue == 0 {
                self.hideBackButton()
            }
        }
        
        didSet {
            if let paging = pagingView {
                //scrollToItem is broken in the GM build of xcode 12. Check if later versions fix this
//                paging.scrollToItem(at: IndexPath(item: self.pageIndex, section: 0),
//                                    at: UICollectionView.ScrollPosition.left,
//                                    animated: true)
                if let rect = paging.layoutAttributesForItem(at: IndexPath(item: pageIndex, section: 0))?.frame {
                    paging.scrollRectToVisible(rect, animated: true)
                }
                
                // Let the scrolling animation run for a slight delay, then update the continue
                // button text if needed, and show the key-use info view. Doing a custom UIView animation
                // for the paging causes the page content to disappear before the next page cell animates in.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    let page = self.pages[self.pageIndex]
                    self.continueButton.title = page.continueButtonText
                    self.keyUseInfoView.isHidden = self.shouldHideInfoView
                    
                    if self.onLastPage {
                        self.showCloseButton()
                    }
                    
                    if self.pageIndex == 0 {
                        self.hideBackButton()
                    } else {
                        self.showBackButton()
                    }
                }
            }
        }
    }
    
    private var onLastPage: Bool { return self.pageIndex == self.pages.count - 1 }
    
    private var exitCallback: DidExitRecoveryKeyIntroWithAction?
    private var exitButtonType: RecoveryKeyIntroExitButtonType = .closeButton
    
    private var shouldHideInfoView: Bool {
        return true
    }
    
    private var infoViewText: String {
        if mode == .unlinkWallet {
            return L10n.RecoveryKeyFlow.unlinkWalletWarning
        } else {
            return L10n.RecoveryKeyFlow.keyUseHint
        }
    }
    
    init(mode: EnterRecoveryKeyMode = .generateKey,
         eventContext: EventContext,
         exitButtonType: RecoveryKeyIntroExitButtonType,
         exitCallback: DidExitRecoveryKeyIntroWithAction?) {
        
        self.mode = mode
        self.exitButtonType = exitButtonType
        self.exitCallback = exitCallback
        
        super.init(eventContext, .paperKeyIntro)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var closeButtonStyle: BaseRecoveryKeyViewController.CloseButtonStyle {
        return eventContext == .onboarding ? .skip : .close
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return eventContext == .onboarding ? .default : .lightContent
    }
    
    override func onCloseButton() {
        guard let exit = self.exitCallback else { return }
        
        switch mode {
        // If writing down the key again, just bail.
        case .writeKey:
            exit(.abort)
            
        // If generating the key for the first time, confirm that the user really wants to exit.
        case .generateKey:
            RecoveryKeyFlowController.promptToSetUpRecoveryKeyLater(from: self) { userWantsToSetUpLater in
                if userWantsToSetUpLater {
                    exit(.abort)
                }
            }
        
        case .unlinkWallet:
            exit(.abort)
        }
    }
    
    override func onBackButton() {
        if pageIndex == 0 {
            onCloseButton()
        } else {
            pageIndex = max(0, pageIndex - 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = LightColors.Background.one
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.backgroundColor = LightColors.Background.one
        
        showExitButton()
        setUpPages()
        setUpKeyUseInfoView()
        setUpPagingView()
        setUpContinueButton()
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(pagingViewContainer)
        view.addSubview(continueButton)
        view.addSubview(keyUseInfoView)
    }
    
    private func showExitButton() {
        
        switch exitButtonType {
        case .none:
            hideLeftNavigationButton()
        case .backButton:
            showBackButton()
        case .closeButton:
            showCloseButton()
        }
    }
    
    private func hideLeftNavigationButton() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
    }
        
    private func setUpKeyUseInfoView() {
        keyUseInfoView.text = infoViewText
        keyUseInfoView.imageName = "ExclamationMarkCircle"
        keyUseInfoView.isHidden = shouldHideInfoView
    }
    
    private func setUpPages() {
        // If the key is being generated for the first time, add the intro pages and allow paging.
        if mode == .generateKey {
            pages.append(RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.writeItDown,
                                              subTitle: L10n.RecoveryKeyFlow.noScreenshotsRecommendation,
                                              imageName: "il_shield",
                                              stepHint: L10n.RecoveryKeyFlow.howItWorksStep("1")))
            
            pages.append(RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.keepSecure,
                                              subTitle: L10n.RecoveryKeyFlow.storeSecurelyRecommendation,
                                              imageName: "il_setup",
                                              stepHint: L10n.RecoveryKeyFlow.howItWorksStep("2")))
            
            pages.append(RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.relaxBuyTrade,
                                              subTitle: L10n.RecoveryKeyFlow.securityAssurance,
                                              imageName: "il_security",
                                              stepHint: L10n.RecoveryKeyFlow.howItWorksStep("3"),
                                              continueButtonText: L10n.RecoveryKeyFlow.generateKeyButton))
        } else {
            continueButton.title = L10n.Swap.gotItButton
            pages.append(landingPage)
        }
    }
    
    private func setUpPagingView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let paging = UICollectionView(frame: .zero, collectionViewLayout: layout)
        paging.backgroundColor = .clear
        
        paging.collectionViewLayout = layout
        paging.isScrollEnabled = (mode == .generateKey)
        paging.isPagingEnabled = true
        
        paging.delegate = self
        paging.dataSource = self
        
        paging.register(RecoveryKeyLandingPageCell.self, forCellWithReuseIdentifier: "RecoveryKeyLandingPageCell")
        paging.register(RecoveryKeyIntroCell.self, forCellWithReuseIdentifier: "RecoveryKeyIntroCell")
        
        paging.isUserInteractionEnabled = false // only use the Continue button to move forward in the flow
        
        pagingViewContainer.addSubview(paging)
        pagingView = paging
    }
    
    private func exit(action: ExitRecoveryKeyAction) {
        if let exit = exitCallback {
            exit(action)
        }
    }
    
    private func setUpContinueButton() {
        continueButton.tap = { [unowned self] in
            if self.mode == .unlinkWallet {
                self.exit(action: .unlinkWallet)
            } else {
                if self.onLastPage {
                    self.exit(action: .generateKey)
                } else {
                    self.pageIndex = min(self.pageIndex + 1, self.pages.count - 1)
                }
            }
        }
    }
    
    private func setUpConstraints() {
        pagingViewContainer.constrain([
            pagingViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        if let paging = pagingView {
            paging.constrain(toSuperviewEdges: .zero)
        }
        
        constrainContinueButton(continueButton)
        
        // The key use info view sits just above the Continue button.
        keyUseInfoView.constrain([
            keyUseInfoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Margins.large.rawValue),
            keyUseInfoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Margins.large.rawValue),
            keyUseInfoView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -Margins.large.rawValue)
            ])
    }
}

extension RecoveryKeyIntroViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let page = pages[indexPath.item]
        
        if page.isLandingPage {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecoveryKeyLandingPageCell",
                                                             for: indexPath) as? RecoveryKeyLandingPageCell {
                cell.configure(with: page)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecoveryKeyIntroCell",
                                                             for: indexPath) as? RecoveryKeyIntroCell {
                cell.configure(with: page)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
}
