//
//  KYCDocumentPickerPresenter.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import AVFoundation
import UIKit

final class KYCDocumentPickerPresenter: NSObject, Presenter, KYCDocumentPickerActionResponses {
    typealias Models = KYCDocumentPickerModels
    
    weak var viewController: KYCDocumentPickerViewController?
    
    // MARK: - KYCDocumentPickerActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let documents = actionResponse.item as? Models.Item else { return }
        
        let sections: [Models.Sections] = [
            .title,
            .documents
        ]
        
        let sectionRows: [Models.Sections: [Any]] = [
            .title: [LabelViewModel.text(L10n.AccountKYCLevelTwo.selectOptions)],
            .documents: documents.compactMap { return NavigationViewModel(image: .imageName($0.imageName), label: .text($0.title)) }
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentTakePhoto(actionResponse: KYCDocumentPickerModels.Photo.ActionResponse) {
        var instructions: String?
        var confirmation: String?
        var checklist = [ChecklistItemViewModel]()
        
        if actionResponse.isFront == true,
           actionResponse.document == .passport {
            instructions = L10n.AccountKYCLevelTwo.instructions
            confirmation = "\(L10n.AccountKYCLevelTwo.instructions)\n\(L10n.AccountKYCLevelTwo.documentConfirmation)"
            checklist = [ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.instructions)),
                         ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.documentConfirmation))]
        } else if actionResponse.isFront == true {
            instructions = L10n.AccountKYCLevelTwo.captureFrontPage
            confirmation = "\(L10n.AccountKYCLevelTwo.frontPageInstructions)\n\(L10n.AccountKYCLevelTwo.documentConfirmation)"
            checklist = [ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.frontPageInstructions)),
                         ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.documentConfirmation))]
        } else if actionResponse.isBack == true {
            instructions = L10n.AccountKYCLevelTwo.captureBackPage
            confirmation = "\(L10n.AccountKYCLevelTwo.backPageInstructions)\n\(L10n.AccountKYCLevelTwo.documentConfirmation)"
            checklist = [ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.backPageInstructions)),
                         ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.documentConfirmation))]
        } else if actionResponse.isSelfie == true {
            instructions = L10n.AccountKYCLevelTwo.faceVisible
            confirmation = "\(L10n.AccountKYCLevelTwo.instructions).\n\(L10n.AccountKYCLevelTwo.faceVisibleConfirmation)"
            checklist = [ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.faceCaptureInstructions)),
                         ChecklistItemViewModel(title: .text(L10n.AccountKYCLevelTwo.faceVisibleConfirmation))]
        }
        
        var device: AVCaptureDevice?
        
        if actionResponse.isSelfie {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        
        guard let device = device else { return }
        
        viewController?.displayTakePhoto(responseDisplay: .init(model: .init(instruction: .text(instructions),
                                                                             confirmation: .text(confirmation)),
                                                                device: device,
                                                                checklist: checklist))
    }
    
    func presentFinish(actionResponse: KYCDocumentPickerModels.Finish.ActionResponse) {
        viewController?.displayFinish(responseDisplay: .init())
    }
    
    // MARK: - Additional Helpers
    
}
