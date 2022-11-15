// 
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//

extension Scenes {
    static let VerifyAccount = VerifyAccountViewController.self
}

class VerifyAccountViewController: BaseInfoViewController {
    var role: CustomerRole?
    var flow: ExchangeFlow?
    
    override var imageName: String? {
        switch flow {
        case .swap:
            return "il_setup"
            
        case .buy:
            return "verification"
            
        default:
            return ""
        }
    }
    override var titleText: String? { return L10n.Account.messageVerifyAccount }
    override var descriptionText: String? {
        switch (role, flow) {
        case (.kyc1, .swap):
            return L10n.Account.verifyIdentity(L10n.HomeScreen.trade.lowercased())
            
        case (.kyc1, .buy):
            return L10n.Account.verifyIdentity(L10n.HomeScreen.buy.lowercased())
            
        case (.kyc2, _):
            return L10n.Account.upgradeVerificationIdentity
            
        default:
            return ""
        }
    }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: L10n.Button.verify, callback: { [weak self] in
                self?.coordinator?.showVerifications()
            }),
            .init(title: L10n.Button.maybeLater, isUnderlined: true, callback: { [weak self] in
                self?.coordinator?.goBack(completion: {})
            })
        ]
    }
    override var buttonConfigurations: [ButtonConfiguration] {
        return [Presets.Button.primary,
                Presets.Button.noBorders]
    }
}
