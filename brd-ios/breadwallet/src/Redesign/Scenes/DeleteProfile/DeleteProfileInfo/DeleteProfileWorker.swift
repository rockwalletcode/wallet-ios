// 
//  DeleteProfileWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 20/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class DeleteProfileWorker: BaseApiWorker<PlainMapper> {
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.profile)
    }
    
    override func getMethod() -> HTTPMethod {
        return .delete
    }
}
