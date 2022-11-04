// 
//  UIHelpers.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-08-11.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

class LightStatusBarHost<T>: UIHostingController<T> where T: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}

struct TitleText: View {
    
    private let text: String
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(Font(Fonts.Title.six))
            .foregroundColor(Color(LightColors.Text.three))
    }
}

enum BodyTextStyle {
    case primary
    case seconday
}

struct BodyText: View {
    
    private let text: String
    private let style: BodyTextStyle
    init(_ text: String, style: BodyTextStyle) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .font(Font(Fonts.Body.one))
            .foregroundColor(Color(LightColors.Text.two))
    }
}
