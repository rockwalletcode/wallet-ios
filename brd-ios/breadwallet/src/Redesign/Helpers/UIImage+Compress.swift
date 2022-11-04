// 
//  ImageCompressor.swift
//  breadwallet
//
//  Created by Rok on 10/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension UIImage {
    
    func compress(to byteSize: Int, didFinish: @escaping ((UIImage?) -> Void)) {
        let image = self
        guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else { return didFinish(image) }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0
            
            while iterationImageSize > byteSize && iterationCompression > 0.01 {
                let percantageDecrease = Self.getPercantageToDecreaseTo(forDataCount: iterationImageSize)
                
                let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                        height: image.size.height * iterationCompression)
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                image.draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()
                
                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count
                else { return didFinish(iterationImage) }
                
                iterationImageSize = newImageSize
                iterationCompression -= percantageDecrease
            }
            
            DispatchQueue.main.async {
                didFinish(iterationImage)
            }
        }
    }
    
    private static func getPercantageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
        case 0..<3_000_000: return 0.05
        case 3_000_000..<10_000_000: return 0.1
        default: return 0.2
        }
    }
}
