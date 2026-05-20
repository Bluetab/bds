# How To Use The Bluetab Design System Package

This repository ships a publishable npm package with:

- All design tokens and component styles (`bds.css`)
- Optional runtime helpers for interactive components (`interactions.js`)

Use it from Phoenix/LiveView projects to keep visual consistency across apps.

## 1) Install In A Phoenix/LiveView Project

From your Phoenix app root:

```bash
cd assets
npm install bluetab-design-system-full
```

If you publish under a private scope, install with that scope name instead.

## 2) Import Styles

In `assets/css/app.css`:

```css
@import "bluetab-design-system-full/styles.css";
```

This imports all tokens and component styles.

## 3) Enable Optional JS Behaviors

If your pages use DS interactions (dialogs, overlays, menus, tabs, snackbars, expansions, theme toggle), initialize them in `assets/js/app.js`:

```js
import { initBtInteractions } from 'bluetab-design-system-full';

initBtInteractions();
```

The helper reads DS data attributes such as:

- `data-dialog-open` / `data-dialog-close`
- `data-overlay-open` / `data-overlay-close`
- `data-menu-toggle`
- `data-expansion-toggle`
- `data-snackbar-open` / `data-snackbar-close`
- `data-tab`
- `data-theme-toggle`

## 4) Use Component Classes In HEEx

Example button in a LiveView template:

```heex
<button class="bt-button">Save changes</button>
<button class="bt-button bt-button--secondary">Cancel</button>
```

Example card:

```heex
<article class="bt-card bt-card--elevated">
  <h3>Data product</h3>
  <p>Reusable style from the shared package.</p>
</article>
```

## 5) Build And Deploy In Phoenix

No custom steps are required beyond your usual build:

```bash
mix assets.deploy
```

## 6) Update Strategy Across Many Projects

Recommended process:

1. Publish a new DS package version.
2. Open automated upgrade PRs in each LiveView app (Renovate/Dependabot).
3. Validate visually and merge.

Versioning guidance:

- Patch (`x.y.Z`): fixes, no API/class/token breaks
- Minor (`x.Y.z`): additive changes (new components, non-breaking variants)
- Major (`X.y.z`): breaking class names, removed tokens, behavior changes

## 7) Troubleshooting

- Styles are missing: verify `@import "bluetab-design-system-full/styles.css";` is in `assets/css/app.css`.
- Interactive components do nothing: verify `initBtInteractions()` is imported and executed.
- Theme icon does not change: ensure your toggle element contains `[data-theme-icon]`.
- Unexpected visual regressions: check package version in `assets/package.json` and lockfile.

