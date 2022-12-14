//
//  VIPViewController.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import UIKit

protocol DataPresentable {
    func prepareData()
}

class VIPViewController<C: CoordinatableRoutes,
                        I: Interactor,
                        P: Presenter,
                        DS: BaseDataStore & NSObject>: UIViewController,
                                                       UIAdaptivePresentationControllerDelegate,
                                                       Controller,
                                                       BaseDataPassing,
                                                       BaseResponseDisplays,
                                                       ModalDismissable,
                                                       Blurrable,
                                                       DataPresentable {
    
    // MARK: Title and tab bar appearance
    
    var sceneTitle: String? { return nil }
    var sceneLeftAlignedTitle: String? { return nil } // TODO: Use large titles. Multiple lines of text makes it harder to use large titles.
    var tabIcon: UIImage? { return nil }
    var infoIcon: UIImage? { return nil }
    
    lazy var leftAlignedTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Title.five
        view.textAlignment = .left
        view.numberOfLines = 0
        view.textColor = LightColors.Text.three
        return view
    }()
    
    lazy var infoButton: UIButton = {
        let view = UIButton()
        view.tintColor = LightColors.Text.one
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy var verticalButtons: WrapperView<VerticalButtonsView> = {
        let view = WrapperView<VerticalButtonsView>()
        view.setupCustomMargins(top: .zero, leading: .large, bottom: .zero, trailing: .large)
        return view
    }()
    
    // MARK: Modal dimissable
    
    var isModalDismissableEnabled: Bool { return false }
    var dismissText: String { return "" }
    var closeImage: UIImage? { return nil }

    var isRootInNavigationController: Bool {
        guard let navigationController = navigationController else { return true }
        return navigationController.viewControllers.first === self
    }

    // MARK: VIP
    
    weak var coordinator: C?
    var interactor: I?
    var dataStore: DS? {
        return interactor?.dataStore as? DS
    }
    
    lazy var blurView: UIVisualEffectView? = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    // MARK: Initialization
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    func setupVIP() {
        interactor = I()
        let presenter = P()
        let dataStore = DS()
        presenter.viewController = self as? P.ResponseDisplays
        interactor?.presenter = presenter as? I.ActionResponses
        interactor?.dataStore = dataStore as? I.DataStore
    }

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        localize()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isModalDismissableEnabled {
            setupCloseButton(closeAction: #selector(dismissModal))
        } else if navigationItem.leftBarButtonItem?.image == closeImage
                    || navigationItem.leftBarButtonItem?.title == dismissText {
            navigationItem.leftBarButtonItem = nil
        } else if navigationItem.rightBarButtonItem?.image == closeImage
                    || navigationItem.rightBarButtonItem?.title == dismissText {
            navigationItem.rightBarButtonItem = nil
        }
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        parent?.presentationController?.delegate = self
        guard parent == nil else { return }

        coordinator?.goBack()
    }

    func setupCloseButton(closeAction: Selector) {
        guard navigationItem.leftBarButtonItem?.title != dismissText,
              navigationItem.rightBarButtonItem?.title != dismissText
        else { return }

        let closeButton = UIBarButtonItem(title: dismissText,
                                          style: .plain,
                                          target: self,
                                          action: closeAction)

        guard navigationItem.rightBarButtonItem == nil else {
            navigationItem.setLeftBarButton(closeButton, animated: false)
            return
        }
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    @objc func dismissModal() {
        ExchangeCurrencyHelper.revertIfNeeded(coordinator: coordinator, completion: { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: {
                self?.coordinator?.goBack()
            })
        })
    }
    
    @objc func infoButtonTapped() {
        // Override in subclass
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        coordinator?.goBack()
    }

    func setupSubviews() {
        tabBarItem.image = tabIcon
        
        guard let icon = infoIcon else { return }
        infoButton.setBackgroundImage(icon, for: .normal)
    }

    func localize() {
        view.backgroundColor = LightColors.Background.two
        tabBarItem.title = sceneTitle
        title = sceneTitle
        leftAlignedTitleLabel.text = sceneLeftAlignedTitle
    }
    
    func prepareData() {}

    // MARK: BaseResponseDisplay
    
    func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        guard !isAccessDenied(responseDisplay: responseDisplay) else { return }
        
        coordinator?.showMessage(with: responseDisplay.error,
                                 model: responseDisplay.model,
                                 configuration: responseDisplay.config,
                                 onTapCallback: nil)
    }
    
    func isAccessDenied(responseDisplay: MessageModels.ResponseDisplays) -> Bool {
        guard let error = responseDisplay.error as? NetworkingError, error == .accessDenied else { return false }
         
        coordinator?.showMessage(with: responseDisplay.error,
                                 model: responseDisplay.model,
                                 configuration: responseDisplay.config,
                                 onTapCallback: nil)
        
        return true
    }
    
    // MARK: - Blurrable
    
    func toggleBlur(animated: Bool) {
        guard let blurView = blurView else { return }
        guard blurView.superview == nil else {
            UIView.animate(withDuration: animated ? Presets.Animation.duration: 0) {
                blurView.alpha = 0
            } completion: { _ in
                blurView.removeFromSuperview()
            }
            return
        }
        
        blurView.alpha = 0
        blurView.frame = view.bounds
        view.addSubview(blurView)
        UIView.animate(withDuration: animated ? Presets.Animation.duration: 0) {
            blurView.alpha = 1
        }
    }
}

protocol ModalDismissable {
    var dismissText: String { get }

    func setupCloseButton(closeAction: Selector)
}

protocol Blurrable: UIViewController {
    var blurView: UIVisualEffectView? { get }
    
    func toggleBlur(animated: Bool)
}
