# Bds — Bluetab Design System

Elixir package for Phoenix/LiveView (`bt_*` components) plus a Vite asset tree under `assets/` (CSS, interactions, component catalog).

## Layout

```text
bds/
├── mix.exs, lib/          # {:bds, path: "../bds"} — Hex package
├── priv/static/           # bds.css + interactions.js (synced from assets/dist)
└── assets/
    ├── src/styles/        # Design tokens & component CSS (edit here)
    ├── src/lib/           # interactions.js
    ├── dist/              # npm run build:lib output
    └── index.html         # Local catalog (npm run dev)
```

## Setup

```bash
mix setup          # deps + npm install + sync priv/static
mix assets.build   # rebuild dist + sync priv/static
mix assets.dev       # catalog at http://localhost:5173/
```

## Consumers (e.g. ds_tester)

```elixir
{:bds, path: "../bds"}
```

```css
/* assets/css/app.css */
@import "bds/styles.css";
```

```js
import {initBtInteractions} from "bds/interactions"
```

In **dev**, point Vite at `bds/assets/src` (see ds_tester `assets/vite.config.js`) so CSS hot-reloads without republishing. In **prod**, use `deps/bds/priv/static` after `mix assets.build` in this repo.

```elixir
config :bds, gettext_backend: MyAppWeb.Gettext
import Bds.Components
```

### Internationalization (Gettext)

Component defaults and catalog metadata use `Bds.Gettext`. In your host app:

```elixir
# lib/my_app_web/gettext.ex
use Gettext.Backend, otp_app: :my_app, imports: [{Bds.Gettext, "default"}]

config :bds, gettext_backend: MyAppWeb.Gettext
```

Set locale on both backends (or rely on imports and set only the host backend):

```elixir
Gettext.put_locale(MyAppWeb.Gettext, "es")
Gettext.put_locale(Bds.Gettext, "es")
```

After changing strings in this package, run `mix gettext.extract` in **bds**, then merge updated `.po` files in the host app.

See [`assets/docs/bds-how-to-use-design-system.md`](assets/docs/bds-how-to-use-design-system.md) and [`assets/docs/bds-integration-patterns.md`](assets/docs/bds-integration-patterns.md).
