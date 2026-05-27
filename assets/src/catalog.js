export const snippets = {
  tokens: String.raw`:root {
  /* Brand */
  --bt-color-primary: #212492;
  --bt-color-primary-hover: #0065ff;
  --bt-color-primary-active: #11135f;
  --bt-color-primary-soft: #eef0ff;
  --bt-color-on-primary: #ffffff;

  --bt-color-secondary: #e05206;
  --bt-color-secondary-hover: #0065ff;
  --bt-color-secondary-soft: #e6f9fc;
  --bt-color-on-secondary: #03232b;

  --bt-color-tertiary: #542675;
  --bt-color-tertiary-soft: #f3ecff;
  --bt-color-on-tertiary: #ffffff;

  /* Semantic */
  --bt-color-success: #008b80;
  --bt-color-success-soft: #e8f7ee;
  --bt-color-warning: #e78c07;
  --bt-color-warning-soft: #fff7e6;
  --bt-color-error: #c21a37;
  --bt-color-error-soft: #fdeceb;
  --bt-color-info: #0065ff;
  --bt-color-info-soft: #e8f2ff;

  /* Neutral / surfaces */
  --bt-color-background: #f2f2f2;
  --bt-color-surface: #ffffff;
  --bt-color-surface-raised: #ffffff;
  --bt-color-surface-soft: #f0f2f8;
  --bt-color-surface-muted: #e8ebf4;
  --bt-color-border: #dce1ee;
  --bt-color-border-strong: #c4ccdd;
  --bt-color-text: #1f222d;
  --bt-color-text-muted: #4a4a4a;
  --bt-color-text-subtle: #959595;

  /* Typography */
  --bt-font-family: "Titillium Web", Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --bt-font-mono: "SFMono-Regular", Consolas, "Liberation Mono", monospace;
  --bt-font-size-xs: 0.75rem;
  --bt-font-size-sm: 0.875rem;
  --bt-font-size-md: 1rem;
  --bt-font-size-lg: 1.125rem;
  --bt-font-size-xl: 1.5rem;
  --bt-font-size-2xl: 2rem;
  --bt-font-size-3xl: 2.75rem;
  --bt-line-height-tight: 1.08;
  --bt-line-height-base: 1.55;

  /* Spacing */
  --bt-space-1: 0.25rem;
  --bt-space-2: 0.5rem;
  --bt-space-3: 0.75rem;
  --bt-space-4: 1rem;
  --bt-space-5: 1.5rem;
  --bt-space-6: 2rem;
  --bt-space-7: 3rem;
  --bt-space-8: 4rem;

  /* Shape */
  --bt-radius-xs: 0.375rem;
  --bt-radius-sm: 0.5rem;
  --bt-radius-md: 0.875rem;
  --bt-radius-lg: 1.25rem;
  --bt-radius-xl: 1.75rem;
  --bt-radius-pill: 999px;

  /* Elevation */
  --bt-shadow-xs: 0 1px 2px rgba(17, 19, 45, 0.06);
  --bt-shadow-sm: 0 4px 12px rgba(17, 19, 45, 0.08);
  --bt-shadow-md: 0 12px 32px rgba(17, 19, 45, 0.12);
  --bt-shadow-lg: 0 24px 60px rgba(17, 19, 45, 0.18);

  /* Layout */
  --bt-sidebar-width: 17.5rem;
  --bt-content-max-width: 76rem;
  --bt-panel-width: min(46rem, 92vw);

  /* Motion */
  --bt-ease: cubic-bezier(.2, .8, .2, 1);
  --bt-duration-fast: 140ms;
  --bt-duration-base: 220ms;
}

html[data-theme="dark"] {
  --bt-color-primary: #8da2ff;
  --bt-color-primary-hover: #b3c2ff;
  --bt-color-primary-active: #6b82e8;
  --bt-color-background: #1f222d;
  --bt-color-surface: #17182b;
  --bt-color-surface-raised: #1e2035;
  --bt-color-surface-soft: #22243a;
  --bt-color-surface-muted: #2c3048;
  --bt-color-border: #333850;
  --bt-color-border-strong: #47506b;
  --bt-color-text: #f5f7ff;
  --bt-color-text-muted: #b9bfd4;
  --bt-color-text-subtle: #8e96b1;
  --bt-color-primary-soft: #252860;
  --bt-color-secondary-soft: #063846;
  --bt-color-tertiary-soft: #38225c;
  --bt-color-success-soft: #173926;
  --bt-color-warning-soft: #3d2d10;
  --bt-color-error-soft: #3d1f22;
  --bt-color-info-soft: #142e4e;
}`,
};

