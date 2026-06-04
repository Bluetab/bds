//#region src/lib/calendar-day-selection.js
var e = {
	mounted() {
		this.dragging = !1, this.dragMoved = !1, this.anchorDate = null, this.lastFocusDate = null, this.onPointerDown = (e) => {
			if (e.button !== 0 || e.shiftKey || e.metaKey || e.ctrlKey || e.target.closest("[data-calendar-day-open]")) return;
			let i = t(e.target);
			!i || !n(i) || r(i) || (this.anchorDate = i.dataset.calendarDay, this.lastFocusDate = this.anchorDate, this.dragging = !0, this.dragMoved = !1, this.el.classList.add("bt-calendar-month-grid--dragging"), this.pushBox(this.anchorDate, this.anchorDate));
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
function r(e) {
	return e.dataset.templateDraggable === "true";
}
//#endregion
//#region src/lib/interactions.js
var i = "bt-theme", a = (e, t = document) => [...t.querySelectorAll(e)], o = (e = document) => e.querySelector("[data-theme-icon]"), s = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), c = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, l = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, u = (e = document, t) => {
	a("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== t && (e.dataset.open = "false");
	});
}, d = (e, t = {}) => {
	let { root: n = document, storageKey: r = i, persist: a = !0 } = t;
	n.documentElement.dataset.theme = e;
	let s = o(n);
	s && (s.textContent = e === "dark" ? "☀" : "◐"), a && localStorage.setItem(r, e);
}, f = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return d(t, e), t;
}, p = (e = {}) => {
	let { root: t = document, storageKey: n = i, fallbackTheme: r = "light" } = e, a = localStorage.getItem(n) || r;
	return d(a, {
		...e,
		root: t,
		persist: !1
	}), a;
};
function m(e = {}) {
	let { root: t = document, storageKey: n = i, autoApplyStoredTheme: r = !0 } = e, o = new AbortController(), { signal: d } = o;
	return r && p({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: d }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			f({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			c(s(r, r.dataset.dialogOpen, t));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			l(i.closest(".bt-dialog"));
			return;
		}
		let o = e.target.closest("[data-overlay-open]");
		if (o) {
			s(o, o.dataset.overlayOpen, t)?.setAttribute("open", "");
			return;
		}
		let d = e.target.closest("[data-overlay-close]");
		if (d) {
			d.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let p = e.target.closest("[data-menu-toggle]");
		if (p) {
			let e = s(p, p.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			u(t, e), e && (e.dataset.open = String(n));
			return;
		}
		e.target.closest(".bt-menu-wrap") || u(t);
		let m = e.target.closest("[data-expansion-toggle]");
		if (m) {
			let e = m.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let h = e.target.closest("[data-snackbar-open]");
		if (h) {
			let e = s(h, h.dataset.snackbarOpen, t);
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
			a("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === _));
			}), a(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== _.dataset.tab));
			});
		}
	}, { signal: d }), () => o.abort();
}
//#endregion
export { e as CalendarDaySelection, i as DEFAULT_THEME_STORAGE_KEY, p as applyStoredTheme, m as initBtInteractions, d as setTheme, f as toggleTheme };
