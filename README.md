# Bluetab Design System Full Starter

Starter en HTML + CSS + JavaScript para documentar un Design System propio de Bluetab con catálogo de componentes inspirado en la cobertura de Beer CSS, pero sin depender visualmente de Beer CSS.

Prueba

## Arranque

```bash
npm install
npm run dev
```

Normalmente se abrirá en:

```text
http://localhost:5173/
```

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
src/main.js
```

Busca el array `COMPONENTS`. Cada componente tiene esta forma:

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

Cada ejemplo se muestra automáticamente en la página y también aparece en el panel lateral con botón de copiar código.

## Componentes incluidos

- Get started
- App bars
- Badges
- Buttons
- Cards
- Checkboxes
- Chips
- Colors
- Containers
- Dialogs
- Directions
- Dividers
- Expansions
- Fields / Inputs
- Grid
- Helpers
- Icons
- Layout
- Lists
- Main layout
- Media
- Menus
- Navigation
- Overlays
- Pages
- Progress
- Radio buttons
- Selects
- Shapes
- Sliders
- Snackbars
- Switches
- Tables
- Tabs
- Textarea
- Tooltips
- Typography

## Funcionalidad incluida

- Copiar código por ejemplo
- Copiar todo el componente desde el panel lateral
- Panel lateral de documentación/código
- Buscador de componentes
- Cambio de tema claro/oscuro
- Dialogs funcionales
- Overlays funcionales
- Menús funcionales
- Snackbars funcionales
- Tabs funcionales
- Expansions/acordeones funcionales
- Sidebar responsive
