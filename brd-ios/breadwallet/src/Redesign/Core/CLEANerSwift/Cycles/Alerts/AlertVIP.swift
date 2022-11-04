//
//  AlertVIP.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import Foundation

protocol AlertViewActions {}

protocol AlertActionResponses {
    func presentAlert(actionResponse: AlertModels.Alerts.ActionResponse)
}

protocol AlertResponseDisplays {
    func displayAlert(responseDisplay: AlertModels.Alerts.ResponseDisplay)
}
