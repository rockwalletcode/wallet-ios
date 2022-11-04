//
//  ScanViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-12.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import AVFoundation

typealias ScanCompletion = (QRCode?) -> Void

class ScanViewController: UIViewController {

    static func presentCameraUnavailableAlert(fromRoot: UIViewController) {
        let alertController = UIAlertController(title: L10n.Send.cameraUnavailableTitle, message: L10n.Send.cameraunavailableMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: L10n.Button.settings, style: .`default`, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }))
        fromRoot.present(alertController, animated: true, completion: nil)
    }

    static var isCameraAllowed: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .denied
    }

    private let completion: ScanCompletion
    private let allowScanningPrivateKeysOnly: Bool
    /// scanner only accepts currency-specific payment request
    private let paymentRequestCurrencyRestriction: Currency?
    fileprivate let guide = CameraGuideView()
    fileprivate let session = AVCaptureSession()
    private let toolbar = UIStackView()
    private let close = UIButton.buildModernCloseButton(position: .middle)
    private let flash = UIButton.icon(image: #imageLiteral(resourceName: "Flash"), accessibilityLabel: L10n.Scanner.flashButtonLabel, position: .middle)
    private let cameraRoll: UIButton = {
        let button: UIButton
        button = UIButton.icon(image: UIImage(systemName: "photo.on.rectangle") ?? UIImage(), accessibilityLabel: "import", position: .middle)
        return button
    }()
    
    fileprivate var currentUri = ""
    private var toolbarHeightConstraint: NSLayoutConstraint?
    private let toolbarHeight: CGFloat = 54.0
    private var hasCompleted = false
    
    init(forPaymentRequestForCurrency currencyRestriction: Currency? = nil, forScanningPrivateKeysOnly: Bool = false, completion: @escaping ScanCompletion) {
        self.completion = completion
        self.paymentRequestCurrencyRestriction = currencyRestriction
        self.allowScanningPrivateKeysOnly = forScanningPrivateKeysOnly
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    override func viewDidLoad() {
        view.backgroundColor = .black
        toolbar.backgroundColor = .secondaryButton
        toolbar.distribution = .fillEqually
        
        view.addSubview(toolbar)
        toolbar.addArrangedSubview(close)
        toolbar.addArrangedSubview(UIView())
        toolbar.addArrangedSubview(cameraRoll)
        toolbar.addArrangedSubview(UIView())
        toolbar.addArrangedSubview(flash)
        view.addSubview(guide)

        toolbar.constrainBottomCorners(sidePadding: 0, bottomPadding: 0)
        toolbarHeightConstraint = toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight)
        toolbar.constrain([toolbarHeightConstraint])

        guide.constrain([
            guide.constraint(.leading, toView: view, constant: Margins.custom(6)),
            guide.constraint(.trailing, toView: view, constant: -Margins.custom(6)),
            guide.constraint(.centerY, toView: view),
            NSLayoutConstraint(item: guide, attribute: .width, relatedBy: .equal, toItem: guide, attribute: .height, multiplier: 1.0, constant: 0.0) ])
        guide.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)

        close.tap = { [unowned self] in
            self.dismiss(animated: true, completion: {
                self.completion(nil)
            })
        }
        
        cameraRoll.tap = importCameraRoll
        addCameraPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Animate guide on appear
        UIView.spring(0.8, animations: {
            self.guide.transform = .identity
        }, completion: { _ in })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        toolbarHeightConstraint?.constant = toolbarHeight + view.safeAreaInsets.bottom
    }

    private func addCameraPreview() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.addInput(input)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)

        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: .main)
        session.addOutput(output)

        if output.availableMetadataObjectTypes.contains(where: { objectType in
            return objectType == AVMetadataObject.ObjectType.qr
        }) {
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            print("no qr code support")
        }

        DispatchQueue(label: "qrscanner").async {
            self.session.startRunning()
        }

        if device.hasTorch {
            flash.tap = {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = device.torchMode == .on ? .off : .on
                    device.unlockForConfiguration()
                } catch let error {
                    print("Camera Torch error: \(error)")
                }
            }
        }
    }
    
    private func importCameraRoll() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let data = metadataObjects as? [AVMetadataMachineReadableCodeObject] {
            if data.isEmpty {
                guide.state = .normal
            } else {
                data.forEach {
                    guard let uri = $0.stringValue else { return }
                    handleURI(uri)
                }
            }
        }
    }

    func handleURI(_ uri: String) {
        print("QR content detected: \(uri)")
        self.currentUri = uri
        let result = QRCode(content: uri)
        guard .invalid != result else {
            guide.state = .negative
            return
        }
        
        if allowScanningPrivateKeysOnly {
            switch result {
            case .privateKey, .gift:
                break
            default:
                guide.state = .negative
                return
            }
        }
        
        if let currencyRestriction = paymentRequestCurrencyRestriction {
            guard case .paymentRequest(let request) = result,
                    let request = request,
                    request.currency.shouldAcceptQRCodeFrom(currencyRestriction, request: request) else {
                guide.state = .negative
                return
            }
        }
        
        guide.state = .positive
        
        //handleURI can be called many times, so we
        //need to make sure the completion block only gets called once
        guard !hasCompleted else { return }
        hasCompleted = true
        
        // Add a small delay so the green guide will be seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.dismiss(animated: true, completion: {
                self.completion(result)
            })
        })
    }
}

//Image Picker Delegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        if let features = detectQRCode(newImage), !features.isEmpty {
            for case let row as CIQRCodeFeature in features {
                if let message = row.messageString {
                    DispatchQueue.main.async { [weak self] in
                        self?.handleURI(message)
                    }
                }
            }
        }
    }
    
    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        //sourced: https://stackoverflow.com/questions/35956538/how-to-read-qr-code-from-static-image
        if let image = image, let ciImage = CIImage.init(image: image) {
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features

        }
        return nil
    }
}
