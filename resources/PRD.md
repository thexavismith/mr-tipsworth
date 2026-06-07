# Product Requirements Document

## Cozy Tip Calculator — iOS App

**Version:** 1.0  
**Platform:** iPhone (iOS 26+)  
**Type:** Personal Project / App Store Release  
**Status:** Draft

---

## 1. Overview

A simple, delightful tip calculator for iPhone with a cozy, warm aesthetic inspired by the cozy game genre and Super Mario. The app helps users quickly calculate tips and optionally split bills, with a lighthearted personality that makes a mundane task feel fun. Monetization is supported through optional one-time in-app donations, which unlock cosmetic rewards as a thank-you.

---

## 2. Goals

- Deliver a fast, frictionless tip calculation experience with no account or setup required.
- Create a visually distinctive cozy/Mario-inspired aesthetic that stands out from generic calculator apps.
- Support optional, feel-good monetization through donation-unlocked cosmetic rewards.
- Ship a focused v1.0 with a clean feature set; avoid scope creep.

---

## 3. Target User

Anyone who needs to calculate a tip at a restaurant, café, or service business — especially users who appreciate charming, personality-driven app design. No specific demographic target; the cozy aesthetic will naturally attract users drawn to that genre.

---

## 4. App Name

**Mr. Tipsworth.** The name evokes a charming, old-world character personality that pairs well with the cozy aesthetic — think a dapper coin with a mustache. The mascot and icon should reflect this character.

---

## 5. Platform & Technical Requirements

| Attribute     | Requirement                                                        |
| ------------- | ------------------------------------------------------------------ |
| Platform      | iPhone only                                                        |
| Minimum iOS   | iOS 26                                                             |
| Frameworks    | SwiftUI (recommended), StoreKit 2 (for IAP)                        |
| Orientation   | Portrait only                                                      |
| Accessibility | Dynamic Type support, VoiceOver labels on all interactive elements |
| App Store     | Paid features via In-App Purchase (non-consumable)                 |

---

## 6. Features

### 6.1 Core — Tip Calculator

**Bill Amount Entry**

- Large, tappable numeric input field at the top of the screen.
- Accepts numeric input only; the field is restricted to numbers and a single decimal point. Non-numeric characters cannot be entered.
- Uses iOS numeric keypad to enforce this at the keyboard level.
- Displays a placeholder (e.g. "Enter bill amount") when empty.
- Clears gracefully with a dedicated clear/delete button.

**Tip Percentage Selection — iPod-Style Dial**

- Tip percentage is selected via a circular dial control inspired by the iPod click wheel.
- The dial spans a range of **15%–50%**, with four snap presets (15%, 18%, 20%, 25%) marked with distinct notches or visual indicators.
- The user can rotate (swipe in a circular gesture) to land on any whole-number percentage, or flick to snap directly to a preset notch.
- The currently selected percentage is displayed prominently in the center of the dial.
- The dial is a central, signature UI element — it should feel tactile, satisfying, and visually characterful (e.g. coin-textured or themed to match the cozy aesthetic).
- Accessibility: VoiceOver treats the dial as an adjustable element with increment/decrement actions.

**Default State**

- On launch, the dial opens at 15% (the minimum and first snap point).
- Tip amount and total display $0.00 until a bill amount is entered.
- Bill entry field displays its placeholder text.
- Calculates and displays in real time:
  - Tip amount
  - Total amount (bill + tip)
- Values update instantly as the user changes bill amount or tip percentage.
- Currency formatted to two decimal places using the device locale.

**Rounding**

- A toggle (or button) lets the user round the **total** up to the next whole dollar (e.g. $22.30 → $23.00). Always rounds up, never down.
- When rounding is active, the tip amount adjusts accordingly and the rounded total is displayed.
- The dial remains at its selected position — it is not updated or locked. Instead, a small "Effective tip: X.X%" label appears beneath the dial to show the true tip percentage after rounding.
- The effective tip label disappears when rounding is toggled off.
- Clear visual indicator when rounding is active.

