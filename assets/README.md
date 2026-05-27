# Bluetab Design System

Design System basado en HTML + CSS + JavaScript para Bluetab, con dos objetivos:

- Servir como catálogo local de componentes durante el desarrollo.
- Publicarse como paquete npm reusable en proyectos Phoenix/LiveView.

## Scripts

```bash
cd assets && npm install && npm run dev
# or from repo root: mix assets.dev
```

Catálogo local (Vite):

```text
http://localhost:5173/
```

Build de paquete publicable:

```bash
npm run build:lib
```

Build del catálogo estático:

```bash
npm run build:docs
```

Salida del catálogo: `dist-docs/`

## Entrypoints del paquete

Este repositorio separa catálogo y librería:

- `src/main.js`: solo catálogo/documentación local.
- `src/lib/index.js`: entrada del paquete para consumo externo.
- `src/lib/interactions.js`: utilidades JS reutilizables.

Salidas principales en `dist/`:

- `dist/bds.css`: tokens + estilos de componentes.
- `dist/bds.js`: entrada principal del paquete.
- `dist/interactions.js`: subpath de interacciones.

## Uso desde aplicaciones consumidoras

Guías para LiveView y otras apps:

- [`docs/bds-how-to-use-design-system.md`](docs/bds-how-to-use-design-system.md) — instalación e imports
- [`docs/bds-integration-patterns.md`](docs/bds-integration-patterns.md) — layout, grid, código, dialogs, Phoenix

### Paquete Elixir (Hex / path)

Phoenix apps consume this repo from the root Mix project:

```elixir
{:bds, path: "../bds"}
```

From the repo root: `mix assets.build` copies `assets/dist/*` into `priv/static/`.

## Qué puedes tocar primero

El archivo principal para parametrizar el diseño es:

```text
src/styles/tokens.css
```

Ahí puedes cambiar:

- Colores de marca
- Tema claro/oscuro
- Tipografía
- Radios
- Sombras
- Espaciados
- Tamaños base

## Estructura

```text
src/
├─ main.js
├─ lib/
│  ├─ index.js
│  └─ interactions.js
├─ assets/
│  └─ logo-bluetab.svg
└─ styles/
   ├─ main.css
   ├─ tokens.css
   ├─ reset.css
   ├─ typography.css
   ├─ layout.css
   ├─ utilities.css
   └─ components/
      ├─ navigation.css
      ├─ buttons.css
      ├─ cards.css
      ├─ badges.css
      ├─ forms.css
      ├─ tables.css
      ├─ dialogs.css
      ├─ tabs.css
      ├─ data-viz.css
      ├─ code.css
      └─ feedback.css
```

## Cómo añadir o cambiar componentes

Los ejemplos del catálogo están definidos en:

```text
src/catalog.js
src/main.js
```

Busca el array `COMPONENTS` en `src/catalog.js` (exportado también a `priv/catalog.json` para Phoenix). Cada componente sigue esta forma:

```js
{
  id: 'buttons',
  group: 'Componentes',
  icon: '▣',
  title: 'Buttons',
  description: '...',
  examples: [
    {
      title: 'Common buttons',
      html: `<button class="bt-button">Primary</button>`
    }
  ]
}
```

## Release y versionado

Flujo recomendado:

1. Actualizar estilos/componentes en este repo.
2. Ejecutar `npm run build:lib`.
3. Subir versión (`npm version patch|minor|major`).
4. Publicar (`npm publish` o registry privado).
5. Actualizar dependencias en proyectos consumidores.

Reglas de versionado (SemVer):

- Patch: fixes sin ruptura.
- Minor: cambios compatibles (nuevos componentes/variantes).
- Major: cambios de ruptura (clases/tokens removidos o renombrados).

```
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Titillium+Web:ital,wght@0,200;0,300;0,400;0,600;0,700;0,900;1,200;1,300;1,400;1,600;1,700&display=swap" rel="stylesheet">
```
