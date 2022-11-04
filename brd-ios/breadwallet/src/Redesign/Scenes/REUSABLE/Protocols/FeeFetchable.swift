// 
//  FeeFetchable.swift
//  breadwallet
//
//  Created by Rok on 01/09/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import WalletKit

protocol FeeFetchable {
    func fetchWkFee(for amount: Amount,
                    with sender: Sender,
                    address: String,
                    completion: @escaping ((TransferFeeBasis?) -> Void))
}

extension FeeFetchable {
    func fetchWkFee(for amount: Amount,
                    with sender: Sender,
                    address: String,
                    completion: @escaping ((TransferFeeBasis?) -> Void)) {
        sender.estimateFee(address: address,
                           amount: amount,
                           tier: .priority,
                           isStake: false) { result in
            switch result {
            case .success(let fee):
                completion(fee)
                
            case .failure:
                completion(nil)
            }
        }
    }
}
