// 
//  UserManager.swift
//  breadwallet
//
//  Created by Rok on 22/06/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class UserManager: NSObject {
    static var shared = UserManager()
    
    var profile: Profile?
    var error: Error?
    var profileResult: Result<Profile?, Error>?
    
    func refresh(completion: ((Result<Profile?, Error>?) -> Void)? = nil) {
        ProfileWorker().execute { [weak self] result in
            self?.profileResult = result
            
            switch result {
            case .success(let profile):
                self?.profile = profile
                
            case .failure(let error):
                self?.error = error
                self?.profile = nil
            }
            
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
}
