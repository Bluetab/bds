import "./styles/main.css";
import { COMPONENTS, GROUP_ORDER, snippets } from "./catalog.js";
import { syncThemeLabels } from "./lib/interactions.js";

const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];

const root = $("#component-root");
const nav = $("#sidebar-nav");
const panel = $("[data-doc-panel]");
const panelTitle = $("[data-doc-title]");
const panelBody = $("[data-doc-body]");
const toast = $("[data-toast]");
let currentComponent = COMPONENTS[0];
let activePanelComponent = COMPONENTS[0];
let toastTimer;

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function highlightHtml(value) {
  return escapeHtml(value)
    .replace(/(&lt;\/?)([\w-]+)/g, '$1<span class="bt-code__tag">$2</span>')
    .replace(/\s([\w-:]+)=/g, ' <span class="bt-code__attr">$1</span>=')
    .replace(/(&quot;.*?&quot;)/g, '<span class="bt-code__value">$1</span>');
}

function normalizeSnippet(value) {
  return value.trim().replace(/^\n+|\n+$/g, "");
}

function renderNav() {
  nav.innerHTML = GROUP_ORDER.map((group) => {
    const items = COMPONENTS.filter((component) => component.group === group);
    if (!items.length) return "";
    return `<div class="bt-sidebar__group" data-group="${group}">
      <span class="bt-sidebar__group-title">${group}</span>
      ${items
        .map(
          (
            component,
          ) => `<a class="bt-nav-link" href="#${component.id}" data-nav-link="${component.id}">
        <span class="bt-icon">${component.icon}</span>
        <span>${component.title}</span>
      </a>`,
        )
        .join("")}
    </div>`;
  }).join("");
}

function renderComponent(component) {
  const examples = component.examples
    .map(
      (example, index) => `
    <article class="bt-example ${example.block ? "" : "bt-example--half"}" data-example-card>
      <div class="bt-example__header">
        <div>
          <h3 class="bt-example__title">${example.title}</h3>
          ${example.note ? `<p class="bt-muted">${example.note}</p>` : ""}
        </div>
        <button class="bt-icon-button" type="button" data-copy-example="${component.id}:${index}" aria-label="Copiar código de ${example.title}">
          <span class="bt-icon">&lt;&gt;</span>
        </button>
      </div>
      <div class="bt-example__preview ${example.block ? "bt-example__preview--block" : ""}">${example.html}</div>
    </article>`,
    )
    .join("");

  root.innerHTML = `
    <section class="bt-hero">

      <p class="bt-eyebrow">${component.group}</p>
      <div class="bt-section__header">
        <h1 class="bt-section__title">${component.title} <button class="bt-icon-button" type="button" data-open-panel="${component.id}" aria-label="Ver código de ${component.title}"><span class="bt-icon">&lt;&gt;</span></button></h1>
        <button class="bt-button bt-button--secondary" type="button" data-open-panel="${component.id}">Documentación</button>
      </div>
      <p class="bt-lead">${component.description}</p>
      
      </section>

    <section class="bt-section" id="${component.id}">

      <div class="bt-example-grid">${examples}</div>
    </section>`;

  $$("#sidebar-nav [data-nav-link]").forEach((link) => {
    link.setAttribute(
      "aria-current",
      link.dataset.navLink === component.id ? "page" : "false",
    );
  });

  root.focus({ preventScroll: true });
}

