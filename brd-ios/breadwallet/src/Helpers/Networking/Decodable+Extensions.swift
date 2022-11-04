//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

extension Decodable {
    static func parse<T: Decodable>(from data: Data?,
                                    decodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
                                    type: T.Type) -> T? {
        guard let data = data else { return nil }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = decodingStrategy
            return try decoder.decode(type.self, from: data)
        } catch {
            print("============================================================")
            print("==== Error decoding JSON of type: \(type.self) ====\n")
            print("\(error)\n")
            print(String(data: data, encoding: .utf8) ?? "")
            print("============================================================")
            return nil
        }
    }

    static func parseArray<T: Decodable>(from data: Data?,
                                         decodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
                                         type: [T].Type) -> [T]? {
        guard let data = data else { return nil }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = decodingStrategy
            return try decoder.decode(type.self, from: data)
        } catch {
            print("============================================================")
            print("==== Error decoding JSON of type: \(type.self) ====\n")
            print("\(error)\n")
            print(String(data: data, encoding: .utf8) ?? "")
            print("============================================================")
            return []
        }
    }

    static func parse<T: Decodable>(from string: String, type: T.Type) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(from: data, type: type)
    }

    static func parseArray<T: Decodable>(from string: String, type: [T].Type) -> [T]? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parseArray(from: data, type: type)
    }
}
