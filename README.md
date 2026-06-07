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
- Optional cosmetic rewards via one-time in-app donations

## Building

Open `MrTipsworth.xcodeproj` in Xcode and run on a simulator or device. No package dependencies to resolve.

## In-App Purchases

IAP is handled with raw StoreKit 2. To test purchases, configure a StoreKit configuration file in Xcode and use the sandbox environment.

| Product ID | Price | Reward |
| --- | --- | --- |
| `com.tipsworth.smallcoin` | $2.99 | Alternate color theme |
| `com.tipsworth.supercoin` | $4.99 | Alternate app icon |
| `com.tipsworth.starcoin` | $9.99 | Premium theme + icon bundle |
