//
//  StateDisplayable.swift
//  
//
//  Created by Rok Cresnik on 07/09/2021.
//

import UIKit

enum DisplayState {
    case normal
    case filled
    case selected
    case highlighted
    case disabled
    case error
}

protocol StateDisplayable {
    var displayState: DisplayState { get set }
    
    func animateTo(state: DisplayState, withAnimation: Bool)
}
