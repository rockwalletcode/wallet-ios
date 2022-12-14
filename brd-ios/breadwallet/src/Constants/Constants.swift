//
//  Constants.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-24.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import WalletKit

public enum EventContext: String {
    case none
    case onboarding
    case generateKey
    case writeKey
    case recoverCloud
    
    var name: String { return rawValue }
}

public enum Screen: String {
    case none
    case confirmPaperKey
    case paperKeyIntro
    case writePaperKey
    
    var name: String { return rawValue }
}

/// Constants
typealias Constant = C
struct C {
    static let brdLogoTopMargin: CGFloat = E.isIPhoneX ? Margins.custom(9) + 35.0 : Margins.custom(9) + 20.0
    static let secondsInDay: TimeInterval = 86400
    static let secondsInMinute: TimeInterval = 60
    static let maxMemoLength = 250
    static let companyURL = "rockwallet.com"
    static let privacyPolicy = "https://\(companyURL)/privacy"
    static let termsAndConditions = "https://\(companyURL)/tc"
    static let supportLink = "https://help.\(companyURL)"
    static let feedbackEmail = "support@\(companyURL)"
    static let reviewLink = "https://apps.apple.com/us/app/rockwallet-buy-and-swap/id6444194230?action=write-review"
    static var standardPort: Int {
        return E.isTestnet ? 18333 : 8333
    }
    static let bip39CreationTime = TimeInterval(1388534400) - NSTimeIntervalSince1970
    
    /// Path where core library stores its persistent data
    static var coreDataDirURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("core-data", isDirectory: true)
    }
    
    static let consoleLogFileName = "log.txt"
    static let previousConsoleLogFileName = "previouslog.txt"
    
    // Returns the console log file path for the current instantiation of the app.
    static var logFilePath: URL {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesURL.appendingPathComponent(consoleLogFileName)
    }
    
    // Returns the console log file path for the previous instantiation of the app.
    static var previousLogFilePath: URL {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesURL.appendingPathComponent(previousConsoleLogFileName)
    }
    
    static let usLocaleCode = "en_US"
    static let countryUS = "US"
    
    static let usdCurrencyCode = "USD"
    static let euroCurrencyCode = "EUR"
    static let britishPoundCurrencyCode = "GBP"
    static let danishKroneCurrencyCode = "DKK"
    static let erc20Prefix = "erc20:"
    static let BTC = "BTC"
    static let BCH = "BCH"
    static let ETH = "ETH"
    static let BSV = "BSV"
    static let USDC = "USDC"
    
    static var backendHost: String {
        if let debugBackendHost = UserDefaults.debugBackendHost {
            return debugBackendHost
        } else {
            return E.apiUrl + "blocksatoshi/wallet"
        }
    }
    
    static var bdbHost: String {
        return E.apiUrl + "blocksatoshi/blocksatoshi"
    }

    static let bdbClientTokenRecordId = "BlockchainDBClientID"
    
    static let fixerAPITokenRecordId = "FixerAPIToken"
}

enum Words {
    /// Returns the wordlist of the current localization
    static var wordList: [NSString]? {
        guard let path = Bundle.main.path(forResource: "BIP39Words", ofType: "plist") else { return nil }
        return NSArray(contentsOfFile: path) as? [NSString]
    }
    
    /// Returns the wordlist that matches to localization of the phrase
    static func wordList(forPhrase phrase: String) -> [NSString]? {
        var result = [NSString]()
        Bundle.main.localizations.forEach { lang in
            if let path = Bundle.main.path(forResource: "BIP39Words", ofType: "plist", inDirectory: nil, forLocalization: lang) {
                if let words = NSArray(contentsOfFile: path) as? [NSString],
                    Account.validatePhrase(phrase, words: words.map { String($0) }) {
                    result = words
                }
            }
        }
        return result
    }
}
