//
//  ViewProtocol.swift
//
//
//  Created by Rok Cresnik on 06/09/2021.
//

import UIKit

protocol ViewModel {}

protocol ObjectConfigurable: NSObject {
    associatedtype C: Configurable
    
    var config: C? { get set }
    func configure(with config: C?)
}

protocol ObjectViewModelable: NSObject {
    associatedtype VM: ViewModel
    
    var viewModel: VM? { get set }
    func setup(with viewModel: VM?)
}

protocol ViewProtocol: ObjectConfigurable, ObjectViewModelable {}
