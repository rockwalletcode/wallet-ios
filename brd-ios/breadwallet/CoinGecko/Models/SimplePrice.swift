//
//  SimplePrice.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-04.
//

import Foundation

struct SimplePrice: Codable {
    let id: String
    let price: Double
    let marketCap: Double?
    let vol24hr: Double?
    let change24hr: Double?
    let lastUpdatedAt: Int?
    
    init?(json: [String: Any], id: String, prefix: String) {
        self.id = id
        
        //non-optional
        guard let price = json["\(prefix)"] as? Double else { return nil }
        self.price = price
        
        //optionals
        self.marketCap = json["\(prefix)_market_cap"] as? Double
        self.vol24hr = json["\(prefix)_24h_vol"] as? Double
        self.change24hr = json["\(prefix)_24h_change"] as? Double
        self.lastUpdatedAt = json["last_updated_at"] as? Int
    }
}

enum SimplePriceOptions: CaseIterable {
    case marketCap
    case vol
    case change
    case lastUpdated
}

struct SimplePriceParams: Codable {
    let ids: [String]
    let vsCurrency: String
    let includeMarketCap: Bool
    let include24hrVol: Bool
    let include24hrChange: Bool
    let includeLastUpdatedAt: Bool
    
    enum CodingKeys: String, CodingKey {
        case ids, includeMarketCap, includeLastUpdatedAt
        case vsCurrency = "vs_currencies"
        case include24hrVol = "include_24hr_vol"
        case include24hrChange = "include_24hr_change"
    }
}

extension SimplePriceParams {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ids.joined(separator: ","), forKey: .ids)
        try container.encode(vsCurrency, forKey: .vsCurrency)
        try container.encode(includeMarketCap.description, forKey: .includeMarketCap)
        try container.encode(include24hrVol.description, forKey: .include24hrVol)
        try container.encode(include24hrChange.description, forKey: .include24hrChange)
        try container.encode(includeLastUpdatedAt.description, forKey: .includeLastUpdatedAt)
    }
    
    func queryItems() -> [URLQueryItem] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        else { fatalError() }
        
        return dict.map { URLQueryItem(name: $0, value: $1) }
    }
}
