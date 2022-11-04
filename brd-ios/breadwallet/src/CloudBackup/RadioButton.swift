// 
//  RadioButton.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-08-11.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

struct RadioButton: View {
    @SwiftUI.Binding var isOn: Bool
    
    private var color: Color {
        guard isOn else {
            return Color(LightColors.secondary)
        }
        return Color(LightColors.primary)
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.isOn.toggle()
            }
        }, label: {
            ZStack {
                SwiftUI.Circle()
                    .strokeBorder(self.color, lineWidth: 3)
                if isOn {
                    SwiftUI.Circle()
                        .fill(self.color)
                        .padding(5)
                        .transition(.scale)
                }
            }
        })
        .frame(width: ViewSizes.extraSmall.rawValue, height: ViewSizes.extraSmall.rawValue)
    }
}
