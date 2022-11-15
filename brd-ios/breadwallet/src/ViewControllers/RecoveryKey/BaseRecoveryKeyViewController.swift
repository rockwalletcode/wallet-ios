//
//  BaseRecoveryKeyViewController.swift
//  breadwallet
//
//  Created by Ray Vander Veen on 2019-04-15.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import UIKit

class BaseRecoveryKeyViewController: UIViewController {
    enum CloseButtonStyle {
        case close
        case skip
    }
    
    var eventContext: EventContext = .none
    var screen: Screen = .none
    
    var closeButtonStyle: CloseButtonStyle {
        return .close
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ eventContext: EventContext, _ screen: Screen) {
        self.eventContext = eventContext
        self.screen = screen
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func constrainContinueButton(_ button: FEButton) {
        button.constrain([
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Margins.large.rawValue),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Margins.large.rawValue),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.huge.rawValue),
            button.heightAnchor.constraint(equalToConstant: ViewSizes.Common.largeCommon.rawValue)
            ])
    }
    
    @objc func onBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onCloseButton() {}

    func showCloseButton() {
        switch closeButtonStyle {
        case .close:
            let close = UIBarButtonItem(image: UIImage(named: "close"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(onCloseButton))
            close.tintColor = LightColors.Text.three
            navigationItem.rightBarButtonItem = close

        case .skip:
            let skip = UIBarButtonItem(title: L10n.Button.skip,
                                       style: .plain,
                                       target: self,
                                       action: #selector(onCloseButton))
            skip.tintColor = LightColors.Text.three
            let fontAttributes = [NSAttributedString.Key.font: Fonts.Body.two]
            skip.setTitleTextAttributes(fontAttributes, for: .normal)
            skip.setTitleTextAttributes(fontAttributes, for: .highlighted)
            navigationItem.rightBarButtonItem = skip
            
        }
    }
    
    func showBackButton() {
        let back = UIBarButtonItem(image: UIImage(named: "back"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(onBackButton))
        back.tintColor = LightColors.Text.three
        navigationItem.leftBarButtonItem = back
    }
    
    func hideBackButton() {
        navigationItem.leftBarButtonItem = nil
    }
}
