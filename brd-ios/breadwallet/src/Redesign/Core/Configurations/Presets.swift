// 
//  Presets.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

// TODO: Unify with designs and use color / font enums
struct Presets {
    struct Background {
        struct Primary {
            static var normal = BackgroundConfiguration(backgroundColor: LightColors.primary,
                                                        tintColor: LightColors.Contrast.two,
                                                        border: Presets.Border.normalButtonFullRadius)
            
            static var selected = BackgroundConfiguration(backgroundColor: LightColors.secondary,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.selectedButtonFullRadius)
            
            static var disabled = BackgroundConfiguration(backgroundColor: LightColors.Disabled.one,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.disabledButtonFullRadius)
            
            static var selectedPickerTextField = BackgroundConfiguration(backgroundColor: LightColors.Background.one,
                                                                   tintColor: LightColors.Contrast.two,
                                                                   border: Border.pickerTextField)
            
            static var error = BackgroundConfiguration(backgroundColor: LightColors.primary,
                                                       tintColor: .red,
                                                       border: Presets.Border.error)
            
            static var tertiary = BackgroundConfiguration(backgroundColor: LightColors.Background.three,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.normalButtonFullRadius)
        }
        
        struct Secondary {
            static var normal = BackgroundConfiguration(tintColor: LightColors.primary)
            static var selected = BackgroundConfiguration(tintColor: LightColors.Text.one)
            static var disabled = BackgroundConfiguration(tintColor: LightColors.Disabled.two)
            static var error = BackgroundConfiguration(tintColor: .red)
        }
        
        struct TextField {
            static var normal = BackgroundConfiguration(backgroundColor: LightColors.Background.one, tintColor: LightColors.primary,
                                                        border: .init(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall))
            static var selected = BackgroundConfiguration(backgroundColor: LightColors.Background.one, tintColor: LightColors.Text.one,
                                                          border: .init(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall))
            static var disabled = BackgroundConfiguration(backgroundColor: LightColors.Background.one, tintColor: LightColors.Disabled.two,
                                                          border: .init(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall))
            static var error = BackgroundConfiguration(backgroundColor: LightColors.Background.one, tintColor: LightColors.Error.one,
                                                       border: .init(tintColor: LightColors.Error.one, borderWidth: 1, cornerRadius: .extraSmall))
        }
        
        static var transparent = BackgroundConfiguration(backgroundColor: .clear,
                                                         tintColor: LightColors.primary)
    }
    
    struct Border {
        static var zero = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var extraSmallPlain = BorderConfiguration(borderWidth: 0, cornerRadius: .extraSmall)
        static var commonPlain = BorderConfiguration(borderWidth: 0, cornerRadius: .common)
        static var error = BorderConfiguration(tintColor: LightColors.Error.one, borderWidth: 1, cornerRadius: .medium)
        static var accountVerification = BorderConfiguration(tintColor: LightColors.Outline.one, borderWidth: 1, cornerRadius: .small)
        static var secondaryButton = BorderConfiguration(tintColor: LightColors.primary, borderWidth: 1, cornerRadius: .fullRadius)
        
        static var normal = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var selected = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var disabled = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        
        static var normalButtonMediumRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var selectedButtonMediumRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var disabledButtonMediumRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        
        static var normalButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        static var selectedButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        static var disabledButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        
        static var normalTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
        static var selectedTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
        static var disabledTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
        
        static var pickerTextField = BorderConfiguration(tintColor: LightColors.primary, borderWidth: 1, cornerRadius: .small)
    }
    
    struct Shadow {
        static var zero = ShadowConfiguration(color: .clear,
                                              opacity: .zero,
                                              offset: .zero,
                                              shadowRadius: .small)
        
        static var normal = ShadowConfiguration(color: LightColors.Contrast.one,
                                                opacity: .low,
                                                offset: .init(width: 4, height: 10),
                                                shadowRadius: .small)
        
