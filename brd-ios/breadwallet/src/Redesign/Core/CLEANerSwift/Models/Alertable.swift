//
//  Alertable.swift
//  
//
//  Created by Rok Cresnik on 08/12/2021.
//

import UIKit

struct AlertViewModel {
    var title: String?
    var description: String?
    var image: UIImage?
    var buttons: [String] = []
}

struct AlertConfiguration: Configurable {
    var titleConfiguration: LabelConfiguration?
    var descriptionConfiguration: LabelConfiguration?
    var imageConfiguration: BackgroundConfiguration?
    var buttonConfigurations: [ButtonConfiguration]
}
