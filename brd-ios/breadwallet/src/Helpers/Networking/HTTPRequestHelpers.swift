//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

enum Encoding {
    // Maybe support "application/x-www-form-urlencoded"
    
    case json
}

struct HTTPResponse {
    var statusCode = 0
    var responseString = ""
    var responseValue: Any?
    var error: FEError?
    var request: URLRequest?
    var response: HTTPURLResponse?
    var data: Data?
}

protocol MultiPart {
    var key: String { get set }
    var fileName: String? { get set }
    var data: Data { get set }
    var mimeType: MultipartMedia.MimeType { get set }
    var mimeFileFormat: MultipartMedia.MimeFileFormat { get set }
}

struct MultipartMedia: MultiPart {
    enum MimeType {
        case jpeg
        case png
        case pdf
        case other(type: String)
        
        var value: String {
            switch self {
            case .jpeg:
                return "image/jpeg"
            case .png:
                return "image/png"
            case .pdf:
                return "application/pdf"
            case .other(type: let type):
                return type
            }
        }
    }
    
    enum MimeFileFormat {
        case jpeg
        case png
        case pdf
        case other(format: String)
        
        var value: String {
            switch self {
            case .jpeg:
                return ".jpeg"
            case .png:
                return ".png"
            case .pdf:
                return ".pdf"
            case .other(format: let format):
                return "." + format
            }
        }
    }
    
    var key: String
    var fileName: String?
    var data: Data
    var mimeType: MimeType
    var mimeFileFormat: MimeFileFormat
    
    init(with data: Data, fileName: String? = nil, forKey key: String, mimeType: MimeType, mimeFileFormat: MimeFileFormat) {
        self.key = key
        self.fileName = fileName
        self.data = data
        self.mimeType = mimeType
        self.mimeFileFormat = mimeFileFormat
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
