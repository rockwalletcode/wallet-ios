// 
//  PhotoCaptureDelegate.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 14/06/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import AVFoundation
import Photos
import UIKit

class KYCCameraPhotoCaptureProcessor: NSObject {
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    private let willCapturePhotoAnimation: () -> Void
    private let completionHandler: (KYCCameraPhotoCaptureProcessor) -> Void
    private let photoProcessingHandler: (Bool) -> Void
    private let photoProcessed: (UIImage) -> Void
    
    private var photoData: Data?
    private var maxPhotoProcessingTime: CMTime?
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         willCapturePhotoAnimation: @escaping () -> Void,
         completionHandler: @escaping (KYCCameraPhotoCaptureProcessor) -> Void,
         photoProcessed: @escaping (UIImage) -> Void,
         photoProcessingHandler: @escaping (Bool) -> Void) {
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completionHandler = completionHandler
        self.photoProcessed = photoProcessed
        self.photoProcessingHandler = photoProcessingHandler
    }
}

extension KYCCameraPhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
    /*
     This extension adopts all of the AVCapturePhotoCaptureDelegate protocol methods.
     */
    
    /// - Tag: WillCapturePhoto
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        willCapturePhotoAnimation()
        
        guard let maxPhotoProcessingTime = maxPhotoProcessingTime else {
            return
        }
        
        // Show a spinner if processing time exceeds one second.
        let oneSecond = CMTime(seconds: 1, preferredTimescale: 1)
        if maxPhotoProcessingTime > oneSecond {
            photoProcessingHandler(true)
        }
    }
    
    /// - Tag: DidFinishProcessingPhoto
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        photoProcessingHandler(false)

        if let error = error {
            print("Error capturing photo: \(error)")
            return
        } else {
            photoData = photo.fileDataRepresentation()
            
            guard let photoData = photoData, let image = UIImage(data: photoData) else { return }
            photoProcessed(image)
        }
    }
}
