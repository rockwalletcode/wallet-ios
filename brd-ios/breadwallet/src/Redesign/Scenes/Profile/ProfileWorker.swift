// 
//  ProfileWorker.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum CustomerRole: String, Codable {
    case customer
    case unverified
    case kyc1
    case kyc2
}

enum ExchangeFlow {
    case buy
    case swap
}

struct ProfileResponseData: ModelResponse {
    var country: String?
    var state: String?
    var dateOfBirth: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var kycStatus: String?
    var kycFailureReason: String?
    var roles: [CustomerRole]
    
    var exchangeLimits: ExchangeLimits?
    
    struct ExchangeLimits: Codable {
        var swapAllowanceLifetime: Decimal
        var swapAllowanceDaily: Decimal
        var swapAllowancePerExchange: Decimal
        var buyAllowanceLifetime: Decimal
        var buyAllowanceDaily: Decimal
        var buyAllowancePerPurchase: Decimal
        var usedSwapLifetime: Decimal
        var usedSwapDaily: Decimal
        var usedBuyLifetime: Decimal
        var usedBuyDaily: Decimal
    }
}

struct Profile: Model {
    var country: String?
    var state: String?
    var dateOfBirth: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var status: VerificationStatus
    var failureReason: String?
    var swapAllowanceLifetime: Decimal
    var swapAllowanceDaily: Decimal
    var swapAllowancePerExchange: Decimal
    var buyAllowanceLifetime: Decimal
    var buyAllowanceDaily: Decimal
    var buyAllowancePerPurchase: Decimal
    var usedSwapLifetime: Decimal
    var usedSwapDaily: Decimal
    var usedBuyLifetime: Decimal
    var usedBuyDaily: Decimal
    var roles: [CustomerRole]
    
    var swapDailyRemainingLimit: Decimal {
        return swapAllowanceDaily - usedSwapDaily
    }
    
    var swapLifetimeRemainingLimit: Decimal {
        return swapAllowanceLifetime - usedSwapLifetime
    }
    
    var buyDailyRemainingLimit: Decimal {
        return buyAllowanceDaily - usedBuyDaily
    }
    
    var buyLifetimeRemainingLimit: Decimal {
        return buyAllowanceLifetime - usedBuyLifetime
    }
}

class ProfileMapper: ModelMapper<ProfileResponseData, Profile> {
    override func getModel(from response: ProfileResponseData?) -> Profile? {
        guard let response = response else { return nil }
        let limits = response.exchangeLimits
        
        let swapAllowanceLifetime = limits?.swapAllowanceLifetime ?? 0
        let swapAllowanceDaily = limits?.swapAllowanceDaily ?? 0
        let swapAllowancePerExchange = limits?.swapAllowancePerExchange ?? 0
        let buyAllowanceLifetime = limits?.buyAllowanceLifetime ?? 0
        let buyAllowanceDaily = limits?.buyAllowanceDaily ?? 0
        let buyAllowancePerPurchase = limits?.buyAllowancePerPurchase ?? 0
        let usedSwapLifetime = limits?.usedSwapLifetime ?? 0
        let usedSwapDaily = limits?.usedSwapDaily ?? 0
        let usedBuyLifetime = limits?.usedBuyLifetime ?? 0
        let usedBuyDaily = limits?.usedBuyDaily ?? 0

        return .init(country: response.country,
                     state: response.state,
                     dateOfBirth: response.dateOfBirth,
                     firstName: response.firstName,
                     lastName: response.lastName,
                     email: response.email,
                     status: .init(rawValue: response.kycStatus),
                     failureReason: response.kycFailureReason,
                     swapAllowanceLifetime: swapAllowanceLifetime,
                     swapAllowanceDaily: swapAllowanceDaily,
                     swapAllowancePerExchange: swapAllowancePerExchange,
                     buyAllowanceLifetime: buyAllowanceLifetime,
                     buyAllowanceDaily: buyAllowanceDaily,
                     buyAllowancePerPurchase: buyAllowancePerPurchase,
                     usedSwapLifetime: usedSwapLifetime,
                     usedSwapDaily: usedSwapDaily,
                     usedBuyLifetime: usedBuyLifetime,
                     usedBuyDaily: usedBuyDaily,
                     roles: response.roles)
    }
}

class ProfileWorker: BaseApiWorker<ProfileMapper> {
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.profile)
    }
}
