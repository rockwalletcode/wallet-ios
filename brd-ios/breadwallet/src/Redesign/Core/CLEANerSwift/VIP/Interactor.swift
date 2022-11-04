//
//  Interactor.swift
//  MagicFactory
//
//  Created by Rok Cresnik on 20/08/2021.
//

import Foundation

protocol Interactor: NSObject, BaseViewActions {
    associatedtype ActionResponses: BaseActionResponses
    associatedtype DataStore: BaseDataStore
    
    var presenter: ActionResponses? { get set }
    var dataStore: DataStore? { get set }
}