function renderPanel(componentOrMode) {
  if (componentOrMode === "tokens") {
    activePanelComponent = null;
    panelTitle.textContent = "Tokens CSS";
    panelBody.innerHTML = `<article class="bt-doc-card">
      <div class="bt-doc-card__header">
        <h3>Variables principales</h3>
        <button class="bt-button bt-button--secondary" type="button" data-copy-text="${encodeURIComponent(snippets.tokens)}">Copiar</button>
      </div>
      <pre class="bt-code"><code>${highlightHtml(snippets.tokens)}</code></pre>
    </article>`;
    document.body.classList.add("bt-panel-open");
    panel.setAttribute("aria-hidden", "false");
    return;
  }

  const component =
    typeof componentOrMode === "string"
      ? COMPONENTS.find((item) => item.id === componentOrMode)
      : componentOrMode;

  if (!component) return;
  activePanelComponent = component;
  panelTitle.textContent = component.title;
  panelBody.innerHTML = component.examples
    .map((example, index) => {
      const code = normalizeSnippet(example.html);
      return `<article class="bt-doc-card">
      <div class="bt-doc-card__header">
        <div>
          <p class="bt-eyebrow">${component.title}</p>
          <h3>${example.title}</h3>
        </div>
        <button class="bt-button bt-button--secondary" type="button" data-copy-example="${component.id}:${index}">Copiar</button>
      </div>
      <div class="bt-doc-card__preview ${example.block ? "bt-doc-card__preview--block" : ""}">${example.html}</div>
      <pre class="bt-code"><code>${highlightHtml(code)}</code></pre>
    </article>`;
    })
    .join("");

  document.body.classList.add("bt-panel-open");
  panel.setAttribute("aria-hidden", "false");
}

function closePanel() {
  document.body.classList.remove("bt-panel-open");
  panel.setAttribute("aria-hidden", "true");
}

async function copyText(value) {
  const text = decodeURIComponent(value);
  try {
    await navigator.clipboard.writeText(text);
  } catch {
    const area = document.createElement("textarea");
    area.value = text;
    document.body.append(area);
    area.select();
    document.execCommand("copy");
    area.remove();
  }
  showToast("Código copiado al portapapeles");
}

function showToast(message) {
  $(".bt-toast__text", toast).textContent = message;
  toast.dataset.visible = "true";
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.dataset.visible = "false";
  }, 2200);
}

function getExampleSnippet(ref) {
  const [componentId, index] = ref.split(":");
  const component = COMPONENTS.find((item) => item.id === componentId);
  return component?.examples[Number(index)]?.html || "";
}

function setRoute(id) {
  const component = COMPONENTS.find((item) => item.id === id) || COMPONENTS[0];
  renderComponent(component);
}

function findLocalTarget(trigger, id) {
  const scope =
    trigger.closest(".bt-example, .bt-doc-card, main, body") || document;
  return (
    scope.querySelector(`#${CSS.escape(id)}`) || document.getElementById(id)
  );
}

function closeMenus(except) {
  $$('[data-open="true"].bt-menu').forEach((menu) => {
    if (menu !== except) menu.dataset.open = "false";
  });
}

