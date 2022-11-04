// 
//  ResendConfirmationWorker.swift
//  breadwallet
//
//  Created by Rok on 01/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class ResendConfirmationWorker: BaseApiWorker<PlainMapper> {

    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.resend)
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> HTTPMethod {
        return .post
    }
}
