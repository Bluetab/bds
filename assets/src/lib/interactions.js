import { afterDialogClose, afterDialogOpen, installA11y, rememberOpener } from './a11y.js';

const DEFAULT_THEME_STORAGE_KEY = 'bt-theme';

const toArray = (selector, root = document) => [...root.querySelectorAll(selector)];

const getThemeIcon = (root = document) => root.querySelector('[data-theme-icon]');

const syncThemeLabels = (root = document, theme = root.documentElement.dataset.theme) => {
  const icon = getThemeIcon(root);
  if (icon) icon.textContent = theme === 'dark' ? 'light_mode' : 'dark_mode';

  toArray('[data-theme-value]', root).forEach((el) => {
    const dark = theme === 'dark';
    el.textContent = dark ? (el.dataset.dark || 'Dark') : (el.dataset.light || 'Light');
  });
};

const findLocalTarget = (trigger, id, root = document) => {
  const scope = trigger.closest('.bt-example, .bt-doc-card, .bt-shell, main, body') || root;
  return scope.querySelector(`#${CSS.escape(id)}`) || root.getElementById(id);
};

const openDialog = (target) => {
  if (!target) return;

  if (typeof HTMLDialogElement !== 'undefined' && target instanceof HTMLDialogElement) {
    if (!target.open && typeof target.showModal === 'function') {
      target.showModal();
    }
    return;
  }

  target.setAttribute('open', '');
};

const closeDialog = (dialog) => {
  if (!dialog) return;

  if (typeof HTMLDialogElement !== 'undefined' && dialog instanceof HTMLDialogElement) {
    if (dialog.open && typeof dialog.close === 'function') {
      dialog.close();
    }
    return;
  }

  dialog.removeAttribute('open');
};

const setMenuState = (menu, open, root = document) => {
  menu.dataset.open = String(open);
  toArray(`[data-menu-toggle="${CSS.escape(menu.id)}"]`, root).forEach((toggle) => {
    toggle.setAttribute('aria-expanded', String(open));
  });
};

const closeMenus = (root = document, except) => {
  toArray('[data-open="true"].bt-menu', root).forEach((menu) => {
    if (menu !== except) setMenuState(menu, false, root);
  });
};

// Closes a dialog or overlay and returns focus to the control that opened it
const closeModalLike = (el) => {
  if (!el) return;
  if (el.classList.contains('bt-overlay')) el.removeAttribute('open');
  else closeDialog(el);
  afterDialogClose(el);
};

const setTheme = (theme, options = {}) => {
  const {
    root = document,
    storageKey = DEFAULT_THEME_STORAGE_KEY,
    persist = true
  } = options;

  root.documentElement.dataset.theme = theme;
  syncThemeLabels(root, theme);

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
  } else {
    syncThemeLabels(root);
  }

  const themeObserver = new MutationObserver(() => syncThemeLabels(root));
  themeObserver.observe(root.documentElement, {
    attributes: true,
    attributeFilter: ['data-theme']
  });

  root.addEventListener('mousedown', (event) => {
    if (event.target.closest('.bt-combobox__panel')) {
      event.preventDefault();
    }
  }, { signal });

  root.addEventListener('click', (event) => {
    const themeToggle = event.target.closest('[data-theme-toggle]');
    if (themeToggle) {
      toggleTheme({ root, storageKey });
      return;
    }

    const dialogOpen = event.target.closest('[data-dialog-open]');
    if (dialogOpen) {
      const target = findLocalTarget(dialogOpen, dialogOpen.dataset.dialogOpen, root);
      if (target) {
        rememberOpener(target, dialogOpen);
        openDialog(target);
        afterDialogOpen(target);
      }
      return;
    }

    const dialogClose = event.target.closest('[data-dialog-close]');
    if (dialogClose) {
      closeModalLike(dialogClose.closest('.bt-dialog'));
      return;
    }

    const overlayOpen = event.target.closest('[data-overlay-open]');
    if (overlayOpen) {
      const target = findLocalTarget(overlayOpen, overlayOpen.dataset.overlayOpen, root);
      if (target) {
        rememberOpener(target, overlayOpen);
        target.setAttribute('open', '');
        afterDialogOpen(target);
      }
      return;
    }

    const overlayClose = event.target.closest('[data-overlay-close]');
    if (overlayClose) {
      closeModalLike(overlayClose.closest('.bt-overlay'));
      return;
    }

    const menuToggle = event.target.closest('[data-menu-toggle]');
    if (menuToggle) {
      const menu = findLocalTarget(menuToggle, menuToggle.dataset.menuToggle, root);
      const next = menu?.dataset.open !== 'true';
      closeMenus(root, menu);
      if (menu) setMenuState(menu, next, root);
      return;
    }

    // Choosing a menu item closes the menu and returns focus to its button
    const menuItem = event.target.closest('.bt-menu [role="menuitem"]');
    if (menuItem) {
      const menu = menuItem.closest('.bt-menu');
      setMenuState(menu, false, root);
      root.querySelector(`[data-menu-toggle="${CSS.escape(menu.id)}"]`)?.focus();
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

    const sidebarToggle = event.target.closest('[data-toggle-sidebar]');
    if (sidebarToggle) {
      root.body.classList.toggle('bt-sidebar-open');
      return;
    }

    if (
      root.body.classList.contains('bt-sidebar-open') &&
      event.target.closest('.bt-sidebar a, .bt-sidebar .bt-nav-link')
    ) {
      root.body.classList.remove('bt-sidebar-open');
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

  const uninstallA11y = installA11y(root, { signal, closeDialog: closeModalLike });

  return () => {
    controller.abort();
    themeObserver.disconnect();
    uninstallA11y();
  };
}

export { CalendarDaySelection } from './calendar-day-selection.js';
export { BtCombobox } from './combobox.js';
export { BtFlash } from './flash.js';
export { BtNumberStep } from './number-step.js';

export {
  DEFAULT_THEME_STORAGE_KEY,
  applyStoredTheme,
  initBtInteractions,
  setTheme,
  syncThemeLabels,
  toggleTheme
};