---

### 6.3 Donations & Cosmetic Rewards

**Donation Tiers (one-time, non-consumable IAP)**

| Tier       | Price | Reward Unlocked                                    |
| ---------- | ----- | -------------------------------------------------- |
| Small Coin | $2.99 | Alternate color theme (e.g. warm mushroom palette) |
| Super Coin | $4.99 | Alternate app icon                                 |
| Star Coin  | $9.99 | Premium theme + icon bundle (best value)           |

**Donation Flow**

- A "Support the Dev" entry point lives in the Settings panel, accessed via a gear icon in the corner of the main screen — never surfaced on the main calculator screen itself.
- Tapping it opens a donation sheet showing the three tiers with their reward descriptions and prices.
- Purchase is handled via StoreKit 2 native sheet.
- On successful purchase, a celebratory animation plays (e.g. coins raining, star burst) and the reward is immediately unlocked.
- Restore Purchases option is available per App Store guidelines.

**Cosmetic Rewards Detail**

- **Themes:** Swap the app's color palette (backgrounds, button colors, accent colors). Default theme is available to all users. Each paid tier unlocks an additional theme selectable from Settings.
- **App Icons:** Alternate icons selectable from Settings via `UIApplication.setAlternateIconName`. Unlocked icons persist across app reinstalls via StoreKit receipt validation.
- Locked rewards are shown with a padlock indicator so users know what they're missing without feeling pressured.

---

## 7. Design Direction

**Aesthetic:** Cozy cafe / old-world charm. Think warm wood textures, earthy tones, candlelight warmth, and a genteel British personality — like a beloved neighborhood bistro. The Mario inspiration should inform the _feeling_ (tactile, satisfying, friendly) rather than the _visual language_ (avoid bright primary colors, brick patterns, or anything resembling Nintendo characters or iconography).

**Mr. Tipsworth** should read as a charming, distinguished character — think a dapper Victorian-era maître d' or a warm, mustachioed restaurateur. Avoid coin-with-a-face imagery that could evoke Mario's coin aesthetic. Instead lean into character traits: a top hat, a waistcoat, a warm expression. The character should feel original and ownable.

**Key Design Principles**

- Large tap targets — everything should feel easy and comfortable to use.
- Satisfying micro-interactions: button presses have a subtle bounce or press animation that feels tactile and fun without being cartoonish.
- Warm color palette for the default theme: creamy off-whites, warm browns, muted greens, amber and gold accents — cafe and bistro tones, not primary colors.
- Typography: rounded, friendly sans-serif (e.g. system rounded variant or a custom font with appropriate licensing).
- No dark/cluttered layouts; the screen should feel open, warm, and inviting.
- Avoid: bright red/blue/yellow primary color combinations, brick block patterns, mushroom motifs, or any imagery that reads as Nintendo-adjacent.

**Screens**

1. **Main Calculator** — bill entry, dial, totals display, rounding toggle.
2. **Settings Panel** — accessed via a gear icon in the corner of the main screen. Contains app version, donation entry point ("Support the Dev"), theme selector, icon selector, and restore purchases.
3. **Donation Sheet** — modal; three tiers, reward previews, purchase buttons.
4. **Reward Unlock Screen** — celebratory animation + confirmation message post-purchase.

---

## 8. Monetization Summary

- The core tip calculator is **100% free** with no paywalls, ads, or required sign-in.
- Donations are entirely optional and framed as a way to support the developer, not as a feature gate.
- Cosmetic rewards give donors something tangible without disadvantaging non-paying users.
- No subscriptions, no consumables, no ads.

---

## 9. Out of Scope (v1.0)

- iPad or Mac support
- History / saved calculations
- Currency conversion
- Tax calculation
- Sharing or exporting results
- Widgets or Live Activities
- Android version

---

## 10. Success Metrics

Since this is a personal project, success is defined loosely:

