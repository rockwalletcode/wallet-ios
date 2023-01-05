// 
//  FESegmentControl.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SegmentControlConfiguration: Configurable {
    var font: UIFont = Fonts.button
    var normal: BackgroundConfiguration = .init(backgroundColor: LightColors.Background.cards, tintColor: LightColors.primary)
    var selected: BackgroundConfiguration = .init(backgroundColor: LightColors.primary, tintColor: LightColors.Contrast.two)
}

struct SegmentControlViewModel: ViewModel {
    /// Passing 'nil' leaves the control deselected
    var selectedIndex: PaymentCard.PaymentType?
}

class FESegmentControl: UISegmentedControl, ViewProtocol {
    var config: SegmentControlConfiguration?
    var viewModel: SegmentControlViewModel?
    
    var didChangeValue: ((PaymentCard.PaymentType) -> Void)?
    
    convenience init() {
        let items = [
            L10n.Buy.buyWithCard,
            L10n.Buy.fundWithAch
        ]
        
        self.init(items: items)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
        clipsToBounds = true
        
        if subviews.indices.contains(selectedSegmentIndex),
            let foregroundImageView = subviews[numberOfSegments] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 10, dy: 10)
            foregroundImageView.image = UIImage.imageForColor(LightColors.primary)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.frame.height / 2
            
            for i in 0..<numberOfSegments {
                let backgroundSegmentView = subviews[i]
                backgroundSegmentView.isHidden = true
            }
        }
    }
    
    func configure(with config: SegmentControlConfiguration?) {
        guard let config = config else { return }
        
        snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        backgroundColor = config.normal.backgroundColor
        selectedSegmentTintColor = config.selected.backgroundColor
        
        setTitleTextAttributes([
            .font: config.font,
            .foregroundColor: config.normal.tintColor
        ], for: .normal)
        
        setTitleTextAttributes([
            .font: config.font,
            .foregroundColor: config.selected.tintColor
        ], for: .selected)
        
        valueChanged = { [weak self] in
            guard let selectedSegmentIndex = self?.selectedSegmentIndex, selectedSegmentIndex >= 0 else { return }
            self?.didChangeValue?(PaymentCard.PaymentType.allCases[selectedSegmentIndex])
        }
    }
    
    func setup(with viewModel: SegmentControlViewModel?) {
        guard let index = viewModel?.selectedIndex,
              let filteredIndex = PaymentCard.PaymentType.allCases.firstIndex(where: { $0 == index }) else {
            selectedSegmentIndex = UISegmentedControl.noSegment
            return
        }
        
        selectedSegmentIndex = filteredIndex
    }
}
