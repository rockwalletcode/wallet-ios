// 
//  PaymentStatusWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct PaymentStatusRequestData: RequestModelData {
    var reference: String?
    
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class PaymentStatusWorker: BaseApiWorker<AddCardMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? PaymentStatusRequestData)?.reference else { return "" }
        
        return APIURLHandler.getUrl(ExchangeEndpoints.paymentStatus, parameters: urlParams)
    }
}
