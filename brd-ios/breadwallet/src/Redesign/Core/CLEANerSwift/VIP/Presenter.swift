//
//  Presenter.swift
//  MagicFactory
//
//  Created by Rok Cresnik on 20/08/2021.
//

import UIKit

protocol Presenter: NSObject, BaseActionResponses {
    associatedtype ResponseDisplays: BaseResponseDisplays
    var viewController: ResponseDisplays? { get set }
}

extension Presenter {
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        let responseDisplay: MessageModels.ResponseDisplays
        let error = actionResponse.error
        
        guard !isAccessDenied(error: actionResponse.error) else { return }
        
        if let error = error as? NetworkingError, error == .sessionExpired {
            responseDisplay = .init(error: error)
        } else if let error = error as? SwapErrors {
            let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .auto)
            let config = Presets.InfoView.error
            responseDisplay = .init(model: model, config: config)
        } else if let error = error as? FEError {
            // TODO: Investigate localized errors
            let message = error.errorMessage
            let model = InfoViewModel(description: .text(message), dismissType: .auto)
            
            let config = Presets.InfoView.error
            responseDisplay = .init(model: model, config: config)
        } else {
            // TODO: Investigate localized errors
            let model = InfoViewModel(headerTitle: .text(L10n.Alert.error), description: .text(error?.localizedDescription ?? ""), dismissType: .auto)
            let config = Presets.InfoView.error
            responseDisplay = .init(model: model, config: config)
        }
    
        viewController?.displayMessage(responseDisplay: responseDisplay)
    }
    
    func isAccessDenied(error: Error?) -> Bool {
        guard let error = error as? NetworkingError, error == .accessDenied else { return false }
        
        let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .auto)
        let config = Presets.InfoView.error
        let responseDisplay: MessageModels.ResponseDisplays = .init(error: error, model: model, config: config)
        
        viewController?.displayMessage(responseDisplay: responseDisplay)
        
        return true
    }
    
    func presentNotification(actionResponse: MessageModels.Notification.ActionResponse) {
        let model = InfoViewModel(title: actionResponse.title != nil ?.text(actionResponse.title) : nil,
                                  description: actionResponse.body != nil ?.text(actionResponse.body) : nil,
                                  dismissType: actionResponse.dissmiss)
        let config = Presets.InfoView.error
        
        viewController?.displayMessage(responseDisplay: .init(model: model, config: config))
    }
    
    func presentAlert(actionResponse: MessageModels.Alert.ActionResponse) {
        let model = InfoViewModel(title: .text(actionResponse.title),
                                  description: .text(actionResponse.body))
        let config = Presets.InfoView.error
        viewController?.displayMessage(responseDisplay: .init(model: model, config: config))
    }
}
