//
//  Currency.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-10.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import WalletKit
import UIKit

typealias CurrencyUnit = WalletKit.Unit

/// Combination of the Core Currency model and its metadata properties
class Currency: SharedCurrency, CurrencyWithIcon, ItemSelectable {
    
    var displayName: String? { return name }
    var displayImage: ImageViewModel? { return .imageName(code) }
    
    private let core: WalletKit.Currency
    let network: WalletKit.Network

    /// Unique identifier from BlockchainDB
    override var uid: CurrencyId { assert(core.uid == metaData.uid); return metaData.uid }
    
    /// Ticker code (e.g. BTC)
    override var code: String { return core.code.uppercased() }
    /// Display name (e.g. Bitcoin)
    override var name: String { return metaData.name }

    var cryptoCompareCode: String {
        return metaData.alternateCode?.uppercased() ?? core.code.uppercased()
    }
    
    override var coinGeckoId: String? { return metaData.coinGeckoId }
    
    // Number of confirmations needed until a transaction is considered complete
    // eg. For bitcoin, a txn is considered complete when it has 6 confirmations
    var confirmationsUntilFinal: Int {
        return Int(network.confirmationsUntilFinal)
    }
    
    override var tokenType: TokenType {
        var type: TokenType = .unknown
        
        // This is a band aid. Backend should be updated. Backend should never return wrong values. 
        switch metaData.type.lowercased() {
        case TokenType.erc20.rawValue:
            type = .erc20
        default:
            type = .native
        }
        
        return type
    }
    
    // MARK: Units

    /// The smallest divisible unit (e.g. satoshi)
    let baseUnit: CurrencyUnit
    /// The default unit used for fiat exchange rate and amount display (e.g. bitcoin)
    let defaultUnit: CurrencyUnit
    /// All available units for this currency by name
    private let units: [String: CurrencyUnit]
    
    var defaultUnitName: String {
        return name(forUnit: defaultUnit)
    }

    /// Returns the unit associated with the number of decimals if available
    func unit(forDecimals decimals: Int) -> CurrencyUnit? {
        return units.values.first { $0.decimals == decimals }
    }

    func unit(named name: String) -> CurrencyUnit? {
        return units[name.lowercased()]
    }

    func name(forUnit unit: CurrencyUnit) -> String {
        if unit.decimals == defaultUnit.decimals {
            return code.uppercased()
        } else {
            return unit.name
        }
    }

    func unitName(forDecimals decimals: UInt8) -> String {
        return unitName(forDecimals: Int(decimals))
    }

    func unitName(forDecimals decimals: Int) -> String {
        guard let unit = unit(forDecimals: decimals) else { return "" }
        return name(forUnit: unit)
    }

    let metaData: CurrencyMetaData

    /// Primary + secondary color
    override var colors: (UIColor, UIColor) { return metaData.colors }
    /// False if a token has been delisted, true otherwise
    override var isSupported: Bool { return metaData.isSupported }
    var tokenAddress: String? { return metaData.tokenAddress }
    
    // MARK: URI

    var urlSchemes: [String]? {
        if isBitcoin {
            return ["bitcoin"]
        }
        if isBitcoinCash {
            return E.isTestnet ? ["bchtest"] : ["bitcoincash"]
        }
        if isEthereumCompatible {
            return ["ethereum"]
        }
        if isXRP {
            return ["xrpl", "xrp", "ripple"]
        }
        if isHBAR {
            return ["hbar"]
        }
        if isBitcoinSV {
            return ["bitcoinsv"]
        }
        
        return nil
    }
    
    func doesMatchPayId(_ details: PayIdAddress) -> Bool {
        let environment = (E.isTestnet || E.isRunningTests) ? "testnet" : "mainnet"
        guard details.environment.lowercased() == environment else { return false }
        guard let id = payId else { return false }
        return details.paymentNetwork.lowercased() == id.lowercased()
    }
    
    var payId: String? {
        if isBitcoin { return C.BTC.lowercased() }
        if isEthereum { return C.ETH.lowercased() }
        if isXRP { return "xrpl" }
        return nil
    }
    
    var attributeDefinition: AttributeDefinition? {
        if isXRP {
            return AttributeDefinition(key: "DestinationTag",
                                       label: L10n.Send.destinationTagOptional,
                                       keyboardType: .numberPad,
                                       maxLength: 10)
        }
        if isHBAR {
            return AttributeDefinition(key: "Memo",
                                       label: L10n.Send.memoTagOptional,
                                       keyboardType: .default,
                                       maxLength: 100)
        }
        return nil
    }
    
    /// Can be used if an example address is required eg. to estimate the max send limit
    var placeHolderAddress: String? {
        if isBitcoin {
            return E.isTestnet ? "tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx" : "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq"
        }
        if isBitcoinCash {
            return E.isTestnet ? "bchtest:qqpz7r5k72e07j0syq26f0h8srvdqeqjg50wg9fp3z" : "bitcoincash:qpm2qsznhks23z7629mms6s4cwef74vcwvy22gdx6a"
        }
        if isEthereumCompatible {
            return "0xA6A60123Feb7F61081b1BFe063464b3219cEdCEc"
        }
        if isXRP {
            return "r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV"
        }
        if isHBAR {
            return "0.0.39768"
        }
        return nil
    }

    /// Returns a transfer URI with the given address
    func addressURI(_ address: String) -> String? {
        //Tezos doesn't have a URI scheme
        if isTezos, isValidAddress(address) { return address }
        guard let scheme = urlSchemes?.first, isValidAddress(address) else { return nil }
        
        if scheme.isEmpty {
            return address
        } else if isERC20Token, let tokenAddress = tokenAddress {
            //This is a non-standard uri format to maintain backwards compatibility with old versions of BRD
            return "\(scheme):\(address)?tokenaddress=\(tokenAddress)"
        } else {
            return "\(scheme):\(address)"
        }
    }
    
