---
name: Mr. Tipsworth
description: Soft, airy tip calculator with a lavender accent palette, warm cream surfaces, pill-shaped cards, and gentle rounded typography.
colors:
  background: "#FAF6EF"
  surface: "#FFFFFF"
  card: "#F5F0FF"
  card-stroke: "#E0D4F7"
  primary: "#8B6BBE"
  primary-light: "#EDE5FF"
  primary-dark: "#5C3D99"
  on-primary: "#FFFFFF"
  on-background: "#2A2035"
  on-background-muted: "#2A203580"
  dial-face: "#8B6BBE"
  dial-pip: "#EDE5FF"
  highlight: "#F5C842"
  error: "#BA1A1A"
typography:
  hero-amount:
    fontFamily: SF Pro Rounded
    fontSize: 52px
    fontWeight: "800"
  hero-percent:
    fontFamily: SF Pro Rounded
    fontSize: 40px
    fontWeight: "800"
  total-emphasized:
    fontFamily: SF Pro Rounded
    fontSize: 36px
    fontWeight: "800"
  total-standard:
    fontFamily: SF Pro Rounded
    fontSize: 28px
    fontWeight: "700"
  label-section:
    fontFamily: SF Pro Rounded
    fontSize: 13px
    fontWeight: "600"
    letterSpacing: 0.08em
  body:
    fontFamily: SF Pro Rounded
    fontSize: 16px
    fontWeight: "500"
  caption:
    fontFamily: SF Pro Rounded
    fontSize: 13px
    fontWeight: "500"
rounded:
  sm: 12px
  md: 20px
  lg: 24px
  pill: 9999px
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
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    rounded: "{rounded.lg}"
    padding: "{spacing.card-internal}"
  bill-entry:
    backgroundColor: "{colors.card}"
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    rounded: "{rounded.lg}"
    padding: "{spacing.card-internal}"
  total-chip-standard:
    backgroundColor: "{colors.card}"
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    textColor: "{colors.on-background}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  total-chip-emphasized:
    backgroundColor: "{colors.primary-light}"
    borderColor: "{colors.primary}"
    borderWidth: 1.5px
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  rounding-toggle:
    backgroundColor: "{colors.card}"
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  settings-card:
    backgroundColor: "{colors.card}"
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    rounded: "{rounded.md}"
    padding: "{spacing.card-internal}"
  settings-button:
    backgroundColor: "{colors.surface}"
    borderColor: "{colors.card-stroke}"
    borderWidth: 1.5px
    rounded: "{rounded.pill}"
  dial-ring:
    backgroundColor: "{colors.dial-face}"
  dial-center:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.pill}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.pill}"
---

## Overview

Mr. Tipsworth is a warm, characterful tip calculator. The visual language is **soft and airy** — gentle lavender accents, warm cream surfaces, pill-shaped cards with fine strokes, and rounded typography at moderate weights. The aesthetic is inspired by the cozy, approachable quality of well-crafted wellness and lifestyle apps: calm, uncluttered, and pleasant to use.

The iPod-style dial is the centrepiece of the UI. It sits at the bottom of the screen for thumb reach, with all informational content stacked above.

## Colors

The palette is anchored by **lavender** (`#8B6BBE`) — softer and more approachable than the previous deep plum. It reads as warm rather than corporate, and pairs naturally with the cream background.

- **Background:** Warm Cream `#FAF6EF` — unchanged; always warm parchment, never pure white or grey.
- **Card:** Soft Lavender Tint `#F5F0FF` — a very light purple wash that ties cards to the accent without competing.
- **Card stroke:** `#E0D4F7` — a 1.5pt border on every card. Cards are defined by both fill and a gentle outline, giving them more presence on the cream background than fill alone.
- **Primary text:** Deep Purple-Grey `#2A2035` — replaces ink brown; cooler and more harmonious with the lavender palette while remaining warm.
- **Highlight:** Amber Gold `#F5C842` — used sparingly on the reward screen and decorative moments. Warm contrast to the cool lavender.

## Typography

