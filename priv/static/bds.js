//#region src/lib/interactions.js
var e = "bt-theme", t = (e, t = document) => [...t.querySelectorAll(e)], n = (e = document) => e.querySelector("[data-theme-icon]"), r = (e = document, r = e.documentElement.dataset.theme) => {
	let i = n(e);
	i && (i.textContent = r === "dark" ? "☀" : "◐"), t("[data-theme-value]", e).forEach((e) => {
		e.textContent = r === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, i = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), a = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, o = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, s = (e = document, n) => {
	t("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== n && (e.dataset.open = "false");
	});
}, c = (t, n = {}) => {
	let { root: i = document, storageKey: a = e, persist: o = !0 } = n;
	i.documentElement.dataset.theme = t, r(i, t), o && localStorage.setItem(a, t);
}, l = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return c(t, e), t;
}, u = (t = {}) => {
	let { root: n = document, storageKey: r = e, fallbackTheme: i = "light" } = t, a = localStorage.getItem(r) || i;
	return c(a, {
		...t,
		root: n,
		persist: !1
	}), a;
};
function d(n = {}) {
	let { root: c = document, storageKey: d = e, autoApplyStoredTheme: f = !0 } = n, p = new AbortController(), { signal: m } = p;
	f ? u({
		root: c,
		storageKey: d,
		fallbackTheme: c.documentElement.dataset.theme || "light"
	}) : r(c);
	let h = new MutationObserver(() => r(c));
	return h.observe(c.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), c.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: m }), c.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			l({
				root: c,
				storageKey: d
			});
			return;
		}
		let n = e.target.closest("[data-dialog-open]");
		if (n) {
			a(i(n, n.dataset.dialogOpen, c));
			return;
		}
		let r = e.target.closest("[data-dialog-close]");
		if (r) {
			o(r.closest(".bt-dialog"));
			return;
		}
		let u = e.target.closest("[data-overlay-open]");
		if (u) {
			i(u, u.dataset.overlayOpen, c)?.setAttribute("open", "");
			return;
		}
		let f = e.target.closest("[data-overlay-close]");
		if (f) {
			f.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let p = e.target.closest("[data-menu-toggle]");
		if (p) {
			let e = i(p, p.dataset.menuToggle, c), t = e?.dataset.open !== "true";
			s(c, e), e && (e.dataset.open = String(t));
			return;
		}
		e.target.closest(".bt-menu-wrap") || s(c);
		let m = e.target.closest("[data-expansion-toggle]");
		if (m) {
			let e = m.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let h = e.target.closest("[data-snackbar-open]");
		if (h) {
			let e = i(h, h.dataset.snackbarOpen, c);
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
			c.body.classList.toggle("bt-sidebar-open");
			return;
		}
		if (c.body.classList.contains("bt-sidebar-open") && e.target.closest(".bt-sidebar a, .bt-sidebar .bt-nav-link")) {
			c.body.classList.remove("bt-sidebar-open");
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
	}, { signal: m }), () => {
		p.abort(), h.disconnect();
	};
}
//#endregion
export { e as DEFAULT_THEME_STORAGE_KEY, u as applyStoredTheme, d as initBtInteractions, c as setTheme, l as toggleTheme };
