// 
//  EnableKeychainView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-08-03.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

struct EnableKeychainView: View {
    
    @SwiftUI.State private var isKeychainToggleOn: Bool = false
    
    var completion: () -> Void
    
    var body: some View {
        VStack {
            TitleText(L10n.CloudBackup.enableTitle)
                .padding(.bottom, Margins.large.rawValue)
            VStack(alignment: .leading) {
                BodyText(L10n.CloudBackup.enableBody1, style: .primary)
                    .padding(.bottom, Margins.large.rawValue)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                ForEach(0..<steps.count, id: \.self) { i in
                    HStack(alignment: .top) {
                        BodyText("\(i + 1).", style: .primary)
                            .frame(width: 14.0)
                        BodyText(steps[i], style: .primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                    }
                }
                BodyText(L10n.CloudBackup.enableBody2, style: .primary)
                    .padding(.top, Margins.large.rawValue)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            .padding(.bottom, Margins.large.rawValue)
            Image("Keychain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 40)
            HStack {
                RadioButton(isOn: self.$isKeychainToggleOn)
                    .padding(.trailing, Margins.medium.rawValue)
                BodyText(L10n.CloudBackup.understandText, style: .primary)
            }.padding()
        }
        .padding([.leading, .trailing], Margins.huge.rawValue)
        .padding(.top, 40)
        Spacer()
        Button(action: self.completion, label: {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.common.rawValue)
                    .fill(Color(isKeychainToggleOn ? LightColors.primary : LightColors.Background.two))
                Text(L10n.CloudBackup.enableButton)
                    .font(Font(Fonts.Body.two))
                    .foregroundColor(Color(isKeychainToggleOn ? LightColors.Contrast.two : LightColors.Text.three))
            }
        })
        .frame(height: 60)
        .disabled(!self.isKeychainToggleOn)
        .padding([.leading, .trailing], Margins.large.rawValue)
        .padding(.bottom, Margins.huge.rawValue)
    }
}

struct EnableKeychainView_Previews: PreviewProvider {
    static var previews: some View {
        EnableKeychainView(completion: {})
    }
}

private let steps = [
    L10n.CloudBackup.step1,
    L10n.CloudBackup.step2,
    L10n.CloudBackup.step3,
    L10n.CloudBackup.step4
]
