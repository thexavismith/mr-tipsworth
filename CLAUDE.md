# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Mr. Tipsworth** is an iPhone-only tip calculator app (iOS 26+) with a cozy cafe / old-world aesthetic. The PRD lives at `resources/PRD.md`.

## Technical Stack

- **Platform:** iPhone only, iOS 26+, portrait orientation
- **UI Framework:** SwiftUI
- **In-App Purchase:** Raw StoreKit 2 (no RevenueCat)
- **No third-party dependencies** — everything is built from scratch

## Architecture

The app has four screens:
1. **Main Calculator** — bill entry field, iPod-style tip dial, totals display, rounding toggle
2. **Settings Panel** — gear icon entry point; contains theme selector, icon selector, donation entry, restore purchases
3. **Donation Sheet** — modal with three IAP tiers (Small Coin $2.99, Super Coin $4.99, Star Coin $9.99)
4. **Reward Unlock Screen** — post-purchase celebratory animation

Key custom component: the **iPod-style dial** (`TipDial`) is a fully custom SwiftUI component using `DragGesture` to track circular rotation. It snaps to four presets (15%, 18%, 20%, 25%) on gesture end. See `resources/PRD.md` Section 13 for the full implementation spec.

## IAP / StoreKit

Three non-consumable one-time purchases. Receipt validation, restore purchases, and transaction state are handled entirely via StoreKit 2. No external SDK.

## Xcode Commands

```bash
# Build and run (adjust scheme/simulator as needed)
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:MrTipsworthTests/TargetTestClass/testMethodName
```

## Key Constraints

- Dial range: 15%–50% whole numbers; snap presets at 15%, 18%, 20%, 25%
- Rounding always rounds the total **up** to the next whole dollar; dial position does not change — an "Effective tip: X.X%" label appears instead
- Donation flow is accessible **only** from Settings — never surfaced on the main calculator screen
- Locked cosmetic rewards show a padlock indicator; unlocked icons persist via StoreKit receipt validation
- No bill splitting in v1.0 (deferred to v1.1)
