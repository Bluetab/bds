/*
  Keyboard and focus behaviour for BDS components (WAI-ARIA APG patterns).

  Everything is delegated from `root`, so it keeps working when LiveView
  patches or replaces the DOM. Installed by `initBtInteractions()`.

    Tabs             ←/→/Home/End, roving tabindex                [role=tablist]
    Menu button      Enter/Space/↓ open, ↑/↓/Home/End, Esc, Tab   [data-menu-toggle]
    Disclosure       aria-expanded kept in sync                   [data-expansion-toggle]
    Dialog/overlay   focus in on open, Tab trapped, Esc, return   [data-focus-trap]
    Modal (LV)       focus returns to the opener on removal       [data-focus-return]
    Tooltip          aria-describedby on the trigger, Esc hides   .bt-tooltip
    Combobox         ↑/↓ active option, Enter picks, Esc clears   [data-combobox-input]
    Tree             ↑/↓ rows, → expand, ← collapse / parent      [data-bt-tree]
    User menu        aria-expanded in sync, Esc closes            [data-navbar-user]
    role=button      Enter/Space activate non-button elements     [role=button]

  Inside [data-demo-static] (documentation previews that pin a state, e.g. an
  open dialog shown as a picture) dialogs are not modal: no Tab trap, no Esc.
*/

const FOCUSABLE = [
  'a[href]', 'area[href]', 'button:not([disabled])', 'input:not([disabled]):not([type="hidden"])',
  'select:not([disabled])', 'textarea:not([disabled])', 'iframe', 'summary',
  '[tabindex]:not([tabindex="-1"])', '[contenteditable="true"]'
].join(',');

const visible = (el) => !!(el.offsetWidth || el.offsetHeight || el.getClientRects().length);
const focusables = (container) => [...container.querySelectorAll(FOCUSABLE)].filter(visible);

const moveIndex = (key, index, length) => {
  switch (key) {
    case 'ArrowRight':
    case 'ArrowDown': return (index + 1) % length;
    case 'ArrowLeft':
    case 'ArrowUp': return (index - 1 + length) % length;
    case 'Home': return 0;
    case 'End': return length - 1;
    default: return null;
  }
};

let uid = 0;
const ensureId = (el, prefix) => {
  if (!el.id) el.id = `${prefix}-${++uid}`;
  return el.id;
};

/* Tabs ------------------------------------------------------------------- */

const selectTab = (tab, { focus = false } = {}) => {
  const container = tab.closest('[data-tabs]');
  if (!container) return;
  container.querySelectorAll('[role="tab"]').forEach((item) => {
    const selected = item === tab;
    item.setAttribute('aria-selected', String(selected));
    item.tabIndex = selected ? 0 : -1;
  });
  container.querySelectorAll('.bt-tab-panel').forEach((panel) => {
    panel.setAttribute('aria-hidden', String(panel.id !== tab.dataset.tab));
  });
  if (focus) tab.focus();
};

const onTabsKeydown = (event) => {
  const tab = event.target.closest('[role="tab"]');
  const list = tab?.closest('[role="tablist"]');
  if (!list) return false;
  const tabs = [...list.querySelectorAll('[role="tab"]')];
  const next = moveIndex(event.key, tabs.indexOf(tab), tabs.length);
  if (next === null) return false;
  event.preventDefault();
  selectTab(tabs[next], { focus: true });
  return true;
};

/* Menu button ------------------------------------------------------------ */

const menuItems = (menu) => [...menu.querySelectorAll('[role="menuitem"]')].filter(visible);

const setMenuOpen = (menu, open, root) => {
  if (!menu) return;
  menu.dataset.open = String(open);
  root.querySelectorAll(`[data-menu-toggle="${CSS.escape(menu.id)}"]`).forEach((toggle) => {
    toggle.setAttribute('aria-expanded', String(open));
  });
};

const toggleFor = (menu, root) => root.querySelector(`[data-menu-toggle="${CSS.escape(menu.id)}"]`);

const onMenuKeydown = (event, root) => {
  const toggle = event.target.closest('[data-menu-toggle]');
  if (toggle && ['ArrowDown', 'ArrowUp', 'Enter', ' '].includes(event.key)) {
    const menu = root.getElementById(toggle.dataset.menuToggle);
    if (!menu) return false;
    event.preventDefault();
    setMenuOpen(menu, true, root);
    const items = menuItems(menu);
    (event.key === 'ArrowUp' ? items[items.length - 1] : items[0])?.focus();
    return true;
  }

  const menu = event.target.closest('.bt-menu[role="menu"]');
  if (!menu) return false;
  const items = menuItems(menu);

  if (event.key === 'Escape') {
    event.preventDefault();
    setMenuOpen(menu, false, root);
    toggleFor(menu, root)?.focus();
    return true;
  }
  if (event.key === 'Tab') {
    setMenuOpen(menu, false, root);
    return false;
  }
  const next = moveIndex(event.key, items.indexOf(event.target.closest('[role="menuitem"]')), items.length);
  if (next === null) return false;
  event.preventDefault();
  items[next]?.focus();
  return true;
};