function setupEvents() {
  document.addEventListener("click", (event) => {
    const navLink = event.target.closest("[data-nav-link]");
    if (navLink) {
      event.preventDefault();
      const id = navLink.dataset.navLink;
      history.pushState(null, "", `#${id}`);
      setRoute(id);
      document.body.classList.remove("bt-sidebar-open");
      return;
    }

    const openPanel = event.target.closest("[data-open-panel]");
    if (openPanel) {
      renderPanel(openPanel.dataset.openPanel);
      return;
    }

    const closePanelButton = event.target.closest("[data-close-panel]");
    if (closePanelButton) {
      closePanel();
      return;
    }

    const copyExample = event.target.closest("[data-copy-example]");
    if (copyExample) {
      copyText(
        encodeURIComponent(
          normalizeSnippet(getExampleSnippet(copyExample.dataset.copyExample)),
        ),
      );
      return;
    }

    const copyTextButton = event.target.closest("[data-copy-text]");
    if (copyTextButton) {
      copyText(copyTextButton.dataset.copyText);
      return;
    }

    const copyCurrent = event.target.closest("[data-copy-current]");
    if (copyCurrent) {
      const sourceComponent = activePanelComponent || currentComponent;
      const combined = sourceComponent.examples
        .map((example) => normalizeSnippet(example.html))
        .join("\n\n");
      copyText(encodeURIComponent(combined));
      return;
    }

    const themeToggle = event.target.closest("[data-theme-toggle]");
    if (themeToggle) {
      const html = document.documentElement;
      const nextTheme = html.dataset.theme === "dark" ? "light" : "dark";
      html.dataset.theme = nextTheme;
      localStorage.setItem("bt-theme", nextTheme);
      syncThemeLabels(document, nextTheme);
      return;
    }

    const sidebarToggle = event.target.closest("[data-toggle-sidebar]");
    if (sidebarToggle) {
      document.body.classList.toggle("bt-sidebar-open");
      return;
    }

    const dialogOpen = event.target.closest("[data-dialog-open]");
    if (dialogOpen) {
      const target = findLocalTarget(dialogOpen, dialogOpen.dataset.dialogOpen);
      target?.setAttribute("open", "");
      return;
    }

    const dialogClose = event.target.closest("[data-dialog-close]");
    if (dialogClose) {
      dialogClose.closest(".bt-dialog")?.removeAttribute("open");
      return;
    }

    const overlayOpen = event.target.closest("[data-overlay-open]");
    if (overlayOpen) {
      const target = findLocalTarget(
        overlayOpen,
        overlayOpen.dataset.overlayOpen,
      );
      target?.setAttribute("open", "");
      return;
    }

    const overlayClose = event.target.closest("[data-overlay-close]");
    if (overlayClose) {
      overlayClose.closest(".bt-overlay")?.removeAttribute("open");
      return;
    }

    const menuToggle = event.target.closest("[data-menu-toggle]");
    if (menuToggle) {
      const menu = findLocalTarget(menuToggle, menuToggle.dataset.menuToggle);
      const next = menu?.dataset.open !== "true";
      closeMenus(menu);
      if (menu) menu.dataset.open = String(next);
      return;
    }

    if (!event.target.closest(".bt-menu-wrap")) closeMenus();

    const expansionToggle = event.target.closest("[data-expansion-toggle]");
    if (expansionToggle) {
      const expansion = expansionToggle.closest("[data-expansion]");
      expansion.dataset.open =
        expansion.dataset.open === "true" ? "false" : "true";
      return;
    }

    const snackbarOpen = event.target.closest("[data-snackbar-open]");
    if (snackbarOpen) {
      const snackbar = findLocalTarget(
        snackbarOpen,
        snackbarOpen.dataset.snackbarOpen,
      );
      if (snackbar) {
        snackbar.dataset.open = "true";
        setTimeout(() => {
          snackbar.dataset.open = "false";
        }, 3200);
      }
      return;
    }

    const snackbarClose = event.target.closest("[data-snackbar-close]");
    if (snackbarClose) {
      snackbarClose.closest(".bt-snackbar").dataset.open = "false";
      return;
    }

    const tab = event.target.closest("[data-tab]");
    if (tab) {
      const container = tab.closest("[data-tabs]");
      $$('[role="tab"]', container).forEach((item) =>
        item.setAttribute("aria-selected", String(item === tab)),
      );
      $$(".bt-tab-panel", container).forEach((panel) =>
        panel.setAttribute("aria-hidden", String(panel.id !== tab.dataset.tab)),
      );
    }
  });

  $("#component-search").addEventListener("input", (event) => {
    const value = event.target.value.trim().toLowerCase();
    $$("#sidebar-nav [data-nav-link]").forEach((link) => {
      const match = link.textContent.toLowerCase().includes(value);
      link.classList.toggle("is-hidden", value && !match);
    });
    $$("#sidebar-nav .bt-sidebar__group").forEach((group) => {
      const visible = $$("[data-nav-link]:not(.is-hidden)", group).length > 0;
      group.classList.toggle("bt-hidden", !visible);
    });
  });

  window.addEventListener("popstate", () =>
    setRoute(location.hash.replace("#", "")),
  );
}

function boot() {
  const storedTheme = localStorage.getItem("bt-theme");
  if (storedTheme) document.documentElement.dataset.theme = storedTheme;
  syncThemeLabels(document);
  renderNav();
  setupEvents();
  setRoute(location.hash.replace("#", "") || "get-started");
}

boot();
