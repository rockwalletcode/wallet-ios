//
//  AccountHeaderView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import SwiftUI

class AccountHeaderView: UIView, GradientDrawable, Subscriber {
    // MARK: - Views
    
    private lazy var intrinsicSizeView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Background.cards
        return view
    }()
    
    private lazy var extendedTouchArea: ExtendedTouchArea = {
        let view = ExtendedTouchArea()
        return view
    }()
    
    private lazy var currencyName: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.one, textAlignment: .center))
        return view
    }()
    
    private lazy var currencyIconImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        return view
    }()
    
    private lazy var exchangeRateLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Title.five, textColor: LightColors.Text.one, textAlignment: .center))
        return view
    }()
    
    private lazy var graphButtonStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.alignment = .fill
        view.layoutMargins = UIEdgeInsets(top: Margins.minimum.rawValue,
                                          left: Margins.medium.rawValue,
                                          bottom: Margins.minimum.rawValue,
                                          right: Margins.medium.rawValue)
        view.isLayoutMarginsRelativeArrangement = true
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let chartView: ChartView
    private let priceChangeView = PriceChangeView(style: .percentAndAbsolute)
    private let priceDateLabel = UILabel(font: .customBody(size: 14.0))
    private let balanceCell: BalanceCell
    private var graphButtons: [HistoryPeriodButton] = HistoryPeriod.allCases.map { HistoryPeriodButton(historyPeriod: $0) }
    
    private let priceInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Margins.large.rawValue
        return stackView
    }()
    
    private let historyPeriodPill: UIView = {
        let view = UIView(color: UIColor.white.withAlphaComponent(0.6))
        view.layer.cornerRadius = CornerRadius.extraSmall.rawValue
        view.layer.masksToBounds = true
        view.alpha = 0.3
        return view
    }()
    
    private var marketDataView: UIView?
    private var delistedTokenView: DelistedTokenView?
    
    // MARK: Constraints
    
    private var headerHeight: NSLayoutConstraint?
    private var historyPeriodPillX: NSLayoutConstraint?
    private var historyPeriodPillY: NSLayoutConstraint?
    
    // MARK: Properties
    
    private static let marketDataHeight: CGFloat = 130
    private let currency: Currency
    private var isChartHidden = false
    private var shouldLockExpandingChart = false
    private var isScrubbing = false
    var setHostContentOffset: ((CGFloat) -> Void)?
    static let headerViewMinHeight: CGFloat = 160.0
    static var headerViewMaxHeight: CGFloat {
        return Self.shouldShowMarketData ? 375.0 + AccountHeaderView.marketDataHeight : 375.0
    }
    
    static var shouldShowMarketData: Bool {
        return true
    }
    
    // MARK: Init
    
    init(currency: Currency) {
        self.currency = currency
        self.balanceCell = BalanceCell(currency: currency)
        self.chartView = ChartView(currency: currency)
        if currency.isSupported == false {
            self.delistedTokenView = DelistedTokenView(currency: currency)
        }
        super.init(frame: CGRect())
        setup()
    }
    
    func setExtendedTouchDelegate(_ view: UIView) {
        self.extendedTouchArea.delegateView = view
    }
    
    // MARK: Setup
    
    private func setup() {
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        addSubview(intrinsicSizeView)
        addSubview(chartView)
        addSubview(currencyName)
        addSubview(currencyIconImageView)
        
        addSubview(priceInfoStackView)
        priceInfoStackView.addSubview(historyPeriodPill)
        priceInfoStackView.addArrangedSubview(exchangeRateLabel)
        priceInfoStackView.addArrangedSubview(priceChangeView)
        priceInfoStackView.addArrangedSubview(priceDateLabel)
        addSubview(graphButtonStackView)
        
        if let id = currency.coinGeckoId {
            let hosting = UIHostingController(rootView: MarketDataView(currencyId: id))
            marketDataView = hosting.view
            hosting.view.backgroundColor = .clear
            addSubview(hosting.view)
        }
        
        addSubview(balanceCell)
        if let delistedTokenView = delistedTokenView {
            addSubview(delistedTokenView)
        }
        
        graphButtons.forEach { button in
            button.button.layer.cornerRadius = CornerRadius.extraSmall.rawValue
            button.button.layer.masksToBounds = true
            graphButtonStackView.addArrangedSubview(button.button)
            
        }
        addSubview(extendedTouchArea)
    }
    
    private func addConstraints() {
        headerHeight = intrinsicSizeView.heightAnchor.constraint(equalToConstant: AccountHeaderView.headerViewMaxHeight)
        intrinsicSizeView.constrain(toSuperviewEdges: nil)
        intrinsicSizeView.constrain([headerHeight])
        currencyName.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(RootNavigationController().navigationBar.frame.height)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(-RootNavigationController().navigationBar.frame.height)
        }
        currencyIconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(currencyName.snp.centerX)
            make.height.width.equalTo(ViewSizes.medium.rawValue)
            make.top.equalTo(currencyName.snp.bottom)
        }
        priceInfoStackView.constrain([
            priceInfoStackView.centerXAnchor.constraint(equalTo: currencyIconImageView.centerXAnchor),
            priceInfoStackView.topAnchor.constraint(equalTo: currencyIconImageView.bottomAnchor)])
        chartView.constrain([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: ViewSizes.extraExtraHuge.rawValue),
            chartView.bottomAnchor.constraint(equalTo: graphButtonStackView.topAnchor)])
        
        if let delistedTokenView = delistedTokenView {
            delistedTokenView.constrain([
                delistedTokenView.topAnchor.constraint(equalTo: priceInfoStackView.topAnchor),
                delistedTokenView.bottomAnchor.constraint(equalTo: balanceCell.topAnchor, constant: -Margins.small.rawValue),
                delistedTokenView.widthAnchor.constraint(equalTo: widthAnchor),
                delistedTokenView.leadingAnchor.constraint(equalTo: leadingAnchor)])
        }
        
        let graphBottom = marketDataView == nil ? balanceCell.topAnchor : marketDataView!.topAnchor
        
        graphButtonStackView.constrain([
            graphButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
            graphButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue),
            graphButtonStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            graphButtonStackView.bottomAnchor.constraint(equalTo: graphBottom),
            graphButtonStackView.heightAnchor.constraint(equalToConstant: ViewSizes.medium.rawValue)])
        
        if let marketView = marketDataView {
            marketView.constrain([
                marketView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.large.rawValue),
                marketView.bottomAnchor.constraint(equalTo: balanceCell.topAnchor),
                marketView.heightAnchor.constraint(equalToConstant: AccountHeaderView.marketDataHeight),
                marketView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.large.rawValue) ])
        }
        
        balanceCell.constrain([
            balanceCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            balanceCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            balanceCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            balanceCell.heightAnchor.constraint(equalToConstant: 64.0)])
        
        historyPeriodPillX = historyPeriodPill.centerXAnchor.constraint(equalTo: graphButtons[4].button.centerXAnchor)
        historyPeriodPillY = historyPeriodPill.centerYAnchor.constraint(equalTo: graphButtons[4].button.centerYAnchor)
        
        historyPeriodPill.constrain([
            historyPeriodPillX,
            historyPeriodPillY,
            historyPeriodPill.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            historyPeriodPill.heightAnchor.constraint(equalToConstant: 28.0)])
        
        extendedTouchArea.constrain([
            extendedTouchArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            extendedTouchArea.bottomAnchor.constraint(equalTo: balanceCell.bottomAnchor),
            extendedTouchArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            extendedTouchArea.topAnchor.constraint(equalTo: graphButtonStackView.bottomAnchor)
        ])
    }

    private func setInitialData() {
        currencyName.setup(with: .text(currency.name))
        currencyIconImageView.wrappedView.setup(with: .image(currency.imageSquareBackground))
        
        priceChangeView.currency = currency
        priceDateLabel.font = Fonts.Subtitle.two
        priceDateLabel.textColor = LightColors.Text.one
        priceDateLabel.textAlignment = .center
        priceDateLabel.alpha = 0.0
        
        graphButtons.forEach {
            $0.callback = { [unowned self] button, period in
                self.chartView.historyPeriod = period
                self.didTap(button: button)
            }
        }
        
        if let initiallySelected = graphButtons.first(where: { return $0.hasInitialHistoryPeriod }) {
            self.updateHistoryPeriodPillPosition(button: initiallySelected.button, withAnimation: false)
        }
                
        Store.subscribe(self,
                        selector: { [weak self] oldState, newState in
                            guard let self = self else { return false }
                            return oldState[self.currency]?.currentRate != newState[self.currency]?.currentRate },
                        callback: { [weak self] in
                            guard let self = self, let rate = $0[self.currency]?.currentRate, !self.isScrubbing else { return }
                            self.exchangeRateLabel.text = rate.localString(forCurrency: self.currency)
        })
        setGraphViewScrubbingCallbacks()
        chartView.shouldHideChart = { [weak self] in
            guard let self = self else { return }
            self.shouldLockExpandingChart = true
            self.collapseHeader()
        }
        if currency.state?.currentRate == nil {
            self.collapseHeader(animated: false)
        }
    }
    
    private func setGraphViewScrubbingCallbacks() {
        chartView.scrubberDidUpdateToValues = { [unowned self] in
            //We can receive a scrubberDidUpdateToValues call after scrubberDidEnd
            //so we need to guard against updating the scrubber labels
            guard self.isScrubbing else { return }
            self.exchangeRateLabel.text = $0
            self.priceDateLabel.text = $1
        }
        chartView.scrubberDidEnd = { [unowned self] in
            self.isScrubbing = false
            UIView.animate(withDuration: Presets.Animation.duration, animations: {
                self.priceChangeView.alpha = 1.0
                self.priceChangeView.isHidden = false
                self.priceDateLabel.alpha = 0.0
            })
            self.exchangeRateLabel.text = Store.state[self.currency]?.currentRate?.localString(forCurrency: self.currency)
        }
        
        chartView.scrubberDidBegin = { [unowned self] in
            self.isScrubbing = true
            UIView.animate(withDuration: Presets.Animation.duration, animations: {
                self.priceChangeView.alpha = 0.0
                self.priceChangeView.isHidden = true
                self.priceDateLabel.alpha = 1.0
            })
        }
    }
    
    // MARK: Stretchy Header
    
    private func showChart() {
        isChartHidden = false
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.chartView.alpha = 1.0
            self.exchangeRateLabel.alpha = 1.0
            self.priceChangeView.alpha = 1.0
            self.graphButtonStackView.alpha = 1.0
            self.historyPeriodPill.alpha = 0.3
            self.marketDataView?.alpha = 1.0
        })
    }
    
    private func hideChart(animated: Bool = true) {
        isChartHidden = true
        if animated {
            UIView.animate(withDuration: Presets.Animation.duration, animations: {
                self.setChartTransparent()
            })
        } else {
            setChartTransparent()
        }
    }
    
    private func setChartTransparent() {
        chartView.alpha = 0.0
        exchangeRateLabel.alpha = 0.0
        priceChangeView.alpha = 0.0
        graphButtonStackView.alpha = 0.0
        historyPeriodPill.alpha = 0.0
        marketDataView?.alpha = 0.0
    }
    
    func setOffset(_ offset: CGFloat) {
        guard delistedTokenView == nil, !shouldLockExpandingChart else { return } //Disable expanding/collapsing header when delistedTokenView is shown
        guard headerHeight?.isActive == true else { return }
        guard let headerHeight = headerHeight else { return }
        let newHeaderViewHeight: CGFloat = headerHeight.constant - offset
        
        if newHeaderViewHeight > AccountHeaderView.headerViewMaxHeight {
            headerHeight.constant = AccountHeaderView.headerViewMaxHeight
        } else if newHeaderViewHeight < AccountHeaderView.headerViewMinHeight {
            headerHeight.constant = AccountHeaderView.headerViewMinHeight
        } else {
            headerHeight.constant = newHeaderViewHeight
            setHostContentOffset?(0)
            if !isChartHidden && newHeaderViewHeight < 300.0 {
                hideChart()
            } else if isChartHidden && newHeaderViewHeight > 305.0 {
                showChart()
            }
        }
    }
    
    func didStopScrolling() {
        guard delistedTokenView == nil, !shouldLockExpandingChart else { return } //Disable expanding/collapsing header when delistedTokenView is shown
        guard headerHeight?.isActive == true else { return }
        guard let currentHeight = headerHeight?.constant else { return }
        let range = AccountHeaderView.headerViewMaxHeight - AccountHeaderView.headerViewMinHeight
        let mid = AccountHeaderView.headerViewMinHeight + (range/2.0)
        if currentHeight > mid {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    private func expandHeader() {
        headerHeight?.constant = AccountHeaderView.headerViewMaxHeight
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.superview?.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.showChart()
        })
    }
    
    //Needs to be public so that it can be hidden
    //when the rewards view is expanded on the iPhone5
    func collapseHeader(animated: Bool = true) {
        headerHeight?.constant = AccountHeaderView.headerViewMinHeight
        if animated {
           UIView.animate(withDuration: Presets.Animation.duration, animations: {
               self.superview?.superview?.layoutIfNeeded()
           }, completion: { _ in
               self.hideChart()
           })
        } else {
            self.hideChart(animated: false)
        }
    }
    
    func stopHeightConstraint() {
        headerHeight?.isActive = false
    }
    
    func resumeHeightConstraint() {
        headerHeight?.isActive = true
    }
    
    private func updateHistoryPeriodPillPosition(button: UIButton, withAnimation: Bool) {
        historyPeriodPillX?.isActive = false
        historyPeriodPillY?.isActive = false
        historyPeriodPillX = historyPeriodPill.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        historyPeriodPillY = historyPeriodPill.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        NSLayoutConstraint.activate([historyPeriodPillX!, historyPeriodPillY!])
        
        if withAnimation {
            UIView.spring(Presets.Animation.duration, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in})
        }
        
        button.backgroundColor = LightColors.Background.three
        graphButtons.forEach {
            if $0.button != button {
                $0.button.backgroundColor = .clear
            }
        }
    }
    
    private func didTap(button: UIButton) {
        updateHistoryPeriodPillPosition(button: button, withAnimation: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currencyIconImageView.wrappedView.configure(background: .init(border: BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
