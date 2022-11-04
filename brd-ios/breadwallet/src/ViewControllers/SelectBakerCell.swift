// 
//  SelectBakerCell.swift
//  breadwallet
//
//  Created by Jared Wheeler on 2/11/21.
//  Copyright © 2021 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum SelectBakerCellIds: String {
    case selectBakerCell = "SelectBakerCell"
}

class SelectBakerCell: UITableViewCell {
    
    static let CellHeight: CGFloat = 70.0
    fileprivate let iconSize: CGFloat = 40.0
    private let bakerIcon = UIImageView(color: .transparentIconBackground)
    private let bakerIconLoadingView = UIView()
    private let iconLoadingSpinner = UIActivityIndicatorView(style: .medium)
    private let bakerName = UILabel(font: Fonts.Title.three, color: .darkGray)
    private let roiHeader = UILabel(font: Fonts.Body.three, color: .lightGray)
    private let roi = UILabel(font: Fonts.Title.three, color: .darkGray)
    private let fee = UILabel(font: Fonts.Body.three, color: .lightGray)
    
    let container = Background()    // not private for inheritance
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    static func cellIdentifier() -> String {
        return SelectBakerCellIds.selectBakerCell.rawValue
    }
    
    func set(_ baker: Baker?) {
        bakerName.text = baker?.name
        roiHeader.text = L10n.Staking.roiHeader
        roi.text = baker?.roiString
        let feeText = baker?.feeString ?? ""
        fee.text = "\(L10n.Staking.feeHeader) \(feeText)"

        if let imageUrl = baker?.logo, !imageUrl.isEmpty {
            UIImage.fetchAsync(from: imageUrl) { [weak bakerIcon] (image, url) in
                // Reusable cell, ignore completion from a previous load call
                if url?.absoluteString == imageUrl {
                    bakerIcon?.image = image
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.bakerIconLoadingView.alpha = 0.0
                    }
                }
            }
        }
    }
    
    func setupViews() {
        separatorInset = .zero
        addSubviews()
        addConstraints()
        setupStyle()
    }

    private func addSubviews() {
        contentView.addSubview(container)
        container.addSubview(bakerName)
        container.addSubview(roiHeader)
        container.addSubview(roi)
        container.addSubview(fee)
        container.addSubview(bakerIcon)
        container.addSubview(bakerIconLoadingView)
        bakerIconLoadingView.addSubview(iconLoadingSpinner)
        
        bakerIcon.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIcon.layer.masksToBounds = true
        
        bakerIconLoadingView.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        bakerIconLoadingView.layer.masksToBounds = true
        bakerIconLoadingView.backgroundColor = .lightGray
        
        iconLoadingSpinner.startAnimating()
    }

    private func addConstraints() {
        container.constrain(toSuperviewEdges:
            UIEdgeInsets(top: 0, left: 0, bottom: -Margins.small.rawValue, right: -Margins.small.rawValue))
        bakerIcon.constrain([
            bakerIcon.topAnchor.constraint(equalTo: container.topAnchor, constant: Margins.large.rawValue),
            bakerIcon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margins.large.rawValue),
            bakerIcon.heightAnchor.constraint(equalToConstant: iconSize),
            bakerIcon.widthAnchor.constraint(equalToConstant: iconSize) ])
        bakerIconLoadingView.constrain([
            bakerIconLoadingView.topAnchor.constraint(equalTo: container.topAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margins.large.rawValue),
            bakerIconLoadingView.heightAnchor.constraint(equalToConstant: iconSize),
            bakerIconLoadingView.widthAnchor.constraint(equalToConstant: iconSize) ])
        iconLoadingSpinner.constrain([
            iconLoadingSpinner.centerXAnchor.constraint(equalTo: bakerIconLoadingView.centerXAnchor),
            iconLoadingSpinner.centerYAnchor.constraint(equalTo: bakerIconLoadingView.centerYAnchor)])
        bakerName.constrain([
            bakerName.topAnchor.constraint(equalTo: container.topAnchor, constant: Margins.large.rawValue),
            bakerName.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue) ])
        fee.constrain([
            fee.topAnchor.constraint(equalTo: bakerName.bottomAnchor),
            fee.leadingAnchor.constraint(equalTo: bakerIcon.trailingAnchor, constant: Margins.large.rawValue) ])
        roi.constrain([
            roi.topAnchor.constraint(equalTo: bakerName.topAnchor),
            roi.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Margins.large.rawValue) ])
        roiHeader.constrain([
            roiHeader.topAnchor.constraint(equalTo: roi.bottomAnchor),
            roiHeader.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Margins.large.rawValue) ])
        
        layoutIfNeeded()
    }

    private func setupStyle() {
        selectionStyle = .default
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        bakerIcon.image = nil
        bakerIconLoadingView.alpha = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
