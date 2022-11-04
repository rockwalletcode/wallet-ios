//
//  MessageModels.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import Foundation

struct MessageModels {
    struct Errors {
        struct ActionResponse {
            var error: Error?
        }
    }
    
    struct Notification {
        struct ActionResponse {
            var title: String?
            var body: String?
            var dissmiss: DismissType = .auto
        }
    }
    
    struct Alert {
        struct ActionResponse {
            var title: String?
            var body: String?}
    }
    
    struct ResponseDisplays {
        var error: FEError?
        var model: InfoViewModel?
        var config: InfoViewConfiguration?
    }
}
