// 
//  Currency+Shared.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 20/05/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct AppGroup {
    struct Main {
        static let groupId: String = "group." + (Bundle.main.bundleIdentifier ?? "")
        static let containerUrl: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId)
    }
}

protocol CurrencyWithIcon {
    var code: String { get }
    var colors: (UIColor, UIColor) { get }
}

protocol CurrencyUID {
    var isBitcoin: Bool { get }
    var isBitcoinSV: Bool { get }
    var isBitcoinCash: Bool { get }
    var isEthereum: Bool { get }
    var isERC20Token: Bool { get }
    var isXRP: Bool { get }
    var isHBAR: Bool { get }
    var isBitcoinCompatible: Bool { get }
    var isEthereumCompatible: Bool { get }
    var isTezos: Bool { get }
    
    var uid: CurrencyId { get }
    var name: String { get }
    var tokenType: SharedCurrency.TokenType { get }
    var coinGeckoId: String? { get }
    var colors: (UIColor, UIColor) { get }
    var code: String { get }
    var isSupported: Bool { get }
}

typealias CurrencyId = Identifier<Currency>
typealias AssetCodes = Currencies.AssetCodes

class SharedCurrency: CurrencyUID {
    public enum TokenType: String {
        case native
        case erc20
        case unknown
    }
    
    /// Unique identifier from BlockchainDB
    var uid: CurrencyId { return .init(rawValue: "") }
    
    /// Display name (e.g. Bitcoin)
    var name: String { return "" }
    
    var tokenType: TokenType { return .unknown }
    
    var coinGeckoId: String? { return "" }
    
    /// Primary + secondary color
    var colors: (UIColor, UIColor) { return (.clear, .clear) }
    
    var code: String { return "" }
    
    /// False if a token has been delisted, true otherwise
    var isSupported: Bool { return false }
    
    var isBitcoin: Bool { return uid == Currencies.shared.getUID(from: AssetCodes.btc.value) }
    var isBitcoinSV: Bool { return uid == Currencies.shared.getUID(from: AssetCodes.bsv.value) }
    var isBitcoinCash: Bool { return uid == Currencies.shared.getUID(from: AssetCodes.bch.value) }
    var isEthereum: Bool { return uid == Currencies.shared.getUID(from: AssetCodes.eth.value) }
    var isXRP: Bool { return uid == Currencies.shared.getUID(from: AssetCodes.xrp.value) }
    var isERC20Token: Bool { return tokenType == .erc20 }
    var isBitcoinCompatible: Bool { return isBitcoin || isBitcoinCash || isBitcoinSV }
    var isEthereumCompatible: Bool { return isEthereum || isERC20Token }
    
    // Unused
    var isHBAR: Bool { return uid == Currencies.shared.getUID(from: "hbar")}
    var isTezos: Bool { return uid == Currencies.shared.getUID(from: "xtz") }
    
    init() {}
}

// MARK: - Metadata Model

/// Model representing metadata for supported currencies
public struct CurrencyMetaData: CurrencyWithIcon {
    let uid: CurrencyId
    let code: String
    let isSupported: Bool
    let colors: (UIColor, UIColor)
    let name: String
    var tokenAddress: String?
    var decimals: UInt8
    let type: String
    let fiatRate: Float?
    
    var isPreferred: Bool { return Currencies.shared.currencies.map { $0.uid }.contains(uid) }
    var isERC20Token: Bool { return type == SharedCurrency.TokenType.erc20.rawValue }
    
    var alternateCode: String?
    var coinGeckoId: String?
    
    enum CodingKeys: String, CodingKey {
        case uid = "currency_id"
        case code
        case isSupported = "is_supported"
        case colors
        case tokenAddress = "contract_address"
        case name
        case decimals = "scale"
        case alternateNames = "alternate_names"
        case type
        case fiatRate = "rate"
    }
}

