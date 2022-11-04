//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

protocol UrlModelData {
    func urlParameters() -> [String]
}

protocol RequestModelData {
    func getParameters() -> [String: Any]
}

extension RequestModelData where Self: Encodable {
    func getParameters() -> [String: Any] {
        guard let json = try? JSONEncoder().encode(self) else { return [:] }
        guard let parameters = try? JSONSerialization.jsonObject(with: json) else { return [:] }

        return parameters as? [String: Any] ?? [:]
    }
}