        static var light = ShadowConfiguration(color: LightColors.Contrast.one,
                                               opacity: .lowest,
                                               offset: .init(width: 0, height: 8),
                                               shadowRadius: .small)
    }
    
    struct Image {
        static var primary = BackgroundConfiguration(tintColor: LightColors.Text.one)
        static var secondary = BackgroundConfiguration(tintColor: LightColors.Text.two)
        static var tertiary = BackgroundConfiguration(tintColor: LightColors.Contrast.two)
    }
}

extension Presets {
    struct Button {
        static var primary = ButtonConfiguration(normalConfiguration: Presets.Background.Primary.normal,
                                                 selectedConfiguration: Presets.Background.Primary.selected,
                                                 disabledConfiguration: Presets.Background.Primary.disabled)
        
        static var secondary = ButtonConfiguration(normalConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.secondaryButton),
                                                   selectedConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalButtonFullRadius),
                                                   disabledConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledButtonFullRadius))
        
        static var noBorders = ButtonConfiguration(normalConfiguration: BackgroundConfiguration(tintColor: LightColors.secondary),
                                                   selectedConfiguration: Presets.Background.Secondary.selected,
                                                   disabledConfiguration: Presets.Background.Secondary.disabled,
                                                   buttonContentEdgeInsets: .zero)
        
        static var blackIcon = ButtonConfiguration(normalConfiguration: .init(tintColor: LightColors.Text.three),
                                                   selectedConfiguration: .init(tintColor: LightColors.Text.one),
                                                   disabledConfiguration: .init(tintColor: LightColors.Disabled.one))
    }
}

extension Presets {
    struct TextField {
        static var primary = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                    titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                    textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                    backgroundConfiguration: Presets.Background.TextField.normal,
                                                    selectedBackgroundConfiguration: Presets.Background.TextField.selected,
                                                    disabledBackgroundConfiguration: Presets.Background.TextField.disabled,
                                                    errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error))
        
        static var two = TextFieldConfiguration(titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                trailingImageConfiguration: .init(tintColor: LightColors.Text.two),
                                                backgroundConfiguration: Presets.Background.TextField.normal,
                                                selectedBackgroundConfiguration: Presets.Background.TextField.selected,
                                                disabledBackgroundConfiguration: Presets.Background.TextField.disabled,
                                                errorBackgroundConfiguration: Presets.Background.TextField.error)
        
        static var email = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                  titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                  textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                  backgroundConfiguration: Presets.Background.TextField.normal,
                                                  selectedBackgroundConfiguration: Presets.Background.TextField.selected,
                                                  disabledBackgroundConfiguration: Presets.Background.TextField.disabled,
                                                  errorBackgroundConfiguration: Presets.Background.TextField.error,
                                                  autocapitalizationType: UITextAutocapitalizationType.none,
                                                  autocorrectionType: .no,
                                                  keyboardType: .emailAddress)
        
        static var number = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                   titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                   textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                   backgroundConfiguration: Presets.Background.TextField.normal,
                                                   selectedBackgroundConfiguration: Presets.Background.TextField.selected,
                                                   disabledBackgroundConfiguration: Presets.Background.TextField.disabled,
                                                   errorBackgroundConfiguration: Presets.Background.TextField.error,
                                                   keyboardType: .numberPad)
    }
}

extension Presets {
    struct InfoView {
        static var verification = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                        headerTitle: .init(font: Fonts.Subtitle.three, textColor: LightColors.Contrast.one),
                                                        headerTrailing: .init(normalConfiguration: .init(tintColor: LightColors.Text.three),
                                                                              selectedConfiguration: .init(tintColor: LightColors.Text.two),
                                                                              disabledConfiguration: .init(tintColor: LightColors.Disabled.two)),
                                                        title: .init(font: Fonts.Subtitle.three, textColor: LightColors.Text.one),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                        button: Presets.Button.primary.withBorder(normal: Presets.Border.normal,
                                                                                                  selected: Presets.Border.selectedButtonMediumRadius,
                                                                                                  disabled: Presets.Border.disabledButtonMediumRadius),
                                                        background: .init(backgroundColor: LightColors.Background.three,
                                                                          border: Presets.Border.commonPlain),
                                                        shadow: Presets.Shadow.zero)
        
