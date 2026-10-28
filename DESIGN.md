# Bluetab Design System (BDS)

> DESIGN.md for AI agents and designers. Format follows
> [awesome-design-md](https://github.com/VoltAgent/awesome-design-md).
> Source of truth: `assets/src/styles/tokens.css`. If this file and the CSS
> disagree, the CSS wins — update this file.

## Overview

BDS is the design system for Bluetab's internal product suite (expenses,
time tracking, performance, org charts). It is a **productive, data-dense UI
for employees doing daily work**, not a marketing site: calm surfaces, one
strong brand blue, orange reserved for accents, and controls sized for
pointer and touch.

It ships as an Elixir package with Phoenix function components (`bt_*`,
see `Bds.Components`) and plain CSS classes (`.bt-*`) that also work in
static HTML.

### Key characteristics

- Bluetab Blue `#212492` (PANTONE 2746 C) carries every primary action.
- Bluetab Orange `#e05206` (PANTONE 166 C) is an accent: eyebrows, focus
  ring, highlights. Never a fill for large areas.
- Titillium Web throughout; buttons are bold, tracked and pill shaped.
- Large radii (14–28px) on surfaces, pills on controls.
- Light and dark themes via `data-theme`, on `<html>` or on any element
  (theme zones).
- Accessibility built in: global `:focus-visible` ring, reduced motion,
  forced colors, skip link, `aria-live` flash.

## Colors

All colors are CSS custom properties. **Use the role tokens
(`--bt-color-*`), never the palette (`--bt-palette-*`) or raw hex, in
components.** Roles are redefined in `[data-theme="dark"]`.

### Brand

| Token | Light | Dark | Role |
|---|---|---|---|
| `--bt-color-primary` | `#212492` | `#8da2ff` | Primary buttons, links, selected nav, checked controls |
| `--bt-color-primary-hover` | `#0065ff` | `#b3c2ff` | Hover/focus state of primary |
| `--bt-color-primary-active` | `#11135f` | `#6b82e8` | Pressed |
| `--bt-color-primary-soft` | `#eef0ff` | `#252860` | Ghost hover, selected rows |
| `--bt-color-on-primary` | `#ffffff` | `#0a0b2c` | Text on primary (dark text on the light dark-theme primary) |
| `--bt-color-secondary` | `#e05206` | `#e05206` | Accent fill, focus ring |
| `--bt-color-secondary-text` | `#be4605` | `#e67538` | Orange used as text (eyebrows) |
| `--bt-color-tertiary` | `#542675` | `#bba8c8` | Rare third accent (purple) |

### Surface

| Token | Light | Dark | Role |
|---|---|---|---|
| `--bt-color-background` | `#f2f2f2` | `#1f222d` | Page behind cards |
| `--bt-color-surface` | `#ffffff` | `#17182b` | Cards, inputs, dialogs |
| `--bt-color-surface-raised` | `#ffffff` | `#1e2035` | Menus, popovers |
| `--bt-color-surface-soft` | `#f0f2f8` | `#22243a` | Hover, icon buttons, chips |
| `--bt-color-surface-muted` | `#e8ebf4` | `#2c3048` | Tracks, disabled fills |
| `--bt-color-border` | `#dce1ee` | `#333850` | Card and divider lines |
| `--bt-color-border-strong` | `#c4ccdd` | `#47506b` | Dashed containers, outline buttons, panels |
| `--bt-color-border-input` | `#80889d` | `#6c7593` | Text field, select and switch boundary (≥ 3:1) |

### Text

| Token | Light | Dark | Role |
|---|---|---|---|
| `--bt-color-text` | `#1f222d` | `#f5f7ff` | Headings, body, values |
| `--bt-color-text-muted` | `#4a4a4a` | `#b9bfd4` | Paragraphs, labels |
| `--bt-color-text-subtle` | `#6b6c75` | `#8e96b1` | Help text, captions, metadata (≥ 4.5:1 on surface and background) |

### Semantic

