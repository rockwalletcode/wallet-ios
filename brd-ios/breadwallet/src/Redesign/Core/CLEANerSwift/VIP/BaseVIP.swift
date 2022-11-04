//
//  BaseVIP.swift
//  MagicFactory
//
//  Created by Rok Cresnik on 20/08/2021.
//

import UIKit

protocol BaseViewActions {}

protocol BaseActionResponses: MessageActionResponses {}

protocol BaseResponseDisplays: MessageResponseDisplays {}

protocol BaseDataStore {}

protocol BaseDataPassing {
    associatedtype DataStore: BaseDataStore
    var dataStore: DataStore? { get }
}

protocol CoordinatableRoutes: NSObject,
                              MessageDisplayable {
    func goBack()
}

protocol MessageDisplayable {
    func showMessage(with error: Error?, model: InfoViewModel?, configuration: InfoViewConfiguration?)
    func hideMessage()
}