    func shouldAcceptQRCodeFrom(_ currency: Currency, request: PaymentRequest) -> Bool {
        if self == currency {
            return true
        }
        
        // Allow scanning BTC on BSV screen and vice-versa.
        if ((isBitcoin && currency.isBitcoinSV) || (isBitcoinSV && currency.isBitcoin)) && request.scheme == nil {
            return true
        }
        
        // Allows sending erc20 tokens to an ETH receive uri, but not the other way around.
        if self == Currencies.shared.eth
            && currency.isERC20Token
            && request.amount == nil //  We shouldn't send tokens to an ETH request amount uri.
        {
            return true
        }
        
        return false
    }
    
    // MARK: Init

    init?(core: WalletKit.Currency,
          network: WalletKit.Network,
          metaData: CurrencyMetaData,
          units: Set<WalletKit.Unit>,
          baseUnit: WalletKit.Unit,
          defaultUnit: WalletKit.Unit) {
        guard core.uid == metaData.uid else { return nil }
        self.core = core
        self.network = network
        self.metaData = metaData
        self.units = Array(units).reduce([String: CurrencyUnit]()) { (dict, unit) -> [String: CurrencyUnit] in
            var dict = dict
            dict[unit.name.lowercased()] = unit
            return dict
        }
        self.baseUnit = baseUnit
        self.defaultUnit = defaultUnit
    }
}

extension Currency: Hashable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.core == rhs.core && lhs.metaData == rhs.metaData
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(core)
        hasher.combine(metaData)
    }
}

// MARK: - Convenience Accessors

extension Currency {
    func isValidAddress(_ address: String) -> Bool {
        return Address.create(string: address, network: network) != nil
    }
}

// MARK: - Confirmation times

extension Currency {
    func feeText(forIndex index: Int) -> String {
        if isEthereumCompatible {
            return ethFeeText(forIndex: index)
        } else if isBitcoinCompatible {
            return btcFeeText(forIndex: index)
        } else {
            return L10n.Confirmation.processingTime(L10n.FeeSelector.ethTime)
        }
    }
    
    private func ethFeeText(forIndex index: Int) -> String {
        
        switch index {
        case 0:
            return L10n.FeeSelector.estimatedDeliver(timeString(forMinutes: FeeLevel.economy.preferredTime(forCurrency: self) / 60 / 1000))
        case 1:
            return L10n.FeeSelector.estimatedDeliver(timeString(forMinutes: FeeLevel.regular.preferredTime(forCurrency: self) / 60 / 1000))
        case 2:
            return L10n.FeeSelector.estimatedDeliver(timeString(forMinutes: FeeLevel.priority.preferredTime(forCurrency: self) / 60 / 1000))
        default:
            return ""
        }
    }
    
    private func timeString(forMinutes minutes: Int) -> String {
        let duration: TimeInterval = Double(minutes * 60)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = [.dropLeading]
        return formatter.string(from: duration) ?? ""
    }
    
    private func btcFeeText(forIndex index: Int) -> String {
        switch index {
        case 0:
            return L10n.FeeSelector.estimatedDeliver(L10n.FeeSelector.economyTime)
        case 1:
            return L10n.FeeSelector.estimatedDeliver(L10n.FeeSelector.regularTime)
        case 2:
            return L10n.FeeSelector.estimatedDeliver(L10n.FeeSelector.priorityTime)
        default:
            return ""
        }
    }
}

// MARK: - Images

extension CurrencyWithIcon {
    /// Icon image with square color background
    public var imageSquareBackground: UIImage? {
        if let baseURL = AssetArchive(name: imageBundleName, apiClient: Backend.apiClient)?.extractedUrl {
            let path = baseURL.appendingPathComponent("white-square-bg").appendingPathComponent(code.lowercased()).appendingPathExtension("png")
            if let data = try? Data(contentsOf: path) {
                return UIImage(data: data)
            }
        }
        
        return TokenImageSquareBackground(code: code, color: colors.0).renderedImage
    }
    
    /// Icon image with no background using template rendering mode
    public var imageNoBackground: UIImage? {
        if let baseURL = AssetArchive(name: imageBundleName, apiClient: Backend.apiClient)?.extractedUrl {
            let path = baseURL.appendingPathComponent("white-no-bg").appendingPathComponent(code.lowercased()).appendingPathExtension("png")
            if let data = try? Data(contentsOf: path) {
                return UIImage(data: data)?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        return TokenImageNoBackground(code: code, color: colors.0).renderedImage
    }
    
    private var imageBundleName: String {
        return (E.isDebug || E.isTestFlight) ? "brd-tokens-staging" : "brd-tokens"
    }
}

/// Natively supported currencies. Enum maps to ticker code.
extension Currencies {
    var btc: Currency? {
        return walletState(for: AssetCodes.btc.value)?.currency
    }
    
    var bch: Currency? {
        return walletState(for: AssetCodes.bch.value)?.currency
    }
    
    var eth: Currency? {
        return walletState(for: AssetCodes.eth.value)?.currency
    }
    
    var bsv: Currency? {
        return walletState(for: AssetCodes.bsv.value)?.currency
    }
    
    func walletState(for code: String) -> WalletState? {
        guard let uid = getUID(from: code),
              currencies.first(where: { $0.uid == uid }) != nil else { return nil }
        
        return Store.state.wallets[uid]
    }
}

extension WalletKit.Currency {
    var uid: CurrencyId { return CurrencyId(rawValue: uids) }
}

struct AttributeDefinition {
    let key: String
    let label: String
    let keyboardType: UIKeyboardType
    let maxLength: Int
}
