---
# gstack: design-md-format=spec
colors:
  bg: "#EFF1F2"
  surface: "#FFFFFF"
  surface-2: "#F6F8F8"
  ink: "#15181A"
  ink-2: "#343A3E"
  muted: "#616970"
  faint: "#6E767D"
  line: "#DCE0E3"
  line-2: "#C3C9CE"
  accent: "#9E3039"
  accent-ink: "#FFFFFF"
  accent-soft: "#F7E5E6"
  ok: "#1E7A45"
  ok-ink: "#FFFFFF"
  danger: "#A61B1B"
  danger-ink: "#FFFFFF"
  scrim: "rgba(20,25,28,.42)"
  dark:
    bg: "#0F1113"
    surface: "#191D20"
    surface-2: "#202528"
    ink: "#E7EAEC"
    ink-2: "#C2C8CC"
    muted: "#8A9197"
    faint: "#858D94"
    line: "#293034"
    line-2: "#3A4248"
    accent: "#E4636D"
    accent-ink: "#1B0508"
    accent-soft: "#2D1519"
    ok: "#4ADE80"
    ok-ink: "#06210F"
    danger: "#F87171"
    danger-ink: "#2A0607"
    scrim: "rgba(0,0,0,.6)"
typography:
  sans: '"Fira Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif'
  mono: '"Fira Mono", ui-monospace, SFMono-Regular, Menlo, monospace'
  base: "16px"
  h1: "21px"
  h2: "18px"
  sheet-title: "19px"
  numeric: "20px"
  body: "14px"
  secondary: "13.5px"
  label: "12px"
  label-tracking: "0.11em"
  eyebrow: "11.5px"
  eyebrow-tracking: "0.1em"
  line-height-body: "1.5"
  line-height-heading: "1.22"
  weight-body: "400"
  weight-medium: "500"
  weight-strong: "600"
  weight-max: "700"
rounded:
  card: "14px"
  sheet: "18px"
  notice: "12px"
  control: "10px"
  input: "10px"
  pill: "999px"
  focus: "6px"
spacing:
  gutter: "16px"
  card-padding: "14px 15px 13px"
  sheet-padding: "20px 16px"
  stack: "12px"
  control-gap: "9px"
  field-gap: "15px"
  rule-gap: "12px"
components:
  touch-min: "44px"
  action-height: "46px"
  primary-button-height: "50px"
  bottom-action-height: "52px"
  input-height: "48px"
  max-width: "560px"
  icon-stroke: "2"
  icon-size: "17px"
---

Skrienam is a one-screen run board for a Latvian running club, opened from a
WhatsApp link on a phone. It is an OPERATE surface: people arrive to finish a
task, not to be persuaded. Scanability and native expectations beat expression;
the brand lives in the details.

This file was inferred from the shipped interface during a design review on
2026-09-21, then corrected where the review found the interface wrong. Where the
two disagreed, this file follows the corrected values.

## Overview

One screen, four fields, no accounts. The board is the product.

The design answers one question fast: who is running what, and am I in. Every
decision serves a person standing in a kitchen on a Saturday morning holding a
phone in one hand. Nothing is here to impress.

Voice is utility Latvian: orientation, status, action. `Kur tiekamies`, not
`Tikšanās vietas informācija`. Never mood, never aspiration, never a welcome.
Button labels name the outcome: `Es skrienu`, `Vairs neskrienu`, `Saglabāt`.

The club's own mark (M Run Club) sits left of the product wordmark, separated by
a hairline rule. The club owns the identity; Skrienam is the tool.

## Colors

Cool grey neutrals with a single carmine accent. Carmine is the Latvian flag
red, and it is the only saturated colour in the interface.

- `bg` is the page ground, `surface` is every card and sheet, `surface-2` is
  inset fields and icon buttons.
- Text runs `ink` → `ink-2` → `muted` → `faint`. All four clear WCAG AA on the
  surface they sit on.
- `accent` is reserved for the primary action, your own name in a roster, and
  the product wordmark's second syllable. Nothing else.
- `ok` and `danger` are semantic and separate from the accent. Each carries its
  own `-ink` pair, because a light green or light red fill in dark mode cannot
  take white text.

Both themes are full token sets. Light is declared on bare `:root` first; dark
is redefined under `prefers-color-scheme` guarded by
`:root:not([data-theme="light"])` and again under `:root[data-theme="dark"]`.
No colour has its only definition inside a media query.

`faint` is the floor, not a licence: it was #8D959B (3.04:1) and failed AA in
both themes. It is now the lightest text this system permits, and anything
lighter is a bug.

## Typography

Two families, one superfamily. Fira Sans for everything read as language, Fira
Mono for everything read as data. Both carry full Latin Extended, which Latvian
requires — ā ē ī ū ķ ļ ņ ģ š ž č must render in the real face, never a fallback.

Mono is not decoration. It marks the values a runner scans and compares: start
times, distances, paces, dates, and the uppercase labels above them. If a number
is meant to be compared to another number, it is mono with tabular figures.

The scale steps at least 1.25× between adjacent roles. `body` 14px → `h2` 18px
is 1.29:1. The place name is the `h2` and the largest non-numeric text on a card,
because the place is what identifies a run.

12px is the absolute text floor. Below that, text on a phone at arm's length in
the dark is not text.

Letter-spacing belongs on uppercase labels only. Tracking lowercase text breaks
the word shapes readers scan by.

## Layout