        static var warning = InfoViewConfiguration(headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Text.three),
                                                   description: .init(font: Fonts.Body.two, textColor: LightColors.Text.three),
                                                   background: .init(backgroundColor: LightColors.Background.three,
                                                                     tintColor: LightColors.Contrast.two,
                                                                     border: Presets.Border.zero),
                                                   shadow: Presets.Shadow.zero)
        
        static var error = InfoViewConfiguration(headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                 description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                 background: .init(backgroundColor: LightColors.Error.one,
                                                                   tintColor: LightColors.Contrast.two,
                                                                   border: Presets.Border.zero),
                                                 shadow: Presets.Shadow.zero)
    }
}

extension Presets {
    struct Popup {
        static var normal = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                 tintColor: LightColors.Contrast.two,
                                                                 border: Presets.Border.zero),
                                               title: .init(font: Fonts.Title.six, textColor: LightColors.Text.three, textAlignment: .center),
                                               body: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .center),
                                               
                                               buttons: [Presets.Button.primary.withBorder(normal: Presets.Border.normalButtonFullRadius,
                                                                                           selected: Presets.Border.selectedButtonFullRadius,
                                                                                           disabled: Presets.Border.disabledButtonFullRadius),
                                                         Presets.Button.secondary],
                                               closeButton: Presets.Button.blackIcon)
        
        static var white = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                tintColor: LightColors.Contrast.two,
                                                                border: Presets.Border.zero),
                                              title: .init(font: Fonts.Title.five, textColor: LightColors.Text.three),
                                              body: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .left),
                                              buttons: [Presets.Button.primary.withBorder(normal: Presets.Border.normalButtonFullRadius,
                                                                                          selected: Presets.Border.selectedButtonFullRadius,
                                                                                          disabled: Presets.Border.disabledButtonFullRadius),
                                                        Presets.Button.secondary],
                                              closeButton: Presets.Button.blackIcon)
    }
}

extension Presets {
    struct Animation {
        static var duration = 0.25
    }
}

extension Presets {
    struct VerificationView {
        static var resubmitAndDeclined = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                                   background: .init(backgroundColor: LightColors.Background.one,
                                                                                     tintColor: LightColors.Outline.two,
                                                                                     border: Presets.Border.zero),
                                                                   title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                                   status: .init(title: .init(font: Fonts.Body.two,
                                                                                              textColor: LightColors.Contrast.two,
                                                                                              textAlignment: .center),
                                                                                 background: .init(backgroundColor: LightColors.Error.one,
                                                                                                   tintColor: LightColors.Contrast.two,
                                                                                                   border: Presets.Border.extraSmallPlain)),
                                                                   infoButton: .init(normalConfiguration: Presets.Background.Secondary.normal,
                                                                                     selectedConfiguration: Presets.Background.Secondary.selected,
                                                                                     disabledConfiguration: Presets.Background.Secondary.disabled),
                                                                   description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                                   benefits: .init(font: Fonts.Body.two, textColor: LightColors.Text.three, textAlignment: .center))
        
