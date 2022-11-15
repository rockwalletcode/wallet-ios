//
//  Coordinator.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import UIKit

protocol BaseControllable: UIViewController {

    associatedtype CoordinatorType: CoordinatableRoutes
    var coordinator: CoordinatorType? { get set }
}

protocol Coordinatable: CoordinatableRoutes {
    // TODO: should eventually die
    var modalPresenter: ModalPresenter? { get set }
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinatable? { get set }

    init(navigationController: UINavigationController)
    
    func childDidFinish(child: Coordinatable)
    func goBack()
    func start()
}

class BaseCoordinator: NSObject,
                       Coordinatable {

    // TODO: should eventually die
    weak var modalPresenter: ModalPresenter? {
        get {
            guard let modalPresenter = presenter else {
                return parentCoordinator?.modalPresenter
            }

            return modalPresenter
        }
        set {
            presenter = newValue
        }
    }
    
    private weak var presenter: ModalPresenter?
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    var isKYCLevelTwo: Bool?

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    init(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        let navigationController = RootNavigationController(rootViewController: viewController)
        self.navigationController = navigationController
    }

    func start() {
        let nvc = RootNavigationController()
        let coordinator: Coordinatable
        
        if let profile = UserManager.shared.profile,
           profile.email?.isEmpty == false,
           profile.status == .emailPending {
            coordinator = RegistrationCoordinator(navigationController: nvc)
        } else {
            coordinator = ProfileCoordinator(navigationController: nvc)
        }
        
        coordinator.start()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        navigationController.show(nvc, sender: nil)
    }
    
    func showRegistration(shouldShowProfile: Bool = false) {
        guard navigationController.presentedViewController?.children.contains(where: { $0 is RegistrationConfirmationViewController }) == nil else { return }
        
        let nvc = RootNavigationController()
        let coordinator = RegistrationCoordinator(navigationController: nvc)
        coordinator.start()
        coordinator.parentCoordinator = self
        
        if let vc = coordinator.navigationController.children.first(where: { $0 is RegistrationViewController }) as? RegistrationViewController {
            vc.dataStore?.shouldShowProfile = shouldShowProfile
        }
        
        if let vc = coordinator.navigationController.children.first(where: { $0 is RegistrationConfirmationViewController }) as? RegistrationConfirmationViewController {
            vc.dataStore?.shouldShowProfile = shouldShowProfile
        }
        
        childCoordinators.append(coordinator)
        navigationController.show(coordinator.navigationController, sender: nil)
    }
    
    func showSwap(currencies: [Currency], coreSystem: CoreSystem, keyStore: KeyStore) {
        ExchangeCurrencyHelper.setUSDifNeeded { [weak self] in
            upgradeAccountOrShowPopup(flow: .swap, role: .kyc1) { showPopup in
                guard showPopup else { return }

                self?.openModally(coordinator: SwapCoordinator.self, scene: Scenes.Swap) { vc in
                    vc?.dataStore?.currencies = currencies
                    vc?.dataStore?.coreSystem = coreSystem
                    vc?.dataStore?.keyStore = keyStore
                    vc?.dataStore?.isKYCLevelTwo = self?.isKYCLevelTwo
                }
            }
        }
    }
    
    func showBuy(coreSystem: CoreSystem?, keyStore: KeyStore?) {
        ExchangeCurrencyHelper.setUSDifNeeded { [weak self] in
            upgradeAccountOrShowPopup(flow: .buy, role: UserManager.shared.profile?.status == .levelOne ? .kyc2 : .kyc1) { showPopup in
                guard showPopup else { return }
                
                self?.openModally(coordinator: BuyCoordinator.self, scene: Scenes.Buy) { vc in
                    vc?.dataStore?.coreSystem = coreSystem
                    vc?.dataStore?.keyStore = keyStore
                }
            }
        }
    }
    
    func showProfile() {
        upgradeAccountOrShowPopup { [weak self] _ in
            self?.openModally(coordinator: ProfileCoordinator.self, scene: Scenes.Profile)
        }
    }
    
    func showVerifications() {
        open(scene: Scenes.AccountVerification) { vc in
            vc.dataStore?.profile = UserManager.shared.profile
            vc.prepareData()
        }
    }
    
    func showVerificationsModally() {
        openModally(coordinator: KYCCoordinator.self, scene: Scenes.AccountVerification) { vc in
            vc?.dataStore?.profile = UserManager.shared.profile
            vc?.prepareData()
        }
    }
    
    func showDeleteProfileInfo(keyMaster: KeyStore) {
        let nvc = RootNavigationController()
        let coordinator = DeleteProfileInfoCoordinator(navigationController: nvc)
        coordinator.start(with: keyMaster)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        UIApplication.shared.activeWindow?.rootViewController?.presentedViewController?.present(coordinator.navigationController, animated: true)
        
        // TODO: Cleanup when everything is moved to Coordinators.
        // There are problems with showing this vc from both menu and profile menu.
        // Cannot get it work reliably. Navigation Controllers are messed up.
        // More hint: deleteAccountCallback inside ModalPresenter.
    }
    
    func showExchangeDetails(with exchangeId: String?, type: Transaction.TransactionType) {
        open(scene: ExchangeDetailsViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.transactionType = type
            vc.prepareData()
        }
    }
    
    func showSupport() {
        guard let url = URL(string: C.supportLink) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: L10n.MenuButton.support))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    // TODO: There are 2 goBack functions. Unify them. 
    /// Determines whether the viewcontroller or navigation stack are being dismissed
    func goBack() {
        // if the same coordinator is used in a flow, we dont want to remove it from the parent
        guard navigationController.viewControllers.count < 1 else { return }

        guard navigationController.isBeingDismissed
                || navigationController.presentedViewController?.isBeingDismissed == true
                || navigationController.presentedViewController?.isMovingFromParent == true
                || parentCoordinator?.navigationController == navigationController
        else { return }
        parentCoordinator?.childDidFinish(child: self)
    }
    
    func goBack(completion: (() -> Void)? = nil) {
        guard parentCoordinator != nil,
              parentCoordinator?.navigationController != navigationController else {
            navigationController.popViewController(animated: true)
            return
        }
        navigationController.dismiss(animated: true) {
            completion?()
        }
        parentCoordinator?.childDidFinish(child: self)
    }
    
    func popToRoot(completion: (() -> Void)? = nil) {
        navigationController.popToRootViewController(animated: true) {
            completion?()
        }
    }

    /// Remove the child coordinator from the stack after iit finnished its flow
    func childDidFinish(child: Coordinatable) {
        childCoordinators.removeAll(where: { $0 === child })
    }
    
    // only call from coordinator subclasses
    func open<T: BaseControllable>(scene: T.Type,
                                   presentationStyle: UIModalPresentationStyle = .fullScreen,
                                   configure: ((T) -> Void)? = nil) {
        let controller = T()
        controller.coordinator = (self as? T.CoordinatorType)
        configure?(controller)
        navigationController.modalPresentationStyle = presentationStyle
        navigationController.show(controller, sender: nil)
    }

    // only call from coordinator subclasses
    func set<C: BaseCoordinator,
             VC: BaseControllable>(coordinator: C.Type,
                                   scene: VC.Type,
                                   presentationStyle: UIModalPresentationStyle = .fullScreen,
                                   configure: ((VC?) -> Void)? = nil) {
        let controller = VC()
        let coordinator = C(navigationController: navigationController)
        controller.coordinator = coordinator as? VC.CoordinatorType
        configure?(controller)
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        navigationController.setViewControllers([controller], animated: true)
    }
    
    // only call from coordinator subclasses
    func openModally<C: BaseCoordinator,
                     VC: BaseControllable>(coordinator: C.Type,
                                           scene: VC.Type,
                                           presentationStyle: UIModalPresentationStyle = .fullScreen,
                                           configure: ((VC?) -> Void)? = nil) {
        let controller = VC()
        let nvc = RootNavigationController(rootViewController: controller)
        nvc.modalPresentationStyle = presentationStyle
        nvc.modalPresentationCapturesStatusBarAppearance = true
        
        let coordinator = C(navigationController: nvc)
        controller.coordinator = coordinator as? VC.CoordinatorType
        configure?(controller)

        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        navigationController.show(nvc, sender: nil)
    }
    
    // It prepares the next KYC coordinator OR returns true.
    // In which case we show 3rd party popup or continue to Buy/Swap.
    //TODO: refactor this once the "coming soon" screen is added
    func upgradeAccountOrShowPopup(flow: ExchangeFlow? = nil, role: CustomerRole? = nil, completion: ((Bool) -> Void)?) {
        let nvc = RootNavigationController()
        var coordinator: Coordinatable?
        
        switch UserManager.shared.profileResult {
        case .success(let profile):
            guard let profile = profile else { return }
            
            let roles = profile.roles
            let status = profile.status
            isKYCLevelTwo = status == .levelTwo(.levelTwo)
            
            if roles.contains(.unverified)
                || roles.isEmpty == true
                || status == .emailPending
                || status == .none {
                coordinator = RegistrationCoordinator(navigationController: nvc)
                
            } else if let kycLevel = role,
                      roles.contains(kycLevel) {
                completion?(true)
            } else if role == nil {
                completion?(true)
            } else if let role = role {
                checkProfileforRole(role: role) { [weak self] hasRole in
                    guard hasRole == false else {
                        completion?(true)
                        return
                    }
                    
                    let coordinator = KYCCoordinator(navigationController: nvc)
                    coordinator.role = role
                    coordinator.flow = flow
                    coordinator.start()
                    coordinator.parentCoordinator = self
                    self?.childCoordinators.append(coordinator)
                    self?.navigationController.show(coordinator.navigationController, sender: nil)
                    
                    completion?(false)
                }
            }
            
        case .failure(let error):
            guard error as? NetworkingError == .sessionExpired
                    || error as? NetworkingError == .parameterMissing else {
                completion?(false)
                return
            }
            
            coordinator = RegistrationCoordinator(navigationController: RootNavigationController())
            
        default:
            completion?(true)
            return
        }
        
        guard let coordinator = coordinator else {
            completion?(false)
            return
        }
        
        coordinator.start()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        navigationController.show(coordinator.navigationController, sender: nil)
        
        completion?(false)
    }
    
    private func checkProfileforRole(role: CustomerRole = .kyc1, completion: ((Bool) -> Void)?) {
        UserManager.shared.refresh { result in
            guard case let .success(profile) = result,
                  profile?.roles.contains(role) == true
            else {
                completion?(false)
                return
            }
            completion?(true)
        }
    }
    
    func showMessage(with error: Error? = nil, model: InfoViewModel? = nil, configuration: InfoViewConfiguration? = nil) {
        hideOverlay()
        LoadingView.hide()
        
        let error = error as? NetworkingError
        
        switch error {
        case .accessDenied:
            UserManager.shared.refresh()
            
        case .sessionExpired:
            openModally(coordinator: RegistrationCoordinator.self, scene: Scenes.Registration) { vc in
                vc?.navigationItem.hidesBackButton = true
            }
            
            return
            
        default:
            break
        }
        
        guard let superview = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let model = model,
              let configuration = configuration else { return }
        
        let notification: FEInfoView = (superview.subviews.first(where: { $0 is FEInfoView }) as? FEInfoView) ?? FEInfoView()
        
        notification.didFinish = { [weak self] in
            self?.hideMessage()
        }
        
        if notification.superview == nil {
            notification.setupCustomMargins(all: .extraLarge)
            notification.configure(with: configuration)
            superview.addSubview(notification)
            notification.alpha = 0
            
            notification.snp.makeConstraints { make in
                make.top.equalTo(superview.safeAreaLayoutGuide.snp.top)
                make.leading.equalToSuperview().offset(Margins.medium.rawValue)
                make.centerX.equalToSuperview()
            }
        }
        
        notification.setup(with: model)
        notification.layoutIfNeeded()
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            notification.alpha = 1
        }
    }
    
    func hideMessage() {
        guard let superview = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let view = superview.subviews.first(where: { $0 is FEInfoView }) else { return }
        
        UIView.animate(withDuration: Presets.Animation.duration) {
            view.alpha = 0
        } completion: { _ in
            view.removeFromSuperview()
        }
    }
    
    func showUnderConstruction(_ feat: String) {
        showPopup(on: navigationController.topViewController,
                  with: .init(title: .text("Under construction"),
                              body: "The \(feat.uppercased()) functionality is being developed for You by the awesome RockWallet team. Stay tuned!"))
    }
    
    func showOverlay(with viewModel: TransparentViewModel, completion: (() -> Void)? = nil) {
        guard let parent = navigationController.view else { return }
        
        let view = TransparentView()
        view.configure(with: .init())
        view.setup(with: viewModel)
        view.didHide = completion
        
        parent.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        view.show()
        parent.bringSubviewToFront(view)
    }
    
    func hideOverlay() {
        guard let view = navigationController.view.subviews.first(where: { $0 is TransparentView }) as? TransparentView else { return }
        view.hide()
    }
    
    func showPopup<V: ViewProtocol & UIView>(with config: WrapperPopupConfiguration<V.C>?,
                                             viewModel: WrapperPopupViewModel<V.VM>,
                                             confirmedCallback: @escaping (() -> Void)) -> WrapperPopupView<V>? {
        guard let superview = navigationController.view else { return nil }
        
        let view = WrapperPopupView<V>()
        view.configure(with: config)
        view.setup(with: viewModel)
        view.confirmCallback = confirmedCallback
        
        superview.addSubview(view)
        superview.bringSubviewToFront(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        view.alpha = 0
            
        UIView.animate(withDuration: Presets.Animation.duration) {
            view.alpha = 1
        }
        
        return view
    }
}
