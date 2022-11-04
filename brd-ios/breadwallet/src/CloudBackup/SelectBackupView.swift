// 
//  SelectBackupView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-07-30.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

enum SelectBackupError: Error {
    case didCancel
}

typealias SelectBackupResult = Result<CloudBackup, Error>

struct SelectBackupView: View {
    
    let backups: [CloudBackup]
    let callback: (SelectBackupResult) -> Void
    @SwiftUI.State private var selectedBackup: CloudBackup?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(LightColors.Background.one))
            VStack {
                Text(L10n.CloudBackup.selectTitle)
                    .foregroundColor(Color(LightColors.Text.one))
                    .lineLimit(nil)
                    .font(Font(Fonts.Title.two))
                ForEach(0..<backups.count, id: \.self) { i in
                    BackupCell(backup: self.backups[i],
                               isOn: self.binding(for: i))
                    .padding(4.0)
                }
                self.okButton()
            }
        }.edgesIgnoringSafeArea(.all)
        .navigationBarItems(trailing: EmptyView())
    }
    
    private func okButton() -> some View {
        Button(action: {
            self.callback(.success(self.selectedBackup!))
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4.0)
                    .fill(Color(UIColor.primaryButton))
                    .opacity(self.selectedBackup == nil ? 0.3 : 1.0)
                Text(L10n.Button.continueAction)
                    .foregroundColor(Color(LightColors.Text.one))
                    .font(Font(Fonts.Title.three))
            }
        })
        .frame(height: 44.0)
        .cornerRadius(4.0)
        .disabled(self.selectedBackup == nil)
        .padding(EdgeInsets(top: 8.0, leading: 32.0, bottom: 32.0, trailing: 32.0))
    }
    
    private func binding(for index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                guard let selectedBackup = self.selectedBackup else { return false }
                return self.backups[index].identifier == selectedBackup.identifier },
            set: { if $0 { self.selectedBackup = self.backups[index] } }
        )
    }
}

struct BackupCell: View {
    
    let backup: CloudBackup
    @SwiftUI.Binding var isOn: Bool
    
    private let gradient = Gradient(colors: [Color(UIColor.gradientStart), Color(UIColor.gradientEnd)])
    
    var body: some View {
        HStack {
            RadioButton(isOn: $isOn)
                .frame(width: 44.0, height: 44.0)
            VStack(alignment: .leading) {
                Text(dateString)
                    .foregroundColor(Color(LightColors.Text.one))
                    .font(Font(Fonts.Body.one))
                    .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 0.0, trailing: 8.0))
                Text("\(backup.deviceName)")
                    .foregroundColor(Color(LightColors.Text.two))
                    .font(Font(Fonts.Body.one))
                    .padding(EdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
            }
        }
    }
    
    var dateString: String {
        let df = DateFormatter()
        df.dateFormat = "MMM d yyyy HH:mm:ss"
        return "\(df.string(from: backup.createTime))"
    }
}

struct RestoreCloudBackupView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBackupView(backups: [
            CloudBackup(phrase: "this is a phrase", identifier: "key", pin: "12345"),
            CloudBackup(phrase: "this is another phrase", identifier: "key", pin: "12345"),
            CloudBackup(phrase: "this is yet another phrase", identifier: "key", pin: "12345")
        ], callback: {_ in })
    }
}
