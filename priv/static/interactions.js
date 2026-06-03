//#region src/lib/calendar-day-selection.js
var e = {
	mounted() {
		this.dragging = !1, this.dragMoved = !1, this.anchorDate = null, this.lastFocusDate = null, this.onPointerDown = (e) => {
			if (e.button !== 0 || e.shiftKey || e.metaKey || e.ctrlKey || e.target.closest("[data-calendar-day-open]")) return;
			let r = t(e.target);
			!r || !n(r) || (this.anchorDate = r.dataset.calendarDay, this.lastFocusDate = this.anchorDate, this.dragging = !0, this.dragMoved = !1, this.el.classList.add("bt-calendar-month-grid--dragging"), this.pushBox(this.anchorDate, this.anchorDate));
		}, this.onPointerOver = (e) => {
			if (!this.dragging) return;
			let r = t(e.target);
			if (!r || !n(r)) return;
			let i = r.dataset.calendarDay;
			i !== this.lastFocusDate && (this.lastFocusDate = i, this.dragMoved = !0, this.pushBox(this.anchorDate, i));
		}, this.onPointerUp = () => {
			this.dragging && (this.dragging = !1, this.anchorDate = null, this.lastFocusDate = null, this.el.classList.remove("bt-calendar-month-grid--dragging"), window.setTimeout(() => {
				this.dragMoved = !1;
			}, 0));
		}, this.onClickCapture = (e) => {
			if (e.target.closest("[data-calendar-day-open]")) return;
			let r = t(e.target);
			if (!(!r || !n(r))) {
				if (this.dragMoved) {
					e.preventDefault(), e.stopPropagation();
					return;
				}
				!e.shiftKey && !e.metaKey && !e.ctrlKey || (e.preventDefault(), e.stopPropagation(), e.stopImmediatePropagation(), this.pushEvent("day_select", {
					date: r.dataset.calendarDay,
					shift: e.shiftKey,
					meta: e.metaKey || e.ctrlKey
				}));
			}
		}, this.el.addEventListener("pointerdown", this.onPointerDown), this.el.addEventListener("pointerover", this.onPointerOver), this.el.addEventListener("click", this.onClickCapture, !0), window.addEventListener("pointerup", this.onPointerUp);
	},
	destroyed() {
		this.el.removeEventListener("pointerdown", this.onPointerDown), this.el.removeEventListener("pointerover", this.onPointerOver), this.el.removeEventListener("click", this.onClickCapture, !0), window.removeEventListener("pointerup", this.onPointerUp);
	},
	pushBox(e, t) {
		this.pushEvent("day_select_box", {
			anchor: e,
			focus: t
		});
	}
};
function t(e) {
	return e.closest("[data-calendar-day]");
}
function n(e) {
	return e.dataset.calendarSelectable === "true";
}
//#endregion
//#region src/lib/interactions.js
var r = "bt-theme", i = (e, t = document) => [...t.querySelectorAll(e)], a = (e = document) => e.querySelector("[data-theme-icon]"), o = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), s = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, c = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, l = (e = document, t) => {
	i("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== t && (e.dataset.open = "false");
	});
}, u = (e, t = {}) => {
	let { root: n = document, storageKey: i = r, persist: o = !0 } = t;
	n.documentElement.dataset.theme = e;
	let s = a(n);
	s && (s.textContent = e === "dark" ? "☀" : "◐"), o && localStorage.setItem(i, e);
}, d = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return u(t, e), t;
}, f = (e = {}) => {
	let { root: t = document, storageKey: n = r, fallbackTheme: i = "light" } = e, a = localStorage.getItem(n) || i;
	return u(a, {
		...e,
		root: t,
		persist: !1
	}), a;
};
function p(e = {}) {
	let { root: t = document, storageKey: n = r, autoApplyStoredTheme: a = !0 } = e, u = new AbortController(), { signal: p } = u;
	return a && f({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			d({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			s(o(r, r.dataset.dialogOpen, t));
			return;
		}
		let a = e.target.closest("[data-dialog-close]");
		if (a) {
			c(a.closest(".bt-dialog"));
			return;
		}
		let u = e.target.closest("[data-overlay-open]");
		if (u) {
			o(u, u.dataset.overlayOpen, t)?.setAttribute("open", "");
			return;
		}
		let f = e.target.closest("[data-overlay-close]");
		if (f) {
			f.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let p = e.target.closest("[data-menu-toggle]");
		if (p) {
			let e = o(p, p.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			l(t, e), e && (e.dataset.open = String(n));
			return;
		}
		e.target.closest(".bt-menu-wrap") || l(t);
		let m = e.target.closest("[data-expansion-toggle]");
		if (m) {
			let e = m.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let h = e.target.closest("[data-snackbar-open]");
		if (h) {
			let e = o(h, h.dataset.snackbarOpen, t);
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
			t.body.classList.toggle("bt-sidebar-open");
			return;
		}
		if (t.body.classList.contains("bt-sidebar-open") && e.target.closest(".bt-sidebar a, .bt-sidebar .bt-nav-link")) {
			t.body.classList.remove("bt-sidebar-open");
			return;
		}
		let _ = e.target.closest("[data-tab]");
		if (_) {
			let e = _.closest("[data-tabs]");
			if (!e) return;
			i("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === _));
			}), i(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== _.dataset.tab));
			});
		}
	}, { signal: p }), () => u.abort();
}
//#endregion
export { e as CalendarDaySelection, r as DEFAULT_THEME_STORAGE_KEY, f as applyStoredTheme, p as initBtInteractions, u as setTheme, d as toggleTheme };
