//
//  FetchVIP.swift
//  
//
//  Created by Rok Cresnik on 02/12/2021.
//

import Foundation

protocol FetchViewActions {
    func getData(viewAction: FetchModels.Get.ViewAction)
}

protocol FetchActionResponses {
    func presentData(actionResponse: FetchModels.Get.ActionResponse)
}

protocol FetchResponseDisplays {
    func displayData(responseDisplay: FetchModels.Get.ResponseDisplay)
}

protocol FetchDataStore {
    var itemId: String? { get set }
}

protocol FetchDataPassing {
    var dataStore: FetchDataStore? { get }
}
