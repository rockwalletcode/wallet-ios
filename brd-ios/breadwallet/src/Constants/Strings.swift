// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// FIO
  internal static let sendFioToLabel = L10n.tr("Localizable", "Send_fio_toLabel", fallback: "FIO")
  /// Always require passcode option
  internal static let touchIdSpendingLimit = L10n.tr("Localizable", "TouchIdSpendingLimit", fallback: "Always require passcode")
  internal enum ATMMapView {
    /// ATM Cash Locatios View Title
    internal static let title = L10n.tr("Localizable", "ATMMapView.title", fallback: "ATM Cash Locations Map")
  }
  internal enum About {
    /// About screen blog label
    internal static let blog = L10n.tr("Localizable", "About.blog", fallback: "Blog")
    /// About screen footer
    internal static func footer(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "About.footer", String(describing: p1), String(describing: p2), fallback: "Made by the global RockWallet team.\nVersion %1$@ Build %2$@")
    }
    /// Privay Policy button label
    internal static let privacy = L10n.tr("Localizable", "About.privacy", fallback: "Privacy Policy")
    /// About screen reddit label
    internal static let reddit = L10n.tr("Localizable", "About.reddit", fallback: "Reddit")
    /// Terms of Use button label
    internal static let terms = L10n.tr("Localizable", "About.terms", fallback: "Terms And Conditions")
    /// About screen title
    internal static let title = L10n.tr("Localizable", "About.title", fallback: "About")
    /// About screen twitter label
    internal static let twitter = L10n.tr("Localizable", "About.twitter", fallback: "Twitter")
    /// About screen wallet ID label
    internal static let walletID = L10n.tr("Localizable", "About.walletID", fallback: "RockWallet Rewards ID")
    internal enum AppName {
      /// App name
      internal static let android = L10n.tr("Localizable", "About.appName.android", fallback: "RockWallet")
    }
  }
  internal enum AccessibilityLabels {
    /// Close modal button accessibility label
    internal static let close = L10n.tr("Localizable", "AccessibilityLabels.close", fallback: "Close")
    /// Support center accessibiliy label
    internal static let faq = L10n.tr("Localizable", "AccessibilityLabels.faq", fallback: "Support Center")
  }
  internal enum Account {
    /// Account limits title in profile view
    internal static let accountLimits = L10n.tr("Localizable", "Account.AccountLimits", fallback: "Account limits")
    /// Account Verification screen title
    internal static let accountVerification = L10n.tr("Localizable", "Account.AccountVerification", fallback: "Account Verification")
    /// Account balance
    internal static let balance = L10n.tr("Localizable", "Account.balance", fallback: "Your balance")
    /// Before confirm photo label in create account screen
    internal static let beforeConfirm = L10n.tr("Localizable", "Account.BeforeConfirm", fallback: "Before you confirm, please:")
    /// Change your email title on registration flow
    internal static let changeEmail = L10n.tr("Localizable", "Account.ChangeEmail", fallback: "Change your email")
    /// Country title label in select countries view
    internal static let country = L10n.tr("Localizable", "Account.Country", fallback: "Country")
    /// Create a RockWallet account by entering your email address label in registration flow
    internal static let createAccount = L10n.tr("Localizable", "Account.CreateAccount", fallback: "Create a RockWallet account by entering your email address.")
    /// Current limit per day label in profile screen
    internal static let currentLimit = L10n.tr("Localizable", "Account.CurrentLimit", fallback: "Current limit: $1,000/day")
    /// Issues for processing your data label on profile screen
    internal static let dataIssues = L10n.tr("Localizable", "Account.DataIssues", fallback: "Oops! We had some issues processing your data")
    /// Date of birth label in create account
    internal static let dateOfBirth = L10n.tr("Localizable", "Account.DateOfBirth", fallback: "Date of birth")
    /// Declined
    internal static let declined = L10n.tr("Localizable", "Account.Declined", fallback: "Declined")
    /// Delete account option in menu
    internal static let deleteAccount = L10n.tr("Localizable", "Account.DeleteAccount", fallback: "Delete account")
    /// Delisted token alert banner message
    internal static let delistedToken = L10n.tr("Localizable", "Account.delistedToken", fallback: "This token has been delisted. \n\nYou may still be able to send these tokens to another platform. For more details, visit our support page.")
    /// Email
    internal static let email = L10n.tr("Localizable", "Account.Email", fallback: "Email")
    /// $10000 per BTC
    internal static func exchangeRate(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Account.exchangeRate", String(describing: p1), String(describing: p2), fallback: "%1$@ per %2$@")
    }
    /// Get full access for the RockWallet label on profile screen
    internal static let fullAccess = L10n.tr("Localizable", "Account.FullAccess", fallback: "Get full access to your RockWallet!")
    /// ID Verification title on account screen
    internal static let idVerification = L10n.tr("Localizable", "Account.IDVerification", fallback: "ID Verification")
    /// Loading Wallet Message
    internal static let loadingMessage = L10n.tr("Localizable", "Account.loadingMessage", fallback: "Loading Wallet")
    /// Verify your account to get full access to the wallet message
    internal static let messageVerifyAccount = L10n.tr("Localizable", "Account.MessageVerifyAccount", fallback: "Verify your account to get full access to your RockWallet!")
    /// Pending
    internal static let pending = L10n.tr("Localizable", "Account.Pending", fallback: "Pending")
    /// Account Personal Information title
    internal static let personalInformation = L10n.tr("Localizable", "Account.PersonalInformation", fallback: "Personal Information")
    /// Promotion and offers label when registering account
    internal static let promotion = L10n.tr("Localizable", "Account.Promotion", fallback: "I'm ok with receiving future promotion, offers and communications")
    /// Proof of Identity title in add document for kyc2
    internal static let proofOfIdentity = L10n.tr("Localizable", "Account.ProofOfIdentity", fallback: "Proof of Identity")
    /// Resubmit
    internal static let resubmit = L10n.tr("Localizable", "Account.Resubmit", fallback: "Resubmit")
    /// Retake photo button on create account
    internal static let retakePhoto = L10n.tr("Localizable", "Account.RetakePhoto", fallback: "Retake photo")
    /// Select country
    internal static let selectCountry = L10n.tr("Localizable", "Account.SelectCountry", fallback: "Select country")
    /// Select state
    internal static let selectState = L10n.tr("Localizable", "Account.SelectState", fallback: "Select state")
    /// State title label in select state view
    internal static let state = L10n.tr("Localizable", "Account.State", fallback: "State")
    /// Submit your photo for document id title
    internal static let submitPhoto = L10n.tr("Localizable", "Account.SubmitPhoto", fallback: "Submit your photo")
    /// Swap and buy limit per day description label
    internal static let swapAndBuyLimit = L10n.tr("Localizable", "Account.SwapAndBuyLimit", fallback: "Swap limit: $10,000 USD/day\nBuy limit: $500 USD/day")
    /// Upgrade your limits label in profile screen
    internal static let upgradeLimits = L10n.tr("Localizable", "Account.UpgradeLimits", fallback: "Upgrade your limits")
    /// You need to upgrade your verification status before you can buy assets.
    internal static let upgradeVerificationIdentity = L10n.tr("Localizable", "Account.UpgradeVerificationIdentity", fallback: "You need to upgrade your verification status before you can buy assets.")
    /// You need to be at least 18 years old to complete Level 1 verification label in verify account
    internal static let verification = L10n.tr("Localizable", "Account.Verification", fallback: "You need to be at least 18 years old to complete Level 1 verification")
    /// Why is the verification declined label in profile screen
    internal static let verificationDeclined = L10n.tr("Localizable", "Account.VerificationDeclined", fallback: "Why is my verification declined?")
    /// Verified
    internal static let verified = L10n.tr("Localizable", "Account.Verified", fallback: "Verified")
    /// Verified account message on profile screen
    internal static let verifiedAccountMessage = L10n.tr("Localizable", "Account.VerifiedAccountMessage", fallback: "We’ll let you know when your account is verified.")
    /// Verify account text in popup
    internal static let verifyAccountText = L10n.tr("Localizable", "Account.VerifyAccountText", fallback: "If you verify your account, you are given access to:\n・Unlimited deposits/withdrawals\n・Enhanced security\n・Full asset support\n・Buy assets with credit card")
    /// Enter and verify your email address for your account label in registration flow
    internal static let verifyEmail = L10n.tr("Localizable", "Account.VerifyEmail", fallback: "Enter and verify your new email address for your RockWallet account.")
    /// We need to verify your identity before you can %s assets.
    internal static func verifyIdentity(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Account.VerifyIdentity", p1, fallback: "We need to verify your identity before you can %s assets.")
    }
    /// We need to verify your identity before you can buy or swap assets.
    internal static let verifyIdentityPlain = L10n.tr("Localizable", "Account.VerifyIdentityPlain", fallback: "We need to verify your identity before you can buy or swap assets.")
    /// Verify personal information text explanation
    internal static let verifyPersonalInformation = L10n.tr("Localizable", "Account.VerifyPersonalInformation", fallback: "We need to verify your personal information for compliance purposes. This information won’t be shared with outside sources unless required by law.")
    /// Welcome title on registration screen
    internal static let welcome = L10n.tr("Localizable", "Account.Welcome", fallback: "Welcome!")
    /// Why verify my account title
    internal static let whyVerify = L10n.tr("Localizable", "Account.WhyVerify", fallback: "Why should I verify my account?")
    /// Write your name as it appears on your ID label in create account
    internal static let writeYourName = L10n.tr("Localizable", "Account.WriteYourName", fallback: "Write your name as it appears on your ID")
  }
  internal enum AccountCreation {
    /// Confirm Account Creation mesage body
    internal static let body = L10n.tr("Localizable", "AccountCreation.body", fallback: "Only create a Hedera account if you intend on storing HBAR in your wallet.")
    /// Change my email label
    internal static let changeEmail = L10n.tr("Localizable", "AccountCreation.ChangeEmail", fallback: "Change my email")
    /// Verification code sent message
    internal static let codeSent = L10n.tr("Localizable", "AccountCreation.CodeSent", fallback: "Verification code sent.")
    /// Create Account button label
    internal static let create = L10n.tr("Localizable", "AccountCreation.create", fallback: "Create Account")
    /// Creating Account progress Label
    internal static let creating = L10n.tr("Localizable", "AccountCreation.creating", fallback: "Creating Account")
    /// Enter the code message in create account flow
    internal static let enterCode = L10n.tr("Localizable", "AccountCreation.EnterCode", fallback: "Please enter the code we’ve sent to")
    /// Creating Account progress Label
    internal static let error = L10n.tr("Localizable", "AccountCreation.error", fallback: "An error occurred during account creation. Please try again later.")
    /// Not Now button label.
    internal static let notNow = L10n.tr("Localizable", "AccountCreation.notNow", fallback: "Not Now")
    /// Re-send my code label
    internal static let resendCode = L10n.tr("Localizable", "AccountCreation.ResendCode", fallback: "Resend my code")
    /// Creating Account progress Label
    internal static let timeout = L10n.tr("Localizable", "AccountCreation.timeout", fallback: "The Request timed out. Please try again later.")
    /// Confirm Account Creation Title
    internal static let title = L10n.tr("Localizable", "AccountCreation.title", fallback: "Confirm Account Creation")
    /// Verify your email label
    internal static let verifyEmail = L10n.tr("Localizable", "AccountCreation.VerifyEmail", fallback: "Verify your email")
    /// Why the wallet is disabled text
    internal static let walletDisabled = L10n.tr("Localizable", "AccountCreation.WalletDisabled", fallback: "If you enter an incorrect wallet PIN too many times, your wallet will become disabled for a certain amount of time.\nThis is to prevent someone else from trying to guess your PIN by quickly making many guesses.\nIf your wallet is disabled, wait until the time shown and you will be able to enter your PIN again.\n\nIf you continue to enter the incorrect PIN, the amount of waiting time in between attempts will increase. Eventually, the app will reset and you can start a new wallet.\n\nIf you have the Recovery Phrase for your wallet, you can use it to reset your PIN by clicking the “Reset PIN” button.")
    /// Why is my wallet disabled title on popup
    internal static let walletDisabledTitle = L10n.tr("Localizable", "AccountCreation.WalletDisabledTitle", fallback: "Why is my wallet disabled?")
  }
  internal enum AccountDelete {
    /// Popup text when the account is deleted
    internal static let accountDeletedPopup = L10n.tr("Localizable", "AccountDelete.AccountDeletedPopup", fallback: "Your account has been deleted.\nWe are sorry to see you go.")
    /// Delete account title
    internal static let deleteAccountTitle = L10n.tr("Localizable", "AccountDelete.DeleteAccountTitle", fallback: "You are about to delete your RockWallet account.")
    /// Delete account explanation title
    internal static let deleteWhatMean = L10n.tr("Localizable", "AccountDelete.DeleteWhatMean", fallback: "What does this mean?")
    /// Delete account explanation part one
    internal static let explanationOne = L10n.tr("Localizable", "AccountDelete.ExplanationOne", fallback: "-You will no longer be able to use your email to sign in into RockWallet")
    /// Delete account explanation part three
    internal static let explanationThree = L10n.tr("Localizable", "AccountDelete.ExplanationThree", fallback: "-Your private keys are still yours, keep your Recovery Phrase in a safe place in case you need to restore your wallet.")
    /// Delete account explanation part two
    internal static let explanationTwo = L10n.tr("Localizable", "AccountDelete.ExplanationTwo", fallback: "-You will no longer be able to user your KYC and registration status")
    /// Recover wallet text after deleting account
    internal static let recoverWallet = L10n.tr("Localizable", "AccountDelete.RecoverWallet", fallback: "I understand that the only way to recover my wallet is by entering my Recovery Phrase")
  }
  internal enum AccountHeader {
    /// Default wallet name
    internal static let defaultWalletName = L10n.tr("Localizable", "AccountHeader.defaultWalletName", fallback: "My RockWallet")
  }
  internal enum AccountKYCLevelOne {
    /// Level one title on account screen
    internal static let levelOne = L10n.tr("Localizable", "AccountKYCLevelOne.LevelOne", fallback: "Level 1")
    /// Account limi message on KYC1
    internal static let limit = L10n.tr("Localizable", "AccountKYCLevelOne.Limit", fallback: "Account limit: $1,000/day ($10,000 lifetime)")
  }
  internal enum AccountKYCLevelTwo {
    /// Back page of the document text instructions for KYC2
    internal static let backPageInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.BackPageInstructions", fallback: "Make sure you have captured the entire back page of the document")
    /// Before start label
    internal static let beforeStart = L10n.tr("Localizable", "AccountKYCLevelTwo.BeforeStart", fallback: "Before you start, please:")
    /// Buy limits on KYC2 account
    internal static let buyLimits = L10n.tr("Localizable", "AccountKYCLevelTwo.BuyLimits", fallback: "Buy limits: $500 USD/day, no lifetime limit")
    /// Capture back page of the document text
    internal static let captureBackPage = L10n.tr("Localizable", "AccountKYCLevelTwo.CaptureBackPage", fallback: "Make sure to capture the entire back page of the document.")
    /// Make sure to capture the entire document.
    internal static let captureEntireDocument = L10n.tr("Localizable", "AccountKYCLevelTwo.CaptureEntireDocument", fallback: "Make sure to capture the entire document.")
    /// Capture front page text label
    internal static let captureFrontPage = L10n.tr("Localizable", "AccountKYCLevelTwo.CaptureFrontPage", fallback: "Make sure to capture the entire front page of the document.")
    /// Checking for errors label on KYC2
    internal static let checkingErrors = L10n.tr("Localizable", "AccountKYCLevelTwo.CheckingErrors", fallback: "Checking for errors")
    /// Please complete Level 1 verification first.
    internal static let completeLevelOneFirst = L10n.tr("Localizable", "AccountKYCLevelTwo.CompleteLevelOneFirst", fallback: "Please complete Level 1 verification first.")
    /// Confirm ID label in KYC2 flow
    internal static let confirmID = L10n.tr("Localizable", "AccountKYCLevelTwo.ConfirmID", fallback: "We need to confirm your ID")
    /// Document confirmation label for KYC2
    internal static let documentConfirmation = L10n.tr("Localizable", "AccountKYCLevelTwo.DocumentConfirmation", fallback: "Make sure document details are clearly visible and within the frame")
    /// Documents review label in KYC2
    internal static let documentsReview = L10n.tr("Localizable", "AccountKYCLevelTwo.DocumentsReview", fallback: "We are reviewing your documents and will let you know when your account has been verified.")
    /// Driver’s license
    internal static let drivingLicence = L10n.tr("Localizable", "AccountKYCLevelTwo.DrivingLicence", fallback: "Driver’s license")
    /// Face capture instructions text on documents for KYC2
    internal static let faceCaptureInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceCaptureInstructions", fallback: "Make sure you have captured your entire face in the frame.")
    /// Face is in the frame text for document on KYC2
    internal static let faceVisible = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceVisible", fallback: "Make sure your face is in the frame and clearly visible")
    /// Face is clearly visible confirmation text for documents on KYC2
    internal static let faceVisibleConfirmation = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceVisibleConfirmation", fallback: "Make sure your face is clearly visible.")
    /// Front page of the document instructions text for KYC2
    internal static let frontPageInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.FrontPageInstructions", fallback: "Make sure you have captured the entire front page of the document")
    /// KYC Level Two status
    internal static let inProgress = L10n.tr("Localizable", "AccountKYCLevelTwo.InProgress", fallback: "Your ID verification is in progress")
    /// Document instructions label for KYC2
    internal static let instructions = L10n.tr("Localizable", "AccountKYCLevelTwo.Instructions", fallback: "Make sure you have captured the entire document")
    /// Level two title in Account screen
    internal static let levelTwo = L10n.tr("Localizable", "AccountKYCLevelTwo.LevelTwo", fallback: "Level 2")
    /// Swap limits on KYC2 account
    internal static let limits = L10n.tr("Localizable", "AccountKYCLevelTwo.Limits", fallback: "Swap limits: $10,000 USD/day, no lifetime limit")
    /// Make sure before photo label in KYC2
    internal static let makeSure = L10n.tr("Localizable", "AccountKYCLevelTwo.MakeSure", fallback: "Make sure you are in a well-lit room")
    /// National ID card
    internal static let nationalIdCard = L10n.tr("Localizable", "AccountKYCLevelTwo.NationalIdCard", fallback: "National ID card")
    /// Passport
    internal static let passport = L10n.tr("Localizable", "AccountKYCLevelTwo.Passport", fallback: "Passport")
    /// Prepare documents label in KYC2
    internal static let prepareDocument = L10n.tr("Localizable", "AccountKYCLevelTwo.PrepareDocument", fallback: "Have a valid government-issued identity document (passport, national ID card or driver’s license) ready")
    /// Residence permit
    internal static let residencePermit = L10n.tr("Localizable", "AccountKYCLevelTwo.ResidencePermit", fallback: "Residence permit")
    /// Select documents  options text label in KYC2
    internal static let selectOptions = L10n.tr("Localizable", "AccountKYCLevelTwo.SelectOptions", fallback: "Select one of the following options:")
    /// Sending your data label for verification on KYC2
    internal static let sendingData = L10n.tr("Localizable", "AccountKYCLevelTwo.SendingData", fallback: "Sending your data for verification")
    /// Make sure your ID is clear and readable and fits fully in the frame
    internal static let takeIdBackPhotoContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdBackPhotoContent", fallback: "Make sure your ID is clear and readable and fits fully in the frame")
    /// Please take a photo of your ID’s back page
    internal static let takeIdBackPhotoTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdBackPhotoTitle", fallback: "Please take a photo of your ID’s back page")
    /// Make sure your ID is clear and readable and fits fully in the frame
    internal static let takeIdFrontPhotoContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdFrontPhotoContent", fallback: "Make sure your ID is clear and readable and fits fully in the frame")
    /// Please take a photo of your ID’s front page
    internal static let takeIdFrontPhotoTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdFrontPhotoTitle", fallback: "Please take a photo of your ID’s front page")
    /// Make sure your passport is clear and readable and fits fully in the frame.
    internal static let takePhotoPassportContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotoPassportContent", fallback: "Make sure your passport is clear and readable and fits fully in the frame.")
    /// Please take a photo of your passport.
    internal static let takePhotoPassportTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotoPassportTitle", fallback: "Please take a photo of your passport.")
    /// Take photos label in KYC2
    internal static let takePhotos = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotos", fallback: "Be prepared to take a selfie and photos of your ID")
    /// Make sure your face is in the frame and it’s clearly visible.
    internal static let takeSelfieContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeSelfieContent", fallback: "Make sure your face is in the frame and it’s clearly visible.")
    /// Please take a selfie
    internal static let takeSelfieTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeSelfieTitle", fallback: "Please take a selfie")
    /// If your personal information has changed, please first update Level 1 KYC and then continue with
    /// Level 2 KYC.
    internal static let updateLevelOne = L10n.tr("Localizable", "AccountKYCLevelTwo.updateLevelOne", fallback: "If your personal information has changed, please first update Level 1 KYC and then continue with\nLevel 2 KYC.")
    /// Uploading your photos label in KYC2 flow
    internal static let uploadingPhoto = L10n.tr("Localizable", "AccountKYCLevelTwo.UploadingPhoto", fallback: "Uploading your photos")
    /// Unavailable while KYC verification is pending.
    internal static let verificationPending = L10n.tr("Localizable", "AccountKYCLevelTwo.VerificationPending", fallback: "Unavailable while KYC verification is pending.")
    /// Verifying label on KYC2
    internal static let verifying = L10n.tr("Localizable", "AccountKYCLevelTwo.Verifying", fallback: "Verifying you")
  }
  internal enum Alert {
    /// Account backed up with iCloud Keychain message in alert view,
    internal static let accountBackedUpiCloud = L10n.tr("Localizable", "Alert.AccountBackedUpiCloud", fallback: "Account backed up with iCloud Keychain")
    /// Account succesfully restored from Cloud backup message in alert view
    internal static let accountRestorediCloud = L10n.tr("Localizable", "Alert.AccountRestorediCloud", fallback: "Account succesfully restored from Cloud backup")
    /// Error alert title
    internal static let error = L10n.tr("Localizable", "Alert.error", fallback: "Error")
    /// Hedera Account succesfully created header alert view
    internal static let hederaAccount = L10n.tr("Localizable", "Alert.HederaAccount", fallback: "Hedera Account succesfully created.")
    /// No internet alert message
    internal static let noInternet = L10n.tr("Localizable", "Alert.noInternet", fallback: "No internet connection found. Check your connection and try again.")
    /// KYCCamera doesn't have permission to use the camera, please change privacy settings
    internal static let permissionCamera = L10n.tr("Localizable", "Alert.PermissionCamera", fallback: "KYCCamera doesn't have permission to use the camera, please change privacy settings")
    /// General error message
    internal static let somethingWentWrong = L10n.tr("Localizable", "Alert.somethingWentWrong", fallback: "Something went wrong. Please try again.")
    /// Request timed out error message
    internal static let timedOut = L10n.tr("Localizable", "Alert.timedOut", fallback: "Request timed out. Check your connection and try again.")
    /// Unable to capture media
    internal static let unableCapture = L10n.tr("Localizable", "Alert.UnableCapture", fallback: "Unable to capture media")
    /// Warning alert title
    internal static let warning = L10n.tr("Localizable", "Alert.warning", fallback: "Warning")
    internal enum CustomKeyboard {
      /// Third party keyboard warning
      internal static let android = L10n.tr("Localizable", "Alert.customKeyboard.android", fallback: "It looks like you are using a third-party keyboard, which can record what you type and steal your Recovery Phrase. Please switch to the default Android keyboard for extra protection.")
    }
    internal enum Keystore {
      internal enum Generic {
        /// Keystore error
        internal static let android = L10n.tr("Localizable", "Alert.keystore.generic.android", fallback: "There is a problem with your Android OS keystore, please contact support@rockwallet.com")
      }
      internal enum Invalidated {
        /// KeyStore error, keys are invalidated
        internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.android", fallback: "Your RockWallet encrypted data was recently invalidated because your Android lock screen was disabled.")
        internal enum Uninstall {
          /// Warn user key store data has been invalidate because the user changed their security settings. The user must uninstall.
          internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.uninstall.android", fallback: "We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your RockWallet app data must be wiped by uninstalling.\n\nDon’t worry, your funds are still secure! Reinstall the app and recover your wallet using your Recovery Phrase.")
        }
        internal enum Wipe {
          /// Warn user key store data has been invalidate because the user changed their security settings. The user must wipe their app data.
          internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.wipe.android", fallback: "We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your RockWallet app data must be wiped.\n\nDon’t worry, your funds are still secure! Recover your wallet using your Recovery Phrase.")
        }
      }
      internal enum Title {
        /// Keystore error title
        internal static let android = L10n.tr("Localizable", "Alert.keystore.title.android", fallback: "Android Key Store Error")
      }
    }
  }
  internal enum Alerts {
    /// 'the addresses were copied'' Alert title
    internal static let copiedAddressesHeader = L10n.tr("Localizable", "Alerts.copiedAddressesHeader", fallback: "Addresses Copied")
    /// Addresses Copied Alert sub header
    internal static let copiedAddressesSubheader = L10n.tr("Localizable", "Alerts.copiedAddressesSubheader", fallback: "All wallet addresses successfully copied.")
    /// Alert Header Label (the paper key was set)
    internal static let paperKeySet = L10n.tr("Localizable", "Alerts.paperKeySet", fallback: "Recovery Key Set")
    /// Alert Subheader label (playfully positive)
    internal static let paperKeySetSubheader = L10n.tr("Localizable", "Alerts.paperKeySetSubheader", fallback: "Awesome!")
    /// Alert Header label (the PIN was set)
    internal static let pinSet = L10n.tr("Localizable", "Alerts.pinSet", fallback: "PIN successfully set")
    /// PIN successfully updated
    internal static let pinUpdated = L10n.tr("Localizable", "Alerts.pinUpdated", fallback: "PIN successfully updated")
    /// Send failure alert header label (the send failed to happen)
    internal static let sendFailure = L10n.tr("Localizable", "Alerts.sendFailure", fallback: "Send failed")
    /// Send success alert header label (confirmation that the send happened)
    internal static let sendSuccess = L10n.tr("Localizable", "Alerts.sendSuccess", fallback: "Send Confirmation")
    /// Send success alert subheader label (e.g. the money was sent)
    internal static let sendSuccessSubheader = L10n.tr("Localizable", "Alerts.sendSuccessSubheader", fallback: "Money Sent!")
    /// Recovery Phrase correct
    internal static let walletRestored = L10n.tr("Localizable", "Alerts.walletRestored", fallback: "Recovery Phrase correct")
    internal enum TouchIdSucceeded {
      /// Fingerprint was recognized by the scanner
      internal static let android = L10n.tr("Localizable", "Alerts.touchIdSucceeded.android", fallback: "Fingerprint recognized")
    }
  }
  internal enum Amount {
    /// Error label on XRP send amount screen
    internal static let minXRPAmount = L10n.tr("Localizable", "Amount.MinXRPAmount", fallback: "The minimum required ammount is 10 XRP.")
    /// Ripple balance title
    internal static let rippleBalance = L10n.tr("Localizable", "Amount.RippleBalance", fallback: "XRP Balance")
    /// Ripple balance popup text
    internal static let rippleBalanceText = L10n.tr("Localizable", "Amount.RippleBalanceText", fallback: "Ripple requires each wallet to have a minimum balance of 10 XRP, so the balance displayed here is always 10 XRP less than your actual balance.")
  }
  internal enum Android {
    /// Tell the user where they can enable permissions to access device storage.
    internal static let allowFileSystemAccess = L10n.tr("Localizable", "Android.allowFileSystemAccess", fallback: "Please enable storage permissions in your device settings: \"Settings\" > \"Apps\" > \"RockWallet\" > \"Permissions\".")
    /// Warning about using apps that can alter the screen
    internal static let screenAlteringMessage = L10n.tr("Localizable", "Android.screenAlteringMessage", fallback: "We've detected an app that is incompatible with RockWallet running on your device. For security reasons, please disable any screen altering or light filtering apps to proceed.")
    /// An app that alters the screen ("screen-altering app") has been detected.
    internal static let screenAlteringTitle = L10n.tr("Localizable", "Android.screenAlteringTitle", fallback: "Screen Altering App Detected")
    internal enum Bch {
      internal enum Welcome {
        /// The "home" screen is the name of the top level menu for the app.
        internal static let message = L10n.tr("Localizable", "Android.BCH.welcome.message", fallback: "Any BCH in your wallet can be accessed through the home screen.")
      }
    }
  }
  internal enum ApiClient {
    /// JSON Serialization error message
    internal static let jsonError = L10n.tr("Localizable", "ApiClient.jsonError", fallback: "JSON Serialization Error")
    /// Wallet not ready error message
    internal static let notReady = L10n.tr("Localizable", "ApiClient.notReady", fallback: "Wallet not ready")
    /// API Token error message
    internal static let tokenError = L10n.tr("Localizable", "ApiClient.tokenError", fallback: "Unable to retrieve API token")
  }
  internal enum Bch {
    /// Send BCH view body.
    internal static func body(_ p1: Any) -> String {
      return L10n.tr("Localizable", "BCH.body", String(describing: p1), fallback: "Enter a destination BCH address below. All BCH in your wallet at the time of the fork (%1$@) will be sent.")
    }
    /// Confirm sending <$5.00> to <address>?
    internal static func confirmationMessage(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "BCH.confirmationMessage", String(describing: p1), String(describing: p2), fallback: "Confirm sending %1$@ to %2$@")
    }
    /// Confirmation alert title
    internal static let confirmationTitle = L10n.tr("Localizable", "BCH.confirmationTitle", fallback: "Confirmation")
    /// Generic bch erorr message
    internal static let genericError = L10n.tr("Localizable", "BCH.genericError", fallback: "Your account does not contain any BCH, or you received BCH after the fork.")
    /// Transaction ID copied message
    internal static let hashCopiedMessage = L10n.tr("Localizable", "BCH.hashCopiedMessage", fallback: "Transaction ID copied")
    /// No address error message
    internal static let noAddressError = L10n.tr("Localizable", "BCH.noAddressError", fallback: "Please enter an address")
    /// Attempted to scan unsupported qr code error message.
    internal static let paymentProtocolError = L10n.tr("Localizable", "BCH.paymentProtocolError", fallback: "Payment Protocol Requests are not supported for BCH transactions")
    /// BCH successfully sent alert message
    internal static let successMessage = L10n.tr("Localizable", "BCH.successMessage", fallback: "BCH was successfully sent.")
    /// Widthdraw BCH view title
    internal static let title = L10n.tr("Localizable", "BCH.title", fallback: "Withdraw BCH")
    /// Tx Hash button header
    internal static let txHashHeader = L10n.tr("Localizable", "BCH.txHashHeader", fallback: "BCH Transaction ID")
  }
  internal enum BitID {
    /// Approve button label
    internal static let approve = L10n.tr("Localizable", "BitID.approve", fallback: "Approve")
    /// <sitename> is requesting authentication using your bitcoin wallet
    internal static func authenticationRequest(_ p1: Any) -> String {
      return L10n.tr("Localizable", "BitID.authenticationRequest", String(describing: p1), fallback: "%1$@ is requesting authentication using your bitcoin wallet")
    }
    /// Deny button label
    internal static let deny = L10n.tr("Localizable", "BitID.deny", fallback: "Deny")
    /// BitID error alert title
    internal static let error = L10n.tr("Localizable", "BitID.error", fallback: "Authentication Error")
    /// BitID error alert messaage (The payment service you are trying to use isn't working. Please contact them, as you may need to try again)
    internal static let errorMessage = L10n.tr("Localizable", "BitID.errorMessage", fallback: "Please check with the service. You may need to try again.")
    /// BitID success alert title
    internal static let success = L10n.tr("Localizable", "BitID.success", fallback: "Successfully Authenticated")
    /// BitID Authentication Request alert view title
    internal static let title = L10n.tr("Localizable", "BitID.title", fallback: "BitID Authentication Request")
  }
  internal enum Button {
    /// As in "(tap here to) buy (bitcoin)"
    internal static let buy = L10n.tr("Localizable", "Button.buy", fallback: "Buy")
    /// Cancel button label
    internal static let cancel = L10n.tr("Localizable", "Button.cancel", fallback: "Cancel")
    /// Close button
    internal static let close = L10n.tr("Localizable", "Button.close", fallback: "Close")
    /// Confirm button title
    internal static let confirm = L10n.tr("Localizable", "Button.confirm", fallback: "Confirm")
    /// prompt continue button
    internal static let continueAction = L10n.tr("Localizable", "Button.continueAction", fallback: "Continue")
    /// prompt dismiss button
    internal static let dismiss = L10n.tr("Localizable", "Button.dismiss", fallback: "Dismiss")
    /// Done button title
    internal static let done = L10n.tr("Localizable", "Button.done", fallback: "DONE")
    /// Finish button title
    internal static let finish = L10n.tr("Localizable", "Button.Finish", fallback: "Finish")
    /// Go to dashboard button
    internal static let goToDashboard = L10n.tr("Localizable", "Button.GoToDashboard", fallback: "Go to dashboard")
    /// Button to return to the "home" screen (the home screen is the top menu).
    internal static let home = L10n.tr("Localizable", "Button.Home", fallback: "Home")
    /// Ignore button label
    internal static let ignore = L10n.tr("Localizable", "Button.ignore", fallback: "Ignore")
    /// Map button
    internal static let map = L10n.tr("Localizable", "Button.map", fallback: "Map")
    /// Maybe Later button label
    internal static let maybeLater = L10n.tr("Localizable", "Button.maybeLater", fallback: "Maybe later")
    /// menu button
    internal static let menu = L10n.tr("Localizable", "Button.menu", fallback: "Menu")
    /// More information button
    internal static let moreInfo = L10n.tr("Localizable", "Button.moreInfo", fallback: "More info")
    /// No button
    internal static let no = L10n.tr("Localizable", "Button.no", fallback: "No")
    /// OK button label
    internal static let ok = L10n.tr("Localizable", "Button.ok", fallback: "OK")
    /// Open Settings button
    internal static let openSettings = L10n.tr("Localizable", "Button.openSettings", fallback: "Open Settings")
    /// Profile button title on tab bar
    internal static let profile = L10n.tr("Localizable", "Button.Profile", fallback: "Profile")
    /// receive button
    internal static let receive = L10n.tr("Localizable", "Button.receive", fallback: "Receive")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "Button.remove", fallback: "Remove")
    /// Search button
    internal static let search = L10n.tr("Localizable", "Button.search", fallback: "Search")
    /// Click this button to sell an asset
    internal static let sell = L10n.tr("Localizable", "Button.sell", fallback: "Sell")
    /// send button
    internal static let send = L10n.tr("Localizable", "Button.send", fallback: "Send")
    /// Settings button label
    internal static let settings = L10n.tr("Localizable", "Button.settings", fallback: "Settings")
    /// Setup button label
    internal static let setup = L10n.tr("Localizable", "Button.setup", fallback: "Set Up")
    /// Skip button title
    internal static let skip = L10n.tr("Localizable", "Button.skip", fallback: "Skip")
    /// Settings button label
    internal static let submit = L10n.tr("Localizable", "Button.submit", fallback: "Submit")
    /// Verify
    internal static let verify = L10n.tr("Localizable", "Button.Verify", fallback: "Verify")
    /// Yes button
    internal static let yes = L10n.tr("Localizable", "Button.yes", fallback: "Yes")
    internal enum ContactSupport {
      /// Button label to open a email compose window with our support email in the to field.
      internal static let android = L10n.tr("Localizable", "Button.contactSupport.android", fallback: "Contact Support")
    }
    internal enum SecuritySettings {
      /// Button label to open Security Settings.
      internal static let android = L10n.tr("Localizable", "Button.securitySettings.android", fallback: "Security Settings")
    }
    internal enum Uninstall {
      /// Button label to uninstall the app.
      internal static let android = L10n.tr("Localizable", "Button.uninstall.android", fallback: "Uninstall")
    }
    internal enum Wipe {
      /// Button label to wipe the user's application data.
      internal static let android = L10n.tr("Localizable", "Button.wipe.android", fallback: "Wipe")
    }
  }
  internal enum Buy {
    /// 3D Secure label on buy flow
    internal static let _3DSecure = L10n.tr("Localizable", "Buy.3DSecure", fallback: "3D Secure")
    /// ACH fee (%s)
    internal static func achFee(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Buy.achFee", p1, fallback: "ACH fee (%s)")
    }
    /// Currently, minimum for buying with ACH is %s USD and maximum is %s USD per day. At the moment lifetime limit is %s USD.
    /// 
    /// It currently takes 7-10 days to process a purchase with ACH
    internal static func achLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Buy.achLimits", p1, p2, p3, fallback: "Currently, minimum for buying with ACH is %s USD and maximum is %s USD per day. At the moment lifetime limit is %s USD.\n\nIt currently takes 7-10 days to process a purchase with ACH")
    }
    /// Currently, ACH payments will take 7-10 days to complete.
    internal static let achPaymentDurationWarning = L10n.tr("Localizable", "Buy.achPaymentDurationWarning", fallback: "Currently, ACH payments will take 7-10 days to complete.")
    /// ACH payment method was relinked successfully
    internal static let achPaymentMethodRelinked = L10n.tr("Localizable", "Buy.achPaymentMethodRelinked", fallback: "ACH payment method was relinked successfully")
    /// ACH Payments
    internal static let achPayments = L10n.tr("Localizable", "Buy.achPayments", fallback: "ACH Payments")
    /// ACH payment method was added successfully
    internal static let achSuccess = L10n.tr("Localizable", "Buy.achSuccess", fallback: "ACH payment method was added successfully")
    /// Add card title for buy cryptos
    internal static let addCard = L10n.tr("Localizable", "Buy.AddCard", fallback: "Add card")
    /// Add a debit or credit card label on add card flow
    internal static let addDebitCreditCard = L10n.tr("Localizable", "Buy.AddDebitCreditCard", fallback: "Add a debit or credit card")
    /// Address label in billing address view on buy flow
    internal static let address = L10n.tr("Localizable", "Buy.Address", fallback: "Address")
    /// Please try again or select a different payment method.
    internal static let bankAccountFailureText = L10n.tr("Localizable", "Buy.bankAccountFailureText", fallback: "Please try again or select a different payment method.")
    /// It currently takes 7-10 days to process a purchase with ACH. You will receive a confirmation email when your digital assets are delivered to your wallet.
    internal static let bankAccountSuccessText = L10n.tr("Localizable", "Buy.bankAccountSuccessText", fallback: "It currently takes 7-10 days to process a purchase with ACH. You will receive a confirmation email when your digital assets are delivered to your wallet.")
    /// Your purchase is being processed
    internal static let bankAccountSuccessTitle = L10n.tr("Localizable", "Buy.bankAccountSuccessTitle", fallback: "Your purchase is being processed")
    /// Billing address label on buy flow
    internal static let billingAddress = L10n.tr("Localizable", "Buy.BillingAddress", fallback: "Billing address")
    /// Buy min and max limit text
    internal static func buyLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Buy.BuyLimits", p1, p2, fallback: "Currently, minimum for Buy is %s USD and maximum is %s USD/day")
    }
    /// BUY WITH CARDS
    internal static let buyWithCard = L10n.tr("Localizable", "Buy.buyWithCard", fallback: "BUY WITH CARDS")
    /// Buy with card
    internal static let buyWithCardButton = L10n.tr("Localizable", "Buy.BuyWithCardButton", fallback: "Buy with card")
    /// Card label on add card flow
    internal static let card = L10n.tr("Localizable", "Buy.Card", fallback: "Card")
    /// CVV label in add card flow
    internal static let cardCVV = L10n.tr("Localizable", "Buy.CardCVV", fallback: "CVV")
    /// Card fee message label in order preview screen
    internal static let cardFee = L10n.tr("Localizable", "Buy.CardFee", fallback: "This fee is charged to cover costs associated with payment processing.")
    /// Card number label in add card flow
    internal static let cardNumber = L10n.tr("Localizable", "Buy.CardNumber", fallback: "Card number")
    /// XXXX XXXX XXXX XXXX
    internal static let cardNumberHint = L10n.tr("Localizable", "Buy.CardNumberHint", fallback: "XXXX XXXX XXXX XXXX")
    /// Card removal failed error message on delete card flow
    internal static let cardRemovalFailed = L10n.tr("Localizable", "Buy.CardRemovalFailed", fallback: "Card removal failed. Please try again.")
    /// Card removed message on delete card flow
    internal static let cardRemoved = L10n.tr("Localizable", "Buy.CardRemoved", fallback: "Card removed")
    /// City label in billing address view on buy flow
    internal static let city = L10n.tr("Localizable", "Buy.City", fallback: "City")
    /// Please confirm your CVV label in payment view
    internal static let confirmCVV = L10n.tr("Localizable", "Buy.ConfirmCVV", fallback: "Please confirm your CVV")
    /// Country
    internal static let country = L10n.tr("Localizable", "Buy.Country", fallback: "Country")
    /// XXX
    internal static let cvvHint = L10n.tr("Localizable", "Buy.CvvHint", fallback: "XXX")
    /// Buy details title
    internal static let details = L10n.tr("Localizable", "Buy.Details", fallback: "Purchase details")
    /// USDC needs to be enabled in your wallet first. You can enable it here, or by selecting Manage assets on the home screen.
    internal static let disabledUSDCMessage = L10n.tr("Localizable", "Buy.disabledUSDCMessage", fallback: "USDC needs to be enabled in your wallet first. You can enable it here, or by selecting Manage assets on the home screen.")
    /// There was an error while processing your payment title in buy failure screen
    internal static let errorProcessingPayment = L10n.tr("Localizable", "Buy.ErrorProcessingPayment", fallback: "There was an error while processing your payment")
    /// Expiration date
    internal static let expirationDate = L10n.tr("Localizable", "Buy.ExpirationDate", fallback: "Expiration date")
    /// Failure transaction message on buy
    internal static let failureTransactionMessage = L10n.tr("Localizable", "Buy.FailureTransactionMessage", fallback: "Please contact your card issuer/bank or try again with a different payment method.")
    /// First Name label in billing address view on buy flow
    internal static let firstName = L10n.tr("Localizable", "Buy.FirstName", fallback: "First Name")
    /// FUND WITH ACH
    internal static let fundWithAch = L10n.tr("Localizable", "Buy.fundWithAch", fallback: "FUND WITH ACH")
    /// Entered expiration date is not valid!
    internal static let invalidExpirationDate = L10n.tr("Localizable", "Buy.InvalidExpirationDate", fallback: "Entered expiration date is not valid!")
    /// I want
    internal static let iWant = L10n.tr("Localizable", "Buy.iWant", fallback: "I want")
    /// Last Name label in billing address view on buy flow
    internal static let lastName = L10n.tr("Localizable", "Buy.LastName", fallback: "Last Name")
    /// Link bank account
    internal static let linkBankAccount = L10n.tr("Localizable", "Buy.linkBankAccount", fallback: "Link bank account")
    /// Month and year label in add card flow
    internal static let monthYear = L10n.tr("Localizable", "Buy.MonthYear", fallback: "MM/YY")
    /// Network fee message in order preview screen
    internal static let networkFeeMessage = L10n.tr("Localizable", "Buy.NetworkFeeMessage", fallback: "Network fee prices vary depending on the blockchain in which you are receiving your assets. This is an external fee to cover mining and transaction costs.")
    /// Network fees label in order preview screen
    internal static let networkFees = L10n.tr("Localizable", "Buy.NetworkFees", fallback: "Network fees")
    /// Order preview title
    internal static let orderPreview = L10n.tr("Localizable", "Buy.OrderPreview", fallback: "Order preview")
    /// Payment failed error message on order preview screen
    internal static let paymentFailed = L10n.tr("Localizable", "Buy.PaymentFailed", fallback: "Payment failed")
    /// Payment method label in buy select card screen
    internal static let paymentMethod = L10n.tr("Localizable", "Buy.PaymentMethod", fallback: "Payment method")
    /// Pay with label in buy flow
    internal static let payWith = L10n.tr("Localizable", "Buy.PayWith", fallback: "Pay with")
    /// Please check with your bank or try again later.
    internal static let plaidErrorDescription = L10n.tr("Localizable", "Buy.plaidErrorDescription", fallback: "Please check with your bank or try again later.")
    /// There was an error connecting your account via Plaid
    internal static let plaidErrorTitle = L10n.tr("Localizable", "Buy.plaidErrorTitle", fallback: "There was an error connecting your account via Plaid")
    /// Processing payment
    internal static let processingPayment = L10n.tr("Localizable", "Buy.ProcessingPayment", fallback: "Processing payment")
    /// Purchase success text in purchase details screen
    internal static let purchaseSuccessText = L10n.tr("Localizable", "Buy.PurchaseSuccessText", fallback: "This purchase will appear as ‘RockWallet’ on your bank statement.")
    /// Your assets are on the way message in purchase details screen
    internal static let purchaseSuccessTitle = L10n.tr("Localizable", "Buy.PurchaseSuccessTitle", fallback: "Your assets are on the way!")
    /// Re-link bank account
    internal static let relinkBankAccount = L10n.tr("Localizable", "Buy.relinkBankAccount", fallback: "Re-link bank account")
    /// Are you sure you want to remove this card title dialog
    internal static let removeCard = L10n.tr("Localizable", "Buy.RemoveCard", fallback: "Are you sure you want to remove card ending in")
    /// You will no longer be able to use it to buy assets description on removing card dialog
    internal static let removeCardOption = L10n.tr("Localizable", "Buy.RemoveCardOption", fallback: "You will no longer be able to use it to buy assets.")
    /// Remove payment method action sheet option on profile screen
    internal static let removePaymentMethod = L10n.tr("Localizable", "Buy.RemovePaymentMethod", fallback: "Remove payment method")
    /// Security code (CVV) label in add card flow
    internal static let securityCode = L10n.tr("Localizable", "Buy.SecurityCode", fallback: "Security code (CVV)")
    /// Explanation of security code in popup
    internal static let securityCodePopup = L10n.tr("Localizable", "Buy.SecurityCodePopup", fallback: "Please enter the 3 digit CVV number as it appears on the back of your card")
    /// Select a payment method button title in buy flow
    internal static let selectPaymentMethod = L10n.tr("Localizable", "Buy.SelectPaymentMethod", fallback: "Select a payment method")
    /// State/Province label in billing address view on buy flow
    internal static let stateProvince = L10n.tr("Localizable", "Buy.StateProvince", fallback: "State/Province")
    /// Payment method switched to ACH payments!
    internal static let switchedToAch = L10n.tr("Localizable", "Buy.switchedToAch", fallback: "Payment method switched to ACH payments!")
    /// Payment method switched to Debit card!
    internal static let switchedToDebitCard = L10n.tr("Localizable", "Buy.switchedToDebitCard", fallback: "Payment method switched to Debit card!")
    /// By placing this order you agree to our terms message when ordering
    internal static let terms = L10n.tr("Localizable", "Buy.Terms", fallback: "By placing this order you agree to our")
    /// Transaction error
    internal static let transactionError = L10n.tr("Localizable", "Buy.TransactionError", fallback: "Transaction error")
    /// Transfer from bank account
    internal static let transferFromBank = L10n.tr("Localizable", "Buy.transferFromBank", fallback: "Transfer from bank account")
    /// Try a different payment method button title in failure buy screen
    internal static let tryAnotherPayment = L10n.tr("Localizable", "Buy.TryAnotherPayment", fallback: "Try a different payment method")
    /// %s Transaction ID
    internal static func txHashHeader(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Buy.txHashHeader", p1, fallback: "%s Transaction ID")
    }
    /// I understand and agree
    internal static let understandAndAgree = L10n.tr("Localizable", "Buy.understandAndAgree", fallback: "I understand and agree")
    /// Your order label in buy flow
    internal static let yourOrder = L10n.tr("Localizable", "Buy.YourOrder", fallback: "Your order:")
    /// ZIP/Postal Code label in billing address view on buy flow
    internal static let zipPostalCode = L10n.tr("Localizable", "Buy.ZIPPostalCode", fallback: "ZIP/Postal Code")
    internal enum Ach {
      /// Your bank account has been unlinked from RockWallet for security purposes. Please link it again to continue using ACH payments.
      internal static let accountUnlinked = L10n.tr("Localizable", "Buy.Ach.AccountUnlinked", fallback: "Your bank account has been unlinked from RockWallet for security purposes. Please link it again to continue using ACH payments.")
      /// Fund with ACH isn’t available in your region. We'll notify you when this feature is released. You can still buy digital assets with a debit/credit card.
      internal static let notAvailableBody = L10n.tr("Localizable", "Buy.Ach.NotAvailableBody", fallback: "Fund with ACH isn’t available in your region. We'll notify you when this feature is released. You can still buy digital assets with a debit/credit card.")
      /// Sorry! This feature is unavailable
      internal static let notAvailableTitle = L10n.tr("Localizable", "Buy.Ach.NotAvailableTitle", fallback: "Sorry! This feature is unavailable")
      /// %s needs to be enabled in your wallet first. Kindly enable it %s, or by selecting 'Manage assets' on the home screen.
      internal static func walletDisabled(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Buy.Ach.WalletDisabled", p1, p2, fallback: "%s needs to be enabled in your wallet first. Kindly enable it %s, or by selecting 'Manage assets' on the home screen.")
      }
      internal enum WalletDisabled {
        /// here
        internal static let link = L10n.tr("Localizable", "Buy.Ach.WalletDisabled.Link", fallback: "here")
        /// Manage assets
        internal static let manageAssets = L10n.tr("Localizable", "Buy.Ach.WalletDisabled.ManageAssets", fallback: "Manage assets")
      }
    }
    internal enum BuyLimits {
      /// Currently, minimum for Buy is $30.00 USD and maximum is $500.00 USD per day.
      internal static let android = L10n.tr("Localizable", "Buy.BuyLimits.android", fallback: "Currently, minimum for Buy is $30.00 USD and maximum is $500.00 USD per day.")
    }
    internal enum RemoveCard {
      /// Are you sure you want to remove card ending in %s?
      internal static func android(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Buy.RemoveCard.android", p1, fallback: "Are you sure you want to remove card ending in %s?")
      }
    }
    internal enum Terms {
      /// By placing this order you agree to our %s
      internal static func android(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Buy.Terms.android", p1, fallback: "By placing this order you agree to our %s")
      }
    }
  }
  internal enum CameraPlugin {
    /// Camera plugin instruction
    internal static let centerInstruction = L10n.tr("Localizable", "CameraPlugin.centerInstruction", fallback: "Center your ID in the box")
  }
  internal enum CashToken {
    /// Cash Token Action Instructions
    internal static let actionInstructions = L10n.tr("Localizable", "CashToken.actionInstructions", fallback: "Please send bitcoin to this address to withdraw at the ATM. Scan QR code or copy and paste to send bitcoin. Note that it may take a few minutes for the transfer to be confirmed.")
    /// Cash Token Location
    internal static let amountBTC = L10n.tr("Localizable", "CashToken.amountBTC", fallback: "Amount (BTC)")
    /// Cash Token Amount
    internal static let amountUSD = L10n.tr("Localizable", "CashToken.amountUSD", fallback: "Amount (USD)")
    /// Cash Token Label
    internal static let awaitingFunds = L10n.tr("Localizable", "CashToken.awaitingFunds", fallback: "Awaiting Funds")
    /// Cash Token Label
    internal static let label = L10n.tr("Localizable", "CashToken.label", fallback: "Withdrawl Status")
    /// Cash Token Location
    internal static let location = L10n.tr("Localizable", "CashToken.location", fallback: "Location")
    /// Cash Token Please Verify
    internal static let pleaseVerify = L10n.tr("Localizable", "CashToken.pleaseVerify", fallback: "Please Verify")
  }
  internal enum CloudBackup {
    /// Backup Erased
    internal static let backupDeleted = L10n.tr("Localizable", "CloudBackup.backupDeleted", fallback: "Backup Erased")
    /// Your iCloud backup has been erased after too many failed PIN attempts. The app will now restart.
    internal static let backupDeletedMessage = L10n.tr("Localizable", "CloudBackup.backupDeletedMessage", fallback: "Your iCloud backup has been erased after too many failed PIN attempts. The app will now restart.")
    /// iCloud Backup
    internal static let backupMenuTitle = L10n.tr("Localizable", "CloudBackup.backupMenuTitle", fallback: "iCloud Backup")
    /// CREATE NEW WALLET
    internal static let createButton = L10n.tr("Localizable", "CloudBackup.createButton", fallback: "CREATE NEW WALLET")
    /// A previously backed up wallet has been detected. Using this backup is recomended. Are you sure you want to proceeed with creating a new wallet?
    internal static let createWarning = L10n.tr("Localizable", "CloudBackup.createWarning", fallback: "A previously backed up wallet has been detected. Using this backup is recomended. Are you sure you want to proceeed with creating a new wallet?")
    /// iCloud Keychain must be turned on for this feature to work.
    internal static let enableBody1 = L10n.tr("Localizable", "CloudBackup.enableBody1", fallback: "iCloud Keychain must be turned on for this feature to work.")
    /// It should look like the following:
    internal static let enableBody2 = L10n.tr("Localizable", "CloudBackup.enableBody2", fallback: "It should look like the following:")
    /// I HAVE TURNED ON ICLOUD KEYCHAIN
    internal static let enableButton = L10n.tr("Localizable", "CloudBackup.enableButton", fallback: "I HAVE TURNED ON ICLOUD KEYCHAIN")
    /// Enable Keychain
    internal static let enableTitle = L10n.tr("Localizable", "CloudBackup.enableTitle", fallback: "Enable Keychain")
    /// Enter pin to encrypt backup
    internal static let encryptBackupMessage = L10n.tr("Localizable", "CloudBackup.encryptBackupMessage", fallback: "Enter pin to encrypt backup")
    /// Please note, iCloud backup is only as secure as your iCloud account. We still recommend writing down your Recovery Phrase in the following step and keeping it secure. The Recovery Phrase is the only way to recover your wallet if you can no longer access iCloud.
    internal static let mainBody = L10n.tr("Localizable", "CloudBackup.mainBody", fallback: "Please note, iCloud backup is only as secure as your iCloud account. We still recommend writing down your Recovery Phrase in the following step and keeping it secure. The Recovery Phrase is the only way to recover your wallet if you can no longer access iCloud.")
    /// iCloud Recovery Backup
    internal static let mainTitle = L10n.tr("Localizable", "CloudBackup.mainTitle", fallback: "iCloud Recovery Backup")
    /// iCloud Keychain must be turned on in the iOS Settings app for this feature to work
    internal static let mainWarning = L10n.tr("Localizable", "CloudBackup.mainWarning", fallback: "iCloud Keychain must be turned on in the iOS Settings app for this feature to work")
    /// Are you sure you want to disable iCloud Backup? This will delete your backup from all devices.
    internal static let mainWarningConfirmation = L10n.tr("Localizable", "CloudBackup.mainWarningConfirmation", fallback: "Are you sure you want to disable iCloud Backup? This will delete your backup from all devices.")
    /// Attempts remaining before erasing backup: %1$@
    internal static func pinAttempts(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CloudBackup.pinAttempts", String(describing: p1), fallback: "Attempts remaining before erasing backup: %1$@")
    }
    /// Restore with Recovery Phrase
    internal static let recoverButton = L10n.tr("Localizable", "CloudBackup.recoverButton", fallback: "Restore with Recovery Phrase")
    /// Enter PIN to unlock iCloud backup
    internal static let recoverHeader = L10n.tr("Localizable", "CloudBackup.recoverHeader", fallback: "Enter PIN to unlock iCloud backup")
    /// A previously backed up wallet has been detected. Using this backup is recommended. Are you sure you want to proceeed with restoring from a Recovery Phrase?
    internal static let recoverWarning = L10n.tr("Localizable", "CloudBackup.recoverWarning", fallback: "A previously backed up wallet has been detected. Using this backup is recommended. Are you sure you want to proceeed with restoring from a Recovery Phrase?")
    /// Restore with iCloud Backup
    internal static let restoreButton = L10n.tr("Localizable", "CloudBackup.restoreButton", fallback: "Restore with iCloud Backup")
    /// Choose Backup
    internal static let selectTitle = L10n.tr("Localizable", "CloudBackup.selectTitle", fallback: "Choose Backup")
    /// Launch the Settings app.
    internal static let step1 = L10n.tr("Localizable", "CloudBackup.step1", fallback: "Launch the Settings app.")
    /// Tap your Apple ID name.
    internal static let step2 = L10n.tr("Localizable", "CloudBackup.step2", fallback: "Tap your Apple ID name.")
    /// Tap iCloud.
    internal static let step3 = L10n.tr("Localizable", "CloudBackup.step3", fallback: "Tap iCloud.")
    /// Verify that iCloud Keychain is ON
    internal static let step4 = L10n.tr("Localizable", "CloudBackup.step4", fallback: "Verify that iCloud Keychain is ON")
    /// I understand that this feature will not work unless iCloud Keychain is enabled.
    internal static let understandText = L10n.tr("Localizable", "CloudBackup.understandText", fallback: "I understand that this feature will not work unless iCloud Keychain is enabled.")
    /// Your iCloud backup will be erased after %1$@ more incorrect PIN attempts.
    internal static func warningBody(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CloudBackup.warningBody", String(describing: p1), fallback: "Your iCloud backup will be erased after %1$@ more incorrect PIN attempts.")
    }
  }
  internal enum ComingSoon {
    /// Buy and Swap aren't currently available in your state. We'll notify you when you can use these features.
    /// 
    /// You can still safely send and receive digital assets to your wallet in the meantime.
    internal static let body = L10n.tr("Localizable", "ComingSoon.body", fallback: "Buy and Swap aren't currently available in your state. We'll notify you when you can use these features.\n\nYou can still safely send and receive digital assets to your wallet in the meantime.")
    /// Coming soon!
    internal static let title = L10n.tr("Localizable", "ComingSoon.title", fallback: "Coming soon!")
    internal enum Buttons {
      /// BACK TO HOME
      internal static let backHome = L10n.tr("Localizable", "ComingSoon.buttons.backHome", fallback: "BACK TO HOME")
      /// Contact support
      internal static let contactSupport = L10n.tr("Localizable", "ComingSoon.buttons.contactSupport", fallback: "Contact support")
    }
  }
  internal enum ConfirmGift {
    /// Paper Wallet Amount
    internal static let paperWalletAmount = L10n.tr("Localizable", "ConfirmGift.paperWalletAmount", fallback: "Paper Wallet Amount")
    /// Validating this paper wallet on the network may take up to 60 minutes
    internal static let processingTime = L10n.tr("Localizable", "ConfirmGift.processingTime", fallback: "Validating this paper wallet on the network may take up to 60 minutes")
  }
  internal enum ConfirmPaperPhrase {
    /// Confirm paper phrase error message
    internal static let error = L10n.tr("Localizable", "ConfirmPaperPhrase.error", fallback: "The words entered do not match your Recovery Phrase. Please try again.")
    /// Confirm paper phrase view label.
    internal static let label = L10n.tr("Localizable", "ConfirmPaperPhrase.label", fallback: "To make sure everything was written down correctly, please enter the following words from your Recovery Phrase.")
    /// Word label eg. Word #1, Word #2
    internal static func word(_ p1: Any) -> String {
      return L10n.tr("Localizable", "ConfirmPaperPhrase.word", String(describing: p1), fallback: "Word #%1$@")
    }
  }
  internal enum ConfirmRecoveryPhrase {
    /// Confirm Recovery Phrase
    internal static let title = L10n.tr("Localizable", "ConfirmRecoveryPhrase.Title", fallback: "Confirm Recovery Phrase")
  }
  internal enum Confirmation {
    /// Amount to Send: ($1.00)
    internal static let amountLabel = L10n.tr("Localizable", "Confirmation.amountLabel", fallback: "Amount to Send:")
    /// Destination Tag
    internal static let destinationTag = L10n.tr("Localizable", "Confirmation.destinationTag", fallback: "Destination Tag")
    /// (empty)
    internal static let destinationTagEmptyHint = L10n.tr("Localizable", "Confirmation.destinationTag_EmptyHint", fallback: "(empty)")
    /// Network Fee: ($1.00)
    internal static let feeLabel = L10n.tr("Localizable", "Confirmation.feeLabel", fallback: "Network Fee:")
    /// Network Fee: (ETH)
    internal static let feeLabelETH = L10n.tr("Localizable", "Confirmation.feeLabelETH", fallback: "Network Fee (ETH):")
    /// Label for Hedera Memo field on transaction confirmation screen
    internal static let hederaMemo = L10n.tr("Localizable", "Confirmation.hederaMemo", fallback: "Hedera Memo")
    /// eg. Processing time: This transaction is predicted to complete in [10-60 minutes].
    internal static func processingTime(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Confirmation.processingTime", String(describing: p1), fallback: "Processing time: This transaction is predicted to complete in %1$@.")
    }
    /// Label for "send" button on final confirmation screen
    internal static let send = L10n.tr("Localizable", "Confirmation.send", fallback: "Send")
    /// Confirmation Screen title
    internal static let title = L10n.tr("Localizable", "Confirmation.title", fallback: "Confirmation")
    /// To: (address)
    internal static let to = L10n.tr("Localizable", "Confirmation.to", fallback: "To")
    /// Total Cost: ($5.00)
    internal static let totalLabel = L10n.tr("Localizable", "Confirmation.totalLabel", fallback: "Total Cost:")
    /// Validator address label on  confirmation screen
    internal static let validatorAddress = L10n.tr("Localizable", "Confirmation.ValidatorAddress", fallback: "Validator Address")
  }
  internal enum CreateGift {
    /// Choose amount ($USD)
    internal static let amountLabel = L10n.tr("Localizable", "CreateGift.amountLabel", fallback: "Choose amount ($USD)")
    /// Create
    internal static let create = L10n.tr("Localizable", "CreateGift.create", fallback: "Create")
    /// Custom amount ($500 max)
    internal static let customAmountHint = L10n.tr("Localizable", "CreateGift.customAmountHint", fallback: "Custom amount ($500 max)")
    /// We'll create what's called a
    internal static let description = L10n.tr("Localizable", "CreateGift.description", fallback: "We'll create what's called a")
    /// You must select a gift amount.
    internal static let inputAmountError = L10n.tr("Localizable", "CreateGift.inputAmountError", fallback: "You must select a gift amount.")
    /// You must enter the name of the recipient.
    internal static let inputRecipientNameError = L10n.tr("Localizable", "CreateGift.inputRecipientNameError", fallback: "You must enter the name of the recipient.")
    /// You have insufficient funds to send a gift.
    internal static let insufficientBalanceError = L10n.tr("Localizable", "CreateGift.insufficientBalanceError", fallback: "You have insufficient funds to send a gift.")
    /// You have insufficient funds to send a gift of this amount.
    internal static let insufficientBalanceForAmountError = L10n.tr("Localizable", "CreateGift.insufficientBalanceForAmountError", fallback: "You have insufficient funds to send a gift of this amount.")
    /// Recipient's name
    internal static let recipientName = L10n.tr("Localizable", "CreateGift.recipientName", fallback: "Recipient's name")
    /// A server error occurred. Please try again later.
    internal static let serverError = L10n.tr("Localizable", "CreateGift.serverError", fallback: "A server error occurred. Please try again later.")
    /// Send bitcoin to someone even if they don't have a wallet.
    internal static let subtitle = L10n.tr("Localizable", "CreateGift.subtitle", fallback: "Send bitcoin to someone even if they don't have a wallet.")
    /// Give the Gift of Bitcoin
    internal static let title = L10n.tr("Localizable", "CreateGift.title", fallback: "Give the Gift of Bitcoin")
    /// An unexpected error occurred. Please contact support.
    internal static let unexpectedError = L10n.tr("Localizable", "CreateGift.unexpectedError", fallback: "An unexpected error occurred. Please contact support.")
  }
  internal enum Crowdsale {
    /// Agree to legal terms button
    internal static let agree = L10n.tr("Localizable", "Crowdsale.agree", fallback: "Agree")
    /// As in "(tap here to) buy (some) tokens"
    internal static let buyButton = L10n.tr("Localizable", "Crowdsale.buyButton", fallback: "Buy Tokens")
    /// Decline to legal terms button
    internal static let decline = L10n.tr("Localizable", "Crowdsale.decline", fallback: "Decline")
    /// Resume Idnetify verification button
    internal static let resume = L10n.tr("Localizable", "Crowdsale.resume", fallback: "Resume Verification")
    /// Retry Identity verification button
    internal static let retry = L10n.tr("Localizable", "Crowdsale.retry", fallback: "Retry")
  }
  internal enum DefaultCurrency {
    /// Bitcoin denomination picker label
    internal static let bitcoinLabel = L10n.tr("Localizable", "DefaultCurrency.bitcoinLabel", fallback: "Bitcoin Display Unit")
    /// Exchange rate label
    internal static let rateLabel = L10n.tr("Localizable", "DefaultCurrency.rateLabel", fallback: "Exchange Rate")
  }
  internal enum Disabled {
    /// Disabled until
    internal static let disabledUntil = L10n.tr("Localizable", "Disabled.disabledUntil", fallback: "Disabled until")
    /// The wallet is disabled.
    internal static let title = L10n.tr("Localizable", "Disabled.title", fallback: "Wallet disabled")
  }
  internal enum Drawer {
    /// title of the drawer shown after buy/sell button tap on home screen
    internal static let title = L10n.tr("Localizable", "Drawer.title", fallback: "Buy / Sell")
    internal enum Button {
      /// SELL & WITHDRAW
      internal static let buyWithSell = L10n.tr("Localizable", "Drawer.button.buy_with_sell", fallback: "SELL & WITHDRAW")
    }
  }
  internal enum Eme {
    internal enum Permissions {
      /// Service capabilities description
      internal static func accountRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.accountRequest", String(describing: p1), fallback: "Request %1$@ account information")
      }
      /// Service capabilities description
      internal static func callRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.callRequest", String(describing: p1), fallback: "Request %1$@ smart contract call")
      }
      /// Service capabilities description
      internal static func paymentRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.paymentRequest", String(describing: p1), fallback: "Request %1$@ payment")
      }
    }
  }
  internal enum Email {
    /// Share address by e-mail subject
    internal static func addressSubject(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Email.address_subject", String(describing: p1), fallback: "%1$@ Address")
    }
  }
  internal enum ErrorMessages {
    /// You cannot purchase assets without completing Level 2 account verification. Upgrade your limits on the Profile screen.
    internal static let accessDenied = L10n.tr("Localizable", "ErrorMessages.accessDenied", fallback: "You cannot purchase assets without completing Level 2 account verification. Upgrade your limits on the Profile screen.")
    /// The currency amount is to high for exchange. Accepts 2 parameters:, - maxiumum amount, - currency code
    internal static func amountTooHigh(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.AmountTooHigh", p1, p2, fallback: "The amount is higher than your daily limit of %s %s. Please enter a lower amount.")
    }
    /// The currency amount is to low for exchange. Accepts 2 parameters:, - minimum amount, - currency code
    internal static func amountTooLow(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.amountTooLow", p1, p2, fallback: "The amount is lower than the minimum of %s %s. Please enter a higher amount.")
    }
    /// Card authorization failed. Please contact your credit card issuer/bank or try another card.
    internal static let authorizationFailed = L10n.tr("Localizable", "ErrorMessages.authorizationFailed", fallback: "Card authorization failed. Please contact your credit card issuer/bank or try another card.")
    /// Accepts 3 parameters:, - currency code, - current balance, - (same) currency code
    internal static func balanceTooLow(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.balanceTooLow", p1, p2, p3, fallback: "You need %s %s in your wallet to cover network fees. Please add more %s to your wallet.")
    }
    /// Check your internet connection message
    internal static let checkInternet = L10n.tr("Localizable", "ErrorMessages.CheckInternet", fallback: "Please, check your internet connection and try again later.")
    /// Something went wrong! Try again later.
    internal static let `default` = L10n.tr("Localizable", "ErrorMessages.default", fallback: "Something went wrong! Try again later.")
    /// Email unavailable alert title
    internal static let emailUnavailableMessage = L10n.tr("Localizable", "ErrorMessages.emailUnavailableMessage", fallback: "This device isn't configured to send email with the iOS mail app.")
    /// Email unavailable alert title
    internal static let emailUnavailableTitle = L10n.tr("Localizable", "ErrorMessages.emailUnavailableTitle", fallback: "Email Unavailable")
    /// Not enough ETH for transaction fee
    internal static func ethBalanceLowAddEth(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.ethBalanceLowAddEth", p1, fallback: "%s is an ERC-20 token on the Ethereum blockchain and requires ETH network fees. Please add ETH to your wallet.")
    }
    /// Swap failed. Reason: %s.
    internal static func exchangeFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.exchangeFailed", p1, fallback: "Swap failed. Reason: %s.")
    }
    /// We are currently having issues making a swap between this pair of coins. Please try again later.
    internal static let exchangeQuoteFailed = L10n.tr("Localizable", "ErrorMessages.ExchangeQuoteFailed", fallback: "We are currently having issues making a swap between this pair of coins. Please try again later.")
    /// We are having temporary network issues. Please try again later.
    internal static let exchangesUnavailable = L10n.tr("Localizable", "ErrorMessages.ExchangesUnavailable", fallback: "We are having temporary network issues. Please try again later.")
    /// Minimum buy/swap amount for this pair is temporarily higher due to higher withdrawal network fees. Try other pairs or try again later.
    internal static let highWidrawalFee = L10n.tr("Localizable", "ErrorMessages.highWidrawalFee", fallback: "Minimum buy/swap amount for this pair is temporarily higher due to higher withdrawal network fees. Try other pairs or try again later.")
    /// Messaging unavailable alert title
    internal static let messagingUnavailableMessage = L10n.tr("Localizable", "ErrorMessages.messagingUnavailableMessage", fallback: "This device isn't configured to send messages.")
    /// Messaging unavailable alert title
    internal static let messagingUnavailableTitle = L10n.tr("Localizable", "ErrorMessages.messagingUnavailableTitle", fallback: "Messaging Unavailable")
    /// This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping.
    internal static let networkFee = L10n.tr("Localizable", "ErrorMessages.networkFee", fallback: "This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping.")
    /// Temporary network issues error message
    internal static let networkIssues = L10n.tr("Localizable", "ErrorMessages.NetworkIssues", fallback: "We are having temporary network issues. Please try again later.")
    /// No selected currencies error message
    internal static let noCurrencies = L10n.tr("Localizable", "ErrorMessages.NoCurrencies", fallback: "No selected currencies.")
    /// Failed to fetch network fees. Please try again later.
    internal static let noFees = L10n.tr("Localizable", "ErrorMessages.noFees", fallback: "Failed to fetch network fees. Please try again later.")
    /// Accepts 2 parameters:, - first currency code, - second currency code
    internal static func noQuoteForPair(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.noQuoteForPair", p1, p2, fallback: "No quote for currency pair %s-%s.")
    }
    /// The amount is higher than your daily limit of %s USD. Please upgrade your account or enter a lower amount.
    internal static func overDailyLimit(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overDailyLimit", p1, fallback: "The amount is higher than your daily limit of %s USD. Please upgrade your account or enter a lower amount.")
    }
    /// Over exchange limit.
    internal static let overExchangeLimit = L10n.tr("Localizable", "ErrorMessages.overExchangeLimit", fallback: "Over exchange limit.")
    /// The amount is higher than your lifetime limit of %s USD. Please upgrade your account or enter a lower amount.
    internal static func overLifetimeLimit(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overLifetimeLimit", p1, fallback: "The amount is higher than your lifetime limit of %s USD. Please upgrade your account or enter a lower amount.")
    }
    /// The amount is higher than your daily limit of %s USD. Please enter a lower amount.
    internal static func overLifetimeLimitLevel2(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overLifetimeLimitLevel2", p1, fallback: "The amount is higher than your daily limit of %s USD. Please enter a lower amount.")
    }
    /// A maximum of one swap can be active for a currency at a time.
    internal static let pendingExchange = L10n.tr("Localizable", "ErrorMessages.pendingExchange", fallback: "A maximum of one swap can be active for a currency at a time.")
    /// PIN Authentication failed.
    internal static let pinConfirmationFailed = L10n.tr("Localizable", "ErrorMessages.pinConfirmationFailed", fallback: "PIN Authentication failed.")
    /// In order to succesfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.
    internal static let selectAssets = L10n.tr("Localizable", "ErrorMessages.selectAssets", fallback: "In order to succesfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.")
    /// Something went wrong message
    internal static let somethingWentWrong = L10n.tr("Localizable", "ErrorMessages.SomethingWentWrong", fallback: "Oops! Something went wrong, please try again later.")
    /// Two parameters:, - maximum amount, - currency code
    internal static func swapAmountTooHigh(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.swapAmountTooHigh", p1, p2, fallback: "The amount is higher than the swap maximum of %s %s.")
    }
    /// We are having temporary issues connecting to our network. Please try again later.
    internal static let temporaryNetworkIssues = L10n.tr("Localizable", "ErrorMessages.temporaryNetworkIssues", fallback: "We are having temporary issues connecting to our network. Please try again later.")
    /// Unknown error text message
    internal static let unknownError = L10n.tr("Localizable", "ErrorMessages.UnknownError", fallback: "Unknown error.")
    internal enum Ach {
      /// Unfortunately, the linked bank account is closed. Please try adding a different bank account or a different payment method.
      internal static let accountClosed = L10n.tr("Localizable", "ErrorMessages.Ach.AccountClosed", fallback: "Unfortunately, the linked bank account is closed. Please try adding a different bank account or a different payment method.")
      /// Unfortunately, there was an error while processing your transaction. Please try again later or contact your bank for additional assistance.
      internal static let accountFrozen = L10n.tr("Localizable", "ErrorMessages.Ach.AccountFrozen", fallback: "Unfortunately, there was an error while processing your transaction. Please try again later or contact your bank for additional assistance.")
      /// Unfortunately, there was an error while processing your transaction. Please try again later or select a different payment method.
      internal static let errorWhileProcessing = L10n.tr("Localizable", "ErrorMessages.Ach.ErrorWhileProcessing", fallback: "Unfortunately, there was an error while processing your transaction. Please try again later or select a different payment method.")
      /// Unfortunately the transaction could not be completed due to insufficient funds in your bank account. Please try again later
      internal static let insufficientFunds = L10n.tr("Localizable", "ErrorMessages.Ach.InsufficientFunds", fallback: "Unfortunately the transaction could not be completed due to insufficient funds in your bank account. Please try again later")
    }
    internal enum Kyc {
      /// You must be at least 18 years old to complete Level 1 and 2 verification.
      internal static let underage = L10n.tr("Localizable", "ErrorMessages.Kyc.Underage", fallback: "You must be at least 18 years old to complete Level 1 and 2 verification.")
    }
    internal enum LoopingLockScreen {
      /// Message that gets shown when we've detected the user has encountered the looping lock-screen bug. (preserve [ ] characters)
      internal static let android = L10n.tr("Localizable", "ErrorMessages.loopingLockScreen.android", fallback: "RockWallet can not be authenticated due to a bug in your version of Android. [Please tap here for more information.]")
    }
    internal enum TouchIdFailed {
      /// Fingerprint was not recognized by the scanner, please try scanning again
      internal static let android = L10n.tr("Localizable", "ErrorMessages.touchIdFailed.android", fallback: "Fingerprint not recognized. Please try again.")
    }
  }
  internal enum ExportConfirmation {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "ExportConfirmation.cancel", fallback: "Cancel")
    /// 
    internal static let `continue` = L10n.tr("Localizable", "ExportConfirmation.continue", fallback: "")
    /// Continue
    internal static let continueAction = L10n.tr("Localizable", "ExportConfirmation.continueAction", fallback: "Continue")
    /// This will generate a CSV file including all completed transactions from all enabled wallets.
    internal static let message = L10n.tr("Localizable", "ExportConfirmation.message", fallback: "This will generate a CSV file including all completed transactions from all enabled wallets.")
    /// Export transactions?
    internal static let title = L10n.tr("Localizable", "ExportConfirmation.title", fallback: "Export transactions?")
  }
  internal enum ExportTransfers {
    /// "Export transfers body"
    internal static let body = L10n.tr("Localizable", "ExportTransfers.body", fallback: "This will generate a CSV file including all completed transactions from all enabled wallets.")
    /// "Export transfers button"
    internal static let confirmExport = L10n.tr("Localizable", "ExportTransfers.confirmExport", fallback: "Export")
    /// "Export dialog error message"
    internal static let exportFailedBody = L10n.tr("Localizable", "ExportTransfers.exportFailedBody", fallback: "Failed to export CSV file, please try again.")
    /// "Export dialog error title"
    internal static let exportFailedTitle = L10n.tr("Localizable", "ExportTransfers.exportFailedTitle", fallback: "Export Failed")
    /// "Export transfers header"
    internal static let header = L10n.tr("Localizable", "ExportTransfers.header", fallback: "Export transactions?")
  }
  internal enum FaceIDSettings {
    /// You can customize your Face ID Spending Limit from the [menu]
    internal static func customizeText(_ p1: Any) -> String {
      return L10n.tr("Localizable", "FaceIDSettings.customizeText", String(describing: p1), fallback: "You can customize your Face ID spending limit from the %1$@.")
    }
    /// Text describing the purpose of the Face ID settings in the BRD app.
    internal static let explanatoryText = L10n.tr("Localizable", "FaceIDSettings.explanatoryText", fallback: "Use Face ID to unlock your RockWallet app and send money.")
    /// Face Id screen label
    internal static let label = L10n.tr("Localizable", "FaceIDSettings.label", fallback: "Use your face to unlock your RockWallet and send money up to a set limit.")
    /// Title of the screen for setting the Face ID Spending Limit
    internal static let linkText = L10n.tr("Localizable", "FaceIDSettings.linkText", fallback: "Face ID Spending Limit Screen")
    /// Setting to turn on Face ID for BRD
    internal static let switchLabel = L10n.tr("Localizable", "FaceIDSettings.switchLabel", fallback: "Enable Face ID for RockWallet")
    /// Face ID settings view title
    internal static let title = L10n.tr("Localizable", "FaceIDSettings.title", fallback: "Face ID")
    /// Text label for a toggle that enables Face ID for sending money.
    internal static let transactionsTitleText = L10n.tr("Localizable", "FaceIDSettings.transactionsTitleText", fallback: "Enable Face ID to send money")
    /// Instructions on how to turn on face id on the iPhone. Please ensure the name of the menu in this string matches the wording Apple uses in the iPhone menu.
    internal static let unavailableAlertMessage = L10n.tr("Localizable", "FaceIDSettings.unavailableAlertMessage", fallback: "You have not set up Face ID on this device. Go to Settings->Face ID & Passcode to set it up now.")
    /// Face ID unavailable alert title
    internal static let unavailableAlertTitle = L10n.tr("Localizable", "FaceIDSettings.unavailableAlertTitle", fallback: "Face ID Not Set Up")
    /// Text label for a toggle that enables Face ID for unlocking the BRD app.
    internal static let unlockTitleText = L10n.tr("Localizable", "FaceIDSettings.unlockTitleText", fallback: "Enable Face ID to unlock RockWallet")
  }
  internal enum FaceIDSpendingLimit {
    /// Face Id spending limit screen title
    internal static let title = L10n.tr("Localizable", "FaceIDSpendingLimit.title", fallback: "Face ID Spending Limit")
  }
  internal enum FeeSelector {
    /// Economy fee
    internal static let economy = L10n.tr("Localizable", "FeeSelector.economy", fallback: "Economy")
    /// E.g. [This transaction is predicted to complete in] 1-24 hours
    internal static let economyTime = L10n.tr("Localizable", "FeeSelector.economyTime", fallback: "1-24 hours")
    /// Warning message for economy fee
    internal static let economyWarning = L10n.tr("Localizable", "FeeSelector.economyWarning", fallback: "This option is not recommended for time-sensitive transactions.")
    /// E.g. Estimated delivery: 10-60 minutes
    internal static func estimatedDeliver(_ p1: Any) -> String {
      return L10n.tr("Localizable", "FeeSelector.estimatedDeliver", String(describing: p1), fallback: "Estimated Delivery: %1$@")
    }
    /// [This transaction will complete in] 2-5 minutes
    internal static let ethTime = L10n.tr("Localizable", "FeeSelector.ethTime", fallback: "2-5 minutes")
    /// <%1$d minutes
    internal static func lessThanMinutes(_ p1: Int) -> String {
      return L10n.tr("Localizable", "FeeSelector.lessThanMinutes", p1, fallback: "<%1$d minutes")
    }
    /// Priority fee
    internal static let priority = L10n.tr("Localizable", "FeeSelector.priority", fallback: "Priority")
    /// E.g. [This transaction is predicted to complete in] 10-30 minutes
    internal static let priorityTime = L10n.tr("Localizable", "FeeSelector.priorityTime", fallback: "10-30 minutes")
    /// Regular fee
    internal static let regular = L10n.tr("Localizable", "FeeSelector.regular", fallback: "Regular")
    /// E.g. [This transaction is predicted to complete in] 10-60 minutes
    internal static let regularTime = L10n.tr("Localizable", "FeeSelector.regularTime", fallback: "10-60 minutes")
    /// Fee Selector title
    internal static let title = L10n.tr("Localizable", "FeeSelector.title", fallback: "Processing Speed")
  }
  internal enum FileChooser {
    internal enum SelectImageSource {
      /// Label for the Android file chooser when we need to prompt the user to select an image file.
      internal static let android = L10n.tr("Localizable", "FileChooser.selectImageSource.android", fallback: "Select Image Source")
    }
  }
  internal enum FingerprintSettings {
    /// Fingerprint authentication settings screen description
    internal static let description = L10n.tr("Localizable", "FingerprintSettings.description", fallback: "Use your fingerprint to unlock your RockWallet app and send transactions.")
    /// Switch label to enable fingerprint authentication to send money
    internal static let sendMoney = L10n.tr("Localizable", "FingerprintSettings.sendMoney", fallback: "Use fingerprint to send money")
    /// Fingerprint authentication settings sceen title
    internal static let title = L10n.tr("Localizable", "FingerprintSettings.title", fallback: "Fingerprint")
    /// Switch label to enable fingerprint authentication to unlock BRD app
    internal static let unlockApp = L10n.tr("Localizable", "FingerprintSettings.unlockApp", fallback: "Use fingerprint to unlock RockWallet")
  }
  internal enum HomeScreen {
    /// Activity button on the home screen toolbar
    internal static let activity = L10n.tr("Localizable", "HomeScreen.activity", fallback: "Activity")
    /// This is the section that allows administration of the user's wallet
    internal static let admin = L10n.tr("Localizable", "HomeScreen.admin", fallback: "Admin")
    /// Home screen menu button to buy some bitcoin
    internal static let buy = L10n.tr("Localizable", "HomeScreen.buy", fallback: "Buy")
    /// home screen toolbar 'Buy & Sell' button
    internal static let buyAndSell = L10n.tr("Localizable", "HomeScreen.buyAndSell", fallback: "Buy & Sell")
    /// Menu button on the home screen toolbar
    internal static let menu = L10n.tr("Localizable", "HomeScreen.menu", fallback: "Menu")
    /// This section lists the users wallets
    internal static let portfolio = L10n.tr("Localizable", "HomeScreen.portfolio", fallback: "Wallets")
    /// Pull to refresh control on Home Screen
    internal static let pullToRefresh = L10n.tr("Localizable", "HomeScreen.PullToRefresh", fallback: "Pull to refresh")
    /// Label for the total balance of all the user's assets (style is all lower case if your language permits)
    internal static let totalAssets = L10n.tr("Localizable", "HomeScreen.totalAssets", fallback: "Balance")
    /// (Tap here to) trade (your assets for other assets)
    internal static let trade = L10n.tr("Localizable", "HomeScreen.trade", fallback: "Swap")
  }
  internal enum Import {
    /// Checking private key balance progress view text
    internal static let checking = L10n.tr("Localizable", "Import.checking", fallback: "Checking private key balance...")
    /// Sweep private key confirmation message
    internal static func confirm(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Import.confirm", p1, p2, fallback: "You are importing %s from this private key into your RockWallet. There will be a network fee of %s.")
    }
    /// [Redeem] the funds stored on this private key.
    internal static let importButton = L10n.tr("Localizable", "Import.importButton", fallback: "Sweep")
    /// Importing wallet progress view label
    internal static let importing = L10n.tr("Localizable", "Import.importing", fallback: "Sweeping a wallet")
    /// Caption for graphics
    internal static let leftCaption = L10n.tr("Localizable", "Import.leftCaption", fallback: "Wallet to be imported")
    /// Import wallet intro screen message
    internal static let message = L10n.tr("Localizable", "Import.message", fallback: "Sweeping a wallet transfers all the money from your other wallet into your RockWallet using a single transaction.")
    /// Enter password alert view title
    internal static let password = L10n.tr("Localizable", "Import.password", fallback: "This private key is password protected.")
    /// password textfield placeholder
    internal static let passwordPlaceholder = L10n.tr("Localizable", "Import.passwordPlaceholder", fallback: "password")
    /// Caption for graphics
    internal static let rightCaption = L10n.tr("Localizable", "Import.rightCaption", fallback: "Your RockWallet")
    /// Scan Private key button label
    internal static let scan = L10n.tr("Localizable", "Import.scan", fallback: "SCAN PRIVATE KEY")
    /// Import wallet success alert title
    internal static let success = L10n.tr("Localizable", "Import.success", fallback: "Success")
    /// Successfully imported wallet message body
    internal static let successBody = L10n.tr("Localizable", "Import.SuccessBody", fallback: "Successfully imported wallet.")
    /// Import Wallet screen title
    internal static let title = L10n.tr("Localizable", "Import.title", fallback: "Sweep Wallet")
    /// Unlocking Private key activity view message.
    internal static let unlockingActivity = L10n.tr("Localizable", "Import.unlockingActivity", fallback: "Unlocking Key")
    /// Import wallet intro warning message
    internal static let warning = L10n.tr("Localizable", "Import.warning", fallback: "Sweeping a wallet does not include transaction history or other details.")
    /// Wrong password alert message
    internal static let wrongPassword = L10n.tr("Localizable", "Import.wrongPassword", fallback: "Wrong password, please try again.")
    internal enum Error {
      /// Duplicate key error message
      internal static let duplicate = L10n.tr("Localizable", "Import.Error.duplicate", fallback: "This private key is already in your wallet.")
      /// empty private key error message
      internal static let empty = L10n.tr("Localizable", "Import.Error.empty", fallback: "This private key is empty.")
      /// Failed to submit transaction error message
      internal static let failedSubmit = L10n.tr("Localizable", "Import.Error.failedSubmit", fallback: "Failed to submit transaction.")
      /// High fees error message
      internal static let highFees = L10n.tr("Localizable", "Import.Error.highFees", fallback: "Transaction fees would cost more than the funds available on this private key.")
      /// Not a valid private key error message
      internal static let notValid = L10n.tr("Localizable", "Import.Error.notValid", fallback: "Not a valid private key")
      /// Service error error message
      internal static let serviceError = L10n.tr("Localizable", "Import.Error.serviceError", fallback: "Service Error")
      /// Service Unavailable error message
      internal static let serviceUnavailable = L10n.tr("Localizable", "Import.Error.serviceUnavailable", fallback: "Service Unavailable")
      /// Import signing error message
      internal static let signing = L10n.tr("Localizable", "Import.Error.signing", fallback: "Error signing transaction")
      /// Unable to sweep wallet error message
      internal static let sweepError = L10n.tr("Localizable", "Import.Error.sweepError", fallback: "Unable to sweep wallet")
      /// Unsupported currency error message
      internal static let unsupportedCurrency = L10n.tr("Localizable", "Import.Error.unsupportedCurrency", fallback: "Unsupported Currency")
    }
  }
  internal enum InputView {
    /// Input view invalid code
    internal static let invalidCode = L10n.tr("Localizable", "InputView.InvalidCode", fallback: "Invalid code")
  }
  internal enum JailbreakWarnings {
    /// Close app button
    internal static let close = L10n.tr("Localizable", "JailbreakWarnings.close", fallback: "Close")
    /// Ignore jailbreak warning button
    internal static let ignore = L10n.tr("Localizable", "JailbreakWarnings.ignore", fallback: "Ignore")
    /// Jailbreak warning message
    internal static let messageWithBalance = L10n.tr("Localizable", "JailbreakWarnings.messageWithBalance", fallback: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access RockWallet's keychain data and steal your bitcoin! Wipe this wallet immediately and restore on a secure device.")
    /// Jailbreak warning message
    internal static let messageWithoutBalance = L10n.tr("Localizable", "JailbreakWarnings.messageWithoutBalance", fallback: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access RockWallet's keychain data and steal your bitcoin. Please only use RockWallet on a non-jailbroken device.")
    /// Jailbreak warning title
    internal static let title = L10n.tr("Localizable", "JailbreakWarnings.title", fallback: "WARNING")
    /// Wipe wallet button
    internal static let wipe = L10n.tr("Localizable", "JailbreakWarnings.wipe", fallback: "Wipe")
  }
  internal enum LinkWallet {
    /// Approve link wallet button label
    internal static let approve = L10n.tr("Localizable", "LinkWallet.approve", fallback: "Approve")
    /// Decline link wallet button label
    internal static let decline = L10n.tr("Localizable", "LinkWallet.decline", fallback: "Decline")
    /// Link Wallet view dislaimer footer
    internal static let disclaimer = L10n.tr("Localizable", "LinkWallet.disclaimer", fallback: "External apps cannot send money without approval from this device")
    /// Link Wallet view title above domain list
    internal static let domainTitle = L10n.tr("Localizable", "LinkWallet.domainTitle", fallback: "Note: ONLY interact with this app when on one of the following domains")
    /// Link wallet logo footer text
    internal static let logoFooter = L10n.tr("Localizable", "LinkWallet.logoFooter", fallback: "Secure Checkout")
    /// Link Wallet view title above permissions list
    internal static let permissionsTitle = L10n.tr("Localizable", "LinkWallet.permissionsTitle", fallback: "This app will be able to:")
    /// Link Wallet view title
    internal static let title = L10n.tr("Localizable", "LinkWallet.title", fallback: "Link Wallet")
  }
  internal enum LocationPlugin {
    /// Location services disabled error
    internal static let disabled = L10n.tr("Localizable", "LocationPlugin.disabled", fallback: "Location services are disabled.")
    /// No permissions for location services
    internal static let notAuthorized = L10n.tr("Localizable", "LocationPlugin.notAuthorized", fallback: "RockWallet does not have permission to access location services.")
  }
  internal enum ManageWallet {
    /// Wallet creation date prefix
    internal static func creationDatePrefix(_ p1: Any) -> String {
      return L10n.tr("Localizable", "ManageWallet.creationDatePrefix", String(describing: p1), fallback: "You created your wallet on %1$@")
    }
    /// Manage wallet description text
    internal static let description = L10n.tr("Localizable", "ManageWallet.description", fallback: "Your wallet name only appears in your account transaction history and cannot be seen by anyone else.")
    /// Change Wallet name textfield label
    internal static let textFeildLabel = L10n.tr("Localizable", "ManageWallet.textFeildLabel", fallback: "Wallet Name")
    /// Manage wallet modal title
    internal static let title = L10n.tr("Localizable", "ManageWallet.title", fallback: "Manage Wallet")
  }
  internal enum MarketData {
    /// 24h high
    internal static let high24h = L10n.tr("Localizable", "MarketData.high24h", fallback: "24h high")
    /// 24h low
    internal static let low24h = L10n.tr("Localizable", "MarketData.low24h", fallback: "24h low")
    /// Market Cap
    internal static let marketCap = L10n.tr("Localizable", "MarketData.marketCap", fallback: "Market Cap")
    /// Trading Volume
    internal static let volume = L10n.tr("Localizable", "MarketData.volume", fallback: "Trading Volume")
  }
  internal enum MenuButton {
    /// "Add [a] Wallet [to the home screen]"
    internal static let addWallet = L10n.tr("Localizable", "MenuButton.addWallet", fallback: "Add Wallet")
    /// Menu button title
    internal static let atmCashRedemption = L10n.tr("Localizable", "MenuButton.atmCashRedemption", fallback: "ATM Cash Redemption")
    /// Feedback menu button title
    internal static let feedback = L10n.tr("Localizable", "MenuButton.feedback", fallback: "Feedback")
    /// Menu button title
    internal static let lock = L10n.tr("Localizable", "MenuButton.lock", fallback: "Lock Wallet")
    /// (Click here to) manage (your list of) wallets
    internal static let manageAssets = L10n.tr("Localizable", "MenuButton.manageAssets", fallback: "Manage Assets")
    /// (Click here to) manage (your list of) wallets
    internal static let manageWallets = L10n.tr("Localizable", "MenuButton.manageWallets", fallback: "Manage Wallets")
    /// (press here to) scan (a) QR code
    internal static let scan = L10n.tr("Localizable", "MenuButton.scan", fallback: "Scan QR Code")
    /// Menu button title
    internal static let security = L10n.tr("Localizable", "MenuButton.security", fallback: "Security Settings")
    /// Menu button title
    internal static let settings = L10n.tr("Localizable", "MenuButton.settings", fallback: "Settings")
    /// Menu button title
    internal static let support = L10n.tr("Localizable", "MenuButton.support", fallback: "Support")
  }
  internal enum MenuViewController {
    /// button label
    internal static let createButton = L10n.tr("Localizable", "MenuViewController.createButton", fallback: "Create New Wallet")
    /// Menu modal title
    internal static let modalTitle = L10n.tr("Localizable", "MenuViewController.modalTitle", fallback: "Menu")
    /// button label
    internal static let recoverButton = L10n.tr("Localizable", "MenuViewController.recoverButton", fallback: "Recover Wallet")
  }
  internal enum Modal {
    internal enum PaperKeySkip {
      /// Paper Key Skip modal title
      internal static let title = L10n.tr("Localizable", "Modal.PaperKeySkip.Title", fallback: "Attention")
      internal enum Body {
        /// Paper Key Skip modal body (Android-version)
        internal static let android = L10n.tr("Localizable", "Modal.PaperKeySkip.Body.Android", fallback: "Your Recovery Phrase is required to open your wallet if you change the security settings on your phone.\n\nAre you sure you want to set up your Recovery Phrase later?")
      }
      internal enum Button {
        /// Paper Key Skip modal Continue Set Up button
        internal static let continueSetUp = L10n.tr("Localizable", "Modal.PaperKeySkip.Button.ContinueSetUp", fallback: "Continue Set Up")
        /// Paper Key Skip modal I'll do it later button
        internal static let illDoItLater = L10n.tr("Localizable", "Modal.PaperKeySkip.Button.IllDoItLater", fallback: "I'll do it later")
      }
    }
  }
  internal enum NoInternet {
    /// We couldn’t connect to the server. Please check your internet connection and try again.
    internal static let body = L10n.tr("Localizable", "NoInternet.Body", fallback: "We couldn’t connect to the server. Please check your internet connection and try again.")
    /// Check your connection
    internal static let title = L10n.tr("Localizable", "NoInternet.Title", fallback: "Check your connection")
  }
  internal enum NodeSelector {
    /// Node selection mode is automatic
    internal static let automatic = L10n.tr("Localizable", "NodeSelector.automatic", fallback: "Automatic")
    /// Switch to automatic mode button label
    internal static let automaticButton = L10n.tr("Localizable", "NodeSelector.automaticButton", fallback: "Switch to Automatic Mode")
    /// Node is connected label
    internal static let connected = L10n.tr("Localizable", "NodeSelector.connected", fallback: "Connected")
    /// Node is connecting label
    internal static let connecting = L10n.tr("Localizable", "NodeSelector.connecting", fallback: "Connecting")
    /// Enter node ip address view body
    internal static let enterBody = L10n.tr("Localizable", "NodeSelector.enterBody", fallback: "Enter Node IP address and port (optional)")
    /// Enter Node ip address view title
    internal static let enterTitle = L10n.tr("Localizable", "NodeSelector.enterTitle", fallback: "Enter Node")
    /// Entered invalid node address at the node selection screen
    internal static let invalid = L10n.tr("Localizable", "NodeSelector.invalid", fallback: "Invalid Node")
    /// Switch to manual mode button label
    internal static let manualButton = L10n.tr("Localizable", "NodeSelector.manualButton", fallback: "Switch to Manual Mode")
    /// Node address label
    internal static let nodeLabel = L10n.tr("Localizable", "NodeSelector.nodeLabel", fallback: "Current Primary Node")
    /// Node is not connected label
    internal static let notConnected = L10n.tr("Localizable", "NodeSelector.notConnected", fallback: "Not Connected")
    /// Node status label
    internal static let statusLabel = L10n.tr("Localizable", "NodeSelector.statusLabel", fallback: "Node Connection Status")
    /// Node Selector view title
    internal static let title = L10n.tr("Localizable", "NodeSelector.title", fallback: "Bitcoin Nodes")
  }
  internal enum Onboarding {
    /// Onboarding screen 'I'll browse first' button
    internal static let browseFirst = L10n.tr("Localizable", "Onboarding.browseFirst", fallback: "I'll browse first")
    /// Onboarding screen 'Buy some coin' button
    internal static let buyCoin = L10n.tr("Localizable", "Onboarding.buyCoin", fallback: "Buy some coin")
    /// Onboarding screen 'Get started' (create new wallet) button
    internal static let getStarted = L10n.tr("Localizable", "Onboarding.getStarted", fallback: "Get started")
    /// Onboarding screen 'Next' button
    internal static let next = L10n.tr("Localizable", "Onboarding.next", fallback: "NEXT")
    /// Onboarding screen restore an existing wallet.
    internal static let restoreWallet = L10n.tr("Localizable", "Onboarding.restoreWallet", fallback: "Restore with Recovery Phrase")
    /// Onboarding screen Skip button title that allows the user to exit the onboarding process.
    internal static let skip = L10n.tr("Localizable", "Onboarding.skip", fallback: "Skip")
  }
  internal enum OnboardingPageFour {
    /// Onboarding screen Page 4 title
    internal static let title = L10n.tr("Localizable", "OnboardingPageFour.title", fallback: "Start investing today with as little as $50!")
  }
  internal enum OnboardingPageOne {
    /// Onboarding screen Page 1 title
    internal static let title = L10n.tr("Localizable", "OnboardingPageOne.title", fallback: "Empowering you to navigate the digital asset economy easily and securely")
  }
  internal enum OnboardingPageThree {
    /// Onboarding screen Page 3 subtitle
    internal static let subtitle = L10n.tr("Localizable", "OnboardingPageThree.subtitle", fallback: "Invest and diversify with RockWallet, easily and securely.")
    /// Onboarding screen Page 3 title
    internal static let title = L10n.tr("Localizable", "OnboardingPageThree.title", fallback: "Buy and swap bitcoin, tokens, and other digital currencies.")
  }
  internal enum OnboardingPageTwo {
    /// Onboarding screen Page 2 subtitle
    internal static let subtitle = L10n.tr("Localizable", "OnboardingPageTwo.subtitle", fallback: "We have over $6 billion USD worth of assets under protection.")
    /// Onboarding screen Page 2 title
    internal static let title = L10n.tr("Localizable", "OnboardingPageTwo.title", fallback: "Join people around the world who trust RockWallet.")
  }
  internal enum PaymentConfirmation {
    /// Eg. Send 1.0Eth to purchase CCC
    internal static func amountText(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "PaymentConfirmation.amountText", String(describing: p1), String(describing: p2), fallback: "Send %1$@ to purchase %2$@")
    }
    /// Payment expired message
    internal static let paymentExpired = L10n.tr("Localizable", "PaymentConfirmation.PaymentExpired", fallback: "The payment has expired due to inactivity. Please try again with the same card, or use a different card.")
    /// Payment verification timeout message
    internal static let paymentTimeout = L10n.tr("Localizable", "PaymentConfirmation.PaymentTimeout", fallback: "Payment verification timeout")
    /// Payment confirmation view title
    internal static let title = L10n.tr("Localizable", "PaymentConfirmation.title", fallback: "Confirmation")
    /// Try again button title in payment view
    internal static let tryAgain = L10n.tr("Localizable", "PaymentConfirmation.TryAgain", fallback: "Try again")
    /// Try with ACH payments
    internal static let tryWithAch = L10n.tr("Localizable", "PaymentConfirmation.TryWithAch", fallback: "Try with ACH payments")
    /// Try with debit card
    internal static let tryWithDebit = L10n.tr("Localizable", "PaymentConfirmation.TryWithDebit", fallback: "Try with debit card")
  }
  internal enum PaymentProtocol {
    internal enum Errors {
      /// Bad Payment request alert title
      internal static let badPaymentRequest = L10n.tr("Localizable", "PaymentProtocol.Errors.badPaymentRequest", fallback: "Your transaction request couldn’t be completed. Please try again.")
      /// Error opening payment protocol file message
      internal static let corruptedDocument = L10n.tr("Localizable", "PaymentProtocol.Errors.corruptedDocument", fallback: "Unsupported or corrupted document")
      /// Missing certificate payment protocol error message
      internal static let missingCertificate = L10n.tr("Localizable", "PaymentProtocol.Errors.missingCertificate", fallback: "missing certificate")
      /// Request expired payment protocol error message
      internal static let requestExpired = L10n.tr("Localizable", "PaymentProtocol.Errors.requestExpired", fallback: "request expired")
      /// Payment too small alert title
      internal static let smallOutputError = L10n.tr("Localizable", "PaymentProtocol.Errors.smallOutputError", fallback: "Couldn't make payment")
      /// Amount too small error message
      internal static func smallPayment(_ p1: Any) -> String {
        return L10n.tr("Localizable", "PaymentProtocol.Errors.smallPayment", String(describing: p1), fallback: "Payment can’t be less than %1$@. Bitcoin transaction fees are more than the amount of this transaction. Please increase the amount and try again.")
      }
      /// Output too small error message.
      internal static func smallTransaction(_ p1: Any) -> String {
        return L10n.tr("Localizable", "PaymentProtocol.Errors.smallTransaction", String(describing: p1), fallback: "Bitcoin transaction outputs can't be less than %1$@.")
      }
      /// Unsupported signature type payment protocol error message
      internal static let unsupportedSignatureType = L10n.tr("Localizable", "PaymentProtocol.Errors.unsupportedSignatureType", fallback: "unsupported signature type")
      /// Untrusted certificate payment protocol error message
      internal static let untrustedCertificate = L10n.tr("Localizable", "PaymentProtocol.Errors.untrustedCertificate", fallback: "untrusted certificate")
    }
  }
  internal enum Platform {
    /// Transaction Cancelled
    internal static let transactionCancelled = L10n.tr("Localizable", "Platform.transaction_cancelled", fallback: "Transaction Cancelled")
  }
  internal enum Prompts {
    internal enum ConnectionIssues {
      /// Connection issues
      internal static let title = L10n.tr("Localizable", "Prompts.ConnectionIssues.title", fallback: "Connection issues")
    }
    internal enum Email {
      /// Body text for a prompt that asks the user to subscribe to email updates to find out product updates.
      internal static let body = L10n.tr("Localizable", "Prompts.Email.body", fallback: "Be the first to receive important support and product updates")
      /// Placeholder text for an email address text field.
      internal static let placeholder = L10n.tr("Localizable", "Prompts.Email.placeholder", fallback: "enter your email")
      /// Body text that is shown when the user successfully subscribes to email updates.
      internal static let successBody = L10n.tr("Localizable", "Prompts.Email.successBody", fallback: "You have successfully subscribed to receive updates")
      /// Text that is displayed as a footnote when the user successfully subscribes to email updates.
      internal static let successFootnote = L10n.tr("Localizable", "Prompts.Email.successFootnote", fallback: "We appreciate your continued support")
      /// Title that is shown when the user successfully subscribes to email updates.
      internal static let successTitle = L10n.tr("Localizable", "Prompts.Email.successTitle", fallback: "Thank you!")
      /// Title for a prompt that asks the user to subscribe to email updates to find out product updates.
      internal static let title = L10n.tr("Localizable", "Prompts.Email.title", fallback: "Get in the loop")
    }
    internal enum FaceId {
      /// Body text for a prompt that asks the user to subscribe to email updates to find out product updates., Placeholder text for an email address text field., Body text that is shown when the user successfully subscribes to email updates., Text that is displayed as a footnote when the user successfully subscribes to email updates., Title that is shown when the user successfully subscribes to email updates., Title for a prompt that asks the user to subscribe to email updates to find out product updates., Enable face ID prompt body
      internal static let body = L10n.tr("Localizable", "Prompts.FaceId.body", fallback: "Tap continue to enable Face ID")
      /// Enable face ID prompt title
      internal static let title = L10n.tr("Localizable", "Prompts.FaceId.title", fallback: "Enable Face ID")
    }
    internal enum NoPasscode {
      /// No passcode set warning body
      internal static let body = L10n.tr("Localizable", "Prompts.NoPasscode.body", fallback: "A device passcode is needed to safeguard your wallet. Go to settings and turn passcode on.")
      /// No Passcode set warning title
      internal static let title = L10n.tr("Localizable", "Prompts.NoPasscode.title", fallback: "Turn device passcode on")
    }
    internal enum NoScreenLock {
      internal enum Body {
        /// Instructions on how to enable screen lock settings
        internal static let android = L10n.tr("Localizable", "Prompts.NoScreenLock.body.android", fallback: "A device screen lock is needed to safeguard your wallet. Enable screen lock in your settings to continue.")
      }
      internal enum Title {
        /// Device encryption prompt title
        internal static let android = L10n.tr("Localizable", "Prompts.NoScreenLock.title.android", fallback: "Screen lock disabled")
      }
    }
    internal enum PaperKey {
      /// Warning about recovery phrase (formerly paper key).
      internal static let body = L10n.tr("Localizable", "Prompts.PaperKey.body", fallback: "Set up your Recovery Phrase in case you ever lose or replace your phone. This is also required if you change your phone's security settings.")
      /// An action is required (You must do this action).
      internal static let title = L10n.tr("Localizable", "Prompts.PaperKey.title", fallback: "Action Required")
      internal enum Body {
        /// Warning about paper key (Android-version)
        internal static let android = L10n.tr("Localizable", "Prompts.PaperKey.Body.Android", fallback: "Set up your Recovery Phrase in case you ever lose or replace your phone. Your key is also required if you change your phone's security settings.")
      }
    }
    internal enum RateApp {
      /// Don't ask again
      internal static let dontShow = L10n.tr("Localizable", "Prompts.RateApp.dontShow", fallback: "Don't ask again")
      /// Enjoying RockWallet?
      internal static let enjoyingBrd = L10n.tr("Localizable", "Prompts.RateApp.enjoyingBrd", fallback: "Enjoying RockWallet?")
      /// Enjoying RockWallet?
      internal static let enjoyingRockWallet = L10n.tr("Localizable", "Prompts.RateApp.enjoyingRockWallet", fallback: "Enjoying RockWallet?")
      /// Your review helps grow the RockWallet community.
      internal static let googlePlayReview = L10n.tr("Localizable", "Prompts.RateApp.googlePlayReview", fallback: "Your review helps grow the RockWallet community.")
      /// No thanks
      internal static let noThanks = L10n.tr("Localizable", "Prompts.RateApp.noThanks", fallback: "No thanks")
      /// Review us
      internal static let rateUs = L10n.tr("Localizable", "Prompts.RateApp.rateUs", fallback: "Review us")
    }
    internal enum RecommendRescan {
      /// Transaction rejected prompt body
      internal static let body = L10n.tr("Localizable", "Prompts.RecommendRescan.body", fallback: "Your wallet may be out of sync. This can often be fixed by pulling down this screen to refresh.")
      /// Transaction rejected prompt title
      internal static let title = L10n.tr("Localizable", "Prompts.RecommendRescan.title", fallback: "Transaction Rejected")
    }
    internal enum ShareData {
      /// Share data prompt body
      internal static let body = L10n.tr("Localizable", "Prompts.ShareData.body", fallback: "Help improve RockWallet by sharing your anonymous data with us")
      /// Share data prompt title
      internal static let title = L10n.tr("Localizable", "Prompts.ShareData.title", fallback: "Share Anonymous Data")
    }
    internal enum TouchId {
      /// Enable touch ID prompt body
      internal static let body = L10n.tr("Localizable", "Prompts.TouchId.body", fallback: "Tap continue to enable Fingerprint authentication.")
      /// Enable touch ID prompt title
      internal static let title = L10n.tr("Localizable", "Prompts.TouchId.title", fallback: "Enable Touch ID")
      internal enum Body {
        /// Enable Fingerprint prompt body
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.body.android", fallback: "Tap here to enable fingerprint authentication")
      }
      internal enum Title {
        /// Enable Fingerprint prompt title
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.title.android", fallback: "Enable Fingerprint Authentication")
      }
      internal enum UsePin {
        /// Button on fingerprint prompt so the user can enter their PIN instead
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.usePin.android", fallback: "PIN")
      }
    }
    internal enum UpgradePin {
      /// Upgrade PIN prompt body.
      internal static let body = L10n.tr("Localizable", "Prompts.UpgradePin.body", fallback: "RockWallet has upgraded to using a 6-digit PIN. Tap Continue to upgrade.")
      /// Upgrade PIN prompt title.
      internal static let title = L10n.tr("Localizable", "Prompts.UpgradePin.title", fallback: "Upgrade PIN")
    }
  }
  internal enum PushNotifications {
    /// Body text for the push notifications prompt.
    internal static let body = L10n.tr("Localizable", "PushNotifications.body", fallback: "Turn on push notifications and be the first to hear about new features and special offers.")
    /// Push notifications are disabled alert title"
    internal static let disabled = L10n.tr("Localizable", "PushNotifications.disabled", fallback: "Notifications Disabled")
    /// Body text when push notifications are disabled.
    internal static let disabledBody = L10n.tr("Localizable", "PushNotifications.disabledBody", fallback: "Turn on notifications to receive special offers and updates from RockWallet.")
    /// Body text when push notifications are enabled.
    internal static let enabledBody = L10n.tr("Localizable", "PushNotifications.enabledBody", fallback: "You’re receiving special offers and updates from RockWallet.")
    /// Instructions to enable push notifications for BRD in the phone's system settings.
    internal static let enableInstructions = L10n.tr("Localizable", "PushNotifications.enableInstructions", fallback: "Looks like notifications are turned off. Please go to Settings to enable notifications from RockWallet.")
    /// Push notifications toggle switch label
    internal static let label = L10n.tr("Localizable", "PushNotifications.label", fallback: "Receive Push Notifications")
    /// Push notifications are off label
    internal static let off = L10n.tr("Localizable", "PushNotifications.off", fallback: "Off")
    /// Push notifications are on label
    internal static let on = L10n.tr("Localizable", "PushNotifications.on", fallback: "On")
    /// Push notifications settings view title label
    internal static let title = L10n.tr("Localizable", "PushNotifications.title", fallback: "Stay in the Loop")
    /// Push notifications settings failed to update settings on the back end
    internal static let updateFailed = L10n.tr("Localizable", "PushNotifications.updateFailed", fallback: "Failed to update push notifications settings")
  }
  internal enum RateAppPrompt {
    internal enum Body {
      /// Google play review prompt body
      internal static let android = L10n.tr("Localizable", "RateAppPrompt.Body.Android", fallback: "If you love our app, please take a moment to rate it and give us a review.")
    }
    internal enum Button {
      internal enum Dismiss {
        /// Google play review prompt, revivew button
        internal static let android = L10n.tr("Localizable", "RateAppPrompt.Button.Dismiss.Android", fallback: "No Thanks")
      }
      internal enum RateApp {
        /// Google play review prompt, dismiss button
        internal static let android = L10n.tr("Localizable", "RateAppPrompt.Button.RateApp.Android", fallback: "Rate RockWallet")
      }
    }
    internal enum Title {
      /// Google play review prompt title
      internal static let android = L10n.tr("Localizable", "RateAppPrompt.Title.Android", fallback: "Rate RockWallet")
    }
  }
  internal enum ReScan {
    /// Alert action button label
    internal static let alertAction = L10n.tr("Localizable", "ReScan.alertAction", fallback: "Sync")
    /// Alert message body
    internal static let alertMessage = L10n.tr("Localizable", "ReScan.alertMessage", fallback: "You will not be able to send money while syncing.")
    /// Alert message title
    internal static let alertTitle = L10n.tr("Localizable", "ReScan.alertTitle", fallback: "Sync with Blockchain?")
    /// extimated time
    internal static let body1 = L10n.tr("Localizable", "ReScan.body1", fallback: "20-45 minutes")
    /// Syncing explanation
    internal static let body2 = L10n.tr("Localizable", "ReScan.body2", fallback: "If a transaction shows as completed on the network but not in your RockWallet.")
    /// Syncing explanation
    internal static let body3 = L10n.tr("Localizable", "ReScan.body3", fallback: "You repeatedly get an error saying your transaction was rejected.")
    /// Start Sync button label
    internal static let buttonTitle = L10n.tr("Localizable", "ReScan.buttonTitle", fallback: "Start Sync")
    /// Sync blockchain view footer
    internal static let footer = L10n.tr("Localizable", "ReScan.footer", fallback: "You will not be able to send money while syncing with the blockchain.")
    /// Sync Blockchain view header
    internal static let header = L10n.tr("Localizable", "ReScan.header", fallback: "Sync Blockchain")
    /// Subheader label
    internal static let subheader1 = L10n.tr("Localizable", "ReScan.subheader1", fallback: "Estimated time")
    /// Subheader label
    internal static let subheader2 = L10n.tr("Localizable", "ReScan.subheader2", fallback: "When to Sync?")
  }
  internal enum Receive {
    /// Address copied message.
    internal static let copied = L10n.tr("Localizable", "Receive.copied", fallback: "Copied to clipboard")
    /// Share via email button label
    internal static let emailButton = L10n.tr("Localizable", "Receive.emailButton", fallback: "Email")
    /// Request button label
    internal static let request = L10n.tr("Localizable", "Receive.request", fallback: "Request an Amount")
    /// Share button label
    internal static let share = L10n.tr("Localizable", "Receive.share", fallback: "Share")
    /// Share via text message (SMS)
    internal static let textButton = L10n.tr("Localizable", "Receive.textButton", fallback: "Text Message")
    /// Receive modal title
    internal static let title = L10n.tr("Localizable", "Receive.title", fallback: "Receive")
  }
  internal enum RecoverWallet {
    /// Done button text
    internal static let done = L10n.tr("Localizable", "RecoverWallet.done", fallback: "DONE")
    /// Enter recovery phrase label to delete the wallet
    internal static let enterRecoveryPhrase = L10n.tr("Localizable", "RecoverWallet.EnterRecoveryPhrase", fallback: "Please enter your Recovery Phrase to delete this wallet from your device.")
    /// Recover wallet header
    internal static let header = L10n.tr("Localizable", "RecoverWallet.header", fallback: "Recover Wallet")
    /// Reset PIN with paper key: header
    internal static let headerResetPin = L10n.tr("Localizable", "RecoverWallet.header_reset_pin", fallback: "Reset your PIN")
    /// Enter paper key instruction
    internal static let instruction = L10n.tr("Localizable", "RecoverWallet.instruction", fallback: "Enter Recovery Phrase")
    /// Recover wallet intro
    internal static let intro = L10n.tr("Localizable", "RecoverWallet.intro", fallback: "Recover your RockWallet with your Recovery Phrase.")
    /// Invalid paper key message
    internal static let invalid = L10n.tr("Localizable", "RecoverWallet.invalid", fallback: "The Recovery Phrase you entered is invalid. Please double-check each word and try again.")
    /// Previous button accessibility label
    internal static let leftArrow = L10n.tr("Localizable", "RecoverWallet.leftArrow", fallback: "Left Arrow")
    /// Next button label
    internal static let next = L10n.tr("Localizable", "RecoverWallet.next", fallback: "NEXT")
    /// What Is recovery phrase text popup
    internal static let recoveryPhrasePopup = L10n.tr("Localizable", "RecoverWallet.RecoveryPhrasePopup", fallback: "A Recovery Phrase consists of 12 randomly generated words. The app creates the Recovery Phrase for you automatically when you start a new wallet. The Recovery Phrase is critically important and should be written down and stored in a safe location. In the event of phone theft, destruction, or loss, the Recovery Phrase can be used to load your wallet onto a new phone. The key is also required when upgrading your current phone to a new one.")
    /// Reset PIN with paper key: more information button.
    internal static let resetPinMoreInfo = L10n.tr("Localizable", "RecoverWallet.reset_pin_more_info", fallback: "Tap here for more information.")
    /// Next button accessibility label
    internal static let rightArrow = L10n.tr("Localizable", "RecoverWallet.rightArrow", fallback: "Right Arrow")
    /// Recover wallet sub-header
    internal static let subheader = L10n.tr("Localizable", "RecoverWallet.subheader", fallback: "Enter the Recovery Phrase for the wallet you want to recover.")
    /// Reset PIN with paper key: sub-header
    internal static let subheaderResetPin = L10n.tr("Localizable", "RecoverWallet.subheader_reset_pin", fallback: "To reset your PIN, enter the words from your Recovery Phrase into the boxes below.")
    /// What is recovery phrase title on popup
    internal static let whatIsRecoveryPhrase = L10n.tr("Localizable", "RecoverWallet.WhatIsRecoveryPhrase", fallback: "What is “Recovery Phrase”?")
  }
  internal enum RecoveryKeyFlow {
    /// Instructs the user to enter words from the set of recovery key words.
    internal static let confirmRecoveryInputError = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryInputError", fallback: "The word you entered is incorrect. Please try again.")
    /// Instructs the user to enter words from the set of recovery phrase words.
    internal static let confirmRecoveryKeySubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryKeySubtitle", fallback: "Almost done! Enter the following words from your Recovery Phrase.")
    /// Title for the confirmation step of the recovery phrase flow.
    internal static let confirmRecoveryKeyTitle = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryKeyTitle", fallback: "Confirm Recovery Phrase")
    /// Title displayed when the user starts the process of entering a recovery phrase
    internal static let enterRecoveryKey = L10n.tr("Localizable", "RecoveryKeyFlow.enterRecoveryKey", fallback: "Enter Recovery Phrase")
    /// Subtitle displayed when the user starts the process of entering a recovery phrase
    internal static let enterRecoveryKeySubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.enterRecoveryKeySubtitle", fallback: "Please enter the Recovery Phrase in order to delete your account and unlink the wallet.")
    /// Body text for an alert dialog asking the user whether to set up the recovery phrase later
    internal static let exitRecoveryKeyPromptBody = L10n.tr("Localizable", "RecoveryKeyFlow.exitRecoveryKeyPromptBody", fallback: "Are you sure you want to set up your Recovery Phrase later?")
    /// Title for an alert dialog asking the user whether to set up the recovery key later
    internal static let exitRecoveryKeyPromptTitle = L10n.tr("Localizable", "RecoveryKeyFlow.exitRecoveryKeyPromptTitle", fallback: "Set Up Later")
    /// Button text for the 'Generate Recovery Phrase' button
    internal static let generateKeyButton = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyButton", fallback: "GOT IT")
    /// Subtext for the recovery key landing page.
    internal static let generateKeyExplanation = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyExplanation", fallback: "This is required to restore your wallet if you upgrade or lose your phone.")
    /// Default title for the recovery phrase landing page
    internal static let generateKeyTitle = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyTitle", fallback: "Generate your private Recovery Phrase")
    /// Title for a button that takes the user to the wallet after setting up the recovery key.
    internal static let goToWalletButtonTitle = L10n.tr("Localizable", "RecoveryKeyFlow.goToWalletButtonTitle", fallback: "GO TO WALLET")
    /// Hint text for recovery key intro page, e.g., Step 2
    internal static func howItWorksStep(_ p1: Any) -> String {
      return L10n.tr("Localizable", "RecoveryKeyFlow.howItWorksStep", String(describing: p1), fallback: "How it works - Step %1$@")
    }
    /// Error text displayed when the user enters an incorrect recovery phrase
    internal static let invalidPhrase = L10n.tr("Localizable", "RecoveryKeyFlow.invalidPhrase", fallback: "Some of the words you entered do not match your Recovery Phrase. Please try again.")
    /// Title for recovery key intro page
    internal static let keepSecure = L10n.tr("Localizable", "RecoveryKeyFlow.keepSecure", fallback: "Write down your Recovery Phrase")
    /// Informs the user that the recovery is only required for recovering a wallet.
    internal static let keyUseHint = L10n.tr("Localizable", "RecoveryKeyFlow.keyUseHint", fallback: "Your key is only needed for recovery, not for everyday wallet access.")
    /// Reminds the user not to take screenshots or email the recovery key words
    internal static let noScreenshotsOrEmailWarning = L10n.tr("Localizable", "RecoveryKeyFlow.noScreenshotsOrEmailWarning", fallback: "For security purposes, do not screenshot or email these words")
    /// Recommends that the user avoids capturing the paper key with a screenshot
    internal static let noScreenshotsRecommendation = L10n.tr("Localizable", "RecoveryKeyFlow.noScreenshotsRecommendation", fallback: "This is required to restore your wallet if you upgrade or lose your phone.")
    /// Title displayed when the user starts the process of recovering a wallet
    internal static let recoveryYourWallet = L10n.tr("Localizable", "RecoveryKeyFlow.recoveryYourWallet", fallback: "Restore Your Wallet")
    /// Subtitle displayed when the user starts the process of recovering a wallet
    internal static let recoveryYourWalletSubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.recoveryYourWalletSubtitle", fallback: "Please enter the Recovery Phrase of the wallet you want to restore")
    /// Title for recovery key intro page
    internal static let relaxBuyTrade = L10n.tr("Localizable", "RecoveryKeyFlow.relaxBuyTrade", fallback: "Keep your Recovery Phrase in a secure location")
    /// Reminds the user to write down the recovery key words.
    internal static let rememberToWriteDownReminder = L10n.tr("Localizable", "RecoveryKeyFlow.rememberToWriteDownReminder", fallback: "Remember to write these words down. Swipe back if you forgot.")
    /// Instruction displayed when the user is resetting the PIN, which requires the recovery phrase to be entered
    internal static let resetPINInstruction = L10n.tr("Localizable", "RecoveryKeyFlow.resetPINInstruction", fallback: "Please enter your Recovery Phrase to reset your PIN.")
    /// Assures the user that BRD will keep the user's funds secure.
    internal static let securityAssurance = L10n.tr("Localizable", "RecoveryKeyFlow.securityAssurance", fallback: "Remember that this is the only way to restore your wallet. RockWallet does not keep a copy.")
    /// Recommends that the user stores the recovery key in a secure location
    internal static let storeSecurelyRecommendation = L10n.tr("Localizable", "RecoveryKeyFlow.storeSecurelyRecommendation", fallback: "For security reasons, screenshots are not recommended, as anyone with your Recovery Phrase can access your funds.")
    /// Title for the success page after the recovery phrase has been set up
    internal static let successHeading = L10n.tr("Localizable", "RecoveryKeyFlow.successHeading", fallback: "Congratulations! You completed your Recovery Phrase setup.")
    /// Subtitle for the success page after the recovery key has been set up
    internal static let successSubheading = L10n.tr("Localizable", "RecoveryKeyFlow.successSubheading", fallback: "You're all set to deposit, swap, and buy crypto from your RockWallet.")
    /// Title displayed to the user on the intro screen when unlinking a wallet
    internal static let unlinkWallet = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWallet", fallback: "Unlink your wallet from this device.")
    /// Subtitle displayed to the user on the intro screen when unlinking a wallet.
    internal static let unlinkWalletSubtext = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWalletSubtext", fallback: "Start a new wallet by unlinking your device from the currently-installed wallet.")
    /// Warning displayed when the user starts the process of unlinking a wallet
    internal static let unlinkWalletWarning = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWalletWarning", fallback: "Wallet must be recovered to regain access.")
    /// Title displayed to the user on the intro screen when wiping a wallet
    internal static let wipeWallet = L10n.tr("Localizable", "RecoveryKeyFlow.wipeWallet", fallback: "Wipe your wallet from this device.")
    /// Subtitle displayed to the user on the intro screen when wiping a wallet.
    internal static let wipeWalletSubtext = L10n.tr("Localizable", "RecoveryKeyFlow.wipeWalletSubtext", fallback: "Start a new wallet by wiping the current wallet from your device.")
    /// Title for recovery key intro page
    internal static let writeItDown = L10n.tr("Localizable", "RecoveryKeyFlow.writeItDown", fallback: "Generate your private Recovery Phrase")
    /// Title for the recovery phrase landing page if the key has already been generated.
    internal static let writeKeyAgain = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyAgain", fallback: "Write down your Recovery Phrase again")
    /// Subtitle for the write recovery key screen
    internal static let writeKeyScreenSubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyScreenSubtitle", fallback: "Write down the following words in order.")
    /// Title for the write recovery phrase screen
    internal static let writeKeyScreenTitle = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyScreenTitle", fallback: "Recovery Phrase")
    /// Title for the step number when the user pages through the recovery words
    internal static func writeKeyStepTitle(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyStepTitle", String(describing: p1), String(describing: p2), fallback: "%1$@ of %2$@")
    }
  }
  internal enum RecoveryKeyOnboarding {
    /// This is required to restore your wallet if you upgrade or lose your phone.
    internal static let description1 = L10n.tr("Localizable", "RecoveryKeyOnboarding.description1", fallback: "This is required to restore your wallet if you upgrade or lose your phone.")
    /// For security reasons, screenshots are not recommended, as anyone with your Recovery Phrase can access your funds.
    internal static let description2 = L10n.tr("Localizable", "RecoveryKeyOnboarding.description2", fallback: "For security reasons, screenshots are not recommended, as anyone with your Recovery Phrase can access your funds.")
    /// Remember that this is the only way to restore your wallet. RockWallet does not keep a copy.
    internal static let description3 = L10n.tr("Localizable", "RecoveryKeyOnboarding.description3", fallback: "Remember that this is the only way to restore your wallet. RockWallet does not keep a copy.")
    /// Generate your private Recovery Phrase
    internal static let title1 = L10n.tr("Localizable", "RecoveryKeyOnboarding.title1", fallback: "Generate your private Recovery Phrase")
    /// Write down your Recovery Phrase
    internal static let title2 = L10n.tr("Localizable", "RecoveryKeyOnboarding.title2", fallback: "Write down your Recovery Phrase")
    /// Generate your private Recovery Phrase
    internal static let titlePage1 = L10n.tr("Localizable", "RecoveryKeyOnboarding.titlePage1", fallback: "Generate your private Recovery Phrase")
  }
  internal enum RequestAnAmount {
    /// No amount entered error message.
    internal static let noAmount = L10n.tr("Localizable", "RequestAnAmount.noAmount", fallback: "Please enter an amount first.")
    /// Request a specific amount of bitcoin
    internal static let title = L10n.tr("Localizable", "RequestAnAmount.title", fallback: "Request an Amount")
  }
  internal enum RewardsView {
    /// Rewards view expanded body.
    internal static let expandedBody = L10n.tr("Localizable", "RewardsView.expandedBody", fallback: "Learn how you can save on trading fees and unlock future rewards")
    /// Rewards view expanded title.
    internal static let expandedTitle = L10n.tr("Localizable", "RewardsView.expandedTitle", fallback: "Introducing RockWallet Rewards.")
    /// Rewards view title
    internal static let normalTitle = L10n.tr("Localizable", "RewardsView.normalTitle", fallback: "Rewards")
  }
  internal enum Scanner {
    /// Scan bitcoin address camera flash toggle
    internal static let flashButtonLabel = L10n.tr("Localizable", "Scanner.flashButtonLabel", fallback: "Camera Flash")
    /// (alert dialog message) Would you like to send a [Bitcoin / Bitcoin Cash / Ethereum] payment to this address?")
    internal static func paymentPromptMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Scanner.paymentPromptMessage", String(describing: p1), fallback: "Would you like to send a %1$@ payment to this address?")
    }
    /// alert dialog title
    internal static let paymentPromptTitle = L10n.tr("Localizable", "Scanner.paymentPromptTitle", fallback: "Send Payment")
  }
  internal enum Search {
    /// Complete filter label
    internal static let complete = L10n.tr("Localizable", "Search.complete", fallback: "complete")
    /// Pending filter label
    internal static let pending = L10n.tr("Localizable", "Search.pending", fallback: "pending")
    /// Received filter label
    internal static let received = L10n.tr("Localizable", "Search.received", fallback: "received")
    /// [Click here to] search
    internal static let search = L10n.tr("Localizable", "Search.search", fallback: "Search")
    /// Sent filter label
    internal static let sent = L10n.tr("Localizable", "Search.sent", fallback: "sent")
  }
  internal enum SecurityCenter {
    /// Face ID button title
    internal static let faceIdTitle = L10n.tr("Localizable", "SecurityCenter.faceIdTitle", fallback: "Face ID")
    /// Paper Key button description
    internal static let paperKeyDescription = L10n.tr("Localizable", "SecurityCenter.paperKeyDescription", fallback: "The only way to access your assets if you lose or upgrade your phone.")
    /// Recovery Phrase button title. This used to be called 'paper key', so leaving the string key as `paperKeyTitle` in order, * to not break existing client code.
    internal static let paperKeyTitle = L10n.tr("Localizable", "SecurityCenter.paperKeyTitle", fallback: "Recovery Phrase")
    /// PIN button description
    internal static let pinDescription = L10n.tr("Localizable", "SecurityCenter.pinDescription", fallback: "Protects your RockWallet from unauthorized users.")
    /// PIN button title
    internal static let pinTitle = L10n.tr("Localizable", "SecurityCenter.pinTitle", fallback: "6-Digit PIN")
    /// Touch ID button description
    internal static let touchIdDescription = L10n.tr("Localizable", "SecurityCenter.touchIdDescription", fallback: "Conveniently unlock your RockWallet and send money up to a set limit.")
    /// Touch ID button title
    internal static let touchIdTitle = L10n.tr("Localizable", "SecurityCenter.touchIdTitle", fallback: "Touch ID")
    internal enum PaperKeyTitle {
      /// Paper Key button title
      internal static let android = L10n.tr("Localizable", "SecurityCenter.paperKeyTitle.android", fallback: "Recovery Phrase")
    }
    internal enum TouchIdTitle {
      /// Security center fingerprint authentication button
      internal static let android = L10n.tr("Localizable", "SecurityCenter.touchIdTitle.android", fallback: "Fingerprint Authentication")
    }
  }
  internal enum Segwit {
    /// Segwit enabled confirmation body
    internal static let confirmationConfirmationBody = L10n.tr("Localizable", "Segwit.ConfirmationConfirmationBody", fallback: "Thank you for helping move bitcoin forward!")
    /// Segwit enabled confirmation title
    internal static let confirmationConfirmationTitle = L10n.tr("Localizable", "Segwit.ConfirmationConfirmationTitle", fallback: "You have enabled SegWit!")
    /// Segwit enabled confirmation description
    internal static let confirmationInstructionsDescription = L10n.tr("Localizable", "Segwit.ConfirmationInstructionsDescription", fallback: "")
    /// Segwit instructions
    internal static let confirmationInstructionsInstructions = L10n.tr("Localizable", "Segwit.ConfirmationInstructionsInstructions", fallback: "SegWit support is still a beta feature.\n\nOnce SegWit is enabled, it will not be possible\nto disable it. You will be able to find the legacy address under Settings. \n\nSome third-party services, including crypto trading, may be unavailable to users who have enabled SegWit. In case of emergency, you will be able to generate a legacy address from Preferences > BTC Settings. \n\nSegWit will automatically be enabled for all\nusers in a future update.")
    /// Segwit extra confirmation title.
    internal static let confirmChoiceLayout = L10n.tr("Localizable", "Segwit.ConfirmChoiceLayout", fallback: "Enabling SegWit is an irreversible feature. Are you sure you want to continue?")
    /// Segwit enableButton
    internal static let enable = L10n.tr("Localizable", "Segwit.Enable", fallback: "Enable")
    /// Segwit button label that takes the user back to the home screen once SegWit is enabled.
    internal static let homeButton = L10n.tr("Localizable", "Segwit.HomeButton", fallback: "Proceed")
  }
  internal enum Sell {
    /// ACH withdrawal will be processed within 3-5 business days.
    internal static let achDurationWarning = L10n.tr("Localizable", "Sell.achDurationWarning", fallback: "ACH withdrawal will be processed within 3-5 business days.")
    /// ACH Withdrawal
    internal static let achWithdrawal = L10n.tr("Localizable", "Sell.achWithdrawal", fallback: "ACH Withdrawal")
    /// Sell & Withdraw details
    internal static let details = L10n.tr("Localizable", "Sell.details", fallback: "Sell & Withdraw details")
    /// Minimum withdrawal is %s and maximum is %s per day. At the moment your lifetime limit is %s USD.
    /// 
    /// ACH Withdrawals will be processed within 3-5 business days.withdrawal
    internal static func disclaimer(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Sell.disclaimer", p1, p2, p3, fallback: "Minimum withdrawal is %s and maximum is %s per day. At the moment your lifetime limit is %s USD.\n\nACH Withdrawals will be processed within 3-5 business days.withdrawal")
    }
    /// I receive
    internal static let iReceive = L10n.tr("Localizable", "Sell.iReceive", fallback: "I receive")
    /// Sell & Withdraw isn't available in your region. We'll notify you when this feature is released. You can always swap to convert digital assets.
    internal static let notAvailableBody = L10n.tr("Localizable", "Sell.NotAvailableBody", fallback: "Sell & Withdraw isn't available in your region. We'll notify you when this feature is released. You can always swap to convert digital assets.")
    /// Withdrawal preview
    internal static let orderPreview = L10n.tr("Localizable", "Sell.OrderPreview", fallback: "Withdrawal preview")
    /// Conversion rate
    internal static let rate = L10n.tr("Localizable", "Sell.rate", fallback: "Conversion rate")
    /// Minimum withdrawal is %s USD and maximum is %s USD per day. At the moment your lifetime limit is %s USD.
    /// 
    /// ACH Withdrawals will be processed within 3-5 business days.
    internal static func sellLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Sell.SellLimits", p1, p2, p3, fallback: "Minimum withdrawal is %s USD and maximum is %s USD per day. At the moment your lifetime limit is %s USD.\n\nACH Withdrawals will be processed within 3-5 business days.")
    }
    /// Subtotal
    internal static let subtotal = L10n.tr("Localizable", "Sell.subtotal", fallback: "Subtotal")
    /// Sell & Withdraw funds
    internal static let title = L10n.tr("Localizable", "Sell.title", fallback: "Sell & Withdraw funds")
    /// Please try again
    internal static let tryAgain = L10n.tr("Localizable", "Sell.tryAgain", fallback: "Please try again")
    /// Withdraw to
    internal static let widrawToBank = L10n.tr("Localizable", "Sell.widrawToBank", fallback: "Withdraw to")
    /// Your funds should be deposited into your account within 3-5 business days. In rare cases, withdrawals may take up to 7 business days.
    internal static let withdrawalSuccessText = L10n.tr("Localizable", "Sell.WithdrawalSuccessText", fallback: "Your funds should be deposited into your account within 3-5 business days. In rare cases, withdrawals may take up to 7 business days.")
    /// Your withdrawal is being processed
    internal static let withdrawalSuccessTitle = L10n.tr("Localizable", "Sell.WithdrawalSuccessTitle", fallback: "Your withdrawal is being processed")
    /// Sell and withdraw details
    internal static let withdrawDetails = L10n.tr("Localizable", "Sell.WithdrawDetails", fallback: "Sell and withdraw details")
    /// You sell:
    internal static let yourOrder = L10n.tr("Localizable", "Sell.yourOrder", fallback: "You sell:")
    /// You’ll receive
    internal static let youWillReceive = L10n.tr("Localizable", "Sell.YouWillReceive", fallback: "You’ll receive")
  }
  internal enum Send {
    /// Send money amount label
    internal static let amountLabel = L10n.tr("Localizable", "Send.amountLabel", fallback: "Amount")
    /// Balance: $4.00
    internal static func balance(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.balance", String(describing: p1), fallback: "Balance: %1$@")
    }
    /// Balance: $4.00 for iOS, the balance can't have a parameter
    internal static let balanceString = L10n.tr("Localizable", "Send.balanceString", fallback: "Balance:")
    /// Camera not allowed message
    internal static let cameraunavailableMessage = L10n.tr("Localizable", "Send.cameraunavailableMessage", fallback: "Go to Settings to allow camera access.")
    /// Camera not allowed alert title
    internal static let cameraUnavailableTitle = L10n.tr("Localizable", "Send.cameraUnavailableTitle", fallback: "RockWallet is not allowed to access the camera")
    /// Warning when sending to self.
    internal static let containsAddress = L10n.tr("Localizable", "Send.containsAddress", fallback: "The destination is your own address. You cannot send to yourself.")
    /// Could not create transaction alert title
    internal static let creatTransactionError = L10n.tr("Localizable", "Send.creatTransactionError", fallback: "Could not create transaction.")
    /// Description for sending money label
    internal static let descriptionLabel = L10n.tr("Localizable", "Send.descriptionLabel", fallback: "Memo")
    /// Destination tag is too long error message in send view
    internal static let destinationTag = L10n.tr("Localizable", "Send.DestinationTag", fallback: "Destination tag is too long.")
    /// Optional Destination Tag label
    internal static let destinationTagOptional = L10n.tr("Localizable", "Send.destinationTag_optional", fallback: "Destination Tag")
    /// Required Destination Tag label
    internal static let destinationTagRequired = L10n.tr("Localizable", "Send.destinationTag_required", fallback: "Destination Tag (Required)")
    /// A valid Destination Tag is required for the target address.
    internal static let destinationTagRequiredError = L10n.tr("Localizable", "Send.destinationTag_required_error", fallback: "A valid Destination Tag is required for the target address.")
    /// Destination Tag text explanation popup in send view
    internal static let destinationTagText = L10n.tr("Localizable", "Send.DestinationTagText", fallback: "Some receiving addresses (exchanges usually) require additional identifying information provided with a Destination Tag.\n\nIf the recipient's address is accompanied by a destination tag, make sure to include it.\nAlso, we strongly suggest you send a small amount of cryptocurrency as a test before attempting to send a significant amount.")
    /// Emtpy pasteboard error message
    internal static let emptyPasteboard = L10n.tr("Localizable", "Send.emptyPasteboard", fallback: "Pasteboard is empty")
    /// "(you) can't send (to your)self"
    internal static let ethSendSelf = L10n.tr("Localizable", "Send.ethSendSelf", fallback: "Can't send to self.")
    /// Network Fee: $0.01
    internal static func fee(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.fee", String(describing: p1), fallback: "Network Fee: %1$@")
    }
    /// Invalid FIO address.
    internal static let fioInvalid = L10n.tr("Localizable", "Send.fio_invalid", fallback: "Invalid FIO address.")
    /// There is no %1$@ address associated with this FIO address.
    internal static func fioNoAddress(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.fio_noAddress", String(describing: p1), fallback: "There is no %1$@ address associated with this FIO address.")
    }
    /// There was an error retrieving the address for this FIO address. Please try again later.
    internal static let fioRetrievalError = L10n.tr("Localizable", "Send.fio_retrievalError", fallback: "There was an error retrieving the address for this FIO address. Please try again later.")
    /// Payee identity not certified alert title.
    internal static let identityNotCertified = L10n.tr("Localizable", "Send.identityNotCertified", fallback: "Payee identity isn't certified.")
    /// Insufficient funds error
    internal static let insufficientFunds = L10n.tr("Localizable", "Send.insufficientFunds", fallback: "Insufficient Funds")
    /// Insufficient gas error
    internal static let insufficientGas = L10n.tr("Localizable", "Send.insufficientGas", fallback: "Insufficient gas.")
    /// e,g, "You must have at least $2 in your wallet in order to transfer this type of token." In this case, "token" is an ethereum ERC20 token.
    internal static func insufficientGasMessage(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Send.insufficientGasMessage", String(describing: p1), String(describing: p2), fallback: "You must have at least %1$@ in your wallet in order to transfer this type of token. Would you like to go to your %2$@ wallet now?")
    }
    /// Your balance is insufficient to complete this action.
    internal static func insufficientGasTitle(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Send.insufficientGasTitle", p1, fallback: "Insufficient %s Balance")
    }
    /// e.g. The destination is not a valid (bitcoin) address.
    internal static func invalidAddressMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.invalidAddressMessage", String(describing: p1), fallback: "The destination address is not a valid %1$@ address.")
    }
    /// Invalid address on pasteboard message
    internal static func invalidAddressOnPasteboard(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.invalidAddressOnPasteboard", String(describing: p1), fallback: "Pasteboard does not contain a valid %1$@ address.")
    }
    /// Invalid address alert title
    internal static let invalidAddressTitle = L10n.tr("Localizable", "Send.invalidAddressTitle", fallback: "Invalid Address")
    /// Is rescanning error message
    internal static let isRescanning = L10n.tr("Localizable", "Send.isRescanning", fallback: "Sending is disabled during a full rescan.")
    /// Warning when the user is trying to send bitcoin cash to a legacy bitcoin address (possible, but probably not what the user wants to do)
    internal static let legacyAddressWarning = L10n.tr("Localizable", "Send.legacyAddressWarning", fallback: "Warning: this is a legacy bitcoin address. Are you sure you want to send Bitcoin Cash to it?")
    /// We are loading the request (now)
    internal static let loadingRequest = L10n.tr("Localizable", "Send.loadingRequest", fallback: "Loading Request")
    /// Hedera Memo Tag Label
    internal static let memoTagOptional = L10n.tr("Localizable", "Send.memoTag_optional", fallback: "Hedera Memo (Optional)")
    /// Transaction fee could not be be caluculated error.
    internal static let nilFeeError = L10n.tr("Localizable", "Send.nilFeeError", fallback: "Insufficient funds to cover the transaction fee.")
    /// Empty address alert message
    internal static let noAddress = L10n.tr("Localizable", "Send.noAddress", fallback: "Please enter the recipient's address.")
    /// Emtpy amount alert message
    internal static let noAmount = L10n.tr("Localizable", "Send.noAmount", fallback: "Please enter an amount to send.")
    /// No fee estimate error on send view
    internal static let noFeeEstimate = L10n.tr("Localizable", "Send.NoFeeEstimate", fallback: "No fee estimate")
    /// No Fees error
    internal static let noFeesError = L10n.tr("Localizable", "Send.noFeesError", fallback: "Network Fee conditions are being downloaded. Please try again.")
    /// Paste button label
    internal static let pasteLabel = L10n.tr("Localizable", "Send.pasteLabel", fallback: "Paste")
    /// Error message for invalid PayID
    internal static let payIdInvalid = L10n.tr("Localizable", "Send.payId_invalid", fallback: "Invalid PayString.")
    /// Error message for no address associated with a PayID for a given currency
    internal static func payIdNoAddress(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.payId_noAddress", String(describing: p1), fallback: "There is no %1$@ address associated with this PayString.")
    }
    /// Error message for error in retrieving the address from the PayID endpoint
    internal static let payIdRetrievalError = L10n.tr("Localizable", "Send.payId_retrievalError", fallback: "There was an error retrieving the address for this PayString. Please try again later.")
    /// PayID label
    internal static let payIdToLabel = L10n.tr("Localizable", "Send.payId_toLabel", fallback: "PayString")
    /// Could not publish transaction alert title
    internal static let publishTransactionError = L10n.tr("Localizable", "Send.publishTransactionError", fallback: "Your transaction request couldn’t be completed. Please try again.")
    /// Could not load remote request error message
    internal static let remoteRequestError = L10n.tr("Localizable", "Send.remoteRequestError", fallback: "Your payment attempt couldn’t be completed. Please try again.")
    /// Scan button label
    internal static let scanLabel = L10n.tr("Localizable", "Send.scanLabel", fallback: "Scan")
    /// Title for error when send request times out and we are not sure weather it succesfull or not.
    internal static let sendError = L10n.tr("Localizable", "Send.sendError", fallback: "Send Error")
    /// Sending Max: $4.00 for iOS, the balance can't have a parameter
    internal static let sendingMax = L10n.tr("Localizable", "Send.sendingMax", fallback: "Sending Max:")
    /// Send button label (the action, "press here to send")
    internal static let sendLabel = L10n.tr("Localizable", "Send.sendLabel", fallback: "Send")
    /// Send button label (for special case where the user specified send amount is too high and does not leave a balance to cover fees.)
    internal static let sendMaximum = L10n.tr("Localizable", "Send.sendMaximum", fallback: "Send maximum amount?")
    /// Error message when send request times out and we are not sure weather it succesfull or not.
    internal static let timeOutBody = L10n.tr("Localizable", "Send.timeOutBody", fallback: "Timed out waiting for network response. Please wait 60 seconds for confirmation before retrying.")
    /// Send screen title (as in "this is the screen for sending money")
    internal static let title = L10n.tr("Localizable", "Send.title", fallback: "Send")
    /// Send money to label
    internal static let toLabel = L10n.tr("Localizable", "Send.toLabel", fallback: "To")
    /// What is a destination tag title in popup in send view
    internal static let whatIsDestinationTag = L10n.tr("Localizable", "Send.WhatIsDestinationTag", fallback: "What is a destination tag?")
    internal enum Error {
      /// Sending error message
      internal static let authenticationError = L10n.tr("Localizable", "Send.Error.authenticationError", fallback: "Authentication Error")
      /// Error calculating maximum.
      internal static let maxError = L10n.tr("Localizable", "Send.Error.maxError", fallback: "Could not calculate maximum")
    }
    internal enum UsedAddress {
      /// Adress already used alert message - first part
      internal static let firstLine = L10n.tr("Localizable", "Send.UsedAddress.firstLine", fallback: "Bitcoin addresses are intended for single use only.")
      /// Adress already used alert message - second part
      internal static let secondLIne = L10n.tr("Localizable", "Send.UsedAddress.secondLIne", fallback: "Re-use reduces privacy for both you and the recipient and can result in loss if the recipient doesn't directly control the address.")
      /// Adress already used alert title
      internal static let title = L10n.tr("Localizable", "Send.UsedAddress.title", fallback: "Address Already Used")
    }
    internal enum CameraUnavailabeMessage {
      /// Instructions how to allow the camera access for the app
      internal static let android = L10n.tr("Localizable", "Send.cameraUnavailabeMessage.android", fallback: "Allow camera access in \"Settings\" > \"Apps\" > \"RockWallet\" > \"Permissions\"")
    }
    internal enum CameraUnavailabeTitle {
      /// Permission required to access camera
      internal static let android = L10n.tr("Localizable", "Send.cameraUnavailabeTitle.android", fallback: "RockWallet is not allowed to access the camera")
    }
  }
  internal enum Settings {
    /// About label
    internal static let about = L10n.tr("Localizable", "Settings.about", fallback: "About")
    /// Advanced settings header
    internal static let advanced = L10n.tr("Localizable", "Settings.advanced", fallback: "Advanced")
    /// Advanced Settings title
    internal static let advancedTitle = L10n.tr("Localizable", "Settings.advancedTitle", fallback: "Advanced Settings")
    /// ATM map menu item title explaining that it's a feature only available in the USA
    internal static let atmMapMenuItemSubtitle = L10n.tr("Localizable", "Settings.atmMapMenuItemSubtitle", fallback: "Available in the USA only")
    /// ATM map menu item title
    internal static let atmMapMenuItemTitle = L10n.tr("Localizable", "Settings.atmMapMenuItemTitle", fallback: "Crypto ATM Map")
    /// i.e. the currency which will be displayed
    internal static let currency = L10n.tr("Localizable", "Settings.currency", fallback: "Display Currency")
    /// e.g. "USD Settings" (settings for how USD is handled)
    internal static func currencyPageTitle(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Settings.currencyPageTitle", String(describing: p1), fallback: "%1$@ Settings")
    }
    /// Section title for a collection of different settings screens, one for each currency
    internal static let currencySettings = L10n.tr("Localizable", "Settings.currencySettings", fallback: "Currency Settings")
    /// Debug crash
    internal static let debugCrash = L10n.tr("Localizable", "Settings.DebugCrash", fallback: "Debug crash")
    /// Developer Options
    internal static let developerOptions = L10n.tr("Localizable", "Settings.DeveloperOptions", fallback: "Developer Options")
    /// Join Early access label
    internal static let earlyAccess = L10n.tr("Localizable", "Settings.earlyAccess", fallback: "Join Early Access")
    /// Enable segwit.
    internal static let enableSegwit = L10n.tr("Localizable", "Settings.EnableSegwit", fallback: "Enable Segwit")
    /// Are you enjoying bread alert message body
    internal static let enjoying = L10n.tr("Localizable", "Settings.enjoying", fallback: "Are you enjoying RockWallet?")
    /// Export transaction history menu item
    internal static let exportTransfers = L10n.tr("Localizable", "Settings.exportTransfers", fallback: "Export transaction history to CSV")
    /// Face ID spending limit label
    internal static let faceIdLimit = L10n.tr("Localizable", "Settings.faceIdLimit", fallback: "Face ID Spending Limit")
    /// Redeem the funds stored on this private key.
    internal static let importTitle = L10n.tr("Localizable", "Settings.importTitle", fallback: "Redeem Private Key")
    /// Manage settings section header
    internal static let manage = L10n.tr("Localizable", "Settings.manage", fallback: "Manage")
    /// No log files found error message
    internal static let noLogsFound = L10n.tr("Localizable", "Settings.noLogsFound", fallback: "No Log files found. Please try again later.")
    /// Notifications label
    internal static let notifications = L10n.tr("Localizable", "Settings.notifications", fallback: "Notifications")
    /// Section header for "other settings".
    internal static let other = L10n.tr("Localizable", "Settings.other", fallback: "Other")
    /// Preferences settings section header
    internal static let preferences = L10n.tr("Localizable", "Settings.preferences", fallback: "Preferences")
    /// Tap here to reset the list of currencies to the default settings.
    internal static let resetCurrencies = L10n.tr("Localizable", "Settings.resetCurrencies", fallback: "Reset to Default Currencies")
    /// Leave review button label
    internal static let review = L10n.tr("Localizable", "Settings.review", fallback: "Leave us a Review")
    /// Rewards menu item
    internal static let rewards = L10n.tr("Localizable", "Settings.rewards", fallback: "Rewards")
    /// Share anonymous data label
    internal static let shareData = L10n.tr("Localizable", "Settings.shareData", fallback: "Share Anonymous Data")
    /// "Enables sharing balance to widget"
    internal static let shareWithWidget = L10n.tr("Localizable", "Settings.shareWithWidget", fallback: "Share portfolio data with widgets")
    /// Sync blockchain label
    internal static let sync = L10n.tr("Localizable", "Settings.sync", fallback: "Sync Blockchain")
    /// Settings title
    internal static let title = L10n.tr("Localizable", "Settings.title", fallback: "Menu")
    /// Touch ID spending limit label
    internal static let touchIdLimit = L10n.tr("Localizable", "Settings.touchIdLimit", fallback: "Touch ID Spending Limit")
    /// View legacy address (old format).
    internal static let viewLegacyAddress = L10n.tr("Localizable", "Settings.ViewLegacyAddress", fallback: "View Legacy Receive Address")
    /// Receive Bitcoin instructions
    internal static let viewLegacyAddressReceiveDescription = L10n.tr("Localizable", "Settings.ViewLegacyAddressReceiveDescription", fallback: "Only send Bitcoin (BTC) to this address. Any other asset sent to this address will be lost permanently.")
    /// Receive Bitcoin
    internal static let viewLegacyAddressReceiveTitle = L10n.tr("Localizable", "Settings.ViewLegacyAddressReceiveTitle", fallback: "Receive Bitcoin")
    /// Wallet Settings section header
    internal static let wallet = L10n.tr("Localizable", "Settings.wallet", fallback: "Wallets")
    /// Web Platform Debug URL
    internal static let webDebugUrl = L10n.tr("Localizable", "Settings.WebDebugUrl", fallback: "Web Platform Debug URL")
    /// Unlink/delete your wallet from the current device.
    internal static let wipe = L10n.tr("Localizable", "Settings.wipe", fallback: "Unlink from this device")
    internal enum TouchIdLimit {
      /// The fingerprint spending limit
      internal static let android = L10n.tr("Localizable", "Settings.touchIdLimit.android", fallback: "Fingerprint Authentication Spending Limit")
    }
    internal enum Wipe {
      /// Wipe/delete your wallet from the current device.
      internal static let android = L10n.tr("Localizable", "Settings.wipe.android", fallback: "Wipe wallet from this device")
    }
  }
  internal enum ShareData {
    /// Share data view body
    internal static let body = L10n.tr("Localizable", "ShareData.body", fallback: "Help improve RockWallet by sharing your anonymous data with us. This does not include any financial information. We respect your financial privacy.")
    /// Share data header
    internal static let header = L10n.tr("Localizable", "ShareData.header", fallback: "Share Data?")
    /// Share data switch label.
    internal static let toggleLabel = L10n.tr("Localizable", "ShareData.toggleLabel", fallback: "Share Anonymous Data?")
  }
  internal enum ShareGift {
    /// Approximate Total
    internal static let approximateTotal = L10n.tr("Localizable", "ShareGift.approximateTotal", fallback: "Approximate Total")
    /// A network fee will be deducted from the total when claimed.
    /// Actual value depends on current price of bitcoin.
    internal static let footerMessage1 = L10n.tr("Localizable", "ShareGift.footerMessage1", fallback: "A network fee will be deducted from the total when claimed.\nActual value depends on current price of bitcoin.")
    /// Download the RockWallet app for iPhone or Android.
    /// For more information visit RockWallet.com/gift
    internal static let footerMessage2 = L10n.tr("Localizable", "ShareGift.footerMessage2", fallback: "Download the RockWallet app for iPhone or Android.\nFor more information visit RockWallet.com/gift")
    /// Someone gifted you bitcoin!
    internal static let tagLine = L10n.tr("Localizable", "ShareGift.tagLine", fallback: "Someone gifted you bitcoin!")
    /// Bitcoin
    internal static let walletName = L10n.tr("Localizable", "ShareGift.walletName", fallback: "Bitcoin")
  }
  internal enum Staking {
    /// Button label: select a baker
    internal static let add = L10n.tr("Localizable", "Staking.add", fallback: "+ Select Baker")
    /// Baker cell: Free Space field header
    internal static let cellFreeSpaceHeader = L10n.tr("Localizable", "Staking.cellFreeSpaceHeader", fallback: "Free Space")
    /// Change
    internal static let changeValidator = L10n.tr("Localizable", "Staking.changeValidator", fallback: "Change")
    /// Delegate your Tezos account to a validator to earn a reward while keeping full security and control of your coins.
    internal static let descriptionTezos = L10n.tr("Localizable", "Staking.descriptionTezos", fallback: "Delegate your Tezos account to a validator to earn a reward while keeping full security and control of your coins.")
    /// Baker cell: Fee field header
    internal static let feeHeader = L10n.tr("Localizable", "Staking.feeHeader", fallback: "Fee:")
    /// Status label: current staking transaction is pending
    internal static let pendingTransaction = L10n.tr("Localizable", "Staking.pendingTransaction", fallback: "Transaction pending...")
    /// Button label: remove selected baker
    internal static let remove = L10n.tr("Localizable", "Staking.remove", fallback: "Remove")
    /// Baker cell: ROI field header
    internal static let roiHeader = L10n.tr("Localizable", "Staking.roiHeader", fallback: "Est. ROI")
    /// Modal title: Select Baker modal
    internal static let selectBakerTitle = L10n.tr("Localizable", "Staking.selectBakerTitle", fallback: "Select XTZ Delegate")
    /// Stake
    internal static let stake = L10n.tr("Localizable", "Staking.stake", fallback: "Stake")
    /// UI flag showing state of Tezos staking
    internal static let stakingActiveFlag = L10n.tr("Localizable", "Staking.stakingActiveFlag", fallback: "ACTIVE")
    /// UI flag showing state of Tezos staking
    internal static let stakingInactiveFlag = L10n.tr("Localizable", "Staking.stakingInactiveFlag", fallback: "INACTIVE")
    /// UI flag showing state of Tezos staking
    internal static let stakingPendingFlag = L10n.tr("Localizable", "Staking.stakingPendingFlag", fallback: "PENDING")
    /// Staking banner title
    internal static let stakingTitle = L10n.tr("Localizable", "Staking.stakingTitle", fallback: "Staking")
    /// staking to %1$@
    internal static func stakingTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Staking.stakingTo", String(describing: p1), fallback: "staking to %1$@")
    }
    /// Pending
    internal static let statusPending = L10n.tr("Localizable", "Staking.statusPending", fallback: "Pending")
    /// Staked!
    internal static let statusStaked = L10n.tr("Localizable", "Staking.statusStaked", fallback: "Staked!")
    /// Earn money while holding
    internal static let subTitle = L10n.tr("Localizable", "Staking.subTitle", fallback: "Earn money while holding")
    /// Tezos XTZ baker asset type
    internal static let tezosDune = L10n.tr("Localizable", "Staking.tezosDune", fallback: "Tezos & Dune")
    /// Tezos XTZ baker asset type
    internal static let tezosMultiasset = L10n.tr("Localizable", "Staking.tezosMultiasset", fallback: "Multiasset Pool")
    /// Tezos XTZ baker asset type
    internal static let tezosOnly = L10n.tr("Localizable", "Staking.tezosOnly", fallback: "Tezos-only")
    /// Stake %1$@
    internal static func title(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Staking.title", String(describing: p1), fallback: "Stake %1$@")
    }
    /// Unstake
    internal static let unstake = L10n.tr("Localizable", "Staking.unstake", fallback: "Unstake")
    /// Enter Validator Address
    internal static let validatorHint = L10n.tr("Localizable", "Staking.validatorHint", fallback: "Enter Validator Address")
  }
  internal enum StartPaperPhrase {
    /// button label
    internal static let againButtonTitle = L10n.tr("Localizable", "StartPaperPhrase.againButtonTitle", fallback: "Write Down Recovery Phrase Again")
    /// Paper key explanation text.
    internal static let body = L10n.tr("Localizable", "StartPaperPhrase.body", fallback: "Your Recovery Phrase is the only way to restore your RockWallet if your phone is lost, stolen, broken, or upgraded.\n\nWe will show you a list of words to write down on a piece of paper and keep safe.")
    /// button label
    internal static let buttonTitle = L10n.tr("Localizable", "StartPaperPhrase.buttonTitle", fallback: "Write Down Recovery Phrase")
    /// Argument is date; date should be on a new line
    internal static func date(_ p1: Any) -> String {
      return L10n.tr("Localizable", "StartPaperPhrase.date", String(describing: p1), fallback: "Last written down on\n %1$@")
    }
    internal enum Body {
      /// Paper key explanation text (Android-version)
      internal static let android = L10n.tr("Localizable", "StartPaperPhrase.Body.Android", fallback: "Your Recovery Phrase is the only way to restore your RockWallet if your phone is lost, stolen, broken, or upgraded.\n\nYour Recovery Phrase is also required if you change the security settings on your device.\n\nWe will show you a list of words to write down on a piece of paper and keep safe.")
    }
  }
  internal enum StartViewController {
    /// button label
    internal static let createButton = L10n.tr("Localizable", "StartViewController.createButton", fallback: "Create New Wallet")
    /// Start view message
    internal static let message = L10n.tr("Localizable", "StartViewController.message", fallback: "Moving money forward.")
    /// Recover your wallet from a backup
    internal static let recoverButton = L10n.tr("Localizable", "StartViewController.recoverButton", fallback: "Recover Wallet")
  }
  internal enum SupportForm {
    /// We would love your feedback
    internal static let feedbackAppreciated = L10n.tr("Localizable", "SupportForm.feedbackAppreciated", fallback: "We would love your feedback")
    /// Help us improve
    internal static let helpUsImprove = L10n.tr("Localizable", "SupportForm.helpUsImprove", fallback: "Help us improve")
    /// Not now
    internal static let notNow = L10n.tr("Localizable", "SupportForm.notNow", fallback: "Not now")
    /// Please describe your experience
    internal static let pleaseDescribe = L10n.tr("Localizable", "SupportForm.pleaseDescribe", fallback: "Please describe your experience")
  }
  internal enum Swap {
    /// Add item label in swap flow
    internal static let addItem = L10n.tr("Localizable", "Swap.AddItem", fallback: "Add item!")
    /// Amount purchased label in detail swap screen
    internal static let amountPurchased = L10n.tr("Localizable", "Swap.AmountPurchased", fallback: "Amount purchased")
    /// Back to Home button
    internal static let backToHome = L10n.tr("Localizable", "Swap.BackToHome", fallback: "Back to Home")
    /// Balance text on swap
    internal static func balance(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.Balance", p1, p2, fallback: "I have %s %s")
    }
    /// Card fee label in swap details screen
    internal static let cardFee = L10n.tr("Localizable", "Swap.CardFee", fallback: "Card fee")
    /// Title on check your assets popup
    internal static let checkAssets = L10n.tr("Localizable", "Swap.CheckAssets", fallback: "Check your assets!")
    /// Text body in check your assets popup
    internal static let checkAssetsBody = L10n.tr("Localizable", "Swap.CheckAssetsBody", fallback: "In order to successfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.")
    /// Swap details title
    internal static let details = L10n.tr("Localizable", "Swap.Details", fallback: "Swap details")
    /// Asset needs to be enabled first. You can do that by selecting ‘Manage assets’ on the home screen.
    internal static let enableAssetFirst = L10n.tr("Localizable", "Swap.enableAssetFirst", fallback: "Asset needs to be enabled first. You can do that by selecting ‘Manage assets’ on the home screen.")
    /// There was an error while processing your transaction title in failure swap screen
    internal static let errorProcessingTransaction = L10n.tr("Localizable", "Swap.ErrorProcessingTransaction", fallback: "There was an error while processing your transaction")
    /// Error swap message on Failure screen
    internal static let failureSwapMessage = L10n.tr("Localizable", "Swap.FailureSwapMessage", fallback: "Please try swapping again or come back later.")
    /// Popup button got it
    internal static let gotItButton = L10n.tr("Localizable", "Swap.GotItButton", fallback: "Got it!")
    /// Swap and Buy I want label from currency
    internal static let iWant = L10n.tr("Localizable", "Swap.iWant", fallback: "I want")
    /// Mining network fee label in swap details screen
    internal static let miningNetworkFee = L10n.tr("Localizable", "Swap.MiningNetworkFee", fallback: "Mining network fee")
    /// Not a valid pair
    internal static let notValidPair = L10n.tr("Localizable", "Swap.NotValidPair", fallback: "Not a valid pair")
    /// Paid with label in swap details screen
    internal static let paidWith = L10n.tr("Localizable", "Swap.PaidWith", fallback: "Paid with")
    /// Rate label in swap screen
    internal static let rateValue = L10n.tr("Localizable", "Swap.RateValue", fallback: "Rate")
    /// Receiving network fee text label on Swap screen
    internal static let receiveNetworkFee = L10n.tr("Localizable", "Swap.ReceiveNetworkFee", fallback: "Receiving network fee")
    /// Your swap request timed out. Please try again.
    internal static let requestTimedOut = L10n.tr("Localizable", "Swap.RequestTimedOut", fallback: "Your swap request timed out. Please try again.")
    /// Retry
    internal static let retry = L10n.tr("Localizable", "Swap.retry", fallback: "Retry")
    /// Select assets title in swap flow
    internal static let selectAssets = L10n.tr("Localizable", "Swap.SelectAssets", fallback: "Select assets")
    /// Sending fee label on swap screen
    internal static let sendingFee = L10n.tr("Localizable", "Swap.SendingFee", fallback: "Sending fee\n")
    /// Sending network fee text label on Swap screen
    internal static let sendNetworkFee = L10n.tr("Localizable", "Swap.SendNetworkFee", fallback: "Sending network fee")
    /// Swap again button title in swap failure screen
    internal static let swapAgain = L10n.tr("Localizable", "Swap.SwapAgain", fallback: "Swap again")
    /// Swap min and max limit text
    internal static func swapLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapLimits", p1, p2, fallback: "Currently, minimum for Swap is %s USD and maximum is %s USD/day.")
    }
    /// Swapping %1$@ to %2$@
    internal static func swapping(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Swap.Swapping", String(describing: p1), String(describing: p2), fallback: "Swapping %1$@ to %2$@")
    }
    /// Swap status message on swap flow
    internal static func swapStatus(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapStatus", p1, fallback: "Your %s is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.")
    }
    /// Swap is temporarily unavailable
    internal static let temporarilyUnavailable = L10n.tr("Localizable", "Swap.temporarilyUnavailable", fallback: "Swap is temporarily unavailable")
    /// Timestamp label in swap details screen
    internal static let timestamp = L10n.tr("Localizable", "Swap.Timestamp", fallback: "Timestamp")
    /// Total label in swap details screen
    internal static let total = L10n.tr("Localizable", "Swap.Total", fallback: "Total:")
    /// From %1$@
    internal static func transactionFrom(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Swap.transactionFrom", String(describing: p1), fallback: "From %1$@")
    }
    /// Transaction ID label in swap details screen
    internal static let transactionID = L10n.tr("Localizable", "Swap.TransactionID", fallback: "RockWallet Transaction ID")
    /// It seems that your transaction takes place in the Ethereum network, please keep in mind that network fees will be charged in ETH
    internal static let transactionInEthereumNetwork = L10n.tr("Localizable", "Swap.transactionInEthereumNetwork", fallback: "It seems that your transaction takes place in the Ethereum network, please keep in mind that network fees will be charged in ETH")
    /// To %1$@
    internal static func transactionTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Swap.transactionTo", String(describing: p1), fallback: "To %1$@")
    }
    /// You'll receive
    internal static let youReceive = L10n.tr("Localizable", "Swap.youReceive", fallback: "You'll receive")
    /// You send
    internal static let youSend = L10n.tr("Localizable", "Swap.youSend", fallback: "You send")
    internal enum AmountPurchased {
      /// Amount purchased:
      internal static let android = L10n.tr("Localizable", "Swap.AmountPurchased.android", fallback: "Amount purchased:")
    }
    internal enum CardFee {
      /// Card fee:
      internal static let android = L10n.tr("Localizable", "Swap.CardFee.android", fallback: "Card fee:")
    }
    internal enum MiningNetworkFee {
      /// Mining network fee:
      internal static let android = L10n.tr("Localizable", "Swap.MiningNetworkFee.android", fallback: "Mining network fee:")
    }
  }
  internal enum Symbols {
    /// u{1F512}
    internal static let lock = L10n.tr("Localizable", "Symbols.lock", fallback: "u{1F512}")
  }
  internal enum SyncingView {
    /// Syncing view done syncing state header text
    internal static let activity = L10n.tr("Localizable", "SyncingView.activity", fallback: "Activity")
    /// Syncing view connectiong state header text
    internal static let connecting = L10n.tr("Localizable", "SyncingView.connecting", fallback: "Connecting")
    /// The sync has failed (to complete)
    internal static let failed = L10n.tr("Localizable", "SyncingView.failed", fallback: "Sync Failed")
    /// Syncing view header text
    internal static let header = L10n.tr("Localizable", "SyncingView.header", fallback: "Syncing")
    /// Retry button label
    internal static let retry = L10n.tr("Localizable", "SyncingView.retry", fallback: "Retry")
    /// "eg. Synced through <Jan 12, 2015>
    internal static func syncedThrough(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SyncingView.syncedThrough", String(describing: p1), fallback: "Synced through %1$@")
    }
    /// Syncing view syncing state header text
    internal static let syncing = L10n.tr("Localizable", "SyncingView.syncing", fallback: "Syncing")
  }
  internal enum TimeSince {
    /// 6 d (6 days)
    internal static func days(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.days", String(describing: p1), fallback: "%1$@ d")
    }
    /// 6 h (6 hours)
    internal static func hours(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.hours", String(describing: p1), fallback: "%1$@ h")
    }
    /// 6 m (6 minutes)
    internal static func minutes(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.minutes", String(describing: p1), fallback: "%1$@ m")
    }
    /// 6 s (6 seconds)
    internal static func seconds(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.seconds", String(describing: p1), fallback: "%1$@ s")
    }
  }
  internal enum Title {
    /// Auto-enter PIN
    internal static let autoEnterPin = L10n.tr("Localizable", "Title.AutoEnterPin", fallback: "Auto-enter PIN")
    /// Connection Settings Override
    internal static let connectionSettingsOverride = L10n.tr("Localizable", "Title.ConnectionSettingsOverride", fallback: "Connection Settings Override")
    /// Fast Sync
    internal static let fastSync = L10n.tr("Localizable", "Title.FastSync", fallback: "Fast Sync")
    /// Lock Wallet
    internal static let lockWallet = L10n.tr("Localizable", "Title.LockWallet", fallback: "Lock Wallet")
    /// RockWallet - Feedback
    internal static let rockwalletFeedback = L10n.tr("Localizable", "Title.RockwalletFeedback", fallback: "RockWallet - Feedback")
    /// Save
    internal static let save = L10n.tr("Localizable", "Title.Save", fallback: "Save")
    /// Search assets
    internal static let searchAssets = L10n.tr("Localizable", "Title.searchAssets", fallback: "Search assets")
    /// Send Logs
    internal static let sendLogs = L10n.tr("Localizable", "Title.SendLogs", fallback: "Send Logs")
    /// Suppress paper key prompt
    internal static let suppressPaperKeyPrompt = L10n.tr("Localizable", "Title.SuppressPaperKeyPrompt", fallback: "Suppress paper key prompt")
    /// Unlink Wallet (no prompt)
    internal static let unlinkWalletNoPrompt = L10n.tr("Localizable", "Title.UnlinkWalletNoPrompt", fallback: "Unlink Wallet (no prompt)")
  }
  internal enum TokenList {
    /// Add [this item to the list]
    internal static let add = L10n.tr("Localizable", "TokenList.add", fallback: "Add")
    /// Add Wallets  [to your home screen]
    internal static let addTitle = L10n.tr("Localizable", "TokenList.addTitle", fallback: "Add Assets")
    /// Hide [this token from view]
    internal static let hide = L10n.tr("Localizable", "TokenList.hide", fallback: "Hide")
    /// [click here to] Manage [your] Wallets
    internal static let manageTitle = L10n.tr("Localizable", "TokenList.manageTitle", fallback: "Manage Assets")
    /// Remove [this item from the list]
    internal static let remove = L10n.tr("Localizable", "TokenList.remove", fallback: "Remove")
    /// Show [this item on your home screen]
    internal static let show = L10n.tr("Localizable", "TokenList.show", fallback: "Show")
  }
  internal enum TouchIdSettings {
    /// You can customize your Touch ID Spending Limit from the [TouchIdSettings.linkText gets added here as a button]
    internal static func customizeText(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TouchIdSettings.customizeText", String(describing: p1), fallback: "You can customize your Touch ID spending limit from the %1$@.")
    }
    /// Text that describes the purpose of the Touch ID settings in the BRD app.
    internal static let explanatoryText = L10n.tr("Localizable", "TouchIdSettings.explanatoryText", fallback: "Use Touch ID to unlock your RockWallet app and send money.")
    /// Touch Id screen label
    internal static let label = L10n.tr("Localizable", "TouchIdSettings.label", fallback: "Use your fingerprint to unlock your RockWallet and send money up to a set limit.")
    /// Link Text (see TouchIdSettings.customizeText)
    internal static let linkText = L10n.tr("Localizable", "TouchIdSettings.linkText", fallback: "Touch ID Spending Limit Screen")
    /// Spending Limit: b100,000 ($100)
    internal static func spendingLimit(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TouchIdSettings.spendingLimit", String(describing: p1), String(describing: p2), fallback: "Spending limit: %1$@ (%2$@)")
    }
    /// Touch id switch label.
    internal static let switchLabel = L10n.tr("Localizable", "TouchIdSettings.switchLabel", fallback: "Enable Touch ID for RockWallet")
    /// Touch ID settings view title
    internal static let title = L10n.tr("Localizable", "TouchIdSettings.title", fallback: "Touch ID")
    /// Text label for a toggle that enables Touch ID for sending money.
    internal static let transactionsTitleText = L10n.tr("Localizable", "TouchIdSettings.transactionsTitleText", fallback: "Enable Touch ID to send money")
    /// Touch ID unavailable alert message
    internal static let unavailableAlertMessage = L10n.tr("Localizable", "TouchIdSettings.unavailableAlertMessage", fallback: "You have not set up Touch ID on this device. Go to Settings->Touch ID & Passcode to set it up now.")
    /// Touch ID unavailable alert title
    internal static let unavailableAlertTitle = L10n.tr("Localizable", "TouchIdSettings.unavailableAlertTitle", fallback: "Touch ID Not Set Up")
    /// Text label for the toggle that enables Touch ID for unlocking the BRD app.
    internal static let unlockTitleText = L10n.tr("Localizable", "TouchIdSettings.unlockTitleText", fallback: "Enable Touch ID to unlock RockWallet")
    internal enum CustomizeText {
      /// Fingerprint enabling description body
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.customizeText.android", fallback: "You can customize your Fingerprint Authentication Spending Limit from the Fingerprint Authorization Spending Limit screen")
    }
    internal enum DisabledWarning {
      internal enum Body {
        /// Instruction for the fingerprint setup
        internal static let android = L10n.tr("Localizable", "TouchIdSettings.disabledWarning.body.android", fallback: "You have not enabled fingerprint authentication on this device. Go to Settings -> Security to set up fingerprint authentication.")
      }
      internal enum Title {
        /// Fingerprint Is Not Setup
        internal static let android = L10n.tr("Localizable", "TouchIdSettings.disabledWarning.title.android", fallback: "Fingerprint Authentication Not Enabled")
      }
    }
    internal enum SwitchLabel {
      /// Enable fingerprint for this wallet called Bread
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.switchLabel.android", fallback: "Enable Fingerprint Authentication")
    }
    internal enum Title {
      /// Fingerprint authentication label
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.title.android", fallback: "Fingerprint Authentication")
    }
  }
  internal enum TouchIdSpendingLimit {
    /// Touch ID spending limit screen body
    internal static let body = L10n.tr("Localizable", "TouchIdSpendingLimit.body", fallback: "You will be asked to enter your 6-digit PIN to send any transaction over your spending limit, and every 48 hours since the last time you entered your 6-digit PIN.")
    /// Touch Id spending limit screen title
    internal static let title = L10n.tr("Localizable", "TouchIdSpendingLimit.title", fallback: "Touch ID Spending Limit")
    internal enum Title {
      /// name of spending limit when using fingerprint authorization
      internal static let android = L10n.tr("Localizable", "TouchIdSpendingLimit.title.android", fallback: "Fingerprint Authorization Spending Limit")
    }
  }
  internal enum Transaction {
    /// Availability status text
    internal static let available = L10n.tr("Localizable", "Transaction.available", fallback: "Available to Spend")
    /// Transaction complete label
    internal static let complete = L10n.tr("Localizable", "Transaction.complete", fallback: "Complete")
    /// Transaction is confirming status text
    internal static let confirming = L10n.tr("Localizable", "Transaction.confirming", fallback: "In Progress")
    /// eg. Ending balance: $50.00
    internal static func ending(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.ending", String(describing: p1), fallback: "Ending balance: %1$@")
    }
    /// Exchange rate on date header
    internal static let exchangeOnDayReceived = L10n.tr("Localizable", "Transaction.exchangeOnDayReceived", fallback: "Exchange rate when received:")
    /// Exchange rate on date header
    internal static let exchangeOnDaySent = L10n.tr("Localizable", "Transaction.exchangeOnDaySent", fallback: "Exchange rate when sent:")
    /// Transaction failed status text
    internal static let failed = L10n.tr("Localizable", "Transaction.failed", fallback: "Failed")
    /// Failed swap label in transaction view
    internal static let failedSwap = L10n.tr("Localizable", "Transaction.FailedSwap", fallback: "Failed swap")
    /// (b600 fee)
    internal static func fee(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.fee", String(describing: p1), fallback: "(%1$@ fee)")
    }
    /// Invalid transaction
    internal static let invalid = L10n.tr("Localizable", "Transaction.invalid", fallback: "INVALID")
    /// Timestamp label for event that just happened
    internal static let justNow = L10n.tr("Localizable", "Transaction.justNow", fallback: "just now")
    /// Manually settled
    internal static let manuallySettled = L10n.tr("Localizable", "Transaction.ManuallySettled", fallback: "Manually settled")
    /// Transaction is pending status text
    internal static let pending = L10n.tr("Localizable", "Transaction.pending", fallback: "Pending")
    /// Pending purchase label in transaction view
    internal static let pendingPurchase = L10n.tr("Localizable", "Transaction.PendingPurchase", fallback: "Pending purchase")
    /// Pending purchase with ACH
    internal static let pendingPurchaseWithAch = L10n.tr("Localizable", "Transaction.PendingPurchaseWithAch", fallback: "Pending purchase with ACH")
    /// Pending swap label in transaction view
    internal static let pendingSwap = L10n.tr("Localizable", "Transaction.PendingSwap", fallback: "Pending swap")
    /// Pending withdraw with ACH
    internal static let pendingWithdrawWithAch = L10n.tr("Localizable", "Transaction.PendingWithdrawWithAch", fallback: "Pending withdraw with ACH")
    /// Purchased label in transaction view
    internal static let purchased = L10n.tr("Localizable", "Transaction.Purchased", fallback: "Purchased")
    /// Purchased with ACH
    internal static let purchasedWithAch = L10n.tr("Localizable", "Transaction.PurchasedWithAch", fallback: "Purchased with ACH")
    /// Purchase failed label in transaction view
    internal static let purchaseFailed = L10n.tr("Localizable", "Transaction.PurchaseFailed", fallback: "Purchase failed")
    /// Purchase with ACH failed
    internal static let purchaseFailedWithAch = L10n.tr("Localizable", "Transaction.PurchaseFailedWithAch", fallback: "Purchase with ACH failed")
    /// Receive status text: 'In progress: 20%'
    internal static func receivedStatus(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.receivedStatus", String(describing: p1), fallback: "In progress: %1$@")
    }
    /// Refunded
    internal static let refunded = L10n.tr("Localizable", "Transaction.refunded", fallback: "Refunded")
    /// Send status text: 'In progress: 20%'
    internal static func sendingStatus(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sendingStatus", String(describing: p1), fallback: "In progress: %1$@")
    }
    /// sending to <address>
    internal static func sendingTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sendingTo", String(describing: p1), fallback: "sending to %1$@")
    }
    /// sent to <address>
    internal static func sentTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sentTo", String(describing: p1), fallback: "sent to %1$@")
    }
    /// staking to %1$@
    internal static func stakingTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.stakingTo", String(describing: p1), fallback: "staking to %1$@")
    }
    /// eg. Starting balance: $50.00
    internal static func starting(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.starting", String(describing: p1), fallback: "Starting balance: %1$@")
    }
    /// Swap from %s failed
    internal static func swapFromFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swapFromFailed", p1, fallback: "Swap from %s failed")
    }
    /// Swapped transaction label
    internal static let swapped = L10n.tr("Localizable", "Transaction.Swapped", fallback: "Swapped")
    /// Swapped from %s
    internal static func swappedFrom(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappedFrom", p1, fallback: "Swapped from %s")
    }
    /// Swapped to %s
    internal static func swappedTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappedTo", p1, fallback: "Swapped to %s")
    }
    /// Swapping from %s
    internal static func swappingFrom(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappingFrom", p1, fallback: "Swapping from %s")
    }
    /// Swapping to %s
    internal static func swappingTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappingTo", p1, fallback: "Swapping to %s")
    }
    /// Swap to %s failed
    internal static func swapToFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swapToFailed", p1, fallback: "Swap to %s failed")
    }
    /// e.g. "[The money you paid was a] Fee for token transfer: BRD" (BRD is the token that was transfered)
    internal static func tokenTransfer(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.tokenTransfer", String(describing: p1), fallback: "Fee for token transfer: %1$@")
    }
    /// to %1$@
    internal static func toRecipient(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.toRecipient", String(describing: p1), fallback: "to %1$@")
    }
    /// Waiting to be confirmed string
    internal static let waiting = L10n.tr("Localizable", "Transaction.waiting", fallback: "Waiting to be confirmed. Some merchants require confirmation to complete a transaction. Estimated time: 1-2 hours.")
  }
  internal enum TransactionDetails {
    /// e.g. I received money from an account.
    internal static let account = L10n.tr("Localizable", "TransactionDetails.account", fallback: "account")
    /// Address received from header
    internal static let addressFromHeader = L10n.tr("Localizable", "TransactionDetails.addressFromHeader", fallback: "From")
    /// Address sent to header
    internal static let addressToHeader = L10n.tr("Localizable", "TransactionDetails.addressToHeader", fallback: "To")
    /// e.g. "(this was received) via (address #1)" via = by way of
    internal static let addressViaHeader = L10n.tr("Localizable", "TransactionDetails.addressViaHeader", fallback: "From")
    /// Amount section header
    internal static let amountHeader = L10n.tr("Localizable", "TransactionDetails.amountHeader", fallback: "Amount")
    /// "(it was worth) $100 when sent, (and it is worth) $200 now"
    internal static func amountWhenReceived(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.amountWhenReceived", String(describing: p1), String(describing: p2), fallback: "%1$@ when received, %2$@ now")
    }
    /// "(it was worth) $100 when sent, (and it is worth) $200 now"
    internal static func amountWhenSent(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.amountWhenSent", String(describing: p1), String(describing: p2), fallback: "%1$@ when sent, %2$@ now")
    }
    /// Block height label
    internal static let blockHeightLabel = L10n.tr("Localizable", "TransactionDetails.blockHeightLabel", fallback: "Confirmed in Block")
    /// Memo section header
    internal static let commentsHeader = L10n.tr("Localizable", "TransactionDetails.commentsHeader", fallback: "Memo")
    /// Memo field placeholder
    internal static let commentsPlaceholder = L10n.tr("Localizable", "TransactionDetails.commentsPlaceholder", fallback: "Add memo...")
    /// Timestamp section header for complete tx
    internal static let completeTimestampHeader = L10n.tr("Localizable", "TransactionDetails.completeTimestampHeader", fallback: "Complete")
    /// Block height and confirmations label, eg. 182930 (45061 confirmations)
    internal static let confirmationsLabel = L10n.tr("Localizable", "TransactionDetails.confirmationsLabel", fallback: "Confirmations")
    /// Destination Tag
    internal static let destinationTag = L10n.tr("Localizable", "TransactionDetails.destinationTag", fallback: "Destination Tag")
    /// (empty)
    internal static let destinationTagEmptyHint = L10n.tr("Localizable", "TransactionDetails.destinationTag_EmptyHint", fallback: "(empty)")
    /// Empty transaction list message.
    internal static let emptyMessage = L10n.tr("Localizable", "TransactionDetails.emptyMessage", fallback: "Your transactions will appear here.")
    /// e.g. the users balance after the transaction was compeleted
    internal static let endingBalanceHeader = L10n.tr("Localizable", "TransactionDetails.endingBalanceHeader", fallback: "Ending Balance")
    /// Exchange rate section header
    internal static let exchangeRateHeader = L10n.tr("Localizable", "TransactionDetails.exchangeRateHeader", fallback: "Exchange Rate")
    /// Tx detail field header
    internal static let feeHeader = L10n.tr("Localizable", "TransactionDetails.feeHeader", fallback: "Total Fee")
    /// "Received [$5] at [which of my addresses]" => This is the "at [which of my addresses]" part.
    internal static func from(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.from", String(describing: p1), fallback: "at %1$@")
    }
    /// Tx detail field header
    internal static let gasLimitHeader = L10n.tr("Localizable", "TransactionDetails.gasLimitHeader", fallback: "Gas Limit")
    /// Tx detail field header
    internal static let gasPriceHeader = L10n.tr("Localizable", "TransactionDetails.gasPriceHeader", fallback: "Gas Price")
    /// Gift
    internal static let gift = L10n.tr("Localizable", "TransactionDetails.gift", fallback: "Gift")
    /// Gifted to %1$@
    internal static func giftedTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.giftedTo", String(describing: p1), fallback: "Gifted to %1$@")
    }
    /// Label for Hedera Memo field on transaction details screen
    internal static let hederaMemo = L10n.tr("Localizable", "TransactionDetails.hederaMemo", fallback: "Hedera Memo")
    /// Hide Details button
    internal static let hideDetails = L10n.tr("Localizable", "TransactionDetails.hideDetails", fallback: "Hide Details")
    /// Label showing the transaction was started (initialized)
    internal static let initializedTimestampHeader = L10n.tr("Localizable", "TransactionDetails.initializedTimestampHeader", fallback: "Initialized")
    /// More button title
    internal static let more = L10n.tr("Localizable", "TransactionDetails.more", fallback: "More...")
    /// Moved $5.00 (as in "I moved $5 to another location")
    internal static func moved(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.moved", String(describing: p1), fallback: "Moved %1$@")
    }
    /// Moved $5.00
    internal static func movedAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.movedAmountDescription", String(describing: p1), fallback: "Moved <b>%1$@</b>")
    }
    /// eg. Confirmed in Block: Not Confirmed
    internal static let notConfirmedBlockHeightLabel = L10n.tr("Localizable", "TransactionDetails.notConfirmedBlockHeightLabel", fallback: "Not Confirmed")
    /// "Received [$5] at [which of my addresses]" => This is the "Received [$5]" part.
    internal static func received(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.received", String(describing: p1), fallback: "Received %1$@")
    }
    /// Received $5.00
    internal static func receivedAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedAmountDescription", String(describing: p1), fallback: "Received <b>%1$@</b>")
    }
    /// received from <address>
    internal static func receivedFrom(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedFrom", String(describing: p1), fallback: "received from %1$@")
    }
    /// received via <address>
    internal static func receivedVia(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedVia", String(describing: p1), fallback: "received via %1$@")
    }
    /// receiving from <address>
    internal static func receivingFrom(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivingFrom", String(describing: p1), fallback: "receiving from %1$@")
    }
    /// receiving via <address>
    internal static func receivingVia(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivingVia", String(describing: p1), fallback: "receiving via %1$@")
    }
    /// Reclaim
    internal static let reclaim = L10n.tr("Localizable", "TransactionDetails.reclaim", fallback: "Reclaim")
    /// Resend
    internal static let resend = L10n.tr("Localizable", "TransactionDetails.resend", fallback: "Resend")
    /// "Sent [$5] to [address]" => This is the "Sent [$5]" part.
    internal static func sent(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.sent", String(describing: p1), fallback: "Sent %1$@")
    }
    /// Sent $5.00
    internal static func sentAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.sentAmountDescription", String(describing: p1), fallback: "Sent <b>%1$@</b>")
    }
    /// Show Details button
    internal static let showDetails = L10n.tr("Localizable", "TransactionDetails.showDetails", fallback: "Show Details")
    /// The balance the user started with before the transaction completed
    internal static let startingBalanceHeader = L10n.tr("Localizable", "TransactionDetails.startingBalanceHeader", fallback: "Starting Balance")
    /// Status section header
    internal static let statusHeader = L10n.tr("Localizable", "TransactionDetails.statusHeader", fallback: "Status")
    /// Transaction Details Title
    internal static let title = L10n.tr("Localizable", "TransactionDetails.title", fallback: "Transaction Details")
    /// Transaction Details Title - Failed
    internal static let titleFailed = L10n.tr("Localizable", "TransactionDetails.titleFailed", fallback: "Failed")
    /// Transaction Details Title - Internal
    internal static let titleInternal = L10n.tr("Localizable", "TransactionDetails.titleInternal", fallback: "Internal")
    /// Transaction Details Title - Received
    internal static let titleReceived = L10n.tr("Localizable", "TransactionDetails.titleReceived", fallback: "Received")
    /// Transaction Details Title - Receiving
    internal static let titleReceiving = L10n.tr("Localizable", "TransactionDetails.titleReceiving", fallback: "Receiving")
    /// Transaction Details Title - Sending
    internal static let titleSending = L10n.tr("Localizable", "TransactionDetails.titleSending", fallback: "Sending")
    /// Transaction Details Title - Sent
    internal static let titleSent = L10n.tr("Localizable", "TransactionDetails.titleSent", fallback: "Sent")
    /// "Sent [$5] to [address]" => This is the "to [address]" part.
    internal static func to(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.to", String(describing: p1), fallback: "to %1$@")
    }
    /// Tx detail field header
    internal static let totalHeader = L10n.tr("Localizable", "TransactionDetails.totalHeader", fallback: "Total")
    /// Transaction ID header
    internal static let txHashHeader = L10n.tr("Localizable", "TransactionDetails.txHashHeader", fallback: "Transaction ID")
  }
  internal enum TransactionDirection {
    /// (this transaction was) Received at this address:
    internal static let address = L10n.tr("Localizable", "TransactionDirection.address", fallback: "Received at this Address")
    /// (this transaction was) Sent to this address:
    internal static let to = L10n.tr("Localizable", "TransactionDirection.to", fallback: "Sent to this Address")
  }
  internal enum UDomains {
    /// Invalid address.
    internal static let invalid = L10n.tr("Localizable", "UDomains.invalid", fallback: "Invalid address.")
  }
  internal enum URLHandling {
    /// Authorize to copy wallet addresses alert message
    internal static let addressaddressListAlertMessage = L10n.tr("Localizable", "URLHandling.addressaddressListAlertMessage", fallback: "Copy wallet addresses to clipboard?")
    /// Authorize to copy wallet address PIN view prompt.
    internal static let addressList = L10n.tr("Localizable", "URLHandling.addressList", fallback: "Authorize to copy wallet address to clipboard")
    /// Authorize to copy wallet address alert title
    internal static let addressListAlertTitle = L10n.tr("Localizable", "URLHandling.addressListAlertTitle", fallback: "Copy Wallet Addresses")
    /// Copy wallet addresses alert button label
    internal static let copy = L10n.tr("Localizable", "URLHandling.copy", fallback: "Copy")
  }
  internal enum UnlockScreen {
    /// Disabled until date
    internal static func disabled(_ p1: Any) -> String {
      return L10n.tr("Localizable", "UnlockScreen.disabled", String(describing: p1), fallback: "Disabled until: %1$@")
    }
    /// Unlock with FaceID accessibility label
    internal static let faceIdText = L10n.tr("Localizable", "UnlockScreen.faceIdText", fallback: "Unlock with FaceID")
    /// My Address button title
    internal static let myAddress = L10n.tr("Localizable", "UnlockScreen.myAddress", fallback: "My Address")
    /// Reset PIN with Paper Key button label.
    internal static let resetPin = L10n.tr("Localizable", "UnlockScreen.resetPin", fallback: "Reset your PIN")
    /// Scan button title
    internal static let scan = L10n.tr("Localizable", "UnlockScreen.scan", fallback: "Scan")
    /// TouchID prompt text
    internal static let touchIdPrompt = L10n.tr("Localizable", "UnlockScreen.touchIdPrompt", fallback: "Unlock your RockWallet.")
    /// Unlock with TouchID accessibility label
    internal static let touchIdText = L10n.tr("Localizable", "UnlockScreen.touchIdText", fallback: "Unlock with TouchID")
    /// Wallet disabled header
    internal static let walletDisabled = L10n.tr("Localizable", "UnlockScreen.walletDisabled", fallback: "Wallet disabled")
    /// Wallet disabled description
    internal static let walletDisabledDescription = L10n.tr("Localizable", "UnlockScreen.walletDisabledDescription", fallback: "You will need your Recovery Phrases to reset PIN.")
    /// Wipe wallet prompt
    internal static let wipePrompt = L10n.tr("Localizable", "UnlockScreen.wipePrompt", fallback: "Are you sure you would like to wipe this wallet?")
    internal enum TouchIdInstructions {
      /// Instruction to touch the sensor for fingerprint authentication
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdInstructions.android", fallback: "Touch Sensor")
    }
    internal enum TouchIdPrompt {
      /// Device authentication body
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdPrompt.android", fallback: "Please unlock your Android device to continue.")
    }
    internal enum TouchIdTitle {
      /// Device authentication title
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdTitle.android", fallback: "Authentication required")
    }
  }
  internal enum UpdatePin {
    /// Update PIN caption text
    internal static let caption = L10n.tr("Localizable", "UpdatePin.caption", fallback: "Remember this PIN. If you forget it, you won't be able to access your assets")
    /// Contact Support button on update pin view
    internal static let contactSupport = L10n.tr("Localizable", "UpdatePin.ContactSupport", fallback: "Contact Support")
    /// PIN creation info.
    internal static let createInstruction = L10n.tr("Localizable", "UpdatePin.createInstruction", fallback: "Your PIN will be used to unlock your wallet")
    /// Update PIN title
    internal static let createTitle = L10n.tr("Localizable", "UpdatePin.createTitle", fallback: "Set PIN")
    /// Update PIN title
    internal static let createTitleConfirm = L10n.tr("Localizable", "UpdatePin.createTitleConfirm", fallback: "Confirm your new PIN")
    /// Disabled until text on disabled wallet view
    internal static let disabledUntil = L10n.tr("Localizable", "UpdatePin.DisabledUntil", fallback: "Disabled until:")
    /// Enter current PIN instruction
    internal static let enterCurrent = L10n.tr("Localizable", "UpdatePin.enterCurrent", fallback: "Enter your current PIN")
    /// Enter new PIN instruction
    internal static let enterNew = L10n.tr("Localizable", "UpdatePin.enterNew", fallback: "Enter your new PIN")
    /// Enter your PIN label to finish the transaction
    internal static let enterPin = L10n.tr("Localizable", "UpdatePin.EnterPin", fallback: "Please enter your PIN to confirm the transaction")
    /// Enter PIN instruction
    internal static let enterYourPin = L10n.tr("Localizable", "UpdatePin.enterYourPin", fallback: "Enter your PIN")
    /// Incorrect PIN popup message
    internal static let incorrectPin = L10n.tr("Localizable", "UpdatePin.IncorrectPin", fallback: "Incorrect PIN. The wallet will get disabled for 6 minutes after")
    /// Number of attempts left on pin entry screen
    internal static let oneAttempt = L10n.tr("Localizable", "UpdatePin.OneAttempt", fallback: "1 more failed attempt.")
    /// Your PIN doesn’t match, please try again.
    internal static let pinDoesntMatch = L10n.tr("Localizable", "UpdatePin.pinDoesntMatch", fallback: "Your PIN doesn’t match, please try again.")
    /// Re-Enter new PIN instruction
    internal static let reEnterNew = L10n.tr("Localizable", "UpdatePin.reEnterNew", fallback: "Re-enter your new PIN")
    /// Attempts remaining on pin entry screen
    internal static let remainingAttempts = L10n.tr("Localizable", "UpdatePin.RemainingAttempts", fallback: "Attempts remaining:")
    /// Your PIN was reset successfully message
    internal static let resetPinSuccess = L10n.tr("Localizable", "UpdatePin.ResetPinSuccess", fallback: "Your PIN was reset successfully!")
    /// Enter PIN header
    internal static let securedWallet = L10n.tr("Localizable", "UpdatePin.securedWallet", fallback: "Secured wallet")
    /// Update PIN title
    internal static let setNewPinTitle = L10n.tr("Localizable", "UpdatePin.setNewPinTitle", fallback: "Set your PIN")
    /// Update PIN failure error message.
    internal static let setPinError = L10n.tr("Localizable", "UpdatePin.setPinError", fallback: "Something went wrong updating your PIN. Please try again.")
    /// Update PIN failure alert view title
    internal static let setPinErrorTitle = L10n.tr("Localizable", "UpdatePin.setPinErrorTitle", fallback: "Update PIN Error")
    /// Number of attempts left on pin entry screen
    internal static let twoAttempts = L10n.tr("Localizable", "UpdatePin.TwoAttempts", fallback: "2 more failed attempts.")
    /// Update pin popup explanation when pressing "?" button
    internal static let updatePinPopup = L10n.tr("Localizable", "UpdatePin.UpdatePinPopup", fallback: "The RockWallet app requires you to set a PIN to secure your wallet, separate from your device passcode.  \n\nYou will be required to enter the PIN to view your balance or send money, which keeps your wallet private even if you let someone use your phone or if your phone is stolen by someone who knows your device passcode.\n            \nDo not forget your wallet PIN! It can only be reset by using your Recovery Phrase. If you forget your PIN and lose your Recovery Phrase, your wallet will be lost.")
    /// Update PIN title
    internal static let updateTitle = L10n.tr("Localizable", "UpdatePin.updateTitle", fallback: "Update PIN")
    /// Why do I need a PIN title explanation popup
    internal static let whyPIN = L10n.tr("Localizable", "UpdatePin.WhyPIN", fallback: "Why do I need a PIN?")
  }
  internal enum VerificationCode {
    /// Verification Code Action Instructions
    internal static let actionInstructions = L10n.tr("Localizable", "VerificationCode.actionInstructions", fallback: "Check your phone for the confirmation token we sent you. It may take a couple of minutes.")
    /// Verification Code Label
    internal static let actionLabel = L10n.tr("Localizable", "VerificationCode.actionLabel", fallback: "Enter token")
    /// Verification Code Confirm Button
    internal static let buttonConfirm = L10n.tr("Localizable", "VerificationCode.buttonConfirm", fallback: "Confirm")
    /// Verification Code Label
    internal static let label = L10n.tr("Localizable", "VerificationCode.label", fallback: "We Texted You a Confirmation Code")
    /// Verification Code Title
    internal static let title = L10n.tr("Localizable", "VerificationCode.title", fallback: "Confirmation Code")
  }
  internal enum VerifyAccount {
    /// Verify your account
    internal static let button = L10n.tr("Localizable", "VerifyAccount.Button", fallback: "Verify your account")
  }
  internal enum VerifyPin {
    /// Verify PIN for transaction view body
    internal static let authorize = L10n.tr("Localizable", "VerifyPin.authorize", fallback: "Please enter your PIN to authorize this transaction.")
    /// Verify PIN view body
    internal static let continueBody = L10n.tr("Localizable", "VerifyPin.continueBody", fallback: "Please enter your PIN to continue.")
    /// Verify PIN view title
    internal static let title = L10n.tr("Localizable", "VerifyPin.title", fallback: "PIN Required")
    /// Authorize transaction with touch id message
    internal static let touchIdMessage = L10n.tr("Localizable", "VerifyPin.touchIdMessage", fallback: "Authorize this transaction")
  }
  internal enum Wallet {
    /// Find assets button on add wallets screen
    internal static let findAssets = L10n.tr("Localizable", "Wallet.FindAssets", fallback: "Trouble finding assets?")
    /// Limited assets title in add wallets popup
    internal static let limitedAssets = L10n.tr("Localizable", "Wallet.LimitedAssets", fallback: "Limited assets")
    /// Limited assets message in add wallets popup
    internal static let limitedAssetsMessage = L10n.tr("Localizable", "Wallet.LimitedAssetsMessage", fallback: "We currently only support the assets that are listed here. You cannot access other assets through this wallet at the moment.")
    /// 1d
    internal static let oneDay = L10n.tr("Localizable", "Wallet.one_day", fallback: "1d")
    /// 1m
    internal static let oneMonth = L10n.tr("Localizable", "Wallet.one_month", fallback: "1m")
    /// 1w
    internal static let oneWeek = L10n.tr("Localizable", "Wallet.one_week", fallback: "1w")
    /// 1y
    internal static let oneYear = L10n.tr("Localizable", "Wallet.one_year", fallback: "1y")
    /// Staking
    internal static let stakingTitle = L10n.tr("Localizable", "Wallet.stakingTitle", fallback: "Staking")
    /// 3m
    internal static let threeMonths = L10n.tr("Localizable", "Wallet.three_months", fallback: "3m")
    /// 3y
    internal static let threeYears = L10n.tr("Localizable", "Wallet.three_years", fallback: "3y")
  }
  internal enum WalletConnectionSettings {
    /// Turn off fast sync confirmation question
    internal static let confirmation = L10n.tr("Localizable", "WalletConnectionSettings.confirmation", fallback: "Are you sure you want to turn off Fastsync?")
    /// Explanation for wallet connection setting
    internal static let explanatoryText = L10n.tr("Localizable", "WalletConnectionSettings.explanatoryText", fallback: "Make syncing your bitcoin wallet practically instant. Learn more about how it works here.")
    /// Connection mode switch label.
    internal static let footerTitle = L10n.tr("Localizable", "WalletConnectionSettings.footerTitle", fallback: "Powered by")
    /// Wallet connection settings view title
    internal static let header = L10n.tr("Localizable", "WalletConnectionSettings.header", fallback: "Fastsync (pilot)")
    /// Link text in explanatoryText This NB: This should exactly match the last word of WalletConnectionSettings.explanatoryText
    internal static let link = L10n.tr("Localizable", "WalletConnectionSettings.link", fallback: "here")
    /// WalletConnectionSettiongs, Wallet connection settings menu item title.
    internal static let menuTitle = L10n.tr("Localizable", "WalletConnectionSettings.menuTitle", fallback: "Connection Mode")
    /// Turn off fast sync button label
    internal static let turnOff = L10n.tr("Localizable", "WalletConnectionSettings.turnOff", fallback: "Turn Off")
    /// Wallet connection settings view title
    internal static let viewTitle = L10n.tr("Localizable", "WalletConnectionSettings.viewTitle", fallback: "Fastsync")
  }
  internal enum Watch {
    /// 'No wallet' warning for watch app
    internal static let noWalletWarning = L10n.tr("Localizable", "Watch.noWalletWarning", fallback: "Open the RockWallet iPhone app to set up your wallet.")
  }
  internal enum Webview {
    /// Dismiss button label
    internal static let dismiss = L10n.tr("Localizable", "Webview.dismiss", fallback: "Dismiss")
    /// Webview loading error message
    internal static let errorMessage = L10n.tr("Localizable", "Webview.errorMessage", fallback: "There was an error loading the content. Please try again.")
    /// Updating webview message
    internal static let updating = L10n.tr("Localizable", "Webview.updating", fallback: "Updating...")
  }
  internal enum Welcome {
    /// Welcome screen text. (?) will be replaced with the help icon users should look for.
    internal static let body = L10n.tr("Localizable", "Welcome.body", fallback: "Breadwallet has changed its name to RockWallet, with a brand new look and some new features.\n\nIf you need help, look for the (?) in the top right of most screens.")
    /// Top title of welcome screen
    internal static let title = L10n.tr("Localizable", "Welcome.title", fallback: "Welcome to RockWallet!")
  }
  internal enum Widget {
    /// Single asset widget description
    internal static let assetDescription = L10n.tr("Localizable", "Widget.assetDescription", fallback: "Stay up to date with your favorite crypto asset")
    /// Asset list widget description
    internal static let assetListDescription = L10n.tr("Localizable", "Widget.assetListDescription", fallback: "Stay up to date with your favorite crypto assets")
    /// Asset list widget title
    internal static let assetListTitle = L10n.tr("Localizable", "Widget.assetListTitle", fallback: "Asset list")
    /// Single asset widget title
    internal static let assetTitle = L10n.tr("Localizable", "Widget.assetTitle", fallback: "Asset")
    /// Title of color grouping in widget color picker
    internal static let colorSectionBackground = L10n.tr("Localizable", "Widget.colorSectionBackground", fallback: "Theme Background Colors")
    /// Title of color grouping in widget color picker
    internal static let colorSectionBasic = L10n.tr("Localizable", "Widget.colorSectionBasic", fallback: "Basic Colors")
    /// Title of color grouping in widget color picker
    internal static let colorSectionCurrency = L10n.tr("Localizable", "Widget.colorSectionCurrency", fallback: "Currency Colors")
    /// Title of color grouping in widget color picker
    internal static let colorSectionSystem = L10n.tr("Localizable", "Widget.colorSectionSystem", fallback: "System Colors")
    /// Title of color grouping in widget color picker
    internal static let colorSectionText = L10n.tr("Localizable", "Widget.colorSectionText", fallback: "Theme Text Colors")
    /// Portfolio widget description if data sharing is disabled
    internal static let enablePortfolio = L10n.tr("Localizable", "Widget.enablePortfolio", fallback: "Enable in app\npreferences")
    /// Portfolio description
    internal static let portfolioDescription = L10n.tr("Localizable", "Widget.portfolioDescription", fallback: "Stay up to date with your portfolio")
    /// Portfolio widget description if data sharing is enabled
    internal static let portfolioSummary = L10n.tr("Localizable", "Widget.portfolioSummary", fallback: "Portfolio\nSummary")
    /// Portfolio widget title
    internal static let portfolioTitle = L10n.tr("Localizable", "Widget.portfolioTitle", fallback: "Portfolio")
    internal enum Color {
      /// Name of color based on os theme light/dark
      internal static let autoLightDark = L10n.tr("Localizable", "Widget.Color.autoLightDark", fallback: "System Auto Light / Dark")
      /// Name of color - Black
      internal static let black = L10n.tr("Localizable", "Widget.Color.black", fallback: "Black")
      /// Name of color - Blue
      internal static let blue = L10n.tr("Localizable", "Widget.Color.blue", fallback: "Blue")
      /// Name of color - Gray
      internal static let gray = L10n.tr("Localizable", "Widget.Color.gray", fallback: "Gray")
      /// Name of color - Green
      internal static let green = L10n.tr("Localizable", "Widget.Color.green", fallback: "Green")
      /// Name of color - Orange
      internal static let orange = L10n.tr("Localizable", "Widget.Color.orange", fallback: "Orange")
      /// Name of color - Pink
      internal static let pink = L10n.tr("Localizable", "Widget.Color.pink", fallback: "Pink")
      /// Name of color - Primary Background
      internal static let primaryBackground = L10n.tr("Localizable", "Widget.Color.primaryBackground", fallback: "Primary")
      /// Name of color - Primary Text
      internal static let primaryText = L10n.tr("Localizable", "Widget.Color.primaryText", fallback: "Primary")
      /// Name of color - Purple
      internal static let purple = L10n.tr("Localizable", "Widget.Color.purple", fallback: "Purple")
      /// Name of color - Red
      internal static let red = L10n.tr("Localizable", "Widget.Color.red", fallback: "Red")
      /// Name of color - Secondary Background
      internal static let secondaryBackground = L10n.tr("Localizable", "Widget.Color.secondaryBackground", fallback: "Secondary")
      /// Name of color - Secondary Text
      internal static let secondaryText = L10n.tr("Localizable", "Widget.Color.secondaryText", fallback: "Secondary")
      /// Name of color - Tertiary Background
      internal static let tertiaryBackground = L10n.tr("Localizable", "Widget.Color.tertiaryBackground", fallback: "Tertiary")
      /// Name of color - Tertiary Text
      internal static let tertiaryText = L10n.tr("Localizable", "Widget.Color.tertiaryText", fallback: "Tertiary")
      /// Name of color - White
      internal static let white = L10n.tr("Localizable", "Widget.Color.white", fallback: "White")
      /// Name of color - Yellow
      internal static let yellow = L10n.tr("Localizable", "Widget.Color.yellow", fallback: "Yellow")
    }
  }
  internal enum WipeWallet {
    /// Wipe wallet alert message
    internal static let alertMessage = L10n.tr("Localizable", "WipeWallet.alertMessage", fallback: "Are you sure you want to unlink this wallet from this device?")
    /// Wipe wallet alert title
    internal static let alertTitle = L10n.tr("Localizable", "WipeWallet.alertTitle", fallback: "Unlink Wallet?")
    /// Failed wipe wallet alert message
    internal static let failedMessage = L10n.tr("Localizable", "WipeWallet.failedMessage", fallback: "Failed to wipe wallet.")
    /// Failed wipe wallet alert title
    internal static let failedTitle = L10n.tr("Localizable", "WipeWallet.failedTitle", fallback: "Failed")
    /// Enter phrase to wipe wallet instruction. (Important to explain it is the CURRENT [this wallet's] paper key that needs to be entered).
    internal static let instruction = L10n.tr("Localizable", "WipeWallet.instruction", fallback: "Please enter your Recovery Phrase to wipe this wallet from your device.")
    /// Instructions for unlinking the wallet
    internal static let startMessage = L10n.tr("Localizable", "WipeWallet.startMessage", fallback: "Starting or recovering another wallet allows you to access and manage a different RockWallet on this device.")
    /// Start wipe wallet view warning
    internal static let startWarning = L10n.tr("Localizable", "WipeWallet.startWarning", fallback: "Your current wallet will be removed from this device. If you wish to restore it in the future, you will need to enter your Recovery Phrase.")
    /// Unlink this wallet from this device.
    internal static let title = L10n.tr("Localizable", "WipeWallet.title", fallback: "Start or Recover Another Wallet")
    /// Wipe wallet button title
    internal static let wipe = L10n.tr("Localizable", "WipeWallet.wipe", fallback: "Wipe")
    /// Wiping activity message
    internal static let wiping = L10n.tr("Localizable", "WipeWallet.wiping", fallback: "Wiping...")
  }
  internal enum WritePaperPhrase {
    /// Paper key instructions.
    internal static let instruction = L10n.tr("Localizable", "WritePaperPhrase.instruction", fallback: "Write down the following words in order")
    /// button label
    internal static let next = L10n.tr("Localizable", "WritePaperPhrase.next", fallback: "NEXT")
    /// button label
    internal static let previous = L10n.tr("Localizable", "WritePaperPhrase.previous", fallback: "Previous")
    /// 1 of 3
    internal static func step(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "WritePaperPhrase.step", p1, p2, fallback: "%1$d of %2$d")
    }
    /// For security purposes, do not screenshot or email these words.
    internal static let warning = L10n.tr("Localizable", "WritePaperPhrase.warning", fallback: "For security purposes, do not screenshot or email these words.")
    /// Remember to write these words down. Swipe back if you forgot.
    internal static let warning2 = L10n.tr("Localizable", "WritePaperPhrase.warning2", fallback: "Remember to write these words down. Swipe back if you forgot.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
