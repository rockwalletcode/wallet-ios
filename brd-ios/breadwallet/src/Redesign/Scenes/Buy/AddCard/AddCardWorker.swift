// 
//  AddCardWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct AddCardResponseData: ModelResponse {
    var status: String?
    var paymentReference: String?
    var redirectUrl: String?
}

struct AddCard: Model {
    enum Status: String {
        case active = "ACTIVE"
        case requested = "REQUESTED"
        case pending = "PENDING"
        case authorized = "AUTHORIZED"
        case cardVerified = "CARD_VERIFIED"
        case canceled = "CANCELED"
        case expired = "EXPIRED"
        case paid = "PAID"
        case declined = "DECLINED"
        case voided = "VOIDED"
        case partiallyCaptured = "PARTIALLY_CAPTURED"
        case captured = "CAPTURED"
        case partiallyRefunded = "PARTIALLY_REFUNDED"
        case refunded = "REFUNDED"
        
        case none
        
        var isSuccesful: Bool {
            switch self {
            case .cardVerified, .captured: return true
            default: return false
            }
        }
    }
    
    var status: Status
    var paymentReference: String
    var redirectUrl: String?
}

class AddCardMapper: ModelMapper<AddCardResponseData, AddCard> {
    override func getModel(from response: AddCardResponseData?) -> AddCard {
        return AddCard(status: AddCard.Status(rawValue: response?.status ?? "") ?? .none,
                       paymentReference: response?.paymentReference ?? "",
                       redirectUrl: response?.redirectUrl)
    }
}

struct AddCardRequestData: RequestModelData {
    var token: String?
    var firstName: String?
    var lastName: String?
    var countryCode: String?
    var state: String?
    var city: String?
    var zip: String?
    var address: String?

    func getParameters() -> [String: Any] {
        let params = ["token": token,
                      "first_name": firstName,
                      "last_name": lastName,
                      "country_code": countryCode,
                      "state": state,
                      "city": city,
                      "zip": zip,
                      "address": address]
        
        return params.compactMapValues { $0 }
    }
}

class AddCardWorker: BaseApiWorker<AddCardMapper> {
    override func getUrl() -> String {
        return ExchangeEndpoints.paymentInstrument.url
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
}
