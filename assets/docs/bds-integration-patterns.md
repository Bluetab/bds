# Integration Patterns

Practical notes from Phoenix/LiveView apps consuming this package. Use alongside
[`how-to-use-design-system.md`](how-to-use-design-system.md).

## Layout: `bt-shell`

`bt-shell` is a **12-column grid** with sidebar + content:

```html
<div class="bt-shell">
  <aside class="bt-sidebar">…</aside>
  <div class="bt-main-wrap">
    <header class="bt-topbar">…</header>
    <main class="bt-main">…</main>
  </div>
</div>
```

For apps **without a sidebar** (topbar stacked above main), add `bt-shell--app`:

```html
<div class="bt-shell bt-shell--app">
  <header class="bt-topbar">…</header>
  <main class="bt-main">…</main>
</div>
```

Without `bt-shell--app`, the first child is placed in the narrow sidebar column (~280px).

### Top navbar

Production apps use the gradient topbar with orange border. In Phoenix:

```heex
<.bt_topbar>
  <:brand>
    <.bt_navbar_logo_link navigate={~p"/"} logo_src={~p"/images/slash_logo_white.png"}>
      My App
    </.bt_navbar_logo_link>
  </:brand>
  <:actions>
    <.bt_navbar_theme_toggle />
    <.bt_navbar_user_menu name="…" role="…" initials="…">
      …dropdown items with class="bt-navbar-menu-item"…
    </.bt_navbar_user_menu>
  </:actions>
</.bt_topbar>
```

For **storybook / catalog** layouts (full-width topbar above sidebar + main), use `bt-shell--storybook` and place the topbar as the **first** child:

```html
<div class="bt-shell bt-shell--storybook">
  <header class="bt-topbar">…</header>
  <aside class="bt-sidebar">…</aside>
  <div class="bt-main-wrap">
    <main class="bt-main">…</main>
  </div>
</div>
```

On viewports below 980px, add a topbar control with `data-toggle-sidebar` (class `bt-sidebar-toggle`). `initBtInteractions()` toggles `body.bt-sidebar-open` so the fixed sidebar slides in at `--bt-sidebar-width` (not full viewport width). In `bt-shell--storybook`, the drawer sits below the topbar.

## Grid: `bt-example-grid`

`bt-example-grid` uses `grid-template-columns: repeat(12, 1fr)`. Children need an explicit span:

| Class | Columns | Typical use |
|-------|---------|-------------|
| `bt-example--third` / `bt-card--third` | 4 | Three cards per row |
| `bt-example--half` / `bt-card--half` | 6 | Two cards per row |
| `bt-example` (default) | 12 | Full width |

```html
<div class="bt-example-grid">
  <article class="bt-card bt-card--elevated bt-card--third">…</article>
  <article class="bt-card bt-card--filled bt-card--third">…</article>
</div>
```

Bare `bt-card` inside the grid only spans **one** column and will look crushed.

Below 980px, third/half spans collapse to full width automatically.

## Code: inline vs block

| Need | Markup | Class |
|------|--------|-------|
| Class name or short token in a sentence | `<code class="bt-code-inline">bt-button</code>` | `bt-code-inline` |
| Long path that should wrap | `<code class="bt-code-inline bt-code-inline--wrap">docs/…</code>` | both |
| Multiline snippet | `<div class="bt-code-block"><pre class="bt-code"><code>…</code></pre></div>` | `bt-code-block` + `bt-code` |

**Do not** put `bt-code` on inline `<code>` in prose — it adds block padding and a left accent bar.

## Dialogs and overlays

Prefer a **`div.bt-dialog`** (not native `<dialog>`) for DS-driven modals:

```html
<button type="button" data-dialog-open="my-dialog">Open</button>

<div id="my-dialog" class="bt-dialog" role="dialog" aria-modal="true" aria-labelledby="my-dialog-title">
  <div class="bt-dialog__surface">
    <h3 id="my-dialog-title">Title</h3>
    <p>…</p>
    <div class="bt-dialog__actions">
      <button type="button" class="bt-button" data-dialog-close>OK</button>
    </div>
  </div>
</div>
```

`initBtInteractions()` toggles the `open` attribute. The overlay is full-viewport and centered via CSS.

Native `<dialog>` elements are also supported: interactions call `showModal()` / `close()` so the browser top layer is used correctly. Using only the HTML `open` attribute without `showModal()` pins the box to the document origin.

### Phoenix / LiveView placement

Render dialogs and snackbars as **siblings of `main`**, not inside scrollable content — e.g. an overlay slot on your app layout:

```heex
<div class="bt-shell bt-shell--app">
  <header class="bt-topbar">…</header>
  <main class="bt-main">{@inner_block}</main>
  {render_slot(@overlay)}
</div>
```

Styles under `.bt-shell > .bt-dialog[open]` raise z-index above page content.

## JavaScript entrypoints

Import styles once in CSS:

```css
@import "bluetab-design-system/styles.css";
```

Import interactions without pulling CSS twice:

```js
import { initBtInteractions } from "bluetab-design-system/interactions";

initBtInteractions();
```

Avoid importing the package root (`bluetab-design-system`) in JS if you already import `styles.css` in your app stylesheet — `src/lib/index.js` also imports CSS.

## Theme bootstrap

Before paint, set the stored theme on `<html>`:

```html
<script>
  (() => {
    const storageKey = "bt-theme";
    document.documentElement.dataset.theme =
      localStorage.getItem(storageKey) || "light";
  })();
</script>
```

`initBtInteractions()` reads the same `bt-theme` key when `autoApplyStoredTheme` is true (default).

## Local package development

Link the repo from a consumer `package.json`:

```json
"bluetab-design-system": "file:../../bds"
```

Point Vite (dev) at `bds/src` for hot reload of styles and interactions; run `npm run build:lib` in `bds` before production asset builds.
