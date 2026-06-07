# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Mr. Tipsworth** is an iPhone-only tip calculator app (iOS 26+) with a cozy cafe / old-world aesthetic. The PRD lives at `resources/PRD.md`.

## Technical Stack

- **Platform:** iPhone only, iOS 26+, portrait orientation
- **UI Framework:** SwiftUI
- **In-App Purchase:** Raw StoreKit 2 (no RevenueCat)
- **Linting:** SwiftLint — config at `.swiftlint.yml`, run before every commit
- **No third-party dependencies** — everything is built from scratch

## Architecture

The app has four screens:
1. **Main Calculator** — bill entry field, iPod-style tip dial, totals display, rounding toggle
2. **Settings Panel** — gear icon entry point; contains theme selector, icon selector, Send Feedback (mailto), and Support the Dev (donation sheet)
3. **Donation Sheet** — tip-jar modal with three one-time IAP tiers (Small Coin $2.99, Super Coin $4.99, Star Coin $9.99). All tiers are purely voluntary — no features or cosmetics are locked behind payment.
4. **Reward Unlock Screen** — post-purchase celebratory animation

Key custom component: the **iPod-style dial** (`TipDialView`) is a fully custom SwiftUI component using `DragGesture` to track circular rotation. It snaps to four presets (15%, 18%, 20%, 25%) on gesture end. See `resources/PRD.md` Section 13 for the full implementation spec.

## IAP / StoreKit

Three non-consumable one-time purchases used as a tip jar. No features or cosmetics are gated — all themes and icons are available to all users. Transaction state is handled entirely via StoreKit 2. No external SDK.

## Linting

Always run SwiftLint before committing. The CI workflow (`.github/workflows/swiftlint.yml`) runs `swiftlint --strict` on every PR to trunk, so warnings fail the build.

```bash
swiftlint
```

Use the `/commit` skill — it runs SwiftLint automatically before staging anything.

## Xcode Commands

```bash
# Build and run
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Run tests
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test

# Run a single test
xcodebuild -scheme MrTipsworth -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:MrTipsworthTests/TargetTestClass/testMethodName
```

## Key Constraints

- Dial range: 15%–50% whole numbers; snap presets at 15%, 18%, 20%, 25%
- Rounding always rounds the total **up** to the next whole dollar; dial position does not change — an "Effective tip: X.X%" label appears instead
- Donation flow is accessible **only** from Settings — never surfaced on the main calculator screen
- All themes and icons are unlocked for all users — no padlocks or purchase gates
- No bill splitting in v1.0 (deferred to v1.1)
