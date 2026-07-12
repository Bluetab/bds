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
    group: "Home",
    icon: "<>",
    title: "Get started",
    description:
      "Base HTML, CSS y JavaScript para crear un Design System Bluetab propio.",
    intro: true,
    examples: [
      {
        title: "Recommended structure",
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
        title: "Sample Bluetab button",
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
    group: "Components",
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
    id: "avatars",
    group: "Components",
    icon: "◎",
    title: "Avatars",
    description:
      "Identidad de persona con foto o iniciales. Compact muestra nombre; expanded añade email.",
    examples: [
      {
        title: "Compact",
        html: String.raw`<div class="bt-avatar bt-avatar--compact">
  <div class="bt-avatar__media"><span>AR</span></div>
  <div class="bt-avatar__text">
    <p class="bt-avatar__name">Alejandro Ramos</p>
    <p class="bt-avatar__email">alejandro.ramos@example.com</p>
  </div>
</div>`,
      },
      {
        title: "Expanded",
        html: String.raw`<div class="bt-avatar bt-avatar--expanded">
  <div class="bt-avatar__media"><span>ML</span></div>
  <div class="bt-avatar__text">
    <p class="bt-avatar__name">María López</p>
    <p class="bt-avatar__email">maria.lopez@example.com</p>
  </div>
</div>`,
      },
      {
        title: "With image",
        block: true,
        html: String.raw`<div class="bt-stack" style="gap: var(--bt-space-3);">
  <div class="bt-avatar bt-avatar--compact">
    <div class="bt-avatar__media">
      <img class="bt-avatar__image" src="https://i.pravatar.cc/96?u=compact" alt="" />
    </div>
    <div class="bt-avatar__text">
      <p class="bt-avatar__name">Jordan Kim</p>
      <p class="bt-avatar__email">jordan.kim@example.com</p>
    </div>
  </div>
  <div class="bt-avatar bt-avatar--expanded">
    <div class="bt-avatar__media">
      <img class="bt-avatar__image" src="https://i.pravatar.cc/128?u=expanded" alt="" />
    </div>
    <div class="bt-avatar__text">
      <p class="bt-avatar__name">Jordan Kim</p>
      <p class="bt-avatar__email">jordan.kim@example.com</p>
    </div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "badges",
    group: "Components",
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
        title: "Badge with number",
        html: String.raw`<span class="bt-badge-wrap">
  <span class="bt-icon">⌂</span>
  <span class="bt-badge">10</span>
</span>`,
      },
      {
        title: "Inline badge",
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
    group: "Components",
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
    group: "Components",
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
    group: "Forms",
    icon: "☑",
    title: "Checkboxes",
    description:
      "Selección múltiple en formularios, filtros y configuraciones.",
    examples: [
      {
        title: "Basic checkbox",
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
        title: "Disabled checkbox",
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
    group: "Components",
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
        title: "Inline in prose",
        block: true,
        html: String.raw`<p class="bt-muted">
  Menciona clases con <code class="bt-code-inline">bt-button</code> o rutas con
  <code class="bt-code-inline bt-code-inline--wrap">docs/how-to-use-design-system.md</code>.
</p>`,
      },
      {
        title: "Multiline block",
        block: true,
        html: String.raw`<div class="bt-code-block">
  <pre class="bt-code"><code>@import "bluetab-design-system/styles.css";

import { initBtInteractions } from "bluetab-design-system/interactions";
initBtInteractions();</code></pre>
</div>`,
      },
      {
        title: "Cards in bt-example-grid",
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
    description: "Base palette editable from CSS tokens.",
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
    group: "Components",
    icon: "□",
    title: "Dialogs",
    description:
      "Ventanas modales para confirmaciones, mensajes críticos o acciones bloqueantes.",
    examples: [
      {
        title: "Basic dialog",
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
    group: "Components",
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
    group: "Forms",
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
    group: "Forms",
    icon: "▭",
    title: "Fields / Inputs",
    description: "Text fields, help text, and error states.",
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
    description: "Utility classes for quick layout composition.",
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
    description: "Main shell, topbar, sidebar, and content areas.",
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
  <header class="bt-site-header bt-topbar">
    <nav class="bt-nav" aria-label="Main">
      <div class="bt-nav__inner">
        <div class="bt-nav__brand">
          <a href="#" class="bt-navbar-logo-link" onclick="return false;">
            <img src="/images/logo-bluetab.svg" alt="Bluetab" class="bt-navbar-logo-img" />
          </a>
        </div>
        <div class="bt-nav__actions">
          <button type="button" class="bt-theme-toggle-button" data-theme-toggle aria-label="Tema">
            <span class="bt-icon" data-theme-icon>◐</span>
          </button>
        </div>
      </div>
    </nav>
  </header>
  <main class="bt-main">Contenido principal</main>
</div>`,
      },
      {
        title: "App shell with user menu",
        block: true,
        html: String.raw`<div class="bt-shell bt-shell--app">
  <header class="bt-site-header bt-topbar">
    <nav class="bt-nav" aria-label="Main">
      <div class="bt-nav__inner">
        <div class="bt-nav__brand">
          <a href="#" class="bt-navbar-logo-link" onclick="return false;">
            <img src="/images/logo-bluetab.svg" alt="Bluetab" class="bt-navbar-logo-img" />
          </a>
        </div>
        <div class="bt-nav__actions">
          <div class="bt-navbar-user" tabindex="-1">
          <div class="bt-navbar-user__trigger bt-navbar-user__trigger--compact" role="button" aria-haspopup="menu" tabindex="0">
            <div class="bt-navbar-user__meta">
              <div class="bt-navbar-user__name">Alex Rivera</div>
            </div>
            <div class="bt-navbar-user__avatar-wrap">
              <div class="bt-navbar-user__avatar bt-navbar-user__avatar--initials" aria-hidden="true">AR</div>
              <span class="bt-navbar-user__status" aria-hidden="true"></span>
            </div>
            <span class="bt-navbar-user__chevron" aria-hidden="true">▾</span>
          </div>
          <div class="bt-navbar-user__dropdown" role="menu">
            <div class="bt-navbar-user__dropdown-header">
              <div class="bt-avatar bt-avatar--expanded">
                <div class="bt-avatar__media" aria-hidden="true"><span>AR</span></div>
                <div class="bt-avatar__text">
                  <p class="bt-avatar__name">Alex Rivera</p>
                  <p class="bt-avatar__email">alex.rivera@example.com</p>
                </div>
              </div>
            </div>
            <div class="bt-navbar-user__dropdown-prefs" role="group" aria-label="Preferences">
              <button type="button" class="bt-navbar-menu-item bt-navbar-menu-item--toggle" aria-label="Toggle language">
                <span class="bt-navbar-menu-item__label">Language</span>
                <span class="bt-navbar-menu-item__value">Spanish</span>
              </button>
              <button type="button" class="bt-navbar-menu-item bt-navbar-menu-item--toggle" data-theme-toggle aria-label="Toggle theme">
                <span class="bt-navbar-menu-item__label">Theme</span>
                <span data-theme-value data-light="Light" data-dark="Dark" class="bt-navbar-menu-item__value">Light</span>
              </button>
            </div>
            <div class="bt-navbar-menu-divider"></div>
            <a href="#" class="bt-navbar-menu-item bt-navbar-menu-item--danger" onclick="return false;">Log out</a>
          </div>
        </div>
      </div>
    </nav>
  </header>
  <main class="bt-main">Main content</main>
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
    group: "Components",
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
    id: "calendar-day",
    group: "Components",
    icon: "▦",
    title: "Calendar day",
    description:
      "Month grid day card with status accent, day number, and optional project lines.",
    examples: [
      {
        title: "Imputed day with projects",
        html: String.raw`<button type="button" class="bt-calendar-day bt-calendar-day--imputado" style="width: 10rem; height: 8rem;">
  <span class="bt-calendar-day__number">12</span>
  <div class="bt-calendar-day__content">
    <div class="bt-calendar-day__projects">
      <div class="bt-calendar-day__project bt-calendar-day__project--aprobado">
        <span class="bt-calendar-day__project-status" title="Approved" aria-label="Approved"></span>
        <span class="bt-calendar-day__project-name">Proyecto A</span>
        <span class="bt-calendar-day__project-hours">4h</span>
      </div>
      <div class="bt-calendar-day__project bt-calendar-day__project--liberado">
        <span class="bt-calendar-day__project-status" title="Sent" aria-label="Sent"></span>
        <span class="bt-calendar-day__project-name">Proyecto B</span>
        <span class="bt-calendar-day__project-hours">4h</span>
      </div>
    </div>
  </div>
</button>`,
      },
      {
        title: "Status variants",
        html: String.raw`<div class="bt-stack" style="flex-flow: row wrap; gap: var(--bt-space-2);">
  <button type="button" class="bt-calendar-day bt-calendar-day--nuevo" style="width: 5rem; height: 5rem;"><span class="bt-calendar-day__number">1</span></button>
  <button type="button" class="bt-calendar-day bt-calendar-day--completado" style="width: 5rem; height: 5rem;"><span class="bt-calendar-day__number">2</span></button>
  <button type="button" class="bt-calendar-day bt-calendar-day--invalid" style="width: 5rem; height: 5rem;"><span class="bt-calendar-day__number">3</span></button>
  <button type="button" class="bt-calendar-day bt-calendar-day--aprobado" style="width: 5rem; height: 5rem;"><span class="bt-calendar-day__number">4</span></button>
  <button type="button" class="bt-calendar-day bt-calendar-day--festivo" style="width: 5rem; height: 5rem;"><span class="bt-calendar-day__number">5</span></button>
</div>`,
      },
    ],
  },
  {
    id: "calendar-toolbar",
    group: "Components",
    icon: "▦",
    title: "Calendar toolbar",
    description: "Month navigation and calendar controls above the weekday row.",
    examples: [
      {
        title: "Toolbar",
        block: true,
        html: String.raw`<div class="bt-calendar-toolbar">
  <div class="bt-calendar-toolbar__row">
    <div><button type="button" class="bt-icon-button" aria-label="Templates"><span class="bt-icon">▥</span></button></div>
    <div style="display: flex; align-items: center; gap: 0.5rem;">
      <button type="button" class="bt-icon-button" aria-label="Previous">‹</button>
      <span class="bt-calendar-toolbar__month">June 2026</span>
      <button type="button" class="bt-icon-button" aria-label="Next">›</button>
    </div>
    <div style="display: flex; justify-content: flex-end;"><button type="button" class="bt-icon-button" aria-label="Today">◎</button></div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "calendar-weekdays",
    group: "Components",
    icon: "▦",
    title: "Calendar weekdays",
    description: "Weekday header row aligned to the month grid columns.",
    examples: [
      {
        title: "Weekdays with weekends",
        block: true,
        html: String.raw`<div class="bt-calendar-weekdays">
  <div class="bt-calendar-weekdays__grid" style="grid-template-columns: repeat(5, minmax(0, 5fr)) repeat(2, minmax(0, 1fr));">
    <span class="bt-calendar-weekdays__label">MON</span>
    <span class="bt-calendar-weekdays__label">TUE</span>
    <span class="bt-calendar-weekdays__label">WED</span>
    <span class="bt-calendar-weekdays__label">THU</span>
    <span class="bt-calendar-weekdays__label">FRI</span>
    <span class="bt-calendar-weekdays__label bt-calendar-weekdays__label--weekend">SAT</span>
    <span class="bt-calendar-weekdays__label bt-calendar-weekdays__label--weekend">SUN</span>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "calendar-legend",
    group: "Components",
    icon: "▦",
    title: "Calendar legend",
    description: "Footer legend for timesheet day statuses and counts.",
    examples: [
      {
        title: "Legend",
        block: true,
        html: String.raw`<footer class="bt-calendar-legend" aria-label="Calendar status legend">
  <ul class="bt-calendar-legend__list" role="list">
    <li class="bt-calendar-legend__item">
      <span class="bt-calendar-legend__icon bt-calendar-legend__icon--imputado">◐</span>
      <span>Draft</span>
      <span class="font-semibold tabular-nums">6</span>
    </li>
    <li class="bt-calendar-legend__item">
      <span class="bt-calendar-legend__icon bt-calendar-legend__icon--completado">●</span>
      <span>Complete</span>
      <span class="font-semibold tabular-nums">5</span>
    </li>
    <li class="bt-calendar-legend__item">
      <span class="bt-calendar-legend__icon bt-calendar-legend__icon--aprobado">✓</span>
      <span>Approved</span>
      <span class="font-semibold tabular-nums">2</span>
    </li>
  </ul>
</footer>`,
      },
    ],
  },
  {
    id: "calendar-template",
    group: "Components",
    icon: "▦",
    title: "Calendar template",
    description: "Template shortcut card for the timesheet sidebar.",
    examples: [
      {
        title: "Template card",
        html: String.raw`<article class="bt-calendar-template-card">
  <div class="bt-calendar-template-card__row">
    <span class="bt-calendar-template-card__key">1</span>
    <div style="min-width: 0; flex: 1;">
      <p class="bt-calendar-template-card__name">Acme — billable</p>
      <div class="bt-calendar-day__projects">
        <div class="bt-calendar-day__project">
          <span class="bt-calendar-day__project-name">PX-1024 · Platform rollout</span>
          <span class="bt-calendar-day__project-hours">8h</span>
        </div>
      </div>
    </div>
  </div>
</article>`,
      },
    ],
  },
  {
    id: "calendar-shell",
    group: "Components",
    icon: "▦",
    title: "Calendar shell",
    description:
      "Composed Tempo-style month view: templates sidebar, toolbar, weekday row, grid, and legend.",
    examples: [
      {
        title: "Month view (static)",
        block: true,
        html: String.raw`<div class="bt-calendar-shell bt-calendar-shell--sidebar-open" data-sidebar-open="true" style="min-height: 24rem;">
  <div class="bt-calendar-shell__toolbar">
    <div class="bt-calendar-toolbar">
      <div class="bt-calendar-toolbar__row">
        <div><button type="button" class="bt-icon-button"><span class="bt-icon">▥</span></button></div>
        <div><span class="bt-calendar-toolbar__month">June 2026</span></div>
        <div></div>
      </div>
    </div>
    <div class="bt-calendar-weekdays">
      <div class="bt-calendar-weekdays__grid" style="grid-template-columns: repeat(5, 1fr) repeat(2, 0.5fr);">
        <span class="bt-calendar-weekdays__label">MON</span><span class="bt-calendar-weekdays__label">TUE</span><span class="bt-calendar-weekdays__label">WED</span><span class="bt-calendar-weekdays__label">THU</span><span class="bt-calendar-weekdays__label">FRI</span>        <span class="bt-calendar-weekdays__label bt-calendar-weekdays__label--weekend">SAT</span><span class="bt-calendar-weekdays__label bt-calendar-weekdays__label--weekend">SUN</span>
      </div>
    </div>
  </div>
  <div class="bt-calendar-shell__workspace">
  <aside class="bt-calendar-shell__sidebar">
    <div class="bt-calendar-templates h-full min-h-0 flex flex-col">
      <div class="bt-calendar-templates__header"><span>Templates</span></div>
      <div class="bt-calendar-templates__body">
        <article class="bt-calendar-template-card">
          <div class="bt-calendar-template-card__row">
            <span class="bt-calendar-template-card__key">1</span>
            <div style="min-width:0;flex:1"><p class="bt-calendar-template-card__name">Acme — billable</p></div>
          </div>
        </article>
      </div>
    </div>
  </aside>
  <div class="bt-calendar-shell__main">
    <div class="bt-calendar-shell__body">
    <div class="bt-calendar-month-grid" style="grid-template-columns: repeat(5, 1fr) repeat(2, 0.5fr); grid-auto-rows: minmax(5rem, 1fr); min-height: 12rem; width: 100%;">
      <div class="bt-calendar-month-grid__cell"><button type="button" class="bt-calendar-day bt-calendar-day--imputado" style="height:100%"><span class="bt-calendar-day__number">2</span></button></div>
      <div class="bt-calendar-month-grid__cell"><button type="button" class="bt-calendar-day bt-calendar-day--completado" style="height:100%"><span class="bt-calendar-day__number">3</span></button></div>
      <div class="bt-calendar-month-grid__cell"><button type="button" class="bt-calendar-day bt-calendar-day--aprobado" style="height:100%"><span class="bt-calendar-day__number">4</span></button></div>
      <div class="bt-calendar-month-grid__cell"><button type="button" class="bt-calendar-day bt-calendar-day--nuevo" style="height:100%"><span class="bt-calendar-day__number">5</span></button></div>
      <div class="bt-calendar-month-grid__cell"><button type="button" class="bt-calendar-day bt-calendar-day--festivo" style="height:100%"><span class="bt-calendar-day__number">9</span></button></div>
    </div>
    </div>
    <footer class="bt-calendar-legend">
      <ul class="bt-calendar-legend__list">
        <li class="bt-calendar-legend__item"><span class="bt-calendar-legend__icon bt-calendar-legend__icon--imputado">◐</span><span>Draft</span><span>6</span></li>
        <li class="bt-calendar-legend__item"><span class="bt-calendar-legend__icon bt-calendar-legend__icon--aprobado">✓</span><span>Approved</span><span>2</span></li>
      </ul>
    </footer>
  </div>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "calendar-day-modal",
    group: "Components",
    icon: "▣",
    title: "Calendar day modal",
    description: "Glass day editor opened from a calendar cell — hours summary, entries list, and actions.",
    examples: [
      {
        title: "Draft day with entries",
        block: true,
        html: String.raw`<div class="bt-calendar-day-modal" data-testid="calendar-day-modal" style="position: relative; inset: auto; min-height: 22rem;">
  <div class="bt-calendar-day-modal__panel" style="position: relative;">
    <button type="button" class="bt-icon-button bt-calendar-day-modal__nav bt-calendar-day-modal__nav--prev" aria-label="Previous day"><span class="bt-icon" aria-hidden="true">‹</span></button>
    <div class="bt-calendar-day-modal__shell bt-calendar-day-modal__shell--completado">
      <aside class="bt-calendar-day-modal__aside">
        <div class="bt-calendar-day-modal__aside-top">
          <p class="bt-calendar-day-modal__day-number">12</p>
          <div class="bt-calendar-day-modal__day-meta">
            <p class="bt-calendar-day-modal__weekday">Thu</p><p class="bt-calendar-day-modal__month">June 2026</p>
          </div>
        </div>
        <div class="bt-calendar-day-modal__aside-bottom bt-calendar-day-modal__aside-bottom--reached">
          <div class="bt-calendar-day-modal__hours"><span class="bt-calendar-day-modal__hours-value">8</span><span class="bt-calendar-day-modal__hours-unit">h</span></div>
          <div class="bt-calendar-day-modal__progress"><div class="bt-calendar-day-modal__progress-fill" style="width: 100%"></div></div>
        </div>
      </aside>
      <section class="bt-calendar-day-modal__content">
        <div class="bt-calendar-day-modal__entries">
          <div class="bt-calendar-day-modal__entries-top">
            <button type="button" class="bt-calendar-day-modal__add bt-button bt-button--secondary bt-button--sm"><span class="bt-icon" aria-hidden="true">+</span> New</button>
          </div>
          <article class="bt-calendar-day-modal__entry">
            <div class="bt-calendar-day-modal__entry-main">
              <div class="bt-calendar-day-modal__entry-heading">
                <p class="bt-calendar-day-modal__entry-project">Proyecto A</p>
                <span class="bt-calendar-day-modal__entry-status bt-calendar-day-modal__entry-status--aprobado"><span class="bt-calendar-day-modal__entry-status-icon" aria-hidden="true">✓</span> Approved</span>
              </div>
              <p class="bt-calendar-day-modal__entry-type">Development</p>
            </div>
            <span class="bt-calendar-day-modal__entry-hours bt-calendar-day-modal__entry-hours--aprobado">4h</span>
            <div class="bt-calendar-day-modal__entry-actions">
              <button type="button" class="bt-icon-button bt-calendar-day-modal__entry-action" aria-label="Edit entry"><svg class="bt-calendar-day-modal__entry-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"/></svg></button>
              <button type="button" class="bt-icon-button bt-calendar-day-modal__entry-action" aria-label="Delete entry"><svg class="bt-calendar-day-modal__entry-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg></button>
            </div>
          </article>
          <article class="bt-calendar-day-modal__entry">
            <div class="bt-calendar-day-modal__entry-main">
              <div class="bt-calendar-day-modal__entry-heading">
                <p class="bt-calendar-day-modal__entry-project">Proyecto B</p>
                <span class="bt-calendar-day-modal__entry-status bt-calendar-day-modal__entry-status--liberado"><span class="bt-calendar-day-modal__entry-status-icon" aria-hidden="true">↑</span> Sent</span>
              </div>
              <p class="bt-calendar-day-modal__entry-type">Development</p>
            </div>
            <span class="bt-calendar-day-modal__entry-hours bt-calendar-day-modal__entry-hours--liberado">4h</span>
            <div class="bt-calendar-day-modal__entry-actions">
              <button type="button" class="bt-icon-button bt-calendar-day-modal__entry-action" aria-label="Edit entry"><svg class="bt-calendar-day-modal__entry-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"/></svg></button>
              <button type="button" class="bt-icon-button bt-calendar-day-modal__entry-action" aria-label="Delete entry"><svg class="bt-calendar-day-modal__entry-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg></button>
            </div>
          </article>
        </div>
        <div class="bt-calendar-day-modal__footer">
          <button type="button" class="bt-button bt-button--ghost bt-button--sm">Close</button>
        </div>
      </section>
    </div>
    <button type="button" class="bt-icon-button bt-calendar-day-modal__nav bt-calendar-day-modal__nav--next" aria-label="Next day"><span class="bt-icon" aria-hidden="true">›</span></button>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "performance-evaluator",
    group: "Components",
    icon: "◎",
    title: "Performance evaluator",
    description: "Evaluator identity card for Me and user profile workspaces.",
    examples: [
      {
        title: "Evaluator card",
        block: true,
        html: String.raw`<section class="bt-stack" style="gap: var(--bt-space-4);">
  <h2 class="bt-performance-section-title">Your evaluator</h2>
  <article class="bt-performance-card bt-performance-evaluator">
    <div class="bt-performance-evaluator__row">
      <img src="https://www.gravatar.com/avatar/?d=mp" alt="Morgan Chen" class="bt-performance-evaluator__avatar" />
      <div>
        <p class="bt-performance-evaluator__name">Morgan Chen</p>
        <p class="bt-performance-meta-sub">morgan.chen@example.com</p>
      </div>
    </div>
  </article>
</section>`,
      },
    ],
  },
  {
    id: "performance-hours",
    group: "Components",
    icon: "◷",
    title: "Performance reported hours",
    description: "Compact reported-hours panel with expandable client groups and project rows.",
    examples: [
      {
        title: "Hours panel",
        block: true,
        html: String.raw`<section class="bt-stack" style="gap: var(--bt-space-4);">
  <h2 class="bt-performance-section-title">Reported hours</h2>
  <div class="bt-performance-panel">
    <div class="bt-performance-panel__inner">
      <div class="bt-performance-hours-row">
        <button type="button" class="bt-performance-hours-toggle"><span class="bt-icon">▸</span><span>Acme Corp · Digital</span></button>
        <span class="bt-performance-hours-pill">128.5h</span>
      </div>
      <div class="bt-performance-hours-row">
        <button type="button" class="bt-performance-hours-toggle"><span class="bt-icon">▸</span><span>Northwind · SAP</span></button>
        <span class="bt-performance-hours-pill">44h</span>
      </div>
    </div>
  </div>
</section>`,
      },
    ],
  },
  {
    id: "performance-briefing-card",
    group: "Components",
    icon: "📄",
    title: "Performance briefing card",
    description: "Briefing bonded with evaluation: objectives, ratings, acknowledgement, and assessment blocks.",
    examples: [
      {
        title: "Published with evaluation",
        block: true,
        html: String.raw`<article class="bt-performance-card" data-briefing-status="published">
  <header class="bt-performance-card__header">
    <div style="display: grid; gap: var(--bt-space-2);">
      <div class="bt-performance-meta-row">
        <span class="bt-icon">📄</span>
        <span class="bt-performance-meta-row__date">2026-04-08</span>
        <span class="bt-performance-chip">H1 2026</span>
        <span class="bt-performance-ack bt-performance-ack--done"><span class="bt-performance-ack__mark" aria-hidden="true">✓</span><span class="bt-performance-ack__label">Acknowledged</span></span>
      </div>
      <p class="bt-performance-meta-sub">Created by Morgan Chen</p>
    </div>
    <div class="bt-performance-actions">
      <button type="button" class="bt-button bt-button--outline bt-button--sm">Edit</button>
    </div>
  </header>
  <div class="bt-performance-card__body">
    <p style="margin:0;font-size:var(--bt-font-size-sm);color:var(--bt-color-text-muted);">Own technical direction for the Northwind FI rollout.</p>
    <div class="bt-performance-evaluation">
      <div style="display:flex;justify-content:space-between;gap:var(--bt-space-3);flex-wrap:wrap;">
        <div><div class="bt-performance-meta-row"><span class="bt-icon">✦</span><span class="bt-performance-meta-row__date">2026-04-22</span></div><p class="bt-performance-meta-sub">Evaluated by Morgan Chen</p></div>
        <span class="bt-performance-rating bt-performance-rating--b">B</span>
      </div>
    </div>
  </div>
</article>`,
      },
      {
        title: "Draft briefing",
        html: String.raw`<article class="bt-performance-card bt-performance-card--draft" data-briefing-status="draft">
  <header class="bt-performance-card__header">
    <p class="bt-performance-kicker">Draft · only visible to you</p>
    <div class="bt-performance-meta-row"><span class="bt-icon">📄</span><span class="bt-performance-meta-row__date">2026-05-12</span></div>
  </header>
  <div class="bt-performance-card__body"><p style="margin:0;font-size:var(--bt-font-size-sm);">Lead delivery on the Acme platform migration.</p></div>
</article>`,
      },
    ],
  },
  {
    id: "performance-team-card",
    group: "Components",
    icon: "👥",
    title: "Performance team card",
    description: "Evaluator team row with project hours, briefing status, and optional delegation.",
    examples: [
      {
        title: "Team member with briefing",
        block: true,
        html: String.raw`<article class="bt-performance-card bt-performance-team-card">
  <div class="bt-performance-team-card__main">
    <img src="https://www.gravatar.com/avatar/?d=mp" alt="Sam Okonkwo" class="bt-performance-evaluator__avatar bt-performance-evaluator__avatar--sm" />
    <div class="bt-performance-team-card__identity">
      <div class="bt-performance-team-card__name-row">
        <span class="bt-performance-team-card__name">Sam Okonkwo</span>
        <span class="bt-performance-chip bt-performance-chip--category">Consultant</span>
      </div>
      <div class="bt-performance-team-card__project-row">
        <span class="bt-performance-team-card__project">Acme · Platform migration</span>
        <span class="bt-performance-hours-pill">96h</span>
      </div>
    </div>
  </div>
  <div class="bt-performance-team-card__aside">
    <div class="bt-performance-team-card__briefing">
      <div class="bt-performance-meta-row bt-performance-meta-row--compact">
        <span class="bt-icon">📄</span>
        <span class="bt-performance-meta-row__date">Briefing on 2026-04-01</span>
      </div>
      <div class="bt-performance-team-card__briefing-tags">
        <span class="bt-status bt-status--sm bt-status--info">Published</span>
        <span class="bt-performance-rating bt-performance-rating--compact bt-performance-rating--a">Exceptional</span>
      </div>
    </div>
  </div>
</article>`,
      },
    ],
  },
  {
    id: "lists",
    group: "Components",
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
    description: "Primary application and documentation layout.",
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
    group: "Components",
    icon: "◫",
    title: "Media",
    description: "Responsive images, video, or placeholders.",
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
    group: "Components",
    icon: "⋮",
    title: "Menus",
    description: "Context menus opened from a button.",
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
    group: "Components",
    icon: "☰",
    title: "Navigation",
    description: "Sidebar, active links, and bottom navigation.",
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
    group: "Components",
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
    description: "Simple SPA inner-page pattern.",
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
    group: "Forms",
    icon: "◉",
    title: "Radio buttons",
    description: "Single selection among multiple options.",
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
    group: "Forms",
    icon: "⌄",
    title: "Selects",
    description: "Selectores nativos estilizados para formularios.",
    examples: [
      {
        title: "Basic select",
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
    group: "Forms",
    icon: "━",
    title: "Sliders",
    description: "Control para seleccionar valores dentro de un rango.",
    examples: [
      {
        title: "Basic slider",
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
    description: "Temporary messages to confirm an action.",
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
    group: "Forms",
    icon: "◐",
    title: "Switches",
    description: "Toggle binary options on or off.",
    examples: [
      {
        title: "Basic switch",
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
    group: "Components",
    icon: "▦",
    title: "Tables",
    description: "Responsive tables for product and docs data.",
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
    group: "Components",
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
    group: "Forms",
    icon: "▤",
    title: "Textarea",
    description: "Multiline text input.",
    examples: [
      {
        title: "Basic textarea",
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
        title: "Tooltip on button",
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
    id: "breadcrumb",
    group: "Components",
    icon: "›",
    title: "Breadcrumb",
    description: "Hierarchical navigation trail for nested workspaces.",
    examples: [
      {
        title: "Spend liquidación trail",
        html: String.raw`<nav class="bt-breadcrumb" aria-label="Breadcrumb">
  <span class="bt-breadcrumb__item"><a href="#" class="bt-breadcrumb__link">Liquidaciones</a></span>
  <span class="bt-breadcrumb__sep" aria-hidden="true">›</span>
  <span class="bt-breadcrumb__item"><span class="bt-breadcrumb__current">Trip Madrid Q1</span></span>
</nav>`,
      },
    ],
  },
  {
    id: "empty-state",
    group: "Feedback",
    icon: "○",
    title: "Empty state",
    description: "Centered placeholder when a list or panel has no items.",
    examples: [
      {
        title: "No liquidaciones",
        block: true,
        html: String.raw`<div class="bt-empty">
  <div class="bt-empty__icon" aria-hidden="true">◎</div>
  <h3 class="bt-empty__title">No liquidaciones in this view</h3>
  <p class="bt-empty__description">Create a new liquidación or sync with SAP to refresh the list.</p>
  <div class="bt-empty__actions">
    <button type="button" class="bt-button bt-button--primary">New liquidación</button>
    <button type="button" class="bt-button bt-button--outline">Sync</button>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "stepper",
    group: "Components",
    icon: "①",
    title: "Stepper",
    description: "Wizard progress indicator for multi-step flows.",
    examples: [
      {
        title: "Liquidación wizard",
        html: String.raw`<div>
  <div class="bt-stepper bt-stepper--labeled" role="list" aria-label="Progress">
    <span class="bt-stepper__step bt-stepper__step--complete" role="listitem" aria-label="Project">✓</span>
    <span class="bt-stepper__connector" aria-hidden="true"></span>
    <span class="bt-stepper__step bt-stepper__step--active bt-stepper__step--badge" role="listitem" aria-current="step" aria-label="Details">Details</span>
    <span class="bt-stepper__connector" aria-hidden="true"></span>
    <span class="bt-stepper__step" role="listitem" aria-label="Review">3</span>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "liveview-modal",
    group: "Feedback",
    icon: "▢",
    title: "LiveView modal",
    description: "Backdrop + panel shell for Phoenix LiveView dialogs (`bt-modal`).",
    examples: [
      {
        title: "New liquidación modal",
        block: true,
        html: String.raw`<div class="bt-modal" style="position: relative; inset: auto; min-height: 18rem;">
  <button type="button" class="bt-modal__backdrop" aria-label="Close dialog"></button>
  <div class="bt-modal__panel bt-modal__panel--lg" role="dialog" aria-modal="true">
    <header class="bt-modal__header">
      <div><h2 class="bt-modal__title">New liquidación</h2><p class="bt-modal__subtitle">Complete the expense liquidación details.</p></div>
      <button type="button" class="bt-icon-button" aria-label="Close dialog"><span class="bt-icon">×</span></button>
    </header>
    <div class="bt-modal__body"><p class="bt-muted">Wizard body content goes here.</p></div>
    <footer class="bt-modal__footer">
      <button type="button" class="bt-button bt-button--ghost">Cancel</button>
      <button type="button" class="bt-button bt-button--primary">Continue</button>
    </footer>
  </div>
</div>`,
      },
    ],
  },
  {
    id: "spinner",
    group: "Feedback",
    icon: "◌",
    title: "Spinner",
    description: "Inline loading indicator for async SAP operations.",
    examples: [
      {
        title: "Sizes",
        html: String.raw`<div class="bt-spinner-row">
  <span class="bt-spinner bt-spinner--sm" role="status"></span>
  <span class="bt-spinner" role="status"></span>
  <span class="bt-spinner bt-spinner--lg" role="status"></span>
</div>`,
      },
    ],
  },
  {
    id: "expense-liquidacion-card",
    group: "Components",
    icon: "₪",
    title: "Expense liquidación card",
    description: "List row for Spend liquidaciones with workflow track and project meta.",
    examples: [
      {
        title: "In progress",
        block: true,
        html: String.raw`<article class="bt-expense-liquidacion-card">
  <div class="bt-expense-liquidacion-card__top">
    <div class="bt-expense-workflow" aria-hidden="true">
      <span class="bt-expense-workflow__dot bt-expense-workflow__dot--done"></span>
      <span class="bt-expense-workflow__line"></span>
      <span class="bt-expense-workflow__pill bt-expense-workflow__pill--warning">Pending approval</span>
      <span class="bt-expense-workflow__line"></span>
      <span class="bt-expense-workflow__dot"></span>
    </div>
    <span class="bt-expense-date-chip">2026-03-18</span>
  </div>
  <p class="bt-expense-liquidacion-card__concept">Client workshop travel</p>
  <div class="bt-expense-liquidacion-card__meta">
    <div class="bt-expense-liquidacion-card__project"><span class="bt-icon">📁</span><span>Northwind rollout</span></div>
    <span>3 expenses</span>
  </div>
</article>`,
      },
    ],
  },
  {
    id: "expense-gasto-card",
    group: "Components",
    icon: "🧾",
    title: "Expense gasto card",
    description: "Gasto row inside a liquidación detail with amount and actions.",
    examples: [
      {
        title: "Taxi receipt",
        block: true,
        html: String.raw`<article class="bt-expense-gasto-card">
  <div class="bt-expense-gasto-card__body">
    <div class="bt-expense-gasto-card__head">
      <span class="bt-expense-gasto-card__type">Taxi</span>
      <span class="bt-expense-date-chip">2026-03-17</span>
    </div>
    <div class="bt-expense-gasto-card__row">
      <h3 class="bt-expense-gasto-card__title">Airport to hotel</h3>
      <p class="bt-expense-gasto-card__amount">42.50 <span class="bt-expense-gasto-card__amount-suffix">EUR</span></p>
    </div>
  </div>
</article>`,
      },
    ],
  },
  {
    id: "typography",
    group: "Foundations",
    icon: "T",
    title: "Typography",
    description: "Typography scale driven by CSS tokens.",
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
  "Home",
  "Foundations",
  "Layout",
  "Components",
  "Forms",
  "Feedback",
];
