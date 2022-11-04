// 
//  AssetSelectionDisplayable.swift
//  breadwallet
//
//  Created by Rok on 18/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

protocol AssetSelectionDisplayable {
    func showAssetSelector(title: String, currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?)
    func isDisabledAsset(code: String?, supportedCurrencies: [SupportedCurrency]?) -> Bool?
}

extension AssetSelectionDisplayable where Self: BaseCoordinator {
    func showAssetSelector(title: String, currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?) {
        let allCurrencies = Currencies.shared.currencies
        
        let supportedAssets = allCurrencies.filter { item in supportedCurrencies?.contains(where: { $0.name.lowercased() == item.code}) ?? false }
        
        var data: [AssetViewModel]? = currencies?.compactMap {
            let topRightText = String(format: "%@ %@",
                                      ExchangeFormatter.crypto.string(for: $0.state?.balance?.tokenValue) ?? "",
                                      $0.code.uppercased())
            let bottomRightText = String(format: "%@ %@",
                                         ExchangeFormatter.fiat.string(for: $0.state?.balance?.fiatValue) ?? "",
                                         C.usdCurrencyCode)
            
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code,
                                  topRightText: topRightText,
                                  bottomRightText: bottomRightText,
                                  isDisabled: isDisabledAsset(code: $0.code, supportedCurrencies: supportedCurrencies) ?? false)
        }
        
        let unsupportedAssets = supportedAssets.filter { item in !(data?.contains(where: { $0.subtitle?.lowercased() == item.code }) ?? false) }
        
        let disabledData: [AssetViewModel]? = unsupportedAssets.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code.uppercased(),
                                  isDisabled: true)
        }
        
        data?.append(contentsOf: disabledData ?? [])
        
        let sortedCurrencies = data?.sorted { !$0.isDisabled && $1.isDisabled }
        
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.AssetSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = sortedCurrencies ?? []
            vc?.dataStore?.sceneTitle = title
            vc?.itemSelected = selected
            vc?.prepareData()
        }
    }
    
    func isDisabledAsset(code: String?, supportedCurrencies: [SupportedCurrency]?) -> Bool? {
        guard let assetCode = code else { return false }
        
        return !(supportedCurrencies?.contains(where: { $0.name == assetCode}) ?? false)
    }
}