/* Dialogs with focus trap ------------------------------------------------ */

const liveTrap = (el) => visible(el) && !el.closest('[data-demo-static]');

const openTraps = (root) =>
  [...root.querySelectorAll('[data-focus-trap][open], .bt-modal [role="dialog"]')].filter(liveTrap);

const focusInto = (container) => {
  const target = container.querySelector('[autofocus]') || focusables(container)[0] || container;
  if (target === container && !container.hasAttribute('tabindex')) container.tabIndex = -1;
  target.focus();
};

const trapTab = (event, root) => {
  if (event.key !== 'Tab') return false;
  const traps = openTraps(root);
  const trap = traps[traps.length - 1];
  if (!trap) return false;
  const items = focusables(trap);
  if (items.length === 0) {
    event.preventDefault();
    return true;
  }
  const first = items[0];
  const last = items[items.length - 1];
  if (!trap.contains(document.activeElement)) {
    event.preventDefault();
    first.focus();
  } else if (event.shiftKey && document.activeElement === first) {
    event.preventDefault();
    last.focus();
  } else if (!event.shiftKey && document.activeElement === last) {
    event.preventDefault();
    first.focus();
  }
  return true;
};

const returnFocus = new WeakMap();

export const rememberOpener = (dialog, opener) => {
  if (opener) returnFocus.set(dialog, opener);
};

// setTimeout, not requestAnimationFrame: rAF does not run in background tabs
export const afterDialogOpen = (dialog) => setTimeout(() => focusInto(dialog), 0);

export const afterDialogClose = (dialog) => {
  const opener = returnFocus.get(dialog);
  returnFocus.delete(dialog);
  if (opener?.isConnected) opener.focus();
};

const onDialogEscape = (event, root, close) => {
  if (event.key !== 'Escape') return false;
  const traps = [...root.querySelectorAll('[data-focus-trap][open]')].filter(liveTrap);
  const trap = traps[traps.length - 1];
  if (!trap) return false;
  event.preventDefault();
  close(trap);
  return true;
};

/* Tooltip ---------------------------------------------------------------- */

const linkTooltip = (tooltip) => {
  const textId = tooltip.dataset.tooltipDescribes;
  const trigger = focusables(tooltip)[0];
  if (!textId || !trigger) return;
  const ids = (trigger.getAttribute('aria-describedby') || '').split(/\s+/).filter(Boolean);
  if (!ids.includes(textId)) trigger.setAttribute('aria-describedby', [...ids, textId].join(' '));
};

/* Combobox --------------------------------------------------------------- */

const comboboxOptions = (input, root) => {
  const panel = root.getElementById(input.getAttribute('aria-controls'));
  return panel ? [...panel.querySelectorAll('[role="option"]')].filter(visible) : [];
};

const setActiveOption = (input, option) => {
  input.closest('.bt-combobox')?.querySelectorAll('[role="option"][data-active]')
    .forEach((el) => el.removeAttribute('data-active'));
  if (!option) {
    input.removeAttribute('aria-activedescendant');
    return;
  }
  option.dataset.active = 'true';
  input.setAttribute('aria-activedescendant', ensureId(option, 'bt-option'));
  option.scrollIntoView({ block: 'nearest' });
};

const onComboboxKeydown = (event, root) => {
  const input = event.target.closest('[data-combobox-input]');
  if (!input) return false;
  const options = comboboxOptions(input, root);
  const activeId = input.getAttribute('aria-activedescendant');
  const index = options.findIndex((o) => o.id === activeId);

  if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
    if (options.length === 0) return false;
    event.preventDefault();
    const next = event.key === 'ArrowDown'
      ? (index + 1) % options.length
      : (index - 1 + options.length) % options.length;
    setActiveOption(input, options[next]);
    return true;
  }
  if (event.key === 'Enter' && index >= 0) {
    event.preventDefault();
    options[index].click();
    setActiveOption(input, null);
    return true;
  }
  if (event.key === 'Escape' && activeId) {
    event.preventDefault();
    setActiveOption(input, null);
    return true;
  }
  return false;
};

/* Tree ------------------------------------------------------------------- */

const rowControl = (row) =>
  row.querySelector('.bt-tree__body button, .bt-tree__body a[href]') || row.querySelector('[data-tree-toggle]');

