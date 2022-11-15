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
         continueButtonText: String = L10n.Onboarding.next,
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        [titleLabel, subTitleLabel, imageView].forEach({ contentView.addSubview($0) })
        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center
        imageView.contentMode = .scaleAspectFit
    }
    
    func setUpConstraints() {
        imageView.constrain([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large.rawValue),
            imageView.heightAnchor.constraint(equalToConstant: ViewSizes.illustration.rawValue),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.custom(15))
        ])
        
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Margins.custom(5)),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.custom(5)),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        subTitleLabel.constrain([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.large.rawValue),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.extraHuge.rawValue),
            subTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configure(with page: RecoveryKeyIntroPage) {
        titleLabel.text = page.title
        subTitleLabel.text = page.subTitle
        imageView.image = UIImage(named: page.imageName)
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
                                        continueButtonText: L10n.Onboarding.next)
        case .writeKey:
            return RecoveryKeyIntroPage(title: L10n.RecoveryKeyFlow.writeKeyAgain,
                                        subTitle: UserDefaults.writePaperPhraseDateString,
                                        imageName: "il_setup",
                                        continueButtonText: L10n.Onboarding.next)
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
    
    private lazy var continueButton: FEButton = {
        let view = FEButton()
        view.configure(with: Presets.Button.primary)
        view.setup(with: .init(title: L10n.Onboarding.next))
        return view
    }()
    
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
                    self.continueButton.setup(with: .init(title: page.continueButtonText))
                    self.keyUseInfoView.isHidden = self.shouldHideInfoView
                    
                    if self.onLastPage {
                        self.showCloseButton()
                    }
                    
                    if self.pageIndex == 0 {
                        self.hideBackButton()
                    } else {
                        self.showBackButton()
                    }
                    
                    self.continueButton.configure(with: self.onLastPage ? Presets.Button.secondary : Presets.Button.primary)
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
            continueButton.setup(with: .init(title: L10n.Swap.gotItButton))
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
        
        paging.register(RecoveryKeyPageCell.self, forCellWithReuseIdentifier: "RecoveryKeyPageCell")
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecoveryKeyPageCell",
                                                            for: indexPath) as? RecoveryKeyPageCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: page)
        return cell
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
