# DESIGN.md

Visual design reference for Mr. Tipsworth.

---

## Color Palette

| Name | Hex | Role |
| --- | --- | --- |
| Warm Yellow | `#F5C842` | Dial face fill (Classic theme) |
| Cozy Peach | `#F5A57A` | Dial face fill (Warm Mushroom theme), accent |
| Sparkle Gold | `#C8971A` | Primary accent — buttons, toggle tint, dial ring |
| Teal Blue | `#2A7F8F` | Highlight — reward screen, decorative pops |
| Soft Cream | `#F5F0E8` | Page background (Classic theme) |
| Rich Brown | `#6B2D1A` | Primary text, snap pip markers |

All colors are defined as `static` extensions on `SwiftUI.Color` in `Theme/Palette.swift`.

---

## Themes

Themes are defined in `Theme/AppTheme.swift` as an enum. Each case exposes semantic color properties (`background`, `surface`, `accent`, `dialFace`, `dialPip`, `primaryText`, `secondaryText`, `highlight`) — views read from the active theme via `ThemeStore` injected through `@Environment`.

| Theme | Unlock | Background | Accent |
| --- | --- | --- | --- |
| Classic | Free | Soft Cream | Sparkle Gold |
| Warm Mushroom | Small Coin ($2.99) | Warm ivory | Cozy Peach |

---

## Typography

- System font with `.rounded` design throughout.
- Bill amount: `size 40, weight .semibold`
- Dial center value: `size 48, weight .bold`
- Total amount: `size 28, weight .bold`
- All other text: Dynamic Type (`body`, `headline`, `caption`) — never fixed sizes.

---

## Spacing & Shape

- Card corner radius: `16pt`
- Donation tier corner radius: `12pt`
- Horizontal screen padding: `24pt`
- Card internal padding: `20pt`
- Dial diameter: `260pt`

---

## Aesthetic Notes

- Background should feel like warm parchment — never pure white or pure grey.
- Surfaces (cards) use white at ~85% opacity over the background for a layered, tactile depth.
- The dial is the hero UI element; its face color (`warmYellow` / `cozyPeach`) should be saturated and inviting against the cream background.
- Teal Blue (`#2A7F8F`) is a deliberate contrast accent used sparingly — reward states and highlights only. Not used in everyday UI chrome.
- Brown (`#6B2D1A`) as text color keeps things warm rather than the default near-black.

---

## Micro-interactions

- Dial snap: `.spring(response: 0.3, dampingFraction: 0.7)`
- Rounding toggle label: `.easeInOut` opacity + slide transition
- Totals: `.numericText()` content transition on value change
- Reward screen: `symbolEffect(.bounce, options: .repeating)` on the star icon
- Respect `accessibilityReduceMotion` — replace motion animations with opacity only when active.
