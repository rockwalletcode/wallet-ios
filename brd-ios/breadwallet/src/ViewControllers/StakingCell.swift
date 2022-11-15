// 
//  StakingCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-10-17.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class StakingCell: UIView, Subscriber {
    
    private let iconContainer = UIView(color: .transparentIconBackground)
    private let icon = UIImageView()
    private let currency: Currency
    private let title = UILabel(font: .customBody(size: 14), color: LightColors.Text.one)
    private var indicatorView = UIImageView()
    private let topPadding = UIView(color: LightColors.Background.one)
    private let bottomPadding = UIView(color: LightColors.Background.one)
    private let statusFlag = UILabel(font: .customBody(size: 11))
    private var wallet: Wallet?
    
    init(currency: Currency, wallet: Wallet?) {
        self.currency = currency
        self.wallet = wallet
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        addSubview(topPadding)
        addSubview(bottomPadding)
        addSubview(iconContainer)
        iconContainer.addSubview(icon)
        addSubview(title)
        addSubview(indicatorView)
        addSubview(statusFlag)
    }
    
    private func setupConstraints() {
        let containerPadding = Margins.large.rawValue
        topPadding.constrainTopCorners(height: containerPadding)
        bottomPadding.constrainBottomCorners(height: containerPadding)
        iconContainer.constrain([
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: containerPadding),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor)])
        icon.constrain(toSuperviewEdges: .zero)
        title.constrain([
            title.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Margins.small.rawValue),
            title.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        statusFlag.constrain([
            statusFlag.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            statusFlag.trailingAnchor.constraint(equalTo: indicatorView.leadingAnchor, constant: -Margins.large.rawValue),
            statusFlag.heightAnchor.constraint(equalToConstant: 20) ])
        indicatorView.constrain([
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21)])
    }
    
    private func setInitialData() {
        icon.image = currency.imageNoBackground
        icon.tintColor = .white
        iconContainer.layer.cornerRadius = CornerRadius.common.rawValue
        iconContainer.backgroundColor = currency.colors.0
        title.text = L10n.Staking.stakingTitle
        statusFlag.layer.cornerRadius = CornerRadius.common.rawValue
        statusFlag.clipsToBounds = true
        indicatorView.image = UIImage(named: "RightArrow")
        
        updateStakingStatus()
        
        wallet?.subscribe(self) { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .transferChanged, .transferSubmitted:
                    self?.updateStakingStatus()
                default:
                    break
                }
            }
        }
    }
    
    private func updateStakingStatus() {
        if currency.wallet?.hasPendingTxn == true {
            statusFlag.text = "  \(L10n.Staking.stakingPendingFlag)  "
            statusFlag.backgroundColor = LightColors.Pending.two
            statusFlag.textColor = LightColors.Pending.one
        } else if currency.wallet?.stakedValidatorAddress != nil {
            statusFlag.text = "  \(L10n.Staking.stakingActiveFlag)  "
            statusFlag.backgroundColor = LightColors.Success.two
            statusFlag.textColor = LightColors.Success.one
        } else {
            statusFlag.text = "  \(L10n.Staking.stakingInactiveFlag)  "
            statusFlag.backgroundColor = LightColors.Pending.two
            statusFlag.textColor = LightColors.Pending.one
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
