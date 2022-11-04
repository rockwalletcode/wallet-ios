// 
//  MarketDataView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-09-09.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

struct MarketDataView: View {
    private let fillColor = Color(LightColors.Background.two)
    private let textColor = Color(LightColors.Text.one)
    private let subTextColor = Color(LightColors.Text.two)
    
    @ObservedObject var marketData: MarketDataPublisher
    
    init(currencyId: String) {
        let fiatId = Store.state.defaultCurrencyCode.lowercased()
        marketData = MarketDataPublisher(currencyId: currencyId, fiatId: fiatId)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: Margins.small.rawValue) {
                text(marketData.viewModel.marketCap)
                subText(L10n.MarketData.marketCap)
                text(marketData.viewModel.totalVolume)
                subText(L10n.MarketData.volume)
            }.padding(8.0)
            .frame(minWidth: 0, maxWidth: .infinity)
            Rectangle()
                .fill(textColor)
                .frame(width: 1.0)
                .cornerRadius(0.5)
                .padding([.top, .bottom], Margins.large.rawValue)
            VStack(alignment: .center, spacing: Margins.small.rawValue) {
                text(marketData.viewModel.high24h)
                subText(L10n.MarketData.high24h)
                text(marketData.viewModel.low24h)
                subText(L10n.MarketData.low24h)
            }.padding(8.0)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(fillColor)
        .cornerRadius(CornerRadius.extraSmall.rawValue)
        .onAppear(perform: {
            self.marketData.fetch()
        })
    }
    
    func text(_ text: String) -> some View {
        Text(text)
            .font(Font(Fonts.Body.one))
            .foregroundColor(textColor)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
    }
    
    func subText(_ text: String) -> Text {
        Text(text)
            .font(Font(Fonts.Subtitle.one))
            .foregroundColor(subTextColor)
    }
    
}

struct MarketDataView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
            MarketDataView(currencyId: "bitcoin")
        }
    }
}
