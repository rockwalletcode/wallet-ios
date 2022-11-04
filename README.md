[![Rockwallet](image/logo_with_text.png)](https://www.rockwallet.com/)

<div align="center">
  <a href="https://apps.apple.com/us/app/rockwallet/id1595167194"><img align="center" width="120px" height="40px" src="image/app_store_logo.png"/></a>
</div>

## Rockwallet

Rockwallet is the best way to get started with bitcoin.
Our simple, streamlined design is easy for beginners, yet powerful enough for experienced users.

### Cutting-edge security

**Rockwallet** utilizes the latest mobile security features to protect users from malware, browser security holes, and even physical theft.
The user’s private key is stored in the device keychain, secured by Secure Enclave, and inaccessible to anyone other than the user.
Users are also able to back up their wallet using iCloud Keychain to store an encrypted backup of their recovery phrase.
The backup is encrypted with the BRD app PIN.

### Designed with New Users in Mind

Simplicity and ease-of-use are **Rockwallet**'s core design principles. A simple recovery phrase (which we call a recovery key) is all that is needed to restore the user's wallet if they ever lose or replace their device. **Rockwallet** is [deterministic](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki), which means the user's balance and transaction history can be recovered just from the recovery key.

### Features

- Supports wallets for Bitcoin, Bitcoin Cash, Ethereum, ERC-20 tokens, Ripple, Hedera, and Tezos
- The single recovery key is all that's needed to backup your wallet
- Private keys never leave your device and are end-to-end encrypted when using iCloud backup
- Save a memo for each transaction (off-chain)

### Bitcoin Specific Features
- Supports importing [password-protected](https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki) paper wallets
- Supports [JSON payment protocol](https://bitpay.com/docs/payment-protocol)
- Supports SegWit and bech32 addresses

## About Rockwallet

This repository is the Rockwallet Mobile repository for iOS, powered by a collection of Kotlin Multiplatform Mobile ([KMM](https://kotlinlang.org/lp/mobile/)) modules codenamed Cosmos.

Cosmos breaks down into many modules that are bundled to produce a final Jar/AAR and Framework for mobile projects.
Each module contains only code related to a single feature, helping keep the project organized and improving incremental build times.

## Development

### Setup

1. Clone this repository `git clone git@github.com:rockwalletcode/wallet-ios.git --recurse-submodules`
2. Open the `brd-ios/breadwallet.xcworkspace` file in Xcode

### WARNING:

***Installation on jailbroken devices is strongly discouraged.***

Any jailbreak app can grant itself access to every other app's keychain data. This means it can access your wallet and steal your bitcoin by self-signing as described [here](http://www.saurik.com/id/8) and including `<key>application-identifier</key><string>*</string>` in its .entitlements file.

---

**Rockwallet** is open source and available under the terms of the MIT license.

Source code is available at https://github.com/rockwalletcode/wallet-ios
