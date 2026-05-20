const DEFAULT_THEME_STORAGE_KEY = 'bt-theme';

const toArray = (selector, root = document) => [...root.querySelectorAll(selector)];

const getThemeIcon = (root = document) => root.querySelector('[data-theme-icon]');

const findLocalTarget = (trigger, id, root = document) => {
  const scope = trigger.closest('.bt-example, .bt-doc-card, main, body') || root;
  return scope.querySelector(`#${CSS.escape(id)}`) || root.getElementById(id);
};

const closeMenus = (root = document, except) => {
  toArray('[data-open="true"].bt-menu', root).forEach((menu) => {
    if (menu !== except) menu.dataset.open = 'false';
  });
};

const setTheme = (theme, options = {}) => {
  const {
    root = document,
    storageKey = DEFAULT_THEME_STORAGE_KEY,
    persist = true
  } = options;

  root.documentElement.dataset.theme = theme;

  const icon = getThemeIcon(root);
  if (icon) icon.textContent = theme === 'dark' ? '☀' : '◐';

  if (persist) localStorage.setItem(storageKey, theme);
};

const toggleTheme = (options = {}) => {
  const root = options.root || document;
  const nextTheme = root.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
  setTheme(nextTheme, options);
  return nextTheme;
};

const applyStoredTheme = (options = {}) => {
  const {
    root = document,
    storageKey = DEFAULT_THEME_STORAGE_KEY,
    fallbackTheme = 'light'
  } = options;

  const storedTheme = localStorage.getItem(storageKey) || fallbackTheme;
  setTheme(storedTheme, { ...options, root, persist: false });
  return storedTheme;
};

function initBtInteractions(options = {}) {
  const {
    root = document,
    storageKey = DEFAULT_THEME_STORAGE_KEY,
    autoApplyStoredTheme = true
  } = options;
  const controller = new AbortController();
  const { signal } = controller;

  if (autoApplyStoredTheme) {
    applyStoredTheme({ root, storageKey, fallbackTheme: root.documentElement.dataset.theme || 'light' });
  }

  root.addEventListener('click', (event) => {
    const themeToggle = event.target.closest('[data-theme-toggle]');
    if (themeToggle) {
      toggleTheme({ root, storageKey });
      return;
    }

    const dialogOpen = event.target.closest('[data-dialog-open]');
    if (dialogOpen) {
      const target = findLocalTarget(dialogOpen, dialogOpen.dataset.dialogOpen, root);
      target?.setAttribute('open', '');
      return;
    }

    const dialogClose = event.target.closest('[data-dialog-close]');
    if (dialogClose) {
      dialogClose.closest('.bt-dialog')?.removeAttribute('open');
      return;
    }

    const overlayOpen = event.target.closest('[data-overlay-open]');
    if (overlayOpen) {
      const target = findLocalTarget(overlayOpen, overlayOpen.dataset.overlayOpen, root);
      target?.setAttribute('open', '');
      return;
    }

    const overlayClose = event.target.closest('[data-overlay-close]');
    if (overlayClose) {
      overlayClose.closest('.bt-overlay')?.removeAttribute('open');
      return;
    }

    const menuToggle = event.target.closest('[data-menu-toggle]');
    if (menuToggle) {
      const menu = findLocalTarget(menuToggle, menuToggle.dataset.menuToggle, root);
      const next = menu?.dataset.open !== 'true';
      closeMenus(root, menu);
      if (menu) menu.dataset.open = String(next);
      return;
    }

    if (!event.target.closest('.bt-menu-wrap')) closeMenus(root);

    const expansionToggle = event.target.closest('[data-expansion-toggle]');
    if (expansionToggle) {
      const expansion = expansionToggle.closest('[data-expansion]');
      expansion.dataset.open = expansion.dataset.open === 'true' ? 'false' : 'true';
      return;
    }

    const snackbarOpen = event.target.closest('[data-snackbar-open]');
    if (snackbarOpen) {
      const snackbar = findLocalTarget(snackbarOpen, snackbarOpen.dataset.snackbarOpen, root);
      if (snackbar) {
        snackbar.dataset.open = 'true';
        setTimeout(() => {
          snackbar.dataset.open = 'false';
        }, 3200);
      }
      return;
    }

    const snackbarClose = event.target.closest('[data-snackbar-close]');
    if (snackbarClose) {
      const snackbar = snackbarClose.closest('.bt-snackbar');
      if (snackbar) snackbar.dataset.open = 'false';
      return;
    }

    const tab = event.target.closest('[data-tab]');
    if (tab) {
      const container = tab.closest('[data-tabs]');
      if (!container) return;
      toArray('[role="tab"]', container).forEach((item) => {
        item.setAttribute('aria-selected', String(item === tab));
      });
      toArray('.bt-tab-panel', container).forEach((panel) => {
        panel.setAttribute('aria-hidden', String(panel.id !== tab.dataset.tab));
      });
    }
  }, { signal });

  return () => controller.abort();
}

export {
  DEFAULT_THEME_STORAGE_KEY,
  applyStoredTheme,
  initBtInteractions,
  setTheme,
  toggleTheme
};
