//#region src/lib/interactions.js
var e = "bt-theme", t = (e, t = document) => [...t.querySelectorAll(e)], n = (e = document) => e.querySelector("[data-theme-icon]"), r = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), i = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, a = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, o = (e = document, n) => {
	t("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== n && (e.dataset.open = "false");
	});
}, s = (t, r = {}) => {
	let { root: i = document, storageKey: a = e, persist: o = !0 } = r;
	i.documentElement.dataset.theme = t;
	let s = n(i);
	s && (s.textContent = t === "dark" ? "☀" : "◐"), o && localStorage.setItem(a, t);
}, c = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return s(t, e), t;
}, l = (t = {}) => {
	let { root: n = document, storageKey: r = e, fallbackTheme: i = "light" } = t, a = localStorage.getItem(r) || i;
	return s(a, {
		...t,
		root: n,
		persist: !1
	}), a;
};
function u(n = {}) {
	let { root: s = document, storageKey: u = e, autoApplyStoredTheme: d = !0 } = n, f = new AbortController(), { signal: p } = f;
	return d && l({
		root: s,
		storageKey: u,
		fallbackTheme: s.documentElement.dataset.theme || "light"
	}), s.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			c({
				root: s,
				storageKey: u
			});
			return;
		}
		let n = e.target.closest("[data-dialog-open]");
		if (n) {
			i(r(n, n.dataset.dialogOpen, s));
			return;
		}
		let l = e.target.closest("[data-dialog-close]");
		if (l) {
			a(l.closest(".bt-dialog"));
			return;
		}
		let d = e.target.closest("[data-overlay-open]");
		if (d) {
			r(d, d.dataset.overlayOpen, s)?.setAttribute("open", "");
			return;
		}
		let f = e.target.closest("[data-overlay-close]");
		if (f) {
			f.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let p = e.target.closest("[data-menu-toggle]");
		if (p) {
			let e = r(p, p.dataset.menuToggle, s), t = e?.dataset.open !== "true";
			o(s, e), e && (e.dataset.open = String(t));
			return;
		}
		e.target.closest(".bt-menu-wrap") || o(s);
		let m = e.target.closest("[data-expansion-toggle]");
		if (m) {
			let e = m.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let h = e.target.closest("[data-snackbar-open]");
		if (h) {
			let e = r(h, h.dataset.snackbarOpen, s);
			e && (e.dataset.open = "true", setTimeout(() => {
				e.dataset.open = "false";
			}, 3200));
			return;
		}
		let g = e.target.closest("[data-snackbar-close]");
		if (g) {
			let e = g.closest(".bt-snackbar");
			e && (e.dataset.open = "false");
			return;
		}
		if (e.target.closest("[data-toggle-sidebar]")) {
			s.body.classList.toggle("bt-sidebar-open");
			return;
		}
		if (s.body.classList.contains("bt-sidebar-open") && e.target.closest(".bt-sidebar a, .bt-sidebar .bt-nav-link")) {
			s.body.classList.remove("bt-sidebar-open");
			return;
		}
		let _ = e.target.closest("[data-tab]");
		if (_) {
			let e = _.closest("[data-tabs]");
			if (!e) return;
			t("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === _));
			}), t(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== _.dataset.tab));
			});
		}
	}, { signal: p }), () => f.abort();
}
//#endregion
export { e as DEFAULT_THEME_STORAGE_KEY, l as applyStoredTheme, u as initBtInteractions, s as setTheme, c as toggleTheme };