Single column, `max-width: 560px`, centred. The gutter is 16px at every width and
never collapses.

The page is a sticky header, a scrolling list, and one fixed bottom action. The
header carries identity and who you are; the list carries the runs; the bottom
action carries the only thing you can create. Nothing else competes.

Safe-area insets are tokens (`--top`, `--bot`) and every fixed edge adds them to
its own padding. The header sticks at `env(safe-area-inset-top)`, not 0.

`main` reserves bottom padding greater than the bottom action's height plus its
gap, so the last card always clears it.

Sheets rise from the bottom, capped at the viewport with `100dvh` so an on-screen
keyboard cannot bury their buttons, and they scroll internally with
`overscroll-behavior: contain`. Page scroll is locked while a sheet is open.

## Elevation & Depth

One shadow token, used only on cards and the bottom action. It is offset plus
blur, never a zero-offset halo: `0 1px 2px` for the contact edge and
`0 10px 24px -16px` for the lift.

Depth in this interface is mostly not shadow. It is surface: `bg` recedes,
`surface` comes forward, `surface-2` sinks back in. A sheet earns a scrim because
it takes over the screen; a card earns a hairline and a whisper of shadow because
it is a list item, not an object floating above the page.

Dark mode deepens the shadow rather than adding a glow. There are no glows.

## Shapes

Radius encodes scale, not style. Sheets 18px because they are the largest
surface, cards 14px, notices 12px, controls and inputs 10px, pills 999px for
anything carrying a person's name.

A uniform radius on everything flattens hierarchy, so these values are a scale
and not a default. Icon buttons match the control radius so they read as
siblings of the button beside them, not as separate objects.

Icons are 17px, 2px stroke, `currentColor`, rounded caps and joins. They inherit
text colour so they participate in the same hierarchy as the words around them.

## Components

**Run card.** The unit of the whole product. Eyebrow (day, mono, uppercase) and
start time (mono, largest numeric) on one row; place name as the `h2`; distance
and pace band in mono; who posted it; a rule; then the roster and the action row.

Cards are legitimate here because each card *is* the interaction — a thing you
join. Cards are never containers for decoration.

**Action row.** Icon buttons at fixed 46px, primary action `flex: 1`. Your own
runs get `[edit] [share] [join]`; everyone else's get `[share] [join]`. The
primary action is always the widest and the only filled one.

**Sheets.** One sheet component serves create, edit, name, share and confirm.
Title, fields, then a `[ghost] [primary]` button pair. Destructive actions sit
below that pair as a bare red text button, never beside the primary.

**Name chip.** Avatar initial on accent, name, pill radius, 44px tall. It is the
only control for changing your name, so it meets the touch minimum like any
other control.

**Empty state.** A dashed container, a real sentence about what to do, and the
bottom action already visible. Never a bare "No items".

**Toast.** Inverted pill above the bottom action, 2.6s, no buttons. Confirmation
only, never a place to put a decision.

## Do's and Don'ts

**Do**

- Keep the whole product on one screen. New capability earns its place by
  replacing something, not by adding a tab.
- Check contrast against the surface a thing actually sits on. `faint` on
  `surface` is the tightest pair in the system and the one that broke.
- Give every interactive element 44px of touch, including the ones that look
  like chrome.
- Let the database enforce what the UI implies. Edit and delete are
  `security definer` functions matching on author, not hidden buttons.
- Preserve the roster through an edit. Fixing a typo must never cost someone
  the people who already joined.
- Write Latvian that a runner would text, not that an app would print.

**Don't**

- Don't put a coloured bar down one side of a rounded card. It was here, it was
  the first coloured thing on the page, and it is the most recognisable tell of
  a generated interface.
- Don't go below 12px for text, or below 4.5:1 for anything at that size.
- Don't let a destructive action be the loudest control in a row. Delete lives
  inside the edit sheet and is neutral until hover.
- Don't add chat. The club has WhatsApp, everyone is already in it, and a second
  inbox is how this dies.
- Don't use pace to hide runs from people. Pace is shown, never filtered on —
  you can run with anyone, the only question is how long.
- Don't add a third font family, a second accent, or a gradient.
- Don't track lowercase text.
- Don't reach for a card when a row will do.

## Motion

One authored moment: a sheet rising 16px with ease-out over 0.22s, from a
visible resting state. A newly created or edited card flashes its border for
2.2s so your eye finds it after the list re-sorts.

Nothing else animates. No entrance on every section, no hover effect on
everything, no skeleton shimmer beyond a plain opacity pulse.

`prefers-reduced-motion: reduce` collapses every duration to 0.01ms.

## Decisions Log

- **2026-09-21** — `faint` raised from `#8D959B`/`#6A7178` to `#6E767D`/`#858D94`.
  Both themes failed WCAG AA. The step between `faint` and `muted` narrows as a
  result; that is accepted, because label hierarchy is carried by case, size and
  tracking, not by contrast.
- **2026-09-21** — Place name raised 16.5px → 18px. The line that identifies a
  run was quieter than the body text around it.
- **2026-09-21** — Notice banner moved from an accent left-bar to a tinted
  surface.
- **2026-09-21** — Delete moved from the card into the edit sheet when edit
  shipped. Keeps the action row three controls wide at 375px and puts a
  destructive action behind a deliberate step.
- **2026-09-21** — Chat, pace filtering, maps, accounts and notifications
  confirmed out of scope. Each was considered and cut on purpose.