        static var pending = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                       background: .init(backgroundColor: LightColors.Background.one,
                                                                         tintColor: LightColors.Outline.two,
                                                                         border: Presets.Border.zero),
                                                       title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                       status: .init(title: .init(font: Fonts.Body.two,
                                                                                  textColor: LightColors.Contrast.one,
                                                                                  textAlignment: .center),
                                                                     background: .init(backgroundColor: LightColors.Pending.one,
                                                                                       tintColor: LightColors.Contrast.one,
                                                                                       border: Presets.Border.extraSmallPlain)),
                                                       infoButton: .init(normalConfiguration: Presets.Background.Secondary.normal,
                                                                         selectedConfiguration: Presets.Background.Secondary.selected,
                                                                         disabledConfiguration: Presets.Background.Secondary.disabled),
                                                       description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                       benefits: .init(font: Fonts.Body.two, textColor: LightColors.Text.three, textAlignment: .center))
        
        static var verified = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                        background: .init(backgroundColor: LightColors.Background.one,
                                                                          tintColor: LightColors.Outline.two,
                                                                          border: Presets.Border.zero),
                                                        title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                        status: .init(title: .init(font: Fonts.Body.two,
                                                                                   textColor: LightColors.Contrast.one,
                                                                                   textAlignment: .center),
                                                                      background: .init(backgroundColor: LightColors.Success.one,
                                                                                        tintColor: LightColors.Contrast.two,
                                                                                        border: Presets.Border.extraSmallPlain)),
                                                        infoButton: .init(normalConfiguration: Presets.Background.Secondary.normal,
                                                                          selectedConfiguration: Presets.Background.Secondary.selected,
                                                                          disabledConfiguration: Presets.Background.Secondary.disabled),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                        benefits: .init(font: Fonts.Body.two, textColor: LightColors.Text.three, textAlignment: .center))
    }
}

extension Presets {
    struct Order {
        static var small = OrderConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center, numberOfLines: 1),
                                              value: .init(font: Fonts.Subtitle.two,
                                                           textColor: LightColors.Text.one,
                                                           textAlignment: .center,
                                                           numberOfLines: 1,
                                                           lineBreakMode: .byTruncatingMiddle),
                                              shadow: Presets.Shadow.light,
                                              background: .init(backgroundColor: LightColors.Background.one,
                                                                tintColor: LightColors.Text.one,
                                                                border: Presets.Border.zero),
                                              contentBackground: .init(tintColor: LightColors.Text.one))
    }
}

extension Presets {
    struct Asset {
        static var header = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one),
                                               bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two),
                                               topRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .right),
                                               bottomRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two, textAlignment: .right),
                                               backgroundConfiguration: .init(backgroundColor: LightColors.Background.cards,
                                                                              border: Presets.Border.normal),
                                               imageConfig: .init(backgroundColor: LightColors.Pending.one,
                                                                  tintColor: .white,
                                                                  border: .init(borderWidth: 0,
                                                                                cornerRadius: .medium)),
                                               imageSize: .small)
        
        static var enabled = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.three),
                                                bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two),
                                                topRightConfiguration: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.three, textAlignment: .right),
                                                bottomRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two, textAlignment: .right), imageSize: .large)
        
        static var disabled = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one.withAlphaComponent(0.5)),
                                                 bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two.withAlphaComponent(0.5)),
                                                 topRightConfiguration: .init(font: Fonts.Subtitle.two,
                                                                              textColor: LightColors.Text.one.withAlphaComponent(0.5),
                                                                              textAlignment: .right),
                                                 bottomRightConfiguration: .init(font: Fonts.Subtitle.two,
                                                                                 textColor: LightColors.Text.two.withAlphaComponent(0.5),
                                                                                 textAlignment: .right),
                                                 imageSize: .large,
                                                 imageAlpha: 0.5)
    }
}

extension Presets {
    struct TitleValue {
        static var horizontal = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, numberOfLines: 1),
                                                        value: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .right))
        
        static var horizontalBold = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, numberOfLines: 1),
                                                            value: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var vertical = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, numberOfLines: 1),
                                                      value: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .right))
        
        static var verticalSmall = TitleValueConfiguration(title: .init(font: Fonts.Body.three, textColor: LightColors.Text.two, numberOfLines: 1),
                                                           value: .init(font: Fonts.Body.three, textColor: LightColors.Text.two, textAlignment: .right))
    }
}
