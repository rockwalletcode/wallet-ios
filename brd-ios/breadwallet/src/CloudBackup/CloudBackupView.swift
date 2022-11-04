// 
//  CloudBackupView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-07-28.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI
import Combine

struct CloudBackupView: View {
    
    @SwiftUI.State private var isBackupOnAtLoad: Bool
    @SwiftUI.State private var isBackupOn: Bool
    @SwiftUI.State private var showingDetail = false
    @SwiftUI.State private var didToggle = false
    @SwiftUI.State private var didSeeFirstToggle = false
    @SwiftUI.State private var didEnableKeyChain = false
    @SwiftUI.State private var showingDisableAlert = false
    @SwiftUI.State private var didToggleOffDuringOnboarding = false
    
    private let synchronizer: BackupSynchronizer
    
    init(synchronizer: BackupSynchronizer) {
        self.synchronizer = synchronizer
        _isBackupOn = SwiftUI.State(initialValue: synchronizer.isBackedUp)
        _isBackupOnAtLoad = SwiftUI.State(initialValue: synchronizer.isBackedUp)
    }
    
    @ViewBuilder
    var body: some View {
        mainStack()
            .if(isBackupOnAtLoad) {
                self.addAlert(content: $0)
            }
            .if(!isBackupOnAtLoad || self.synchronizer.context == .onboarding) {
                self.addSheet(content: $0)
            }
            .if(self.synchronizer.context == .onboarding) {
                self.addNavItem(content: $0)
            }
    }
    
    private func mainStack() -> some View {
        ZStack {
            Rectangle()
                .fill(Color(LightColors.Background.one))
            VStack {
                CloudBackupViewBody()
                Toggle(isOn: $isBackupOn) {
                    Text(L10n.CloudBackup.mainTitle)
                        .font(Font(Fonts.Body.one))
                        .foregroundColor(Color(LightColors.Text.three))
                }
                .toggleStyle(SwitchToggleStyle(tint: Color(LightColors.primary)))
                .onReceive(Just(isBackupOn), perform: self.onToggleChange)
                .padding([.leading, .trailing])
                .padding(.bottom, Margins.extraExtraHuge.rawValue)
                
                HStack {
                    Image("warning")
                        .frame(width: ViewSizes.medium.rawValue, height: ViewSizes.medium.rawValue)
                        .foregroundColor(Color(LightColors.Error.one))
                        .background(Color(LightColors.Background.one))
                        .cornerRadius(ViewSizes.medium.rawValue * CornerRadius.fullRadius.rawValue)
                        .padding(.leading)
                    BodyText(L10n.CloudBackup.mainWarning, style: .seconday)
                        .padding([.top, .bottom], Margins.extraLarge.rawValue)
                        .padding(.trailing, 40)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                }.background(Color(LightColors.Background.three))
                    .cornerRadius(CornerRadius.common.rawValue)
                    .padding([.leading, .trailing], Margins.large.rawValue)
                if self.synchronizer.context == .onboarding {
                    Button(action: {
                        if !didToggleOffDuringOnboarding {
                            self.showingDetail = true
                        } else {
                            self.synchronizer.completion?()
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4.0)
                                .fill(Color(LightColors.primary))
                            Text(L10n.Button.continueAction)
                                .font(Font(Fonts.button))
                                .foregroundColor(Color(LightColors.Contrast.two))
                        }
                    })
                    .frame(height: 44.0)
                    .padding([.leading, .trailing, .bottom])
                }
            }
        }
        .edgesIgnoringSafeArea(.all)

    }
    
    private func addAlert<Content: View>(content: Content) -> some View {
        return content.alert(isPresented: $showingDisableAlert) {
            SwiftUI.Alert(title: Text(L10n.WalletConnectionSettings.turnOff),
                          message: Text(L10n.CloudBackup.mainWarningConfirmation),
                          primaryButton: .default(Text(L10n.Button.cancel), action: {
                            self.isBackupOn = true
                            self.didToggle = false
                          }), secondaryButton: .destructive(Text(L10n.WalletConnectionSettings.turnOff), action: {
                            self.didToggle = false
                            self.isBackupOnAtLoad = false
                            self.synchronizer.deleteBackup()
                          }))
        }
    }
    
    private func addSheet<Content: View>(content: Content) -> some View {
        return content.sheet(isPresented: $showingDetail, onDismiss: self.onEnableKeychainDismiss, content: {
            EnableKeychainView(completion: self.onEnableKeychain)
        })
    }
    
    private func addNavItem<Content: View>(content: Content) -> some View {
        return content.navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing:
                Button(action: { self.synchronizer.skipBackup() },
                       label: { BodyText(L10n.Button.skip, style: .primary)
                    .foregroundColor(Color(LightColors.Contrast.two))
                        }))
    }
    
    private func onToggleChange(value: Bool) {
        //SWIFTUI:HACK - onReceive gets called at launch - we want to ignore the first result
        guard didSeeFirstToggle else { didSeeFirstToggle = true; return }

        if synchronizer.context == .onboarding && value == false {
            didToggleOffDuringOnboarding = true
        }
        
        //Turn off mode
        if isBackupOnAtLoad {
            if value == false && !didToggle {
                showingDisableAlert = true
                didToggle = true
            }
        //Turn on mode
        } else {
            if value == true && !didToggle {
                showingDetail = true
                didToggle = true
            }
        }
    }
    
    private func onEnableKeychain() {
        didEnableKeyChain = true
        showingDetail = false
    }
    
    private func onEnableKeychainDismiss() {
        if didEnableKeyChain {
            synchronizer.enableBackup { success in
                if success == false {
                    self.isBackupOn = false
                    self.didToggle = false
                } else {
                    self.didToggle = false
                    self.isBackupOnAtLoad = true
                }
            }
        } else {
            isBackupOn = false
        }
        didToggle = false
    }
}

struct CloudBackupViewBody: View {
    var body: some View {
        Group {
            CloudBackupIcon(style: .up)
                .padding(.bottom, Margins.extraHuge.rawValue)
            Text(L10n.CloudBackup.mainTitle)
                .font(Font(Fonts.Title.six))
                .foregroundColor(Color(LightColors.Text.three))
                .padding(.bottom, Margins.large.rawValue)
            Text(L10n.CloudBackup.mainBody)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .font(Font(Fonts.Body.two))
                .foregroundColor(Color(LightColors.Text.two))
            // uncommon padding :shrug
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .padding(.bottom, Margins.huge.rawValue)
        }
    }
}

enum CloudBackupIconStyle: String {
    case up = "icloud.and.arrow.up"
    case down = "icloud.and.arrow.down"
}

struct CloudBackupIcon: View {
    
    let style: CloudBackupIconStyle
    
    private var imageSize: CGFloat {
        return 120
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(LightColors.primary), Color(LightColors.primary.withAlphaComponent(0.5))]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask(Image(systemName: style.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
        )
        .frame(width: imageSize, height: imageSize)
    }
}

struct CloudBackupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CloudBackupView(synchronizer: CloudBackupView_Previews.synchronizer)
            }
            CloudBackupView(synchronizer: CloudBackupView_Previews.synchronizer)
        }
    }
    
    // swiftlint:disable force_try
    private static let keyStore = try! KeyStore.create()
    private static let synchronizer = BackupSynchronizer(context: .onboarding,
                                                         keyStore: CloudBackupView_Previews.keyStore,
                                                         navController: RootNavigationController())
}
