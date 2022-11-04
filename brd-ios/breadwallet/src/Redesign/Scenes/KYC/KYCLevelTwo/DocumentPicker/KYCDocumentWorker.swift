// 
//  KYCDocumentWorker.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum Document: String, Model {
    case passport = "PASSPORT"
    case idCard = "ID_CARD"
    case driversLicense = "DRIVERS_LICENSE"
    case residencePermit = "RESIDENCE_PERMIT"
    case selfie = "SELFIE"
    
    init(from rawValue: String?) {
        switch rawValue {
        case "ID_CARD":
            self = .idCard
            
        case "DRIVERS_LICENSE":
            self = .driversLicense
            
        case "RESIDENCE_PERMIT":
            self = .residencePermit
            
        default:
            self = .passport
        }
    }
    
    var imageName: String {
        switch self {
        case .idCard, .residencePermit:
            return "id_card"
            
        case .driversLicense:
            return "drivers_license"
            
        default:
            return "passport"
        }
    }
    
    var title: String {
        switch self {
        case .idCard: return L10n.AccountKYCLevelTwo.nationalIdCard
        case .driversLicense: return L10n.AccountKYCLevelTwo.drivingLicence
        case .residencePermit: return L10n.AccountKYCLevelTwo.residencePermit
        default: return L10n.AccountKYCLevelTwo.passport
        }
    }
    
    /// Do we need to take a pic of the back of the document?
    var isTwosided: Bool {
        switch self {
        case .passport: return false
        default: return true
        }
    }
}

struct KYCDocumentResponseData: ModelResponse {
    var supportedDocuments: [String]
}
    
class KYCDocumentMapper: ModelMapper<KYCDocumentResponseData, [Document]> {
    override func getModel(from response: KYCDocumentResponseData?) -> [Document]? {
        return response?.supportedDocuments.compactMap { return Document(from: $0) }
    }
}

class KYCDocumentWorker: BaseApiWorker<KYCDocumentMapper> {
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.documents)
    }
}
