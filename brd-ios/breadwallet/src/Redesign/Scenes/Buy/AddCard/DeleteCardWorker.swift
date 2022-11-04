// 
//  DeleteCardWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct DeleteCardRequestData: RequestModelData {
    var instrumentId: String?
    
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class DeleteCardWorker: BaseApiWorker<PlainMapper> {
    override func getMethod() -> HTTPMethod {
        return .delete
    }
    override func getUrl() -> String {
        guard let urlParams = (requestData as? DeleteCardRequestData)?.instrumentId else { return "" }
        
        return APIURLHandler.getUrl(ExchangeEndpoints.paymentInstrumentId, parameters: urlParams)
    }
}