Each role has three tokens:

| Role | Fill (`--bt-color-X`) | Text (`--bt-color-X-text`) light / dark | On fill (`--bt-color-on-X`) |
|---|---|---|---|
| success | `#008b80` | `#00766d` / `#66b9b3` | `#ffffff` (use the teal-70 fill for small text) |
| warning | `#e78c07` | `#a26205` / `#e78c07` | `#1f222d` |
| error | `#c21a37` | `#c21a37` / `#da7687` | `#ffffff` |
| info | `#0065ff` | `#0056d9` / `#66a3ff` | — |

- **Fills** (badges, bars, dots, stripes) use `--bt-color-X`.
- **Text and icons** (status chips, validation messages, callouts) use
  `--bt-color-X-text`: ≥ 4.5:1 on the surface and on `--bt-color-X-soft`
  in both themes. Never put `--bt-color-X` on text.
- Status always pairs color with a word or a named icon (“Overdue”, not
  just red).

### Palette

Twelve families in ten steps (`--bt-palette-<family>-10…100`, step 60 is
the Bluetab master): bluetab-blue, bluetab-orange, purple, deep-purple,
royal-blue, soft-blue, periwinkle, electric-blue, navy, red, warm-red,
amber, teal, neutral-black. Use them for charts and illustrations, not for
UI states.

## Typography

**Family:** `"Titillium Web"`, then Inter / system UI. Mono:
`SFMono-Regular, Consolas, "Liberation Mono"`. Icons: Material Symbols
Rounded, self-hosted (`.bt-icon`, ligature names as text).

| Role | Size | Weight | Line height | Tracking |
|---|---|---|---|---|
| h1 | `clamp(2rem, 4vw, 2.75rem)` | 700 | 1.08 | -0.035em |
| h2 | `clamp(1.5rem, 3vw, 2rem)` | 700 | 1.08 | -0.035em |
| h3 | 1.5rem | 700 | 1.08 | -0.035em |
| h4 | 1.125rem | 700 | 1.08 | -0.035em |
| Lead (`.bt-lead`) | 1.125rem | 400 | 1.55 | normal, max 72ch |
| Body | 1rem | 400 | 1.55 | normal |
| Label | 0.875rem | 700 | 1.55 | normal |
| Button | 1rem (sm 0.875, xs 0.75) | 700 | 1.2 | 1.4px |
| Eyebrow (`.bt-eyebrow`) | 0.75rem | 600 | — | 0.12em, uppercase, orange |
| Help / caption | 0.75rem | 400 | 1.55 | normal |

### Rules

- Weight **750** (`--bt-font-weight-heavy`) always carries ≥ 1px tracking
  (`--bt-letter-spacing-heavy`, or `.bt-text-heavy`). Enforced by
  `test/bds/typography_rules_test.exs`.
- Headings use `text-wrap: balance`.
- Numbers that are compared (tables, totals, hours) use
  `font-variant-numeric: tabular-nums`.
- Use `…` (not `...`) and curly quotes in copy.

## Layout

**Spacing scale** (`--bt-space-*`): 1 = 4px, 2 = 8px, 3 = 12px, 4 = 16px,
5 = 24px, 6 = 32px, 7 = 48px, 8 = 64px. Don't invent values in between.

**Shell:** sticky sidebar `17.5rem` (`--bt-sidebar-width`), topbar
`5rem` (`--bt-topbar-height`), content max width `76rem`, side panels
`min(46rem, 92vw)`.

**Control heights** (`--bt-control-height-*`): xs 28px, sm 32px, md 40px,
lg 52px. Buttons: xs 28, sm 36, md 48, lg 60px. Inputs: 44px minimum.

**Breakpoints in use:** 560, 640, 720/768, 960/980, 1280px. Mobile first
(`min-width`) where possible.

## Elevation & Depth