- App successfully passes App Store review on first or second submission.
- Core calculator works correctly across all common bill amounts and tip percentages.
- At least one person outside the developer uses it and finds it useful.
- Donation flow completes without errors in both sandbox and production.

---

## 11. Resolved Decisions

All open questions have been resolved. No open items remain for v1.0.

| Decision                   | Resolution                                                                                                                                                                                                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bill splitting             | Deferred to v1.1. Not in v1.0 scope.                                                                                                                                                                                                                                |
| Dial implementation        | Build custom from scratch in SwiftUI (see Section 13). No suitable open-source library exists for an iPod-style snapping dial; `OneFingerRotation` exists for free-spin knobs but doesn't handle preset snap points cleanly.                                        |
| IAP SDK                    | Raw StoreKit 2. See Section 12.                                                                                                                                                                                                                                     |
| Mascot art                 | AI-generated. Produce Mr. Tipsworth character art via image generation tools; review output for quality and originality before use.                                                                                                                                 |
| Cozy/Mario-inspired assets | AI-generated. All art assets will be original AI-generated artwork with a cozy cafe / old-world aesthetic. Mario serves as tonal inspiration only (tactile, friendly, satisfying) — no Nintendo visual language, characters, or iconography will appear in the app. |

---

## 12. IAP SDK: RevenueCat vs. Raw StoreKit 2

**Recommendation: Raw StoreKit 2 for this project.**

RevenueCat is excellent, but it's better suited to apps with subscriptions, multiple platforms, or teams who need a dashboard. Here's the tradeoff for Mr. Tipsworth specifically:

|                     | RevenueCat                              | Raw StoreKit 2                     |
| ------------------- | --------------------------------------- | ---------------------------------- |
| Setup effort        | Low (SDK + dashboard config)            | Moderate (all code is yours)       |
| Analytics dashboard | Yes — purchase events, revenue, funnels | None built-in                      |
| Cost                | Free up to $2,500/mo revenue, then 1%   | Free                               |
| Complexity added    | SDK dependency, network calls           | None                               |
| Best for            | Subscriptions, multi-platform, teams    | Simple one-time IAP, solo projects |

For three simple non-consumable one-time purchases on a personal project, StoreKit 2 handles everything you need — receipt validation, restore purchases, and transaction state — without adding an SDK dependency or routing purchase data through a third party. The code is maybe 100–150 lines and well-documented by Apple.

**Use RevenueCat if:** you later add a subscription tier, ship an Android version, or want a revenue dashboard without building one yourself.

---

## 13. Dial Implementation Spec

The iPod-style tip dial is a fully custom SwiftUI component. No third-party library is required.

**Behavior**

- The dial is circular and responds to a one-finger circular drag gesture.
- Dragging clockwise increases the tip percentage; counter-clockwise decreases it.
- Range: 15%–50%, whole numbers only.
- The four presets (15%, 18%, 20%, 25%) are snap points — when the user's finger lifts near one, the dial snaps to it with a spring animation and haptic tap. All four sit in the lower portion of the dial's travel (15–50 range), so their notches should be visually spaced to feel distinct and easy to land on.
- The current percentage is displayed in the center of the dial in large, bold type.
- Preset positions are marked with a distinct notch or pip on the dial ring.

**Implementation Approach**

- Use a `DragGesture` tracking touch position relative to the dial's center to compute the rotation angle.
- Convert angle to a percentage value using linear mapping across the 15–50 range.
- On gesture end, check proximity to snap points and animate to the nearest one if within a threshold (e.g. ±2%).
- Use `UIImpactFeedbackGenerator` (`.light`) for haptic feedback on snap, and `.soft` for each integer increment while dragging.
- Render the dial face using SwiftUI `Canvas` or layered `Circle` + `ZStack` views.

**Accessibility**

- Expose as an `AdjustableAccessibilityElement`.
- Increment/decrement actions move by 1% per step.
- Announce value changes: "Tip: 20%".

---

_Document owner: TBD — Last updated: June 2026_