const onTreeKeydown = (event) => {
  const tree = event.target.closest('[data-bt-tree]');
  if (!tree || !['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return false;
  const row = event.target.closest('.bt-tree__row');
  if (!row) return false;

  const rows = [...tree.querySelectorAll('.bt-tree__row')].filter(visible).filter(rowControl);
  const toggle = row.querySelector('[data-tree-toggle]');
  const expanded = toggle?.getAttribute('aria-expanded') === 'true';

  if (event.key === 'ArrowRight') {
    if (toggle && !expanded) toggle.click();
    else if (toggle) rows[rows.indexOf(row) + 1] && rowControl(rows[rows.indexOf(row) + 1]).focus();
  } else if (event.key === 'ArrowLeft') {
    if (toggle && expanded) toggle.click();
    else rowControl(row.closest('.bt-tree--nested')?.closest('.bt-tree__item')?.querySelector('.bt-tree__row') || row)?.focus();
  } else {
    const next = moveIndex(event.key, rows.indexOf(row), rows.length);
    if (next === null) return false;
    // Up/Down don't wrap in a tree
    if ((event.key === 'ArrowDown' && next === 0) || (event.key === 'ArrowUp' && next === rows.length - 1)) {
      event.preventDefault();
      return true;
    }
    rowControl(rows[next])?.focus();
  }
  event.preventDefault();
  return true;
};

/* Navbar user menu (disclosure opened by hover/focus) -------------------- */

const syncUserMenu = (container) => {
  const trigger = container.querySelector('[data-navbar-user-trigger]');
  if (!trigger) return;
  const open = container.dataset.dismissed !== 'true' &&
    (container.dataset.open === 'true' || container.matches(':hover') || container.matches(':focus-within'));
  trigger.setAttribute('aria-expanded', String(open));
};

/* Install ---------------------------------------------------------------- */

export function installA11y(root, { signal, closeDialog }) {
  // Remember where focus was before something modal appeared
  let lastFocusOutside = null;

  root.addEventListener('focusin', (event) => {
    if (!event.target.closest('[data-focus-trap], .bt-modal')) lastFocusOutside = event.target;

    const tooltip = event.target.closest('.bt-tooltip');
    if (tooltip) linkTooltip(tooltip);

    const user = event.target.closest('[data-navbar-user]');
    if (user) syncUserMenu(user);
  }, { signal });

  root.addEventListener('focusout', (event) => {
    const user = event.target.closest('[data-navbar-user]');
    if (user && !user.contains(event.relatedTarget)) {
      delete user.dataset.dismissed;
      user.dataset.open = 'false';
      setTimeout(() => syncUserMenu(user), 0);
    }
    const tooltip = event.target.closest('.bt-tooltip');
    if (tooltip && !tooltip.contains(event.relatedTarget)) delete tooltip.dataset.tooltipHidden;
  }, { signal });

  root.addEventListener('mouseover', (event) => {
    const user = event.target.closest('[data-navbar-user]');
    if (user) syncUserMenu(user);
  }, { signal });

  root.addEventListener('mouseout', (event) => {
    const user = event.target.closest('[data-navbar-user]');
    if (user && !user.contains(event.relatedTarget)) setTimeout(() => syncUserMenu(user), 0);
  }, { signal });

  root.addEventListener('click', (event) => {
    const trigger = event.target.closest('[data-navbar-user-trigger]');
    if (trigger) {
      const user = trigger.closest('[data-navbar-user]');
      const open = trigger.getAttribute('aria-expanded') === 'true' && user.dataset.dismissed !== 'true';
      if (open) {
        user.dataset.dismissed = 'true';
        user.dataset.open = 'false';
      } else {
        delete user.dataset.dismissed;
        user.dataset.open = 'true';
      }
      syncUserMenu(user);
      return;
    }

    const expansionToggle = event.target.closest('[data-expansion-toggle]');
    if (expansionToggle) {
      // interactions.js flipped data-open earlier in this same click
      const expansion = expansionToggle.closest('[data-expansion]');
      expansionToggle.setAttribute('aria-expanded', String(expansion?.dataset.open === 'true'));
    }

    const tab = event.target.closest('[role="tab"][data-tab]');
    if (tab) selectTab(tab);
  }, { signal });

  root.addEventListener('keydown', (event) => {
    if (event.defaultPrevented) return;
    if (onTabsKeydown(event)) return;
    if (onMenuKeydown(event, root)) return;
    if (onComboboxKeydown(event, root)) return;
    if (onTreeKeydown(event)) return;
    if (trapTab(event, root)) return;
    if (onDialogEscape(event, root, closeDialog)) return;

    if (event.key === 'Escape') {
      const tooltip = event.target.closest('.bt-tooltip');
      if (tooltip) tooltip.dataset.tooltipHidden = 'true';

      const user = event.target.closest('[data-navbar-user]');
      if (user) {
        user.dataset.dismissed = 'true';
        user.dataset.open = 'false';
        syncUserMenu(user);
        user.querySelector('[data-navbar-user-trigger]')?.focus();
      }
      return;
    }

    // Non-button elements that act as buttons
    if ((event.key === 'Enter' || event.key === ' ') && event.target.matches('[role="button"]:not(button):not(a):not(input)')) {
      event.preventDefault();
      event.target.click();
    }
  }, { signal });

  // LiveView modals: when one is removed, send focus back to where it was
  const observer = new MutationObserver((mutations) => {
    const removedModal = mutations.some((m) =>
      [...m.removedNodes].some((n) => n.nodeType === 1 && (n.matches?.('[data-focus-return]') || n.querySelector?.('[data-focus-return]')))
    );
    if (removedModal && lastFocusOutside?.isConnected &&
        (document.activeElement === document.body || !document.activeElement)) {
      lastFocusOutside.focus();
    }
  });
  observer.observe(root.body || root, { childList: true, subtree: true });

  return () => observer.disconnect();
}

export { selectTab, setMenuOpen };
