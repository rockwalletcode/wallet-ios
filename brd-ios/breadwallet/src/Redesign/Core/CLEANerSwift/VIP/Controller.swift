//
//  Controller.swift
//  MagicFactory
//
//  Created by Rok Cresnik on 20/08/2021.
//

import UIKit

struct Scenes {}

protocol Controller: BaseResponseDisplays, BaseDataPassing, BaseControllable {
    associatedtype ViewActions: BaseViewActions
    associatedtype DataStorable: BaseDataStore
    associatedtype Coordinator: CoordinatableRoutes
    
    var interactor: ViewActions? { get set }
    var coordinator: Coordinator? { get set }
    var dataStore: DataStorable? { get }
    
    func setupVIP()
}

// TODO: maybe future update or delete? :D 
protocol VIPCylce {
    associatedtype I: Interactor
    associatedtype P: Presenter
    associatedtype C: BaseCoordinator
    associatedtype DS: BaseDataStore

    var interactor: I { get }
    var presenter: P { get }
    var coordinator: C { get }
    var dataStore: DS { get }
}