| Token | Value | Use |
|---|---|---|
| `--bt-shadow-xs` | `0 1px 2px rgba(17,19,45,.06)` | Cards, appbar, active nav |
| `--bt-shadow-sm` | `0 4px 12px rgba(17,19,45,.08)` | Hover lift |
| `--bt-shadow-md` | `0 12px 32px rgba(17,19,45,.12)` | Elevated cards, FAB, menus |
| `--bt-shadow-lg` | `0 24px 60px rgba(17,19,45,.18)` | Dialogs |
| `--bt-shadow-button` | `0 20px 25px -5px rgb(33 36 146 / .2)` | Button hover/focus |

Modals and overlays use **glass** tokens (`--bt-glass-*`): translucent
gradient surface, `backdrop-filter: blur(24px) saturate(150%)`, lighter
blur under 768px.

## Shapes

| Token | Value | Use |
|---|---|---|
| `--bt-radius-xs` | 6px | Tiny tags |
| `--bt-radius-sm` | 8px | Code, small tiles |
| `--bt-radius-md` | 14px | Inputs, xs icon buttons, card media |
| `--bt-radius-lg` | 20px | Cards, appbar, FAB |
| `--bt-radius-xl` | 28px | Bottom nav, large panels |
| `--bt-radius-pill` | 999px | Buttons, chips, nav links, status |

## Components

Use the Phoenix component when one exists (`<.bt_button>`), otherwise the
class. Full catalog with live demos and a11y notes: the Storybook app.

### Buttons — `<.bt_button>` / `.bt-button`

- Pill, Titillium 16px bold, 1.4px tracking, 16px icon gap, 24px icon.
- Variants: primary (blue fill, white text), `secondary` (surface fill,
  blue text, hairline ring), `tertiary` (soft fill), `outline`, `ghost`,
  `danger` (error fill).
- Hover **and** keyboard focus share the elevated state: fill turns
  `primary-hover` and gains `--bt-shadow-button`; focus also keeps the ring.
- Disabled: explicit colors (`bluetab-blue-10` fill, `bluetab-blue-30`
  text), no opacity trick, no hover.
- Icon-only actions use `<.bt_icon_button>` and **must** have a label.

### Inputs — `<.bt_input>` / `.bt-input`, `.bt-select`, `.bt-textarea`

- 44px min height, 14px radius, 1px `border-strong`, surface fill.
- Focus: border turns primary + 4px soft halo.
- Errors: `.bt-field--error` turns the border to `error` and shows the
  message in words below the field.
- Every control has a visible `<label>`; placeholders are examples, end in
  `…`, and never replace the label. Placeholder color is
  `--bt-color-text-subtle` (≥ 4.5:1).
- A field with an error keeps its red border on focus and adds a solid 2px
  ring in `--bt-color-error-text`.

### Chips, status, badges

- `.bt-chip`: 32px pill, `surface-soft`; `--selected` fills with primary.
  Chips that act are `<button>`s.
- `<.bt_status>`: pill with soft semantic background + semantic text + icon.
- `.bt-badge`: counter dot on icons, error red by default.

### Cards — `<.bt_card>` / `.bt-card`

- Surface, 1px border, 20px radius, `shadow-xs`, 16px padding, 12px gap.
- `--elevated` (shadow-md, no border), `--filled` (surface-soft),
  `--primary` (blue fill, white text).
- Don't nest cards inside cards; use sections or dividers.

### Navigation

- Sidebar nav links: 44px pill rows, muted text; current page gets primary
  fill (`aria-current="page"`).
- Topbar with optional brand accent gradient; user menu with theme and
  locale toggles (`bt_navbar_user_menu`).
- Tabs, breadcrumb, stepper, bottom nav, tree.

### Overlays & feedback

- `<.bt_dialog>` / `<.bt_modal>` on native `<dialog>`: focus moves in,
  Escape closes, focus returns to the opener.
- `<.bt_flash>` and snackbar announce via `aria-live`.
- Spinner, progress (linear and circle), empty state, tooltip.

### Domain components

