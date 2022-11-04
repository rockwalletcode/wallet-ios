//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

protocol ModelResponse: Codable {}

protocol Model {}

extension Array: Model {}

class ModelMapper<T: ModelResponse, U: Any>: Mapper {
    required public init() {}
    
    open func getModel(from response: T?) -> U? {
        return nil
    }
}

enum GenericModels {
    enum Error {
        struct Response {
            let error: FEError?
        }
        struct ViewModel {
            let error: String
        }
    }
}
