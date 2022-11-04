//
//  HomeScreenCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-11-28.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

protocol HighlightableCell {
    func highlight()
    func unhighlight()
}

enum HomeScreenCellIds: String {
    case regularCell = "CurrencyCell"
    case highlightableCell  = "HighlightableCurrencyCell"
}

class Background: UIView, GradientDrawable {
    var currency: Currency?

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        let corners: UIRectCorner = .allCorners
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: CornerRadius.common.rawValue,
                                                          height: CornerRadius.common.rawValue)).cgPath
        layer.mask = maskLayer
    }
}

class HomeScreenCell: UITableViewCell, Subscriber {
    private lazy var iconImageView: WrapperView<FEImageView> = {
        let view = WrapperView<FEImageView>()
        view.setupClearMargins()
        return view
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CornerRadius.common.rawValue
        view.layer.borderColor = UIColor.shadowColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.shadowRadius = view.layer.cornerRadius
        view.layer.shadowColor = view.layer.borderColor
        view.layer.shadowOpacity = 2
        view.layer.shadowOffset = .zero
        view.backgroundColor = .whiteBackground
        return view
    }()
    
    private let currencyName = UILabel(font: Fonts.Subtitle.one, color: LightColors.Text.three)
    private let price = UILabel(font: Fonts.Subtitle.two, color: LightColors.Text.two)
    private let fiatBalance = UILabel(font: Fonts.Subtitle.two, color: LightColors.Text.two)
    private let tokenBalance = UILabel(font: Fonts.Subtitle.one, color: LightColors.Text.three)
    private let syncIndicator = SyncingIndicator(style: .home)
    private let priceChangeView = PriceChangeView(style: .percentOnly)
    
    let container = Background()
        
    private var isSyncIndicatorVisible: Bool = false {
        didSet {
            UIView.crossfade(tokenBalance, syncIndicator, toRight: isSyncIndicatorVisible, duration: isSyncIndicatorVisible == oldValue ? 0.0 : 0.3)
            fiatBalance.textColor = (isSyncIndicatorVisible || !(container.currency?.isSupported ?? false)) ? .transparentBlack : .black
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    static func cellIdentifier() -> String {
        return "CurrencyCell"
    }
    
    func set(viewModel: HomeScreenAssetViewModel) {
        accessibilityIdentifier = viewModel.currency.name
        container.currency = viewModel.currency
        iconImageView.wrappedView.setup(with: .image(viewModel.currency.imageSquareBackground))
        iconImageView.configure(background: BackgroundConfiguration(tintColor: viewModel.currency.isSupported ? .white : .disabledBackground,
                                                                    border: .init(borderWidth: 0,
                                                                                  cornerRadius: .fullRadius)))
        currencyName.text = viewModel.currency.name
        currencyName.textColor = viewModel.currency.isSupported ? .black : .transparentBlack
        price.text = viewModel.exchangeRate
        fiatBalance.text = viewModel.fiatBalance
        fiatBalance.textColor = viewModel.currency.isSupported ? .black : .transparentBlack
        tokenBalance.text = viewModel.tokenBalance
        priceChangeView.isHidden = false
        priceChangeView.currency = viewModel.currency
        container.setNeedsDisplay()
        Store.subscribe(self, selector: { $0[viewModel.currency]?.syncState != $1[viewModel.currency]?.syncState },
                        callback: { state in
                            guard !(viewModel.currency.isHBAR && Store.state.requiresCreation(viewModel.currency)),
                               let syncState = state[viewModel.currency]?.syncState else {
                                self.isSyncIndicatorVisible = false
                                return
                            }
            
                            self.syncIndicator.syncState = syncState
                            switch syncState {
                            case .connecting, .failed, .syncing:
                                self.isSyncIndicatorVisible = false
                            case .success:
                                self.isSyncIndicatorVisible = false
                            }
        })
        
        Store.subscribe(self, selector: { $0[viewModel.currency]?.syncProgress != $1[viewModel.currency]?.syncProgress },
                        callback: { state in
            guard let progress = state[viewModel.currency]?.syncProgress else {
                return
            }
            self.syncIndicator.progress = progress
        })
    }
    
    func setupViews() {
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        backgroundColor = .homeBackground
        selectionStyle = .none
        
        contentView.addSubview(container)
        container.addSubview(cardView)
        cardView.addSubview(iconImageView)
        cardView.addSubview(currencyName)
        cardView.addSubview(price)
        cardView.addSubview(fiatBalance)
        cardView.addSubview(tokenBalance)
        cardView.addSubview(syncIndicator)
        cardView.addSubview(priceChangeView)
    }

    private func addConstraints() {
        let containerPadding = Margins.large.rawValue
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        cardView.constrain([
            cardView.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            cardView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            cardView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: containerPadding),
            cardView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -containerPadding)])
        iconImageView.constrain([
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: containerPadding),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: ViewSizes.large.rawValue),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)])
        currencyName.constrain([
            currencyName.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: containerPadding),
            currencyName.bottomAnchor.constraint(equalTo: iconImageView.centerYAnchor)])
        price.constrain([
            price.leadingAnchor.constraint(equalTo: currencyName.leadingAnchor),
            price.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Margins.special.rawValue)])
        priceChangeView.constrain([
            priceChangeView.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: Margins.small.rawValue),
            priceChangeView.centerYAnchor.constraint(equalTo: price.centerYAnchor)])
        fiatBalance.constrain([
            fiatBalance.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -containerPadding),
            fiatBalance.leadingAnchor.constraint(greaterThanOrEqualTo: priceChangeView.trailingAnchor, constant: containerPadding),
            fiatBalance.bottomAnchor.constraint(equalTo: price.bottomAnchor)])
        tokenBalance.constrain([
            tokenBalance.trailingAnchor.constraint(equalTo: fiatBalance.trailingAnchor),
            tokenBalance.leadingAnchor.constraint(greaterThanOrEqualTo: currencyName.trailingAnchor, constant: containerPadding),
            tokenBalance.topAnchor.constraint(equalTo: currencyName.topAnchor)])
        tokenBalance.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        fiatBalance.setContentCompressionResistancePriority(.required, for: .vertical)
        fiatBalance.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        syncIndicator.constrain([
            syncIndicator.trailingAnchor.constraint(equalTo: fiatBalance.trailingAnchor),
            syncIndicator.leadingAnchor.constraint(greaterThanOrEqualTo: priceChangeView.trailingAnchor, constant: containerPadding),
            syncIndicator.bottomAnchor.constraint(equalTo: tokenBalance.bottomAnchor)])
        syncIndicator.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        Store.unsubscribe(self)
    }
    
    deinit {
        Store.unsubscribe(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
