//
//  ErrorVIP.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import Foundation

protocol MessageActionResponses {
    func presentError(actionResponse: MessageModels.Errors.ActionResponse)
    func presentNotification(actionResponse: MessageModels.Notification.ActionResponse)
    func presentAlert(actionResponse: MessageModels.Alert.ActionResponse)
}

protocol MessageResponseDisplays {
    func displayMessage(responseDisplay: MessageModels.ResponseDisplays)
}
