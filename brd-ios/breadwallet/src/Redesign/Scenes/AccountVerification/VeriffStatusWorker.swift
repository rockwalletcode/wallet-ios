// 
//  VeriffStatusWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 13/12/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class VeriffStatusWorker: BaseApiWorker<PlainMapper> {
    override func getUrl() -> String {
        return KYCAuthEndpoints.veriffSubmittedStatus.url
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
}
