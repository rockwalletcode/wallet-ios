// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import Foundation

enum KYCEndpoints: String, URLType {
    static var baseURL: String = "https://" + E.apiUrl + "blocksatoshi/one/kyc/%@"
    
    case countriesList = "countries"
    
    var url: String {
        return String(format: Self.baseURL, rawValue)
    }
}

enum KYCAuthEndpoints: String, URLType {
    static var baseURL: String = "https://"  + E.apiUrl + "blocksatoshi/one/%@"
    
    case newDevice = "auth/new-device"
    case profile = "auth/profile"
    case register = "auth/associate"
    case confirm = "auth/associate/confirm"
    case resend = "auth/associate/resend"
    
    case veriffSession = "kyc/session"
    case veriffSubmittedStatus = "kyc/veriff/submitted-status"
    case basic = "kyc/basic"
    case documents = "kyc/documents"
    case upload = "kyc/upload"
    case submit = "kyc/session/submit"
    
    var url: String {
        return String(format: Self.baseURL, rawValue)
    }
}
