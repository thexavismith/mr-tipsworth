---
name: Mr. Tipsworth
description: Bold, warm, and playful tip calculator with a plum accent palette and chunky rounded typography.
colors:
  background: "#FAF6EF"
  surface: "#FFFFFF"
  card: "#F3E6F3"
  primary: "#7B3F7A"
  primary-dark: "#4E1F4D"
  primary-light: "#F3E6F3"
  on-primary: "#FFFFFF"
  on-background: "#1C1209"
  on-background-muted: "#1C120973"
  highlight: "#1A7A6E"
  dial-face: "#7B3F7A"
  dial-pip: "#F3E6F3"
  error: "#BA1A1A"
typography:
  hero-amount:
    fontFamily: SF Pro Rounded
    fontSize: 52px
    fontWeight: "900"
  hero-percent:
    fontFamily: SF Pro Rounded
    fontSize: 40px
    fontWeight: "900"
  total-emphasized:
    fontFamily: SF Pro Rounded
    fontSize: 36px
    fontWeight: "900"
  total-standard:
    fontFamily: SF Pro Rounded
    fontSize: 28px
    fontWeight: "900"
  label-section:
    fontFamily: SF Pro Rounded
    fontSize: 13px
    fontWeight: "600"
    letterSpacing: 0.08em
  body:
    fontFamily: SF Pro Rounded
    fontSize: 16px
    fontWeight: "600"
  caption:
    fontFamily: SF Pro Rounded
    fontSize: 13px
    fontWeight: "500"
rounded:
  sm: 12px
  md: 20px
  lg: 24px
  full: 9999px
spacing:
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 28px
  screen-horizontal: 24px
  card-internal: 20px
  between-cards: 12px
components:
  card:
    backgroundColor: "{colors.card}"
    rounded: "{rounded.lg}"
    padding: "{spacing.card-internal}"
  bill-entry:
    backgroundColor: "{colors.card}"
    rounded: "{rounded.lg}"
    padding: "{spacing.card-internal}"
  total-chip-standard:
    backgroundColor: "{colors.card}"
    textColor: "{colors.on-background}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  total-chip-emphasized:
    backgroundColor: "{colors.primary-light}"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  rounding-toggle:
    backgroundColor: "{colors.card}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  settings-card:
    backgroundColor: "{colors.card}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  settings-button:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.full}"
  dial-ring:
    backgroundColor: "{colors.dial-face}"
  dial-center:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.full}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.md}"
---

## Overview

Mr. Tipsworth is a warm, characterful tip calculator. The visual language is **bold and modern** — large black-weight numbers as hero elements, solid colour-block cards with no borders or gradients, and generous whitespace. The aesthetic references contemporary mobile app design (chunky rounded shapes, flat surfaces, high-contrast typography) while staying warm through the plum palette and cream background.

The iPod-style dial is the centrepiece of the UI. It sits at the bottom of the screen for thumb reach, with all informational content stacked above.

## Colors

The palette is anchored by **plum** (`#7B3F7A`) — rich, warm, and distinctive. It appears on the dial face, interactive buttons, the Total chip tint and border, the Done button in Settings, and all active/checked states.

- **Background:** Warm Cream `#FAF6EF` — never pure white or grey; always feels like warm parchment.
- **Card:** Light Plum `#F3E6F3` — used as the fill for all card chips. Tinted to echo the primary without competing.
- **Primary text:** Ink Brown `#1C1209` — near-black with warmth; avoids the coldness of pure black.
- **Highlight:** Deep Teal `#1A7A6E` — reserved for the reward screen and decorative pops only; not used in everyday chrome.

## Typography

All type is set in **SF Pro Rounded** (`.design: .rounded` in SwiftUI). The rounded terminals keep everything warm and approachable.

- Section labels are uppercase with +0.8pt letter spacing to create clear hierarchy without requiring large sizes.
- Numbers (bill, tip %, totals) use `.black` (900) weight — they are the hero of each screen.
- No Dynamic Type scaling on hero numerals; fixed sizes ensure visual hierarchy is preserved.

## Layout

- Cards are **colour blocks**, not bordered boxes. Background fill defines the card surface; the only exception is the highlighted Total chip which adds a plum stroke.
- The dial lives at the **bottom** of the main screen, pushed there by a `Spacer`, so the thumb can reach it naturally.
- Section labels sit **outside and above** their card in uppercase caption style — this creates breathing room and clear grouping.
- Spacing between cards: 12pt. Horizontal screen padding: 24pt.

## Elevation & Depth

The design is deliberately **flat**. No gradients on primary surfaces. The only depth cue is the dial center button, which uses a soft multi-layer drop shadow to feel physically raised above the rotating ring. All other cards sit flush on the background with no shadow.

## Shapes

Rounded corners throughout, scaled by context:

- **Cards (bill entry, totals, rounding):** 24pt radius
- **Settings cards and rows:** 20pt radius
- **Settings gear button:** Circle (full radius)
- **Dial center button:** Circle (full radius)
- **Snap pips on dial:** 2pt corner radius on a 5×18pt rectangle

## Components

### Bill Entry
Label ("BILL AMOUNT") in uppercase caption above the field. Currency symbol at 36pt bold in secondary text colour; amount at 52pt black in primary text colour. Clear button appears inline when field has content.

### Totals
Two side-by-side chips. The **Tip** chip uses the standard card background. The **Total** chip uses a plum-tinted background with a plum stroke border; the amount is rendered in plum at 36pt black weight.

### Tip Dial
- Outer ring: solid plum fill, 60 fine grip ticks (1.5pt wide, 8pt tall) at 12% black opacity, rotating with gesture.
- Snap pips: light plum `#F3E6F3`, 5×18pt rounded rectangles fixed at the 4 preset positions (15%, 18%, 20%, 25%).
- Center button: white, 130pt diameter, soft drop shadow.
- Percentage label: 40pt black weight, ink brown.
- Clockwise drag = higher tip. Accumulator-based sensitivity so slow drags still register.

### Settings
Custom scroll view on theme background — no system List chrome. Section titles use the uppercase caption label style. Row cards use the `settings-card` component. Plum tint on the Done button, picker tint, and selected-icon checkmark.

## Micro-interactions

- **Dial snap:** `.spring(response: 0.3, dampingFraction: 0.7)` with light haptic on snap-point land.
- **Number changes:** `.numericText()` content transition, `.snappy(duration: 0.2)` animation.
- **Rounding toggle:** `.easeInOut(duration: 0.2)` opacity + upward slide on the effective tip caption.
- **Reward screen:** `symbolEffect(.bounce, options: .repeating)` on the star icon.
- Always respect `accessibilityReduceMotion` — replace motion with opacity-only transitions.

## Do's and Don'ts

**Do:**
- Use plum as the sole interactive accent colour.
- Let large numbers do the visual work — resist adding decorative elements.
- Keep cards flat; colour fill is enough to define a surface.
- Use the uppercase label pattern consistently above every card group.

**Don't:**
- Use gradients on any primary surface (dial, cards, background).
- Use amber/gold as accent in the Classic theme (it belongs to Warm Mushroom only).
- Apply system white `List` backgrounds in settings or sheets.
- Add borders to cards except on the highlighted Total chip.
- Use skeuomorphic effects — no inner shadows, embossing, or textures.
