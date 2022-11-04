// 
//  String+Chunk.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 22/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

extension String {
    public func chunk(step: Int) -> [SubSequence] {
        var sequence: [SubSequence] = []
        var startIndexHolder = startIndex
        var currentIndex: Index
        while startIndexHolder != endIndex {
            currentIndex = index(startIndexHolder, offsetBy: step, limitedBy: endIndex) ?? endIndex
            sequence.append(self[startIndexHolder..<currentIndex])
            startIndexHolder = currentIndex
        }
        return sequence
    }
    
    func chunkFormatted(withChunkSize chunkSize: Int = 4, withSeparator separator: Character = " ") -> String {
        return filter { $0 != separator }.chunk(step: chunkSize).map { String($0) }.joined(separator: String(separator))
    }
}