Calendar (month grid, day modal, templates), project picker, user picker,
combobox, expense (cards, workflow track, filter bar), performance
(briefing, evaluator, team cards). Same tokens and rules as above.

## Motion

Durations grow with the size and distance of what moves:

| Token | ms | Use |
|---|---|---|
| `--bt-duration-fast-01` | 70 | Toggles, color, small opacity |
| `--bt-duration-fast-02` | 110 | Buttons, chips, hover/press, tooltips |
| `--bt-duration-moderate-01` | 150 | Dropdowns, menus, exits |
| `--bt-duration-moderate-02` | 240 | Dialogs, accordions, tabs |
| `--bt-duration-slow-01` | 400 | Side panels, page content |
| `--bt-duration-slow-02` | 700 | Expressive moments only |

Curves: `--bt-ease-standard`, `-entrance` (decelerate),
`-exit` (accelerate), plus expressive variants. Animate `transform` and
`opacity`; list properties, never `transition: all`. Everything collapses
under `prefers-reduced-motion: reduce`.

## Do's and Don'ts

### Do

- Use role tokens (`--bt-color-text`, `--bt-space-4`, `--bt-radius-lg`).
- Use Bluetab Blue for the one primary action per view.
- Keep the global focus ring; if you restyle focus, keep an outline (use
  `outline-color: transparent` plus a ring, so forced-colors mode still
  draws it).
- Put status in words + icon, not color alone.
- Test both themes, and nested theme zones.
- Use `<button>` for actions and `<a>`/`<.link>` for navigation.

### Don't

- Don't hardcode hex in components; don't use palette steps for UI state.
- Don't fill large areas with orange; it's an accent.
- Don't put a fill color (`--bt-color-success`, `--bt-color-warning`…) on text; use its `-text` token.
- Don't remove outlines (`outline: none`) without a replacement.
- Don't put `phx-click` on `div`/`span`.
- Don't nest cards in cards or stack more than one elevated layer.

## Responsive Behavior

- The shell is two columns (sidebar + content) and stacks to one column at
  980px and below; the topbar compacts below 1280px.
- Touch targets are ≥ 40px (controls md) and 44px for inputs/nav rows.
- Glass blur is reduced under 768px for performance.
- Typography: h1/h2 scale with `clamp()`; body stays at 16px.

## Iteration Guide

1. Change tokens in `assets/src/styles/tokens.css`, not per component.
2. Component CSS lives in `assets/src/styles/components/<name>.css`.
3. Phoenix components in `lib/bds/components*.ex`; catalog entries in
   `assets/src/catalog.js` (exported to `priv/catalog.json`).
4. Run `mix test` (contrast, typography, a11y and catalog tests).
5. Check the change in the Storybook in light, dark and a nested zone.

## Contrast

Every token pair BDS renders together is listed in `Bds.Tokens.pairs/0`
and audited by `Bds.Tokens.audit/1`; `test/bds/contrast_test.exs` fails if
any text, status or control pair drops below WCAG AA in either theme.

**Focus ring:** solid `--bt-color-secondary`, 3px, offset 3px: ≥ 3:1 on
surface and background in both themes. Inside primary fills
(`.bt-appbar--primary`, `.bt-card--primary`) it switches to
`--bt-color-on-primary`, because orange on the dark-theme primary is 1.6:1.
Controls inside `overflow: hidden` parents (expansion header, segmented,
filter bar) draw it inside (`outline-offset: -3px`). Restyled focus keeps a
transparent outline so Windows forced-colors mode still paints it.

**Stacking:** header 220, user menu 230, flash 240, doc panel 250, LiveView
modal layers `--bt-z-overlay` (300), portaled combobox panels above that,
skip link `--bt-z-skip-link`.

## Known Gaps

- Card and divider borders (`--bt-color-border`, 1.3:1) are decorative and
  exempt from SC 1.4.11; don't use them as the only boundary of a control.
- The calendar's fill-only status colors (festivo, vacaciones, nuevo) are
  not meant for text.
