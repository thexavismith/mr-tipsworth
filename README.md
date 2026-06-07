# Mr. Tipsworth

A cozy, personality-driven tip calculator for iPhone. Built with SwiftUI and StoreKit 2.

## Requirements

- Xcode 26+
- iOS 26+
- iPhone only (portrait)

## Features

- iPod-style rotating dial for tip percentage (15%–50%)
- Real-time tip and total calculation
- Round-up toggle to round the total to the next whole dollar
- Theme and icon selector in Settings
- Optional tip-jar donations to support development

## Building

Open `MrTipsworth.xcodeproj` in Xcode and run on a simulator or device. No package dependencies to resolve.

## Linting

[SwiftLint](https://github.com/realm/SwiftLint) is required. Install via Homebrew:

```bash
brew install swiftlint
```

The CI workflow runs `swiftlint --strict` on every PR to trunk.

## In-App Purchases

IAP is handled with raw StoreKit 2. Donations are a voluntary tip jar — all app features, themes, and icons are free for everyone.

| Product ID | Price |
| --- | --- |
| `com.tipsworth.smallcoin` | $2.99 |
| `com.tipsworth.supercoin` | $4.99 |
| `com.tipsworth.starcoin` | $9.99 |

To test purchases, configure a StoreKit configuration file in Xcode and use the sandbox environment.
