//
//  PlatformAuthResult.swift
//  BreadWallet
//
//  Created by Samuel Sutch on 2/18/16.
//  Copyright (c) 2016-2019 Breadwinner AG. All rights reserved.
//

import Foundation

enum PlatformAuthResult {
    case success(String?)
    case cancelled
    case failed
}
