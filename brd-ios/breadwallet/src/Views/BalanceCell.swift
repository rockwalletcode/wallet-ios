//
//  BalanceCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-07-01.
//  Copyright © 2019 breadwallet LLC. All rights reserved.
//

import UIKit

class BalanceCell: UIView, Subscriber {
    private let currency: Currency
    
    private lazy var balanceLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var primaryBalance: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var secondaryBalance: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two))
        return view
    }()
    
    private var exchangeRate: Rate? {
        didSet {
            DispatchQueue.main.async {
                self.setBalances()
            }
        }
    }
    
    private var balance: Amount {
        didSet {
            DispatchQueue.main.async {
                self.setBalances()
            }
        }
    }
    
    init(currency: Currency) {
        self.currency = currency
        self.balance = Amount.zero(currency)
        self.exchangeRate = currency.state?.currentRate
        
        super.init(frame: .zero)
        
        addConstraints()
        setInitialData()
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        Store.lazySubscribe(self,
                            selector: { [weak self] oldState, newState in
            guard let self = self else { return false }
            return oldState[self.currency]?.currentRate != newState[self.currency]?.currentRate },
                            callback: { [weak self] in
            guard let self = self else { return }
            self.exchangeRate = $0[self.currency]?.currentRate
        })
        
        Store.subscribe(self,
                        selector: { [weak self] oldState, newState in
            guard let self = self else { return false }
            return oldState[self.currency]?.balance != newState[self.currency]?.balance },
                        callback: { [weak self] state in
            guard let self = self else { return }
            if let balance = state[self.currency]?.balance {
                self.balance = balance
            } })
    }
    
    private func addConstraints() {
        addSubview(balanceLabel)
        addSubview(primaryBalance)
        addSubview(secondaryBalance)
        
        snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.defaultCommon.rawValue)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        primaryBalance.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        secondaryBalance.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(Margins.large.rawValue)
        }
    }
    
    private func setInitialData() {
        balanceLabel.text = L10n.Account.balance
    }
    
    private func setBalances() {
        let amount = Amount(amount: balance, rate: exchangeRate)
        
        let tokenValue = amount.tokenDescription
        let fiatValue = amount.fiatDescription
        
        primaryBalance.setup(with: .text(tokenValue))
        secondaryBalance.setup(with: .text(fiatValue))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
