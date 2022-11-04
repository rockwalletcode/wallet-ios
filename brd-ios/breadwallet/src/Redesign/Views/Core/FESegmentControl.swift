// 
//  FESegmentControl.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SegmentControlConfiguration: Configurable {
    var font: UIFont = Fonts.button
    var normal: BackgroundConfiguration = .init(backgroundColor: LightColors.tertiary, tintColor: LightColors.Text.one)
    var selected: BackgroundConfiguration = .init(backgroundColor: LightColors.primary, tintColor: LightColors.Contrast.two)
}

struct SegmentControlViewModel: ViewModel {
    /// Passing 'nil' leaves the control deselected
    var selectedIndex: FESegmentControl.Values?
}

class FESegmentControl: UISegmentedControl, ViewProtocol {
    enum Values: String, CaseIterable {
        
        case min
        case max
    }
    
    var config: SegmentControlConfiguration?
    var viewModel: SegmentControlViewModel?
    
    var didChangeValue: ((Values) -> Void)?
    
    convenience init() {
        let items = [
            Values.min.rawValue,
            Values.max.rawValue
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
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 6, dy: 6)
            foregroundImageView.image = UIImage.imageForColor(LightColors.primary)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.frame.height / 2
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
        
        // TODO: Divider should be the same color as the background color. There is something wrong with the background color.
        setDividerImage(UIImage.imageForColor(UIColor(red: 223.0/255.0,
                                                      green: 228.0/255.0,
                                                      blue: 239.0/255.0,
                                                      alpha: 1.0)),
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal,
                        barMetrics: .default)
        
        valueChanged = { [weak self] in
            guard let selectedSegmentIndex = self?.selectedSegmentIndex, selectedSegmentIndex >= 0 else { return }
            self?.didChangeValue?(Values.allCases[selectedSegmentIndex])
        }
    }
    
    func setup(with viewModel: SegmentControlViewModel?) {
        guard let index = viewModel?.selectedIndex,
              let filteredIndex = Values.allCases.firstIndex(where: { $0 == index }) else {
            selectedSegmentIndex = UISegmentedControl.noSegment
            return
        }
        
        selectedSegmentIndex = filteredIndex
    }
}
