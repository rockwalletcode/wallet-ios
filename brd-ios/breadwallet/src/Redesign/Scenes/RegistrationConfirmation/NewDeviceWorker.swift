// 
//  NewDeviceWorker.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

struct NewDeviceResponseData: ModelResponse {
    var status: String?
    var sessionKey: String?
    var email: String?
}

struct NewDeviceData: Model {
    var sessionKey: String?
    var email: String?
}

class NewDeviceMapper: ModelMapper<NewDeviceResponseData, NewDeviceData> {
    override func getModel(from response: NewDeviceResponseData?) -> NewDeviceData? {
        return .init(sessionKey: response?.sessionKey, email: response?.email)
    }
}

struct NewDeviceRequestData: RequestModelData {
    var nonce = UUID().uuidString
    let token: String?
    
    func getParameters() -> [String: Any] {
        return [
            "nonce": nonce,
            "token": token ?? ""
        ]
    }
}

class NewDeviceWorker: BaseApiWorker<NewDeviceMapper> {
    
    override func getHeaders() -> [String: String] {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "US")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let dateString = formatter.string(from: Date())
        
        guard let nonce = (getParameters()["nonce"] as? String),
              let token = (getParameters()["token"] as? String),
              let data = (dateString + token + nonce).data(using: .utf8)?.sha256,
              let apiKeyString = try? keychainItem(key: KeychainKey.apiAuthKey) as String?,
              !apiKeyString.isEmpty,
              let apiKey = Key.createFromString(asPrivate: apiKeyString),
              let signature = CoreSigner.basicDER.sign(data32: data, using: apiKey)?.base64EncodedString()
        else { return [:] }
        
        return [
            "Date": dateString,
            "Signature": signature
        ]
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.newDevice)
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
}
