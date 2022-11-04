// 
//  Baker.swift
//  breadwallet
//
//  Created by Jared Wheeler on 2/10/21.
//  Copyright © 2021 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
public struct Baker: Codable {
    public let address: String
    public let name: String
    public let logo: String?
    public let balance: Double
    public let stakingBalance: Double
    public let stakingCapacity: Double
    public let maxStakingBalance: Double
    public let freeSpace: Double
    public let fee: Double
    public let minDelegation: Double
    public let payoutDelay: Double
    public let payoutPeriod: Double
    public let openForDelegation: Bool
    public let estimatedRoi: Double
    public let serviceType: String
    public let serviceHealth: String
    public let payoutTiming: String
    public let payoutAccuracy: String
    
    var serviceTypeString: String {
        switch serviceType {
        case "multiasset":
            return L10n.Staking.tezosMultiasset
        case "tezos_only":
            return L10n.Staking.tezosOnly
        case "tezos_dune":
            return L10n.Staking.tezosDune
        default:
            return ""
        }
    }
    
    var roiString: String {
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = 3
        return "\(formatter.string(from: NSNumber(value: estimatedRoi * 100.0)) ?? "") %"
    }
    
    var feeString: String {
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = 3
        return "\(formatter.string(from: NSNumber(value: fee * 100.0)) ?? "") %"
    }
    
    var freeSpaceString: String {
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: freeSpace / 1000)) ?? "0") K"
    }
}
