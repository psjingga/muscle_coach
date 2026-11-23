# Muscle Coach — Design System (redesign direction, dark-first)

## Product context
- Mobile app (Flutter, Android + iOS), UI language **Bahasa Indonesia**, metric units (kg, cm, g, kcal).
- Personal hypertrophy coach for dumbbell/barbell training: assessment → realistic goal → AI (Gemini) weekly program (draft, user approves) → workout logging → nutrition (Indonesian food catalog TKPI, kcal/macros) → progress (weight trend, check-ins, body measurements, progress photos, weekly review).
- Fully local, privacy-first: no account; AI output always labelled "estimasi"/"draft AI".
- Bottom navigation, 5 tabs: **Beranda** (home), **Latihan** (workout), **Nutrisi**, **Progres**, **Profil**.
- JTBD: "Di gym, saya ingin mencatat set secepat mungkin dengan satu tangan" · "Setiap hari, saya ingin tahu apa yang harus saya latih dan makan hari ini" · "Tiap minggu, saya ingin melihat apakah saya berada di jalur yang benar".

## Visual direction
Dark-first, high-contrast gym aesthetic. Flat cards, ONE energetic accent, bold tabular numerals, generous tap targets. Calm, focused, not flashy. Inspired by the low-friction logging of Strong/Hevy. Light mode exists with the same structure.

## Color tokens (dark — primary)
| token | value | use |
|---|---|---|
| bg | #0B0D0C | app background |
| surface | #151918 | cards, sheets |
| surface-2 | #1E2321 | nested cards, inputs, inactive chips |
| outline | #2A302E | 1px card borders, dividers |
| text | #F2F5F3 | primary text, numerals |
| text-muted | #A3ACA8 | labels, secondary text |
| accent (Volt) | #B6F23E | primary actions, active tab, completed set, progress ring fill |
| on-accent | #0B0D0C | text/icons on accent |
| accent-soft | rgba(182,242,62,0.14) | accent tinted backgrounds |
| protein | #5CC8FF | protein ring/bars |
| carbs | #FFB547 | carbs |
| fat | #FF7A93 | fat |
| warning | #FFB547 | "perlu disesuaikan", reminders |
| danger | #FF5A5A | destructive, safety stop |

Light mode: bg #F4F6F3, surface #FFFFFF, surface-2 #EEF1ED, outline #DDE2DC, text #111413, text-muted #5D6662, accent #4E8A00 (darker for contrast), on-accent #FFFFFF; macro colors darkened ~15%.

No gradients except an optional very subtle accent glow behind the main progress ring. No purple, no neon pink, no extra accent colors.

## Typography
- Font: **Inter** (fallback: system Roboto / SF Pro). No serif, no decorative fonts.
- Numerals: Inter with tabular figures, weight 800.
- Scale: display-num 44/48 800 · num-lg 28/32 800 · title 20/26 700 · subtitle 16/22 600 · body 15/22 400 · label 13/18 600 (uppercase not required) · caption 12/16 500.

## Shape, spacing, elevation
- 4-pt grid; screen padding 16; card padding 16; gap between cards 12.
- Radius: cards 20, buttons 14, inputs 14, chips/pills 999, set-check button = full circle.
- Elevation: flat. Dark: 1px outline border, no shadows. Light: hairline border + very soft shadow (0 1px 2px rgba(0,0,0,.06)).

## Components
- **Bottom nav**: 5 items, icon + label, active = accent icon + accent-soft pill behind icon; bg = surface with top outline.
- **Primary button**: accent fill, on-accent text, height 52, radius 14, bold label. Secondary: surface-2 fill, text color. Tonal: accent-soft fill, accent text.
- **Progress ring**: 10–12px stroke, track = surface-2, fill = accent (kcal) / protein color; big numeral centered + small label ("kkal tersisa").
- **Stat tile**: surface-2, label muted on top, big tabular numeral, unit in muted small text.
- **Set row (workout logging)**: set number chip · previous ("Sebelumnya 20 kg × 10") · kg field · reps field · RIR · large 48px circular check button. Completed row: accent-soft background, check filled accent.
- **Rest timer**: floating pill above bottom area: countdown numeral (num-lg), "+15 dtk", "Lewati"; accent ring progress.
- **Chips**: pill, surface-2; selected = accent fill + on-accent text.
- **AI label**: small pill "Draft AI · estimasi" in accent-soft.
- Icons: Material Symbols Rounded, 24px, stroke-like.

## Motion
Short (150–250 ms) ease-out; set completion = quick scale pop of check + row tint; ring fills animate on load. Respect reduce-motion.

## Accessibility
Contrast ≥ 4.5:1 for text, tap targets ≥ 48px, numerals readable at arm's length, never color-only status (pair with icon/text).

## Device
Mobile portrait, 390 × 844 (iPhone 14 / typical Android), safe areas respected.