All type is set in **SF Pro Rounded** (`.design: .rounded` in SwiftUI). Weights are stepped down from the previous direction — `.black` (900) becomes `.heavy` (800) for heroes, `.bold` (700) for totals, and `.medium` (500) for body. This makes the UI feel lighter and more refined.

- Section labels remain uppercase with +0.8pt kerning.
- Hero numerals (bill amount, tip %) are fixed-size at 52pt and 40pt respectively.
- No Dynamic Type on hero numerals.

## Layout

- Cards are defined by a **soft fill + fine stroke** — the 1.5pt `card-stroke` border gives each card a gentle edge without feeling heavy.
- The dial lives at the **bottom** of the main screen, pushed there by a `Spacer`.
- Section labels sit **outside and above** their card in uppercase caption style.
- Spacing between cards: 12pt. Horizontal screen padding: 24pt.
- Prefer pill shapes (`rounded.pill`) for interactive elements like buttons and the settings gear.

## Elevation & Depth

Still deliberately **flat** — no gradients or skeuomorphic effects on any surface. The card stroke replaces shadow as the primary depth cue. The dial center button retains its soft drop shadow as the one exception, since it needs to read as physically raised above the rotating ring.

## Shapes

- **Cards (bill entry, totals, rounding):** 24pt radius
- **Settings cards and rows:** 20pt radius
- **Pill elements (buttons, settings gear, toggle):** full radius (9999px)
- **Dial center button:** Circle (full radius)
- **Snap pips on dial:** 2pt corner radius on a 5×18pt rectangle

## Components

### Bill Entry
Label ("BILL AMOUNT") in uppercase caption above the field. Currency symbol at 36pt heavy in secondary text colour; amount at 52pt heavy in primary text colour. Card background with stroke border, 24pt radius.

### Totals
Two side-by-side chips. **Tip** chip: card fill + stroke. **Total** chip: primary-light fill + primary stroke; amount in primary colour at 36pt heavy.

### Tip Dial
- Outer ring: solid lavender fill, 60 fine grip ticks at 12% black opacity, rotating with gesture.
- Fixed 12 o'clock marker: 4×14pt lavender rounded rectangle on the background, outside the ring.
- Snap pips: light lavender `#EDE5FF`, 5×18pt rounded rectangles at the 4 preset positions (15%, 18%, 20%, 25%), fixed in place.
- Center button: white circle, 164pt diameter, soft drop shadow. Lavender stroke ring pulses in on snap point.
- Percentage label: 40pt heavy, primary text colour. Counts up/down directionally.
- Clockwise drag = higher tip. Accumulator-based sensitivity. Flick momentum with 0.88 friction. Spring overshoot on snap (`dampingFraction: 0.55`).

### Settings
Custom scroll view on theme background. Section titles use uppercase caption label style. Row cards use the `settings-card` component with stroke border. Lavender tint on Done button, picker tint, and selected-icon checkmark.

## Micro-interactions

- **Dial snap:** `.spring(response: 0.4, dampingFraction: 0.55)` — natural overshoot then settle. Light haptic on snap-point land, softer haptic on each integer tick.
- **Snap visual:** center button scales to 1.08× then springs back; lavender stroke ring fades in while on a snap point.
- **Number changes:** `.numericText(countsDown:)` content transition, `.snappy(duration: 0.2)` animation, directional based on change direction.
- **Rounding toggle:** `.easeInOut(duration: 0.2)` opacity + upward slide on effective tip caption.
- **Reward screen:** `symbolEffect(.bounce, options: .repeating)` on the star icon.
- Always respect `accessibilityReduceMotion` — replace motion with opacity-only transitions.

## Do's and Don'ts

**Do:**
- Use lavender as the sole interactive accent colour.
- Add a 1.5pt `card-stroke` border to every card surface.
- Use pill shapes for all interactive button elements.
- Keep typography weights moderate — heavy not black, medium not bold for body text.
- Let the cream background and lavender tint do the atmospheric work; resist adding decorative elements.

**Don't:**
- Use gradients on any primary surface.
- Use deep plum or ink brown from the previous direction.
- Apply system white `List` backgrounds in settings or sheets.
- Use drop shadows on anything except the dial center button.
- Use skeuomorphic effects — no inner shadows, embossing, or textures.
