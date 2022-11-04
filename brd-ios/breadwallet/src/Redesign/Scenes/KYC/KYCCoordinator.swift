// 
//  KYCCoordinator.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import AVFoundation
import UIKit

class KYCCoordinator: BaseCoordinator,
                      KYCBasicRoutes,
                      KYCDocumentPickerRoutes,
                      DocumentReviewRoutes,
                      VerifyAccountRoutes {
    var role: CustomerRole?
    
    override func start() {
        switch UserManager.shared.profile?.status {
        case .emailPending:
            let coordinator = RegistrationCoordinator(navigationController: navigationController)
            coordinator.start()
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            
        default:
            open(scene: Scenes.VerifyAccount) { [weak self] vc in
                guard let role = self?.role else { return }
                
                let coverImageName: String
                let subtitleMessage: String
                
                switch role {
                case .kyc1:
                    coverImageName = "il_setup"
                    subtitleMessage = L10n.Account.verifyIdentity
                    
                case .kyc2:
                    coverImageName = "verification"
                    subtitleMessage = L10n.Account.upgradeVerificationIdentity
                    
                default:
                    coverImageName = ""
                    subtitleMessage = ""
                }
                
                vc.dataStore?.coverImageName = coverImageName
                vc.dataStore?.subtitleMessage = subtitleMessage
            }
        }
    }
    
    func showCountrySelector(countries: [Country], selected: ((Country?) -> Void)?) {
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.ItemSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = countries
            vc?.dataStore?.sceneTitle = L10n.Account.selectCountry
            vc?.itemSelected = { item in
                selected?(item as? Country)
            }
            vc?.prepareData()
        }
    }
    
    func showDocumentReview(checklist: [ChecklistItemViewModel], image: UIImage) {
        let controller = DocumentReviewViewController()
        controller.dataStore?.checklist = checklist
        controller.dataStore?.image = image
        controller.prepareData()
        controller.coordinator = self
        controller.setBarButtonItem(from: navigationController, to: .right, target: self, action: #selector(popFlow(sender:)))
        
        controller.retakePhoto = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        controller.confirmPhoto = { [weak self] in
            let picker = self?.navigationController.children.first(where: { $0 is KYCDocumentPickerViewController }) as? KYCDocumentPickerViewController
            picker?.interactor?.confirmPhoto(viewAction: .init(photo: image))
            
            LoadingView.show()
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showKYCFinal() {
        let controller = KYCLevelTwoPostValidationViewController()
        controller.coordinator = self
        controller.navigationItem.hidesBackButton = true
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showKYCLevelOne() {
        let controller = KYCBasicViewController()
        controller.coordinator = self
        controller.setBarButtonItem(from: navigationController, to: .right, target: self, action: #selector(popFlow(sender:)))
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showKYCLevelTwo() {
        let controller = KYCLevelTwoEntryViewController()
        controller.coordinator = self
        controller.setBarButtonItem(from: navigationController, to: .right, target: self, action: #selector(popFlow(sender:)))
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showIdentitySelector() {
        let controller = KYCDocumentPickerViewController()
        controller.coordinator = self
        controller.setBarButtonItem(from: navigationController, to: .right, target: self, action: #selector(popFlow(sender:)))
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showDocumentVerification(for document: Document) {
        showUnderConstruction("\(document.title) verification")
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
    
    @objc func popFlow(sender: UIBarButtonItem) {
        if navigationController.children.count == 1 {
            dismissFlow()
        }
        
        navigationController.popToRootViewController(animated: true)
    }
}

extension KYCCoordinator: ImagePickable {
    func showImagePicker(model: KYCCameraImagePickerModel?,
                         device: AVCaptureDevice,
                         completion: ((UIImage?) -> Void)?) {
        let controller = KYCCameraViewController()
        
        let backButtonVisibility = navigationController.children.last is KYCDocumentPickerViewController == false
        controller.navigationItem.hidesBackButton = backButtonVisibility
        controller.defaultVideoDevice = device
        controller.configure(with: .init(instructions: .init(font: Fonts.Body.one,
                                                             textColor: LightColors.Background.one,
                                                             textAlignment: .center),
                                         instructionsBackground: .init(backgroundColor: LightColors.Text.one)))
        controller.setup(with: model)
        controller.photoSelected = completion
        controller.setBarButtonItem(from: navigationController, to: .right, target: self, action: #selector(popFlow(sender:)))
        
        navigationController.pushViewController(controller, animated: true)
    }
}

extension KYCCoordinator {
    func showDatePicker(model: DateViewModel) {
        guard let viewController = navigationController.children.last(where: { $0 is KYCBasicViewController }) as? KYCBasicViewController else { return }
        DatePickerViewController.show(on: viewController,
                                      sourceView: viewController.view,
                                      title: nil,
                                      date: model.date ?? Date(),
                                      minimumDate: Calendar.current.date(byAdding: .year, value: -120, to: Date()),
                                      maximumDate: Date()) { date in
            viewController.interactor?.birthDateSet(viewAction: .init(date: date))
        }
    }
}
