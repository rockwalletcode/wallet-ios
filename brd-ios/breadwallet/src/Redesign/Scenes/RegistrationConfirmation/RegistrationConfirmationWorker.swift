// 
//  RegistrationConfirmationWorker.swift
//  breadwallet
//
//  Created by Rok on 01/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct RegistrationConfirmationRequestData: RequestModelData {
    let code: String?
    
    func getParameters() -> [String: Any] {
        return [
            "confirmation_code": code ?? ""
        ]
    }
}

class RegistrationConfirmationWorker: BaseApiWorker<PlainMapper> {

    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.confirm)
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> HTTPMethod {
        return .post
    }
}
