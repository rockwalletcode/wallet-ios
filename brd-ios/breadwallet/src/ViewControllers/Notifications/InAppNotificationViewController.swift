//
//  InAppNotificationViewController.swift
//  breadwallet
//
//  Created by rrrrray-BRD-mac on 2019-06-04.
//  Copyright © 2019 breadwallet LLC. All rights reserved.
//

import UIKit

class InAppNotificationViewController: UIViewController {

    private let notification: BRDMessage
    private var image: UIImage?
    
    private let titleLabel = UILabel.wrapping(font: Fonts.Title.two, color: LightColors.Text.one)
    private let bodyLabel = UILabel.wrapping(font: Fonts.Body.one, color: LightColors.Text.two)
    private let imageView = UIImageView()
    private let ctaButton = BRDButton(title: "", type: .primary)
    
    private let imageSizePercent: CGFloat = 0.74
    private let contentTopMarginPercent: CGFloat = 0.1
    private let textMarginPercent: CGFloat = 0.14
    
    private var imageTopConstraint: CGFloat = 52
    private var imageSize: CGFloat = 280
    private var textLeftRightMargin: CGFloat = 54
    
    // MARK: - initialization
    
    init(_ notification: BRDMessage, image: UIImage?) {
        self.notification = notification
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    // MARK: - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = LightColors.Background.one
        
        calculateMarginsAndSizes()
        addCloseButton()
        setUpAppearance()
        addSubviews()
        addConstraints()
    }
    
    // MARK: - misc/setup
    
    @objc private func onCloseButton() {
        dismiss(animated: true)
    }
    
    private func addCloseButton() {
        let close = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(.alwaysOriginal),
                                    style: .plain,
                                    target: self,
                                    action: #selector(onCloseButton))
        close.tintColor = LightColors.Text.three
        navigationItem.rightBarButtonItem = close
    }
    
    private func calculateMarginsAndSizes() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let contentTop = (screenHeight * contentTopMarginPercent) - statusBarHeight
        
        imageTopConstraint = contentTop
        imageSize = screenWidth * imageSizePercent
        textLeftRightMargin = screenWidth * textMarginPercent
    }
    
    private func loadImage() {
        if let preloadedImage = self.image {
            imageView.image = preloadedImage
        } else if let urlString = notification.imageUrl, !urlString.isEmpty {
            UIImage.fetchAsync(from: urlString) { [weak self] (image) in
                guard let self = self else { return }
                if let image = image {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func setUpAppearance() {
        
        //
        // image view
        //
        
        imageView.contentMode = .center
        imageView.backgroundColor = LightColors.primary.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        loadImage()
        
        //
        // text fields
        //
        
        titleLabel.textAlignment = .center
        bodyLabel.textAlignment = .center
        
        if let title = notification.title {
            titleLabel.text = title
        }

        if let body = notification.body {
            bodyLabel.text = body
        }
        
        //
        // CTA (call-to-action) button
        //
        
        if let cta = notification.cta, !cta.isEmpty {
            ctaButton.title = cta
            
            ctaButton.tap = { [weak self] in
                guard let self = self else { return }
                
                self.dismiss(animated: true, completion: {
                    if let ctaUrl = self.notification.ctaUrl, !ctaUrl.isEmpty, let url = URL(string: ctaUrl) {
                        // The UIApplication extension will ensure we handle the url correctly, including deep links.
                        UIApplication.shared.open(url)
                    }
                })
            }

        } else {
            ctaButton.isHidden = true
        }
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(ctaButton)
    }
    
    private func addConstraints() {
        
        imageView.constrain([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: imageTopConstraint),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: textLeftRightMargin),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -textLeftRightMargin)
            ])
        
        bodyLabel.constrain([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.large.rawValue),
            bodyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: textLeftRightMargin),
            bodyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -textLeftRightMargin)
            ])
        
        ctaButton.constrain([
            ctaButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Margins.large.rawValue),
            ctaButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Margins.large.rawValue),
            ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.large.rawValue),
            ctaButton.heightAnchor.constraint(equalToConstant: ViewSizes.Common.defaultCommon.rawValue)
        ])
    }
}
