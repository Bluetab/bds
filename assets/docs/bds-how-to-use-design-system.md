# How To Use The Bluetab Design System Package

Publishable npm package (`bluetab-design-system`) with:

- Tokens and component styles (`dist/bds.css`, source in `src/styles/`)
- Interactive helpers (`dist/interactions.js`)

See **[integration-patterns.md](integration-patterns.md)** for layout grids, code classes, dialogs, and LiveView-specific notes.

## 1) Install in a Phoenix/LiveView project

```bash
cd assets
npm install bluetab-design-system
```

Local sibling repo (hot reload during DS development):

```json
"bluetab-design-system": "file:../../bds"
```

Configure Vite dev aliases to `bds/src/styles/main.css` and `bds/src/lib/interactions.js` if needed.

## 2) Import styles

In `assets/css/app.css`:

```css
@import "bluetab-design-system/styles.css";
```

## 3) Enable interactions

In `assets/js/app.js`:

```js
import { initBtInteractions } from "bluetab-design-system/interactions";

initBtInteractions();
```

Supported data attributes:

- `data-dialog-open` / `data-dialog-close`
- `data-overlay-open` / `data-overlay-close`
- `data-menu-toggle`
- `data-expansion-toggle`
- `data-snackbar-open` / `data-snackbar-close`
- `data-tab`
- `data-theme-toggle` (with `[data-theme-icon]` inside the toggle)
- `data-toggle-sidebar` (toggles `body.bt-sidebar-open` for mobile sidebar shells)

## 4) Use component classes in HEEx

```heex
<button class="bt-button">Save changes</button>
<button class="bt-button bt-button--secondary">Cancel</button>

<article class="bt-card bt-card--elevated">
  <h3>Data product</h3>
  <p class="bt-muted">Reusable styles from the shared package.</p>
</article>

<p>
  Use <code class="bt-code-inline">bt-button</code> in sentences.
</p>

<div class="bt-code-block">
  <pre class="bt-code"><code>@import "bluetab-design-system/styles.css";</code></pre>
</div>
```

## 5) Build and deploy

Build the library when consuming `dist/`:

```bash
cd bds && npm run build:lib
```

Then in the Phoenix app:

```bash
mix assets.deploy
```

## 6) Versioning across projects

1. Publish a new package version from `bds`.
2. Upgrade consumers (Renovate/Dependabot).
3. Validate visually and merge.

SemVer:

- **Patch**: fixes, no breaking class/token changes
- **Minor**: additive components or variants
- **Major**: removed or renamed classes/tokens

## 7) Troubleshooting

| Issue | Check |
|-------|--------|
| Styles missing | `@import "bluetab-design-system/styles.css"` in `app.css` |
| Interactions inert | `initBtInteractions()` called after DOM ready |
| Theme icon static | `[data-theme-icon]` present on toggle |
| Topbar in left column | Use `bt-shell--app` without sidebar |
| Cards crushed in a row | Add `bt-card--third` / `bt-example--half` in `bt-example-grid` |
| Inline code too large | Use `bt-code-inline`, not `bt-code` |
| Dialog stuck top-left | Use `div.bt-dialog` or let interactions call `showModal()` on `<dialog>` |
| Stale production CSS | Run `npm run build:lib` in `bds` after source changes |
