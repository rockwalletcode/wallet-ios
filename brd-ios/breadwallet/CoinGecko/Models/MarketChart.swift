//
//  MarketChart.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-09.
//

import Foundation

struct MarketChart: Codable {
    let prices: [[Double]]
    
    var dataPoints: [PriceDataPoint] {
        prices.compactMap {
            guard $0.count == 2 else { return nil }
            return PriceDataPoint(time: Date(timeIntervalSince1970: $0[0] / 1000.0), close: $0[1])
        }
    }
}

enum PriceHistoryResult {
    case success([PriceDataPoint])
    case unavailable
}

//Data points used in the chart on the Account Screen
struct PriceDataPoint: Codable, Equatable {
    let time: Date
    let close: Double
}
