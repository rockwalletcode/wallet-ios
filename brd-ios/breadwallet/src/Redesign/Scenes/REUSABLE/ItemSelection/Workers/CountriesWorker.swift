// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

import Foundation

struct CountriesResponseData: ModelResponse {
    struct CountryResponseData: ModelResponse {
        var iso2: String
        var localizedName: String
        var states: [USState]?
    }
    var countries: [CountryResponseData]
}

struct USState: ModelResponse, ItemSelectable {
    var iso2: String
    var name: String
    
    var displayName: String? {
        return name
    }
    
    var displayImage: ImageViewModel? { return nil }
}

protocol ItemSelectable {
    var displayName: String? { get }
    var displayImage: ImageViewModel? { get }
}

struct Country: Model, ItemSelectable {
    var code: String
    var name: String
    
    var states: [USState]?
    
    var displayName: String? { return name }
    var displayImage: ImageViewModel? { return .imageName(code) }
}

class CountriesMapper: ModelMapper<CountriesResponseData, [Country]> {
    override func getModel(from response: CountriesResponseData?) -> [Country]? {
        var countries = response?.countries.compactMap({ return Country(code: $0.iso2, name: $0.localizedName, states: $0.states) })
        
        if let firstIndexUS = countries?.firstIndex(where: { $0.code == "US" }), let us = countries?[firstIndexUS] {
            countries?.remove(at: firstIndexUS)
            countries?.insert(us, at: 0)
        }
        
        return countries
    }
}

struct CountriesRequestData: RequestModelData {
    let locale: String = Locale.current.identifier
    
    func getParameters() -> [String: Any] {
        return [
            "_locale": locale
        ]
    }
}

class CountriesWorker: BaseApiWorker<CountriesMapper> {
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCEndpoints.countriesList)
    }
    
    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
}
