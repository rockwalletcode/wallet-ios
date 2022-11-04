//
//  MarketData.swift
//  
//
//  Created by Adrian Corscadden on 2020-09-08.
//

import Foundation

struct MarketData: Codable {
    
    let marketCap: Double
    let totalVolume: Double
    let high24h: Double
    let low24h: Double
    
    init(from decoder: Decoder) throws {
        guard let marketDataKey = DynamicCodingKeys(stringValue: "market_data"),
              let customKey = decoder.userInfo[CustomKeyUserInfoKey] as? String
        else { throw CoinGeckoError.jsonDecoding }
        
        let container = try decoder
            .container(keyedBy: DynamicCodingKeys.self)
            .nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: marketDataKey)
        
        self.marketCap = try extractDouble(container: container, key1: "market_cap", key2: customKey)
        self.totalVolume = try extractDouble(container: container, key1: "total_volume", key2: customKey)
        self.high24h = try extractDouble(container: container, key1: "high_24h", key2: customKey)
        self.low24h = try extractDouble(container: container, key1: "low_24h", key2: customKey)
    }
}

private func extractDouble(container: KeyedDecodingContainer<DynamicCodingKeys>, key1: String, key2: String) throws -> Double {
    var result: Double?
    try container.allKeys.forEach {
        if $0.stringValue == key1 {
            let x = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: $0)
            try x.allKeys.forEach {
                if $0.stringValue == key2 {
                    result = try x.decode(Double.self, forKey: $0)
                }
            }
        }
    }
    guard let r = result else { throw CoinGeckoError.jsonDecoding }
    return r
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
