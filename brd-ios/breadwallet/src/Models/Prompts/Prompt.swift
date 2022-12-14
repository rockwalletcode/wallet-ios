//
//  Prompt.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-05-04.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication

// Defines the types and priority ordering of prompts. Only one prompt can appear on the home screen at at time.
enum PromptType: Int {
    case none
    case noInternet
    case kyc
    case upgradePin
    case paperKey
    case noPasscode
    case biometrics
    
    var order: Int { return rawValue }
    
    static var defaultTypes: [PromptType] = {
        return [.noInternet, .kyc, .upgradePin, .paperKey, .noPasscode, .biometrics]
    }()
    
    var title: String {
        switch self {
        case .noInternet: return L10n.Prompts.ConnectionIssues.title
        case .biometrics: return LAContext.biometricType() == .face ? L10n.Prompts.FaceId.title : L10n.Prompts.TouchId.title
        case .paperKey: return L10n.Prompts.PaperKey.title
        case .upgradePin: return L10n.Prompts.UpgradePin.title
        case .noPasscode: return L10n.Prompts.NoPasscode.title
        default: return ""
        }
    }
    
    var name: String {
        switch self {
        case .noInternet: return "noInternetPrompt"
        case .kyc: return "kycPrompt"
        case .biometrics: return "biometricsPrompt"
        case .paperKey: return "paperKeyPrompt"
        case .upgradePin: return "upgradePinPrompt"
        case .noPasscode: return "noPasscodePrompt"
        default: return ""
        }
    }
    
    var body: String {
        switch self {
        case .noInternet: return L10n.Alert.noInternet
        case .biometrics: return LAContext.biometricType() == .face ? L10n.Prompts.FaceId.body : L10n.Prompts.TouchId.body
        case .paperKey: return L10n.Prompts.PaperKey.body
        case .upgradePin: return L10n.Prompts.UpgradePin.body
        case .noPasscode: return L10n.Prompts.NoPasscode.body
        default: return ""
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .noInternet: return LightColors.Error.two
        default: return LightColors.Background.three
        }
    }
    
    var alertIcon: UIImage? {
        switch self {
        case .noInternet: return Asset.warning.image.tinted(with: LightColors.Error.one)
        default: return Asset.alert.image.tinted(with: LightColors.primary)
        }
    }
    
    // This is the trigger that happens when the prompt is tapped
    var trigger: TriggerName? {
        switch self {
        case .biometrics: return .promptBiometrics
        case .paperKey: return .promptPaperKey
        case .upgradePin: return .promptUpgradePin
        default: return nil
        }
    }
}

// Standard protocol for prompts that are shown to the user, typically at the top of the home screen.
protocol Prompt {
    /**
     *  The type for this prompt, which is used to determine whether to show the prompt
     *  and in which order relative to other prompts.
     */
    var type: PromptType { get }
    
    /**
     *  Name of this prompt, used for event logging.
     */
    var name: String { get }
    
    /**
     *  The priority ordering of this prompt relative to other prompts.
     */
    var order: Int { get }
    
    /**
     *  Background color of prompt.
     */
    var backgroundColor: UIColor { get }
    
    /**
     *  Alert icon of prompt.
     */
    var alertIcon: UIImage? { get }
    
    /**
     *  The title displayed with this prompt. e.g., "Action Required" for the paper key prompt.
     */
    var title: String { get }
    
    /**
     *  The body displayed with this prompt. e.g., "Your paper key must be saved..."
     */
    var body: String { get }
    
    /**
     *  The trigger that should be invoked when this prompt is tapped.
     */
    var trigger: TriggerName? { get }
    
    /**
     *  Returns whether this prompt should be presented to the user.
     */
    func shouldPrompt(walletAuthenticator: WalletAuthenticator?) -> Bool
    
    /**
     *  Invoked when this prompt is shown to the user. This function may be used to track the number of
     *  times a prompt has been shown, and whether to show it again.
     */
    func didPrompt() -> Bool
}

//
// Default Prompt implementation
//
extension Prompt {
    var type: PromptType {
        return .none
    }
    
    var name: String {
        return type.name
    }
    
    var order: Int {
        return type.order
    }
    
    var backgroundColor: UIColor {
        return type.backgroundColor
    }
    
    var alertIcon: UIImage? {
        return type.alertIcon
    }
    
    var title: String {
        return type.title
    }
    
    var body: String {
        return type.body
    }
    var trigger: TriggerName? {
        return type.trigger
    }
    
    // Default implementation based on the type of prompt
    func shouldPrompt(walletAuthenticator: WalletAuthenticator?) -> Bool {
        switch type {
        case .noInternet:
            return !Reachability.isReachable
            
        case .kyc:
            let profile = UserManager.shared.profile
            let hasKYC = profile?.status.hasKYC
            let isUnverified = profile?.roles.contains(.unverified) == true
            
            return hasKYC == false && isUnverified == false
            
        case .biometrics:
            guard !UserDefaults.hasPromptedBiometrics && LAContext.canUseBiometrics else { return false }
            guard let authenticator = walletAuthenticator, !authenticator.isBiometricsEnabledForUnlocking else { return false }
            
            return true
            
        case .paperKey:
            return UserDefaults.walletRequiresBackup && !UserDefaults.debugShouldSuppressPaperKeyPrompt
        case .upgradePin:
            return walletAuthenticator?.pinLength != 6
            
        case .noPasscode:
            return !LAContext.isPasscodeEnabled
            
        default:
            return false
        }
    }
    
    func didPrompt() -> Bool {
        guard !PromptFactory.shared.presentedPopups.contains(type) else { return true }
        
        switch type {
        case .noInternet:
            return false
            
        case .biometrics:
            UserDefaults.hasPromptedBiometrics = true
            PromptFactory.shared.presentedPopups.append(type)
            
            return false
            
        default:
            PromptFactory.shared.presentedPopups.append(type)
            
            return false
        }
    }
}

// Struct for basic prompts that include a Dismiss and Continue button, such as the paper-key prompt.
struct StandardPrompt: Prompt {
    var promptType: PromptType
    
    init(type: PromptType) {
        self.promptType = type
    }
    
    var type: PromptType {
        return promptType
    }
}

class PromptFactory: Subscriber {
    static let shared = PromptFactory()
    
    private var prompts = [Prompt]() {
        didSet {
            prompts.sort(by: { return $0.order < $1.order })
        }
    }
    
    var presentedPopups: [PromptType] = []
    
    init() {
        addDefaultPrompts()
    }
    
    static func nextPrompt(walletAuthenticator: WalletAuthenticator) -> Prompt? {
        let prompts = PromptFactory.shared.prompts
        
        let next = prompts.first(where: {
            Reachability.isReachable ? $0.shouldPrompt(walletAuthenticator: walletAuthenticator):  $0.type == .noInternet
        })
        
        return next
    }
    
    static func createPromptView(prompt: Prompt, presenter: UIViewController) -> PromptView {
        return PromptView(prompt: prompt)
    }
    
    private func addDefaultPrompts() {
        PromptType.defaultTypes.forEach { type in
            prompts.append(StandardPrompt(type: type))
        }
    }
}