extension CurrencyMetaData: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //TODO:CRYPTO temp hack until testnet support to added /currencies endpoint (BAK-318)
        var uid = try container.decodeIfPresent(String.self, forKey: .uid)
        if E.isTestnet {
            uid = uid?.replacingOccurrences(of: "mainnet", with: "testnet")
            uid = uid?.replacingOccurrences(of: "0x558ec3152e2eb2174905cd19aea4e34a23de9ad6", with: "0x7108ca7c4718efa810457f228305c9c71390931a") // BRD token
            uid = uid?.replacingOccurrences(of: "ethereum-testnet", with: "ethereum-goerli")
        }
        self.uid = CurrencyId(rawValue: uid ?? "") //try container.decode(CurrencyId.self, forKey: .uid)
        code = try container.decode(String.self, forKey: .code)
        let colorValues = try container.decodeIfPresent([String].self, forKey: .colors)
        if colorValues?.count == 2 {
            colors = (UIColor(hex: colorValues?[0] ?? ""), UIColor(hex: colorValues?[1] ?? ""))
        } else {
            colors = (UIColor.black, UIColor.black)
        }
        isSupported = try container.decodeIfPresent(Bool.self, forKey: .isSupported) ?? false
        name = try container.decode(String.self, forKey: .name)
        tokenAddress = try container.decodeIfPresent(String.self, forKey: .tokenAddress)
        decimals = try container.decodeIfPresent(UInt8.self, forKey: .decimals) ?? 0
        fiatRate = try container.decodeIfPresent(Float.self, forKey: .fiatRate) ?? 0
        
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        self.type = type != SharedCurrency.TokenType.erc20.rawValue ? SharedCurrency.TokenType.native.rawValue : SharedCurrency.TokenType.erc20.rawValue
        
        var didFindCoinGeckoID = false
        if let alternateNames = try? container.decode([String: String].self, forKey: .alternateNames) {
            if let code = alternateNames["cryptocompare"] {
                alternateCode = code
            }
            
            if let id = alternateNames["coingecko"] {
                didFindCoinGeckoID = true
                coinGeckoId = id
            }
        }
        
        // If the /currencies endpoint hasn't provided a coingeckoID,
        // use the local list. Eventually /currencies should provide
        // all of them
        if !didFindCoinGeckoID {
            if let id = CoinGeckoCodes.map[code.uppercased()] {
                coinGeckoId = id
            } else if code.uppercased() == "BSV" {
                coinGeckoId = "bitcoin-cash-sv"
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(code, forKey: .code)
        var colorValues = [String]()
        colorValues.append(colors.0.toHex)
        colorValues.append(colors.1.toHex)
        try container.encode(colorValues, forKey: .colors)
        try container.encode(isSupported, forKey: .isSupported)
        try container.encode(name, forKey: .name)
        try container.encode(tokenAddress, forKey: .tokenAddress)
        try container.encode(type, forKey: .type)
        try container.encode(decimals, forKey: .decimals)
        try container.encode(fiatRate, forKey: .fiatRate)
        
        var alternateNames = [String: String]()
        if let alternateCode = alternateCode {
            alternateNames["cryptocompare"] = alternateCode
        }
        if let coingeckoId = coinGeckoId {
            alternateNames["coingecko"] = coingeckoId
        }
        if !alternateNames.isEmpty {
            try container.encode(alternateNames, forKey: .alternateNames)
        }
    }
}

extension CurrencyMetaData: Hashable {
    public static func == (lhs: CurrencyMetaData, rhs: CurrencyMetaData) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

class Currencies {
    static var shared = Currencies()
    
    enum AssetCodes: String {
        case bsv
        case btc
        case bch
        case eth
        case xrp
        
        var value: String { return rawValue }
    }
    
    init() {
        reloadCurrencies()
    }
    
    func reloadCurrencies() {
        currencies = CurrencyFileManager.getCurrencyMetaDataFromCache(type: .currencies)
    }
    
    var currencies: [CurrencyMetaData] = []
    
    let prioritizedCurrencyCodes = [AssetCodes.bsv.value,
                                    AssetCodes.btc.value,
                                    AssetCodes.eth.value]
    
    var defaultCurrencyIds: [CurrencyId] {
        let allCurrencyCodes = Currencies.shared.currencies.compactMap({ $0.code.lowercased() })
        var filteredCurrencyCodes = allCurrencyCodes.filter({ !Currencies.shared.prioritizedCurrencyCodes.contains($0) }).sorted()
        filteredCurrencyCodes.insert(contentsOf: Currencies.shared.prioritizedCurrencyCodes, at: 0)
        let currencyUIDs = filteredCurrencyCodes.compactMap { getUID(from: $0) }
        
        return currencyUIDs
    }
    
    func getUID(from code: String) -> CurrencyId? {
        return Currencies.shared.currencies.first(where: { $0.code == code })?.uid
    }
}

struct CurrencyFileManager {
    enum DownloadedCurrencyType: String {
        case currencies
        case fiatCurrencies = "fiat_currencies"
    }
    
    static func sharedFilePath(type: DownloadedCurrencyType) -> String? {
        return AppGroup.Main.containerUrl?.appendingPathComponent("\(type.rawValue).json").path
    }
    
