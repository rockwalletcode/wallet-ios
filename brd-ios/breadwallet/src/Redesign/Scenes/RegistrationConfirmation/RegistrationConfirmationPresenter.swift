//
//  RegistrationConfirmationPresenter.swift
//  breadwallet
//
//  Created by Rok on 02/06/2022.
//
//

import UIKit

final class RegistrationConfirmationPresenter: NSObject, Presenter, RegistrationConfirmationActionResponses {
    typealias Models = RegistrationConfirmationModels

    weak var viewController: RegistrationConfirmationViewController?

    // MARK: - RegistrationConfirmationActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let email = actionResponse.item as? String
        let sections: [Models.Section] = [
            .image,
            .title,
            .instructions,
            .input,
            .help
        ]
        
        var help: [ButtonViewModel] = [ButtonViewModel(title: L10n.AccountCreation.resendCode, isUnderlined: true)]
        
        if UserManager.shared.profile?.status == .emailPending {
            help.append(ButtonViewModel(title: L10n.AccountCreation.changeEmail, isUnderlined: true))
        }
        
        let sectionRows: [Models.Section: [Any]] = [
            .image: [
                ImageViewModel.imageName("email")
            ],
            .title: [
                LabelViewModel.text(L10n.AccountCreation.verifyEmail)
            ],
            .instructions: [
                LabelViewModel.text("\(L10n.AccountCreation.enterCode)\(": \n")\(email ?? "")")
            ],
            .input: [
                TextFieldModel(title: L10n.Receive.emailButton, value: email)
            ],
            .help: [
                ScrollableButtonsViewModel(buttons: help)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentValidate(actionResponse: RegistrationConfirmationModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentConfirm(actionResponse: RegistrationConfirmationModels.Confirm.ActionResponse) {
        viewController?.displayConfirm(responseDisplay: .init(shouldShowProfile: actionResponse.shouldShowProfile))
    }
    
    func presentResend(actionResponse: RegistrationConfirmationModels.Resend.ActionResponse) {
        viewController?.displayMessage(responseDisplay: .init(model: .init(description: .text(L10n.AccountCreation.codeSent)),
                                                              config: Presets.InfoView.verification))
    }
    
    func presentError(actionResponse: RegistrationConfirmationModels.Error.ActionResponse) {
        viewController?.displayError(responseDisplay: .init())
    }
    
    // MARK: - Additional Helpers

}
