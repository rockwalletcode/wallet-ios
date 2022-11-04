// 
//  RegistrationWorker.swift
//  breadwallet
//
//  Created by Rok on 01/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class RegistrationMapper: ModelMapper<RegistrationResponseData, RegistrationData> {
    override func getModel(from response: RegistrationResponseData?) -> RegistrationData? {
        guard let key = response?.sessionKey else {
            return nil
        }
        return .init(sessionKey: key)
    }
}

struct RegistrationResponseData: ModelResponse {
    var data: [String: String]?
    var sessionKey: String? {
        return data?["sessionKey"]
    }
}

struct RegistrationData: Model {
    var sessionKey: String?
}

struct RegistrationRequestData: RequestModelData {
    let email: String?
    let token: String?
    let subscribe: Bool?
    
    func getParameters() -> [String: Any] {
        let params: [String: Any?] = [
            "email": email,
            "token": token,
            "subscribe": subscribe
        ]
        
        return params.compactMapValues { $0 }
    }
}

class RegistrationWorker: BaseApiWorker<RegistrationMapper> {
    
    override func getHeaders() -> [String: String] {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "US")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let dateString = formatter.string(from: Date())
        
        guard let email = (getParameters()["email"] as? String),
              let token = (getParameters()["token"] as? String),
              let data = (dateString + token + email).data(using: .utf8)?.sha256,
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
        return APIURLHandler.getUrl(KYCAuthEndpoints.register)
    }
    
    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
}