    static func bundledFilePath(type: DownloadedCurrencyType) -> String? {
        return Bundle.main.path(forResource: type.rawValue, ofType: "json")
    }
    
    static func cachedCurrenciesFilePath(type: DownloadedCurrencyType) -> String? {
        guard let sharedFilePath = sharedFilePath(type: type),
              let bundleFilePath = bundledFilePath(type: type) else { return nil }
        
        if FileManager.default.fileExists(atPath: sharedFilePath) {
            return sharedFilePath
        } else {
            return bundleFilePath
        }
    }
    
    static func isFiatCodeAvailable(_ code: String) -> Bool {
        let available = CurrencyFileManager.getCurrencyMetaDataFromCache(type: .fiatCurrencies).map { $0.code.lowercased() }
        return available.contains(code.lowercased())
    }
    
    static func getCurrencyMetaDataFromCache(type: DownloadedCurrencyType) -> [CurrencyMetaData] {
        guard let sharedFilePath = CurrencyFileManager.cachedCurrenciesFilePath(type: type),
              FileManager.default.fileExists(atPath: sharedFilePath) else { return [] }
        do {
            print("[\(type.rawValue.uppercased())] using cached currencies list")
            let cachedData = try Data(contentsOf: URL(fileURLWithPath: sharedFilePath))
            let currencies = try JSONDecoder().decode([CurrencyMetaData].self, from: cachedData)
            
            print("[\(type.rawValue.uppercased())] updated: \(currencies.count) tokens")
            
            return currencies
        } catch let e {
            print("[\(type.rawValue.uppercased())] error reading from cache: \(e)")
            // remove the invalid cached data
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: sharedFilePath))
            return []
        }
    }
    
    static func getCurrencyMetaDataFromCache(type: DownloadedCurrencyType, completion: @escaping ([CurrencyId: CurrencyMetaData]) -> Void) {
        guard let sharedFilePath = CurrencyFileManager.cachedCurrenciesFilePath(type: type) else { return }
        
        _ = processCurrenciesCache(type: type, path: sharedFilePath, completion: completion)
    }
    
    // Converts an array of CurrencyMetaData to a dictionary keyed on uid
    static func processCurrencies(type: DownloadedCurrencyType, _ currencies: [CurrencyMetaData], completion: ([CurrencyId: CurrencyMetaData]) -> Void) {
        let currencyMetaData = currencies.reduce(into: [CurrencyId: CurrencyMetaData](), { (dict, token) in
            dict[token.uid] = token
        })
        
        print("[\(type.rawValue.uppercased())] updated: \(currencies.count) \(type.rawValue)")
        
        completion(currencyMetaData)
    }

    // Loads and processes cached currencies
    static func processCurrenciesCache(type: DownloadedCurrencyType, path: String, completion: ([CurrencyId: CurrencyMetaData]) -> Void) -> Bool {
        guard FileManager.default.fileExists(atPath: path) else { return false }
        do {
            print("[\(type.rawValue.uppercased())] using cached currencies list")
            let cachedData = try Data(contentsOf: URL(fileURLWithPath: path))
            let currencies = try JSONDecoder().decode([CurrencyMetaData].self, from: cachedData)
            processCurrencies(type: type, currencies, completion: completion)
            return true
        } catch let e {
            print("[\(type.rawValue.uppercased())] error reading from cache: \(e)")
            // remove the invalid cached data
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
            return false
        }
    }

    // Updates the currency cache
    static func updateCache(type: DownloadedCurrencyType, _ currencies: [CurrencyMetaData], cachedFilePath: String) {
        do {
            let data = try JSONEncoder().encode(currencies)
            try data.write(to: URL(fileURLWithPath: cachedFilePath))
        } catch let e {
            print("[\(type.rawValue.uppercased())] Failed to write to cache: \(e.localizedDescription)")
        }
    }
    
    // Copies currencies embedded in bundle if cached file doesn't exist
    static func copyEmbeddedCurrencies(type: DownloadedCurrencyType, path: String) {
        let fileManager = FileManager.default
        
        if let embeddedFilePath = Bundle.main.path(forResource: type.rawValue, ofType: "json"), !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.copyItem(atPath: embeddedFilePath, toPath: path)
                print("[CurrencyList] copied bundle tokens list to cache")
            } catch let e {
                print("[CurrencyList] unable to copy bundled \(embeddedFilePath) -> \(path): \(e)")
            }
        }
    }
}
