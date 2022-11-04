//
// Created by Equaleyes Solutions Ltd
//

import Foundation

struct CountriesResponseData: ModelResponse {
    struct CountryResponseData: ModelResponse {
        var iso2: String
        var localizedName: String
    }
    var countries: [CountryResponseData]
}

protocol ItemSelectable {
    var displayName: String? { get }
    var displayImage: ImageViewModel? { get }
}

struct Country: Model, ItemSelectable {
    var code: String
    var name: String
    
    var displayName: String? { return name }
    var displayImage: ImageViewModel? { return .imageName(code) }
}
class CountriesMapper: ModelMapper<CountriesResponseData, [Country]> {
    override func getModel(from response: CountriesResponseData?) -> [Country]? {
        return response?.countries.compactMap { return .init(code: $0.iso2, name: $0.localizedName) }
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
