//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

protocol APIWorker {
    func execute()
    func executeMultipartRequest(data: MultipartModelData)
    func processResponse(response: HTTPResponse)
    func apiCallDidFinish(response: HTTPResponse)
    func getUrl() -> String
    func getMethod() -> HTTPMethod
    func getParameters() -> [String: Any]
    func getHeaders() -> [String: String]
    func getPagination() -> Pagination?
}
/**
 Super class for all workers that makes api calls to API
 */
class BaseApiWorker<M: Mapper>: APIWorker {
    
    typealias Completion = (Result<M.ToModel?, Error>) -> Void
    typealias PlainCompletion = (Error?) -> Void
    
    var requestData: RequestModelData?
    var completion: Completion?
    var result: M.ToModel?
    var isLoading: Bool {
        return getPagination()?.isLoading ?? false
    }
    
    var httpRequestManager = HTTPRequestManager()
    
    init() {}
    
    func execute(requestData: RequestModelData? = nil, completion: Completion? = nil) {
        self.requestData = requestData
        self.completion = completion
        execute()
    }
    
    func execute() {
        let method = getMethod()
        let url = getUrl()
        let headers = getHeaders()
        var parameters = getParameters()
        getPagination()?.getPagingParameters().forEach { parameters[$0] = $1 }
        
        let request = httpRequestManager.request(method, url: url, headers: headers, parameters: parameters)
        request.run { response in
            DispatchQueue.global(qos: .background).async {
                self.processResponse(response: response)
                DispatchQueue.main.async {
                    self.apiCallDidFinish(response: response)
                }
            }
        }
    }
    
    func executeMultipartRequest(data: MultipartModelData, completion: Completion? = nil) {
        self.completion = completion
        executeMultipartRequest(data: data)
    }
    
    func executeMultipartRequest(data: MultipartModelData) {
        let method = getMethod()
        let url = getUrl()
        let headers = getHeaders()
        let parameters = data.getParameters()
        
        let request = httpRequestManager.request(method, url: url, headers: headers, parameters: parameters)
        request.media = data.getMultipartData()
        request.runMultipartRequest { response in
            DispatchQueue.global(qos: .background).async {
                self.processResponse(response: response)
                DispatchQueue.main.async {
                    self.apiCallDidFinish(response: response)
                }
            }
        }
        
    }
    
    // Pagination
    func loadFirstPage(requestData: RequestModelData? = nil, completion: @escaping Completion) {
        self.completion = completion
        self.requestData = requestData
        getPagination()?.firstPageLoad()
        execute()
    }
    
    func shouldLoadNextPage() -> Bool {
        return getPagination()?.shouldLoadNextPage() ?? false
    }
    
    func fetchNextPage(completion: @escaping Completion) {
        result = nil
        guard shouldLoadNextPage() else { return }
        getPagination()?.nextPageLoad()
        self.completion = completion
        execute()
    }
    
    /**
     Function for any complex processing of http response. This function is called on a background thread.
     */
    func processResponse(response: HTTPResponse) {
        guard let data = response.data, response.error == nil else {
            return
        }
        let payload = M.FromModel.parse(from: data, type: M.FromModel.self)
        result = M().getModel(from: payload)
        
        guard let pagination = getPagination() else {
            return
        }

        guard result != nil else {
            pagination.handleNoContent()
            return
        }
        let itemCount = (result as? [Any])?.count ?? 1
        pagination.handlePageResponse(objectCount: itemCount, error: response.error)
    }
    
    /**
     Call completion from this function. This function is called on the main thread.
     */
    
    func apiCallDidFinish(response: HTTPResponse) {
        if let error = response.error {
            completion?(.failure(error))
        } else if let data = result {
            completion?(.success(data))
        } else {
            // No content
            completion?(.success(nil))
        }
    }
    
    func getUrl() -> String { return "" }
    func getMethod() -> HTTPMethod { return .get }
    func getParameters() -> [String: Any] { return requestData?.getParameters() ?? [:] }

    func getHeaders() -> [String: String] {
        return ["Authorization": UserDefaults.kycSessionKeyValue].compactMapValues { $0 }
    }
    
    func getPagination() -> Pagination? { return nil }
}

class Pagination {
    private var currentPage = 0
    var isLoading = false
    
    func firstPageLoad() {
        currentPage = 0
        isLoading = true
    }
    
    func nextPageLoad() {
        isLoading = true
    }
    
    private func successLoadingPage(objectCount: Int) {
        isLoading = false
        currentPage += 1
    }
    
    private func failureLoadingPage() {
        isLoading = false
    }
    
    func getPagingParameters() -> [String: Any] {
        return [
            "page": currentPage
        ]
    }
    
    func shouldLoadNextPage() -> Bool {
        return !isLoading
    }
    
    func handlePageResponse(objectCount: Int, error: FEError?) {
        guard error == nil else {
            failureLoadingPage()
            return
        }
        successLoadingPage(objectCount: objectCount)
    }
    
    func handleNoContent() {
        successLoadingPage(objectCount: 0)
    }
}

protocol Mapper {
    associatedtype FromModel: ModelResponse
    associatedtype ToModel: Any
    
    init()
    func getModel(from response: FromModel?) -> ToModel?
}
