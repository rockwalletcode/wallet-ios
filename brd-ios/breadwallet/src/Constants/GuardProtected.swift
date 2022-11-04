//
//  GuardProtected.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-06-18.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

/// Executes the callback on the given queue when the device becomes unlocked, or immediately if protected data is already available
func guardProtected(callback: @escaping () -> Void) {
    DispatchQueue.main.async {
        if UIApplication.shared.isProtectedDataAvailable {
            callback()
        } else {
            var observer: Any?
            observer = NotificationCenter.default.addObserver(forName: UIApplication.protectedDataDidBecomeAvailableNotification,
                                                              object: nil,
                                                              queue: nil) { _ in
                DispatchQueue.main.async {
                    callback()
                }
                if let observer = observer {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        }
    }
}
