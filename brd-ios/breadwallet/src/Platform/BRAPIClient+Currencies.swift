//
//  BRAPIClient+Currencies.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-03-12.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import Foundation
import UIKit

public enum APIResult<ResultType: Codable> {
    case success(ResultType)
    case error(Error)
}

public struct HTTPError: Error {
    let code: Int
}

extension BRAPIClient {
    /// Get the list of supported currencies and their metadata from the backend or local cache
    func getCurrencyMetaData(type: CurrencyFileManager.DownloadedCurrencyType, completion: @escaping ([CurrencyId: CurrencyMetaData]) -> Void) {
        guard let cachedFilePath = CurrencyFileManager.sharedFilePath(type: type) else {
            CurrencyFileManager.getCurrencyMetaDataFromCache(type: type, completion: completion)
            return
        }
        
        var req = URLRequest(url: url("/\(type.rawValue)"))
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        send(request: req, handler: { (result: APIResult<[CurrencyMetaData]>) in
            switch result {
            case .success(let currencies):
                CurrencyFileManager.updateCache(type: type, currencies, cachedFilePath: cachedFilePath)
                CurrencyFileManager.processCurrencies(type: type, currencies, completion: completion)
                
            case .error(let error):
                print("[\(type.rawValue.uppercased())] Error fetching tokens: \(error)")
                CurrencyFileManager.copyEmbeddedCurrencies(type: type, path: cachedFilePath)
                
                let result = CurrencyFileManager.processCurrenciesCache(type: type, path: cachedFilePath, completion: completion)
                assert(result, "[\(type.rawValue.uppercased())] Failed to get currency list from backend or cache")
            }
        })
    }
    
    private func send<ResultType>(request: URLRequest, handler: @escaping (APIResult<ResultType>) -> Void) {
        dataTaskWithRequest(request, authenticated: true, retryCount: 0, handler: { data, response, error in
            guard error == nil, let data = data else {
                print("[API] HTTP error: \(error!)")
                return handler(APIResult<ResultType>.error(error!))
            }
            guard let statusCode = response?.statusCode, statusCode >= 200 && statusCode < 300 else {
                return handler(APIResult<ResultType>.error(HTTPError(code: response?.statusCode ?? 0)))
            }
            
            do {
                let result = try JSONDecoder().decode(ResultType.self, from: data)
                handler(APIResult<ResultType>.success(result))
            } catch let jsonError {
                print("[API] JSON error: \(jsonError)")
                handler(APIResult<ResultType>.error(jsonError))
            }
        }).resume()
    }
}