export const COMPONENTS = [
  {
    id: "get-started",
    group: "Inicio",
    icon: "<>",
    title: "Get started",
    description:
      "Base HTML, CSS y JavaScript para crear un Design System Bluetab propio.",
    intro: true,
    examples: [
      {
        title: "Estructura recomendada",
        block: true,
        html: String.raw`<div class="bt-card bt-card--filled">
  <h3>Arquitectura del proyecto</h3>
  <p>Modifica primero <code class="bt-code-inline">src/styles/tokens.css</code>. Después ajusta cada componente en <code class="bt-code-inline">src/styles/components/</code>.</p>
  <div class="bt-code-block">
    <pre class="bt-code">src/styles/tokens.css
src/styles/components/buttons.css
src/styles/components/forms.css
src/styles/components/tables.css
src/main.js</pre>
  </div>
</div>`,
      },
      {
        title: "Botón de ejemplo Bluetab",
        html: String.raw`<button class="bt-button">
  <span>Guardar cambios</span>
</button>
<button class="bt-button bt-button--outline">
  <span>Cancelar</span>
</button>`,
      },
    ],
  },
  {
    id: "app-bars",
    group: "Componentes",
    icon: "▣",
    title: "App bars",
    description:
      "Barras superiores e inferiores para navegación, acciones contextuales y estado de una pantalla.",
    examples: [
      {
        title: "Top app bar",
        html: String.raw`<header class="bt-appbar">
  <button class="bt-icon-button" aria-label="Menú"><span class="bt-icon">☰</span></button>
  <strong>Proyecto Bluetab</strong>
  <span class="bt-spacer"></span>
  <button class="bt-icon-button" aria-label="Buscar"><span class="bt-icon">⌕</span></button>
  <button class="bt-icon-button" aria-label="Usuario"><span class="bt-icon">◎</span></button>
</header>`,
      },
      {
        title: "Primary app bar",
        html: String.raw`<header class="bt-appbar bt-appbar--primary">
  <button class="bt-icon-button bt-icon-button--primary" aria-label="Volver"><span class="bt-icon">←</span></button>
  <strong>Analytics Dashboard</strong>
  <span class="bt-spacer"></span>
  <button class="bt-button bt-button--secondary">Publicar</button>
</header>`,
      },
      {
        title: "Bottom navigation bar",
        block: true,
        html: String.raw`<nav class="bt-bottom-nav" aria-label="Navegación inferior">
  <a href="#" aria-current="page"><span class="bt-icon">⌂</span><span>Home</span></a>
  <a href="#"><span class="bt-icon">▦</span><span>Apps</span></a>
  <a href="#"><span class="bt-icon">☷</span><span>Datos</span></a>
  <a href="#"><span class="bt-icon">⚙</span><span>Ajustes</span></a>
</nav>`,
      },
    ],
  },
  {
    id: "badges",
    group: "Componentes",
    icon: "◈",
    title: "Badges",
    description:
      "Indicadores numéricos o visuales para notificaciones, estados y elementos pendientes.",
    examples: [
      {
        title: "Badge dot",
        html: String.raw`<span class="bt-badge-wrap">
  <span class="bt-icon">⌂</span>
  <span class="bt-badge bt-badge--dot"></span>
</span>`,
      },
      {
        title: "Badge con número",
        html: String.raw`<span class="bt-badge-wrap">
  <span class="bt-icon">⌂</span>
  <span class="bt-badge">10</span>
</span>`,
      },
      {
        title: "Badge inline",
        html: String.raw`<button class="bt-button">
  <span>Alertas</span>
  <span class="bt-badge bt-badge--inline">3</span>
</button>
<button class="bt-button bt-button--secondary">
  <span>Procesos</span>
  <span class="bt-badge bt-badge--inline bt-badge--success">OK</span>
</button>`,
      },
    ],
  },
  {
    id: "buttons",
    group: "Componentes",
    icon: "▣",
    title: "Buttons",
    description:
      "Acciones principales, secundarias, terciarias, de icono y FAB.",
    examples: [
      {
        title: "Common buttons",
        html: String.raw`<button class="bt-button">Primary</button>
<button class="bt-button bt-button--secondary">Secondary</button>
<button class="bt-button bt-button--tertiary">Tertiary</button>
<button class="bt-button bt-button--outline">Outline</button>
<button class="bt-button bt-button--ghost">Ghost</button>`,
      },
      {
        title: "Button sizes",
        html: String.raw`<button class="bt-button bt-button--sm">Small</button>
<button class="bt-button">Medium</button>
<button class="bt-button bt-button--lg">Large</button>`,
      },
      {
        title: "Icon buttons",
        html: String.raw`<button class="bt-icon-button" aria-label="Buscar"><span class="bt-icon">⌕</span></button>
<button class="bt-icon-button bt-icon-button--primary" aria-label="Guardar"><span class="bt-icon">✓</span></button>
<button class="bt-fab" aria-label="Crear"><span class="bt-icon">＋</span></button>
<button class="bt-fab bt-fab--extended"><span class="bt-icon">＋</span><span>Crear</span></button>`,
      },
      {
        title: "Segmented buttons",
        html: String.raw`<div class="bt-segmented" role="group" aria-label="Vista">
  <button type="button" aria-pressed="true">Día</button>
  <button type="button" aria-pressed="false">Semana</button>
  <button type="button" aria-pressed="false">Mes</button>
</div>`,
      },
    ],
  },
  {
    id: "cards",
    group: "Componentes",
    icon: "▧",
    title: "Cards",
    description:
      "Contenedores de contenido con variantes elevadas, rellenas, con media y acciones.",
    examples: [
      {
        title: "Outlined card",
        block: true,
        html: String.raw`<article class="bt-card">
  <h3>Card estándar</h3>
  <p>Úsala para agrupar información relacionada dentro de una pantalla.</p>
  <div class="bt-card__actions">
    <button class="bt-button bt-button--ghost">Ver más</button>
    <button class="bt-button">Aceptar</button>
  </div>
</article>`,
      },
      {
        title: "Elevated card",
        block: true,
        html: String.raw`<article class="bt-card bt-card--elevated">
  <div class="bt-card__media"></div>
  <h3>Data product</h3>
  <p>Tarjeta con bloque visual, sombra y acciones.</p>
</article>`,
      },
      {
        title: "Filled / Primary cards",
        block: true,
        html: String.raw`<article class="bt-card bt-card--filled">
  <h3>Filled card</h3>
  <p>Para secciones suaves o agrupaciones secundarias.</p>
</article>
<article class="bt-card bt-card--primary">
  <h3>Primary card</h3>
  <p>Para mensajes destacados de producto o marca.</p>
</article>`,
      },
    ],
  },
  {
    id: "checkboxes",
    group: "Formularios",
    icon: "☑",
    title: "Checkboxes",
    description:
      "Selección múltiple en formularios, filtros y configuraciones.",
    examples: [
      {
        title: "Checkbox básico",
        html: String.raw`<label class="bt-checkbox">
  <input type="checkbox" />
  <span>Acepto condiciones</span>
</label>
<label class="bt-checkbox">
  <input type="checkbox" checked />
  <span>Enviar copia</span>
</label>`,
      },
      {
        title: "Checkbox disabled",
        html: String.raw`<label class="bt-checkbox">
  <input type="checkbox" disabled />
  <span>Opción no disponible</span>
</label>
<label class="bt-checkbox">
  <input type="checkbox" checked disabled />
  <span>Opción obligatoria</span>
</label>`,
      },
    ],
  },
  {
    id: "chips",
    group: "Componentes",
    icon: "◌",
    title: "Chips",
    description:
      "Etiquetas compactas para filtros, selección, metadatos o acciones rápidas.",
    examples: [
      {
        title: "Common chips",
        html: String.raw`<span class="bt-chip">Data</span>
<span class="bt-chip bt-chip--selected">Selected</span>
<span class="bt-chip bt-chip--outline">Outline</span>
<button class="bt-chip"><span class="bt-icon">＋</span> Añadir filtro</button>`,
      },
      {
        title: "Status chips",
        html: String.raw`<span class="bt-status bt-status--success">Activo</span>
<span class="bt-status bt-status--warning">Pendiente</span>
<span class="bt-status bt-status--error">Error</span>
<span class="bt-status bt-status--info">Info</span>`,
      },
    ],
  },
  {
    id: "code",
    group: "Foundations",
    icon: "{}",
    title: "Code",
    description:
      "Código inline en prosa y bloques multilínea. No mezclar clases.",
    examples: [
      {
        title: "Inline en prosa",
        block: true,
        html: String.raw`<p class="bt-muted">
  Menciona clases con <code class="bt-code-inline">bt-button</code> o rutas con
  <code class="bt-code-inline bt-code-inline--wrap">docs/how-to-use-design-system.md</code>.
</p>`,
      },
      {
        title: "Bloque multilínea",
        block: true,
        html: String.raw`<div class="bt-code-block">
  <pre class="bt-code"><code>@import "bluetab-design-system/styles.css";

import { initBtInteractions } from "bluetab-design-system/interactions";
initBtInteractions();</code></pre>
</div>`,
      },
      {
        title: "Cards en bt-example-grid",
        block: true,
        html: String.raw`<div class="bt-example-grid">
  <article class="bt-card bt-card--elevated bt-card--third">A</article>
  <article class="bt-card bt-card--filled bt-card--third">B</article>
  <article class="bt-card bt-card--third">C</article>
</div>`,
      },
    ],
  },
  {
    id: "colors",
    group: "Foundations",
    icon: "◍",
    title: "Colors",
    description: "Paleta base editable desde tokens CSS.",
    examples: [
      {
        title: "Brand colors",
        block: true,
        html: String.raw`<div class="bt-color-grid">
  <div class="bt-color-swatch"><div class="bt-color-swatch__color" style="--swatch: var(--bt-color-primary)"></div><div class="bt-color-swatch__text">Primary</div></div>
  <div class="bt-color-swatch"><div class="bt-color-swatch__color" style="--swatch: var(--bt-color-secondary)"></div><div class="bt-color-swatch__text">Secondary</div></div>
  <div class="bt-color-swatch"><div class="bt-color-swatch__color" style="--swatch: var(--bt-color-tertiary)"></div><div class="bt-color-swatch__text">Tertiary</div></div>
  <div class="bt-color-swatch"><div class="bt-color-swatch__color" style="--swatch: var(--bt-color-surface-muted)"></div><div class="bt-color-swatch__text">Surface</div></div>
</div>`,
      },
      {
        title: "Semantic colors",
        block: true,
        html: String.raw`<div class="bt-row">
  <span class="bt-status bt-status--success">Success</span>
  <span class="bt-status bt-status--warning">Warning</span>
  <span class="bt-status bt-status--error">Error</span>
  <span class="bt-status bt-status--info">Info</span>
</div>`,
      },
    ],
  },
  {
    id: "containers",
    group: "Layout",
    icon: "▤",
    title: "Containers",
    description:
      "Bloques estructurales para agrupar contenido y controlar densidad.",
    examples: [
      {
        title: "Default container",
        block: true,
        html: String.raw`<section class="bt-container">
  <h3>Container</h3>
  <p>Bloque reutilizable para documentación, paneles y zonas de contenido.</p>
</section>`,
      },
      {
        title: "Compact container",
        block: true,
        html: String.raw`<section class="bt-container bt-container--compact">
  <p>Container compacto con menos padding.</p>
</section>`,
      },
    ],
  },
  {
    id: "dialogs",
    group: "Componentes",
    icon: "□",
    title: "Dialogs",
    description:
      "Ventanas modales para confirmaciones, mensajes críticos o acciones bloqueantes.",
    examples: [
      {
        title: "Dialog básico",
        html: String.raw`<button class="bt-button" data-dialog-open="dialog-basic">Abrir dialog</button>
<div class="bt-dialog" id="dialog-basic" role="dialog" aria-modal="true" aria-labelledby="dialog-basic-title">
  <div class="bt-dialog__surface">
    <h3 id="dialog-basic-title">Confirmar acción</h3>
    <p>Este dialog usa JavaScript local del Design System.</p>
    <div class="bt-dialog__actions">
      <button class="bt-button bt-button--ghost" data-dialog-close>Cancelar</button>
      <button class="bt-button" data-dialog-close>Aceptar</button>
    </div>
  </div>
</div>`,
      },
      {
        title: "Alert dialog",
        html: String.raw`<button class="bt-button bt-button--danger" data-dialog-open="dialog-alert">Eliminar</button>
<div class="bt-dialog" id="dialog-alert" role="alertdialog" aria-modal="true">
  <div class="bt-dialog__surface">
    <h3>Eliminar registro</h3>
    <p>Esta acción no se puede deshacer.</p>
    <div class="bt-dialog__actions">
      <button class="bt-button bt-button--ghost" data-dialog-close>Volver</button>
      <button class="bt-button bt-button--danger" data-dialog-close>Eliminar</button>
    </div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "directions",
    group: "Layout",
    icon: "↔",
    title: "Directions",
    description:
      "Utilidades para controlar dirección, orden y alineación de elementos.",
    examples: [
      {
        title: "Row direction",
        html: String.raw`<div class="bt-dir-row">
  <button class="bt-button bt-button--secondary">Uno</button>
  <button class="bt-button bt-button--secondary">Dos</button>
  <button class="bt-button bt-button--secondary">Tres</button>
</div>`,
      },
      {
        title: "Column direction",
        html: String.raw`<div class="bt-dir-column">
  <button class="bt-button bt-button--secondary">Primero</button>
  <button class="bt-button bt-button--secondary">Segundo</button>
  <button class="bt-button bt-button--secondary">Tercero</button>
</div>`,
      },
      {
        title: "Reverse direction",
        html: String.raw`<div class="bt-dir-reverse">
  <button class="bt-button bt-button--secondary">A</button>
  <button class="bt-button bt-button--secondary">B</button>
  <button class="bt-button bt-button--secondary">C</button>
</div>`,
      },
    ],
  },
  {
    id: "dividers",
    group: "Layout",
    icon: "─",
    title: "Dividers",
    description:
      "Separadores horizontales y verticales para organizar contenido.",
    examples: [
      {
        title: "Horizontal divider",
        block: true,
        html: String.raw`<div class="bt-stack">
  <span>Contenido superior</span>
  <span class="bt-divider" aria-hidden="true"></span>
  <span>Contenido inferior</span>
</div>`,
      },
      {
        title: "Vertical divider",
        html: String.raw`<div class="bt-row">
  <span>Inicio</span>
  <span class="bt-divider bt-divider--vertical" aria-hidden="true"></span>
  <span>Fin</span>
</div>`,
      },
    ],
  },
  {
    id: "expansions",
    group: "Componentes",
    icon: "⌄",
    title: "Expansions",
    description:
      "Acordeones para mostrar u ocultar información progresivamente.",
    examples: [
      {
        title: "Expansion panel",
        block: true,
        html: String.raw`<div class="bt-expansion" data-expansion>
  <button class="bt-expansion__button" type="button" data-expansion-toggle>
    <span>¿Qué incluye este componente?</span>
    <span class="bt-expansion__icon">⌄</span>
  </button>
  <div class="bt-expansion__content">
    <p>Contenido expandible, útil para documentación, FAQs o datos secundarios.</p>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "combobox",
    group: "Formularios",
    icon: "⌕",
    title: "Combobox",
    description:
      "Searchable select with async results panel, loading state, and option variants.",
    examples: [
      {
        title: "Open with results",
        block: true,
        html: String.raw`<div class="bt-combobox bt-combobox--open">
  <div class="bt-field">
    <label for="combobox-demo">Project</label>
    <div class="bt-combobox__input-wrap">
      <input class="bt-input" id="combobox-demo" type="text" name="project_search" value="portal" placeholder="Search by name or ID…" />
    </div>
  </div>
  <div class="bt-combobox__panel" role="listbox">
    <div class="bt-combobox__options">
      <button type="button" class="bt-combobox__option bt-combobox__option--selected" role="option" aria-selected="true">
        <span class="bt-combobox__option-title">1042</span>
        <span> — Portal Redesign</span>
      </button>
      <button type="button" class="bt-combobox__option" role="option" aria-selected="false">
        <span class="bt-combobox__option-title">1088</span>
        <span> — Portal Maintenance</span>
      </button>
      <button type="button" class="bt-combobox__option bt-combobox__option--warning" role="option" aria-selected="false">
        <span class="bt-combobox__option-title">991</span>
        <span> — Legacy Portal</span>
        <span class="bt-combobox__option-sub">Ended 2024-12-31</span>
      </button>
    </div>
  </div>
</div>`,
      },
      {
        title: "Loading",
        html: String.raw`<div class="bt-combobox bt-combobox--open">
  <div class="bt-field">
    <label for="combobox-loading">Project</label>
    <div class="bt-combobox__input-wrap">
      <input class="bt-input" id="combobox-loading" type="text" name="project_search" value="data" />
      <div class="bt-combobox__trailing"><span class="bt-combobox__spinner" aria-hidden="true"></span></div>
    </div>
  </div>
  <div class="bt-combobox__panel"><div class="bt-combobox__status">Searching…</div></div>
</div>`,
      },
    ],
  },
  {
    id: "fields",
    group: "Formularios",
    icon: "▭",
    title: "Fields / Inputs",
    description: "Campos de entrada, estados de ayuda y error.",
    examples: [
      {
        title: "Text fields",
        html: String.raw`<div class="bt-field">
  <label for="name-field">Nombre</label>
  <input class="bt-input" id="name-field" type="text" placeholder="Ej. Data Governance" />
  <small class="bt-help">Texto de ayuda opcional.</small>
</div>
<div class="bt-field bt-field--error">
  <label for="error-field">Campo con error</label>
  <input class="bt-input" id="error-field" type="text" value="Valor incorrecto" />
  <small class="bt-help">Revisa este valor antes de continuar.</small>
</div>`,
      },
      {
        title: "Field with icon",
        html: String.raw`<div class="bt-field">
  <label for="search-field">Buscar</label>
  <input class="bt-input" id="search-field" type="search" placeholder="Buscar componente" />
</div>`,
      },
    ],
  },
  {
    id: "grid",
    group: "Layout",
    icon: "▦",
    title: "Grid",
    description:
      "Sistema de rejilla CSS para distribuir contenido de forma responsive.",
    examples: [
      {
        title: "Three columns",
        block: true,
        html: String.raw`<div class="bt-layout-demo">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>`,
      },
      {
        title: "Auto grid",
        block: true,
        html: String.raw`<div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr)); gap: var(--bt-space-3); width:100%;">
  <article class="bt-card bt-card--filled">A</article>
  <article class="bt-card bt-card--filled">B</article>
  <article class="bt-card bt-card--filled">C</article>
</div>`,
      },
    ],
  },
  {
    id: "helpers",
    group: "Foundations",
    icon: "+",
    title: "Helpers",
    description: "Clases utilitarias para composición rápida.",
    examples: [
      {
        title: "Stack / Inline",
        block: true,
        html: String.raw`<div class="bt-stack">
  <div class="bt-inline">
    <span class="bt-status bt-status--info">Inline</span>
    <span class="bt-status bt-status--success">Wrap</span>
  </div>
  <p class="bt-muted">Usa <code class="bt-code-inline">.bt-stack</code>, <code class="bt-code-inline">.bt-inline</code>, <code class="bt-code-inline">.bt-row</code> para composición.</p>
</div>`,
      },
      {
        title: "Radius and elevation helpers",
        html: String.raw`<div class="bt-surface bt-round-sm bt-shadow-sm" style="padding: var(--bt-space-4);">Small radius</div>
<div class="bt-surface bt-round-lg bt-shadow-md" style="padding: var(--bt-space-4);">Large radius</div>`,
      },
    ],
  },
  {
    id: "icons",
    group: "Foundations",
    icon: "◎",
    title: "Icons",
    description:
      "Sistema simple de iconos basado en texto/SVG para que puedas cambiarlo por la librería corporativa.",
    examples: [
      {
        title: "Iconos inline",
        html: String.raw`<span class="bt-icon">⌂</span>
<span class="bt-icon">⌕</span>
<span class="bt-icon">⚙</span>
<span class="bt-icon">✓</span>
<span class="bt-icon">×</span>`,
      },
      {
        title: "Icon inside button",
        html: String.raw`<button class="bt-button">
  <span class="bt-icon">✓</span>
  <span>Validar</span>
</button>`,
      },
    ],
  },
  {
    id: "layout",
    group: "Layout",
    icon: "▥",
    title: "Layout",
    description: "Shell principal, topbar, sidebar y áreas de contenido.",
    examples: [
      {
        title: "Basic shell",
        block: true,
        html: String.raw`<div class="bt-shell">
  <aside class="bt-sidebar">Sidebar</aside>
  <main class="bt-main">Contenido principal</main>
</div>`,
      },
      {
        title: "App shell (no sidebar)",
        block: true,
        html: String.raw`<div class="bt-shell bt-shell--app">
  <header class="bt-topbar">
    <div class="bt-topbar__inner">
      <div class="bt-topbar__start">
        <a href="#" class="bt-navbar-logo-link" onclick="return false;">App</a>
      </div>
      <div class="bt-topbar__actions">
        <button type="button" class="bt-theme-toggle-button" data-theme-toggle aria-label="Tema">
          <span class="bt-icon" data-theme-icon>◐</span>
        </button>
      </div>
    </div>
  </header>
  <main class="bt-main">Contenido principal</main>
</div>`,
      },
      {
        title: "Section header",
        block: true,
        html: String.raw`<section class="bt-section">
  <div class="bt-section__header">
    <h2 class="bt-section__title">Título sección</h2>
    <button class="bt-button bt-button--secondary">Acción</button>
  </div>
  <p class="bt-section__description">Descripción breve de la sección.</p>
</section>`,
      },
    ],
  },
  {
    id: "tree",
    group: "Componentes",
    icon: "⎇",
    title: "Tree",
    description:
      "Expandable hierarchical lists for org structures, reporting lines, and nested navigation.",
    examples: [
      {
        title: "Org-style tree",
        block: true,
        html: String.raw`<ul class="bt-tree" role="tree">
  <li class="bt-tree__item" role="treeitem" aria-expanded="true">
    <div class="bt-tree__row">
      <div class="bt-tree__toggle-col">
        <button type="button" class="bt-tree__toggle" aria-expanded="true" aria-label="Toggle branch">
          <span class="bt-tree__chevron bt-tree__chevron--open">›</span>
        </button>
      </div>
      <div class="bt-tree__body">
        <div class="bt-tree__label-row">
          <span class="bt-tree__kind">BU</span>
          <span class="bt-tree__name">Technology</span>
          <span class="bt-tree__meta">· Alex Rivera</span>
        </div>
        <ul class="bt-tree bt-tree--nested" role="tree">
          <li class="bt-tree__item" role="treeitem" aria-expanded="true">
            <div class="bt-tree__row">
              <div class="bt-tree__toggle-col">
                <button type="button" class="bt-tree__toggle" aria-expanded="true" aria-label="Toggle branch">
                  <span class="bt-tree__chevron bt-tree__chevron--open">›</span>
                </button>
              </div>
              <div class="bt-tree__body">
                <div class="bt-tree__label-row">
                  <span class="bt-tree__kind">Cluster</span>
                  <span class="bt-tree__name">EMEA</span>
                </div>
                <ul class="bt-tree bt-tree--nested" role="tree">
                  <li class="bt-tree__item" role="treeitem" aria-expanded="false">
                    <div class="bt-tree__row">
                      <div class="bt-tree__toggle-col">
                        <span class="bt-tree__toggle-spacer" aria-hidden="true"></span>
                      </div>
                      <div class="bt-tree__body">
                        <div class="bt-tree__label-row">
                          <span class="bt-tree__kind">Project</span>
                          <span class="bt-tree__name">Portal Redesign</span>
                          <span class="bt-tree__doc">P-1042</span>
                        </div>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </li>
</ul>`,
      },
      {
        title: "Empty state",
        html: String.raw`<div class="bt-tree-empty">No nodes match your search.</div>`,
      },
    ],
  },
  {
    id: "lists",
    group: "Componentes",
    icon: "☷",
    title: "Lists",
    description: "Listados verticales con avatar, contenido y acciones.",
    examples: [
      {
        title: "List",
        block: true,
        html: String.raw`<div class="bt-list">
  <div class="bt-list-item">
    <div class="bt-list-item__avatar">B</div>
    <div class="bt-list-item__content">
      <p class="bt-list-item__title">Bluetab Design System</p>
      <p class="bt-list-item__subtitle">Componente de listado</p>
    </div>
    <button class="bt-icon-button" aria-label="Más"><span class="bt-icon">⋯</span></button>
  </div>
  <div class="bt-list-item">
    <div class="bt-list-item__avatar">D</div>
    <div class="bt-list-item__content">
      <p class="bt-list-item__title">Data Product</p>
      <p class="bt-list-item__subtitle">Elemento secundario</p>
    </div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "main-layout",
    group: "Layout",
    icon: "▨",
    title: "Main layout",
    description: "Composición principal de aplicación/documentación.",
    examples: [
      {
        title: "Dashboard layout",
        block: true,
        html: String.raw`<div class="bt-card bt-card--filled">
  <div class="bt-appbar">
    <strong>Dashboard</strong>
    <span class="bt-spacer"></span>
    <button class="bt-button bt-button--secondary">Exportar</button>
  </div>
  <div class="bt-layout-demo" style="margin-top: var(--bt-space-4);">
    <div>KPI</div><div>Chart</div><div>Table</div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "media",
    group: "Componentes",
    icon: "◫",
    title: "Media",
    description: "Imágenes, vídeos o placeholders responsivos.",
    examples: [
      {
        title: "Media placeholder",
        block: true,
        html: String.raw`<figure class="bt-card">
  <div class="bt-card__media"></div>
  <figcaption class="bt-muted">Media responsivo dentro de una card.</figcaption>
</figure>`,
      },
      {
        title: "Avatar media",
        html: String.raw`<div class="bt-list-item__avatar">BT</div>
<div class="bt-list-item__avatar" style="background: var(--bt-color-secondary-soft); color: var(--bt-color-secondary-hover);">UX</div>`,
      },
    ],
  },
  {
    id: "menus",
    group: "Componentes",
    icon: "⋮",
    title: "Menus",
    description: "Menús contextuales activados por botón.",
    examples: [
      {
        title: "Context menu",
        html: String.raw`<div class="bt-menu-wrap">
  <button class="bt-button bt-button--secondary" data-menu-toggle="menu-basic">Abrir menú</button>
  <div class="bt-menu" id="menu-basic" role="menu">
    <button type="button" role="menuitem">Editar</button>
    <button type="button" role="menuitem">Duplicar</button>
    <button type="button" role="menuitem">Eliminar</button>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "navigation",
    group: "Componentes",
    icon: "☰",
    title: "Navigation",
    description: "Sidebar, enlaces activos y navegación inferior.",
    examples: [
      {
        title: "Sidebar nav links",
        block: true,
        html: String.raw`<nav class="bt-sidebar__nav" style="width: 16rem;">
  <a class="bt-nav-link" aria-current="page" href="#"><span class="bt-icon">⌂</span> Inicio</a>
  <a class="bt-nav-link" href="#"><span class="bt-icon">▣</span> Componentes</a>
  <a class="bt-nav-link" href="#"><span class="bt-icon">⚙</span> Ajustes</a>
</nav>`,
      },
      {
        title: "Bottom navigation",
        block: true,
        html: String.raw`<nav class="bt-bottom-nav">
  <a href="#" aria-current="page"><span class="bt-icon">⌂</span><span>Home</span></a>
  <a href="#"><span class="bt-icon">⌕</span><span>Search</span></a>
  <a href="#"><span class="bt-icon">◎</span><span>Profile</span></a>
</nav>`,
      },
    ],
  },
  {
    id: "overlays",
    group: "Componentes",
    icon: "▩",
    title: "Overlays",
    description:
      "Capas superpuestas para paneles, drawers o estados bloqueantes.",
    examples: [
      {
        title: "Overlay",
        html: String.raw`<button class="bt-button" data-overlay-open="overlay-basic">Abrir overlay</button>
<div class="bt-overlay" id="overlay-basic" role="dialog" aria-modal="true">
  <div class="bt-overlay__surface">
    <h3>Overlay</h3>
    <p>Útil para paneles y contenidos temporales.</p>
    <button class="bt-button" data-overlay-close>Cerrar</button>
  </div>
</div>`,
      },
      {
        title: "Drawer visual",
        block: true,
        html: String.raw`<div class="bt-drawer-demo">
  <aside class="bt-drawer-demo__panel">
    <strong>Drawer</strong>
    <p>Panel lateral.</p>
  </aside>
</div>`,
      },
    ],
  },
  {
    id: "pages",
    group: "Layout",
    icon: "□",
    title: "Pages",
    description: "Patrón simple de páginas internas SPA.",
    examples: [
      {
        title: "Page sections",
        block: true,
        html: String.raw`<section class="bt-section" id="overview-page">
  <div class="bt-section__header">
    <h2 class="bt-section__title">Overview</h2>
  </div>
  <p class="bt-section__description">Contenido de página.</p>
</section>`,
      },
      {
        title: "Page link",
        html: String.raw`<a class="bt-nav-link" href="#components" aria-current="page">
  <span class="bt-icon">▣</span>
  Componentes
</a>`,
      },
    ],
  },
  {
    id: "progress",
    group: "Feedback",
    icon: "◔",
    title: "Progress",
    description: "Indicadores de progreso lineales y circulares.",
    examples: [
      {
        title: "Linear progress",
        html: String.raw`<div class="bt-progress" aria-label="Progreso al 68%">
  <div class="bt-progress__bar" style="--value: 68%"></div>
</div>`,
      },
      {
        title: "Circular progress",
        html: String.raw`<div class="bt-progress-circle" style="--value: 72%" data-label="72%"></div>`,
      },
    ],
  },
  {
    id: "radio",
    group: "Formularios",
    icon: "◉",
    title: "Radio buttons",
    description: "Selección única entre varias opciones.",
    examples: [
      {
        title: "Radio group",
        html: String.raw`<label class="bt-radio">
  <input type="radio" name="view" checked />
  <span>Semanal</span>
</label>
<label class="bt-radio">
  <input type="radio" name="view" />
  <span>Mensual</span>
</label>
<label class="bt-radio">
  <input type="radio" name="view" />
  <span>Anual</span>
</label>`,
      },
    ],
  },
  {
    id: "selects",
    group: "Formularios",
    icon: "⌄",
    title: "Selects",
    description: "Selectores nativos estilizados para formularios.",
    examples: [
      {
        title: "Select básico",
        html: String.raw`<div class="bt-field">
  <label for="framework-select">Framework</label>
  <select class="bt-select" id="framework-select">
    <option>Bluetab DS</option>
    <option>Material Design</option>
    <option>Carbon</option>
  </select>
</div>`,
      },
      {
        title: "Select con ayuda",
        html: String.raw`<div class="bt-field">
  <label for="status-select">Estado</label>
  <select class="bt-select" id="status-select">
    <option>Activo</option>
    <option>Pendiente</option>
    <option>Archivado</option>
  </select>
  <small class="bt-help">Este valor afecta a la visibilidad.</small>
</div>`,
      },
    ],
  },
  {
    id: "shapes",
    group: "Foundations",
    icon: "◯",
    title: "Shapes",
    description: "Formas y radios reutilizables.",
    examples: [
      {
        title: "Shapes",
        html: String.raw`<div class="bt-center bt-shape-circle" style="width:5rem; background:var(--bt-color-primary-soft); color:var(--bt-color-primary);">Circle</div>
<div class="bt-center bt-shape-soft" style="width:7rem; height:5rem; background:var(--bt-color-secondary-soft); color:var(--bt-color-secondary-hover);">Soft</div>
<div class="bt-center bt-shape-blob" style="width:7rem; height:5rem; background:var(--bt-color-tertiary-soft); color:var(--bt-color-tertiary);">Blob</div>`,
      },
    ],
  },
  {
    id: "sliders",
    group: "Formularios",
    icon: "━",
    title: "Sliders",
    description: "Control para seleccionar valores dentro de un rango.",
    examples: [
      {
        title: "Slider básico",
        html: String.raw`<input class="bt-slider" type="range" min="0" max="100" value="64" aria-label="Porcentaje" />`,
      },
      {
        title: "Slider con label",
        html: String.raw`<div class="bt-field">
  <label for="quality-slider">Calidad</label>
  <input class="bt-slider" id="quality-slider" type="range" min="0" max="100" value="80" />
  <small class="bt-help">Arrastra para ajustar el valor.</small>
</div>`,
      },
    ],
  },
  {
    id: "snackbars",
    group: "Feedback",
    icon: "▤",
    title: "Snackbars",
    description: "Mensajes temporales para confirmar una acción.",
    examples: [
      {
        title: "Snackbar",
        html: String.raw`<button class="bt-button" data-snackbar-open="snackbar-basic">Mostrar snackbar</button>
<div class="bt-snackbar" id="snackbar-basic">
  <span>Elemento guardado correctamente.</span>
  <button class="bt-button bt-button--ghost" data-snackbar-close>Cerrar</button>
</div>`,
      },
    ],
  },
  {
    id: "switches",
    group: "Formularios",
    icon: "◐",
    title: "Switches",
    description: "Activación o desactivación de opciones binarias.",
    examples: [
      {
        title: "Switch básico",
        html: String.raw`<label class="bt-switch">
  <input type="checkbox" checked />
  <span class="bt-switch__track"></span>
  <span>Modo activo</span>
</label>`,
      },
      {
        title: "Switch off",
        html: String.raw`<label class="bt-switch">
  <input type="checkbox" />
  <span class="bt-switch__track"></span>
  <span>Notificaciones</span>
</label>`,
      },
    ],
  },
  {
    id: "tables",
    group: "Componentes",
    icon: "▦",
    title: "Tables",
    description: "Tablas responsivas para datos de negocio y documentación.",
    examples: [
      {
        title: "Data table",
        block: true,
        html: String.raw`<div class="bt-table-wrap">
  <table class="bt-table">
    <thead>
      <tr><th>Componente</th><th>Estado</th><th>Uso</th></tr>
    </thead>
    <tbody>
      <tr><td>Button</td><td><span class="bt-status bt-status--success">Activo</span></td><td>Acciones</td></tr>
      <tr><td>Dialog</td><td><span class="bt-status bt-status--warning">Revisar</span></td><td>Modales</td></tr>
      <tr><td>Table</td><td><span class="bt-status bt-status--success">Activo</span></td><td>Datos</td></tr>
    </tbody>
  </table>
</div>`,
      },
    ],
  },
  {
    id: "tabs",
    group: "Componentes",
    icon: "☰",
    title: "Tabs",
    description:
      "Organización de contenido por pestañas dentro de una misma vista.",
    examples: [
      {
        title: "Tabs",
        block: true,
        html: String.raw`<div data-tabs>
  <div class="bt-tabs" role="tablist">
    <button class="bt-tab" role="tab" aria-selected="true" data-tab="tab-1">Overview</button>
    <button class="bt-tab" role="tab" aria-selected="false" data-tab="tab-2">Details</button>
    <button class="bt-tab" role="tab" aria-selected="false" data-tab="tab-3">Settings</button>
  </div>
  <div class="bt-tab-panel" id="tab-1" role="tabpanel" aria-hidden="false">Contenido overview.</div>
  <div class="bt-tab-panel" id="tab-2" role="tabpanel" aria-hidden="true">Contenido details.</div>
  <div class="bt-tab-panel" id="tab-3" role="tabpanel" aria-hidden="true">Contenido settings.</div>
</div>`,
      },
    ],
  },
  {
    id: "textarea",
    group: "Formularios",
    icon: "▤",
    title: "Textarea",
    description: "Entrada de texto multilínea.",
    examples: [
      {
        title: "Textarea básico",
        html: String.raw`<div class="bt-field">
  <label for="notes-textarea">Notas</label>
  <textarea class="bt-textarea" id="notes-textarea" placeholder="Escribe una descripción"></textarea>
</div>`,
      },
      {
        title: "Textarea con ayuda",
        html: String.raw`<div class="bt-field">
  <label for="description-textarea">Descripción</label>
  <textarea class="bt-textarea" id="description-textarea">Texto de ejemplo para documentación.</textarea>
  <small class="bt-help">Máximo recomendado: 240 caracteres.</small>
</div>`,
      },
    ],
  },
  {
    id: "tooltips",
    group: "Feedback",
    icon: "?",
    title: "Tooltips",
    description: "Ayuda contextual breve al pasar el cursor o enfocar.",
    examples: [
      {
        title: "Tooltip en botón",
        html: String.raw`<span class="bt-tooltip" data-tooltip="Crear nuevo elemento">
  <button class="bt-icon-button" aria-label="Crear"><span class="bt-icon">＋</span></button>
</span>`,
      },
      {
        title: "Tooltip en texto",
        html: String.raw`<span class="bt-tooltip" data-tooltip="Información adicional">
  <span class="bt-status bt-status--info">Hover me</span>
</span>`,
      },
    ],
  },
  {
    id: "typography",
    group: "Foundations",
    icon: "T",
    title: "Typography",
    description: "Escala tipográfica editable desde tokens CSS.",
    examples: [
      {
        title: "Headings",
        block: true,
        html: String.raw`<div class="bt-stack">
  <h1>Heading 1</h1>
  <h2>Heading 2</h2>
  <h3>Heading 3</h3>
  <p class="bt-lead">Lead paragraph para introducciones importantes.</p>
  <p>Texto base para contenidos habituales de producto y documentación.</p>
</div>`,
      },
      {
        title: "Eyebrow and muted text",
        block: true,
        html: String.raw`<p class="bt-eyebrow">Bluetab label</p>
<h3>Contenido destacado</h3>
<p class="bt-muted">Texto secundario con menor énfasis visual.</p>`,
      },
    ],
  },
];

export const GROUP_ORDER = [
  "Inicio",
  "Foundations",
  "Layout",
  "Componentes",
  "Formularios",
  "Feedback",
];
