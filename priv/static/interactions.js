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
//#region src/lib/combobox.js
var i = 4, a = 250, o = {
	mounted() {
		this.sync();
	},
	updated() {
		this.sync();
	},
	destroyed() {
		this.cleanup();
	},
	sync() {
		if (!this.el.classList.contains("bt-combobox--open")) {
			this.cleanup();
			return;
		}
		let e = this.el.querySelector(".bt-combobox__panel") || this.activePanel();
		e && this.portal(e);
	},
	activePanel() {
		return this.panel?.isConnected ? this.panel : null;
	},
	portal(e) {
		if (this.panel === e && e.parentNode === document.body) {
			requestAnimationFrame(() => this.position());
			return;
		}
		this.cleanup(), this.panel = e, this.anchor = this.el.querySelector(".bt-combobox__input-wrap") || this.el, e.classList.add("bt-combobox__panel--portal"), document.body.appendChild(e), this.reposition || (this.reposition = () => this.position(), window.addEventListener("scroll", this.reposition, !0), window.addEventListener("resize", this.reposition)), requestAnimationFrame(() => this.position());
	},
	cleanup() {
		this.panel?.isConnected && this.panel.remove(), this.panel = null, this.anchor = null, this.reposition &&= (window.removeEventListener("scroll", this.reposition, !0), window.removeEventListener("resize", this.reposition), null);
	},
	position() {
		if (!this.anchor || !this.panel) return;
		let e = this.anchor.getBoundingClientRect(), t = this.panel;
		t.style.position = "fixed", t.style.zIndex = String(a), t.style.left = `${e.left}px`, t.style.width = `${e.width}px`, t.style.right = "auto";
		let n = t.offsetHeight, r = window.innerHeight - e.bottom, o = r < n + i && e.top > r;
		t.style.top = o ? `${Math.max(i, e.top - i - n)}px` : `${e.bottom + i}px`;
	}
}, s = {
	mounted() {
		this.scheduleDismiss();
	},
	updated() {
		this.scheduleDismiss();
	},
	destroyed() {
		this.clearDismiss();
	},
	scheduleDismiss() {
		this.clearDismiss();
		let e = parseInt(this.el.dataset.autoDismiss, 10);
		!e || e <= 0 || (this.dismissTimer = setTimeout(() => {
			this.el.click();
		}, e));
	},
	clearDismiss() {
		this.dismissTimer &&= (clearTimeout(this.dismissTimer), null);
	}
}, c = "bt-theme", l = (e, t = document) => [...t.querySelectorAll(e)], u = (e = document) => e.querySelector("[data-theme-icon]"), d = (e = document, t = e.documentElement.dataset.theme) => {
	let n = u(e);
	n && (n.textContent = t === "dark" ? "☀" : "◐"), l("[data-theme-value]", e).forEach((e) => {
		e.textContent = t === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, f = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), p = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, m = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, h = (e = document, t) => {
	l("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== t && (e.dataset.open = "false");
	});
}, g = (e, t = {}) => {
	let { root: n = document, storageKey: r = c, persist: i = !0 } = t;
	n.documentElement.dataset.theme = e, d(n, e), i && localStorage.setItem(r, e);
}, _ = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return g(t, e), t;
}, v = (e = {}) => {
	let { root: t = document, storageKey: n = c, fallbackTheme: r = "light" } = e, i = localStorage.getItem(n) || r;
	return g(i, {
		...e,
		root: t,
		persist: !1
	}), i;
};
function y(e = {}) {
	let { root: t = document, storageKey: n = c, autoApplyStoredTheme: r = !0 } = e, i = new AbortController(), { signal: a } = i;
	r ? v({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}) : d(t);
	let o = new MutationObserver(() => d(t));
	return o.observe(t.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: a }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			_({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			p(f(r, r.dataset.dialogOpen, t));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			m(i.closest(".bt-dialog"));
			return;
		}
		let a = e.target.closest("[data-overlay-open]");
		if (a) {
			f(a, a.dataset.overlayOpen, t)?.setAttribute("open", "");
			return;
		}
		let o = e.target.closest("[data-overlay-close]");
		if (o) {
			o.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let s = e.target.closest("[data-menu-toggle]");
		if (s) {
			let e = f(s, s.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			h(t, e), e && (e.dataset.open = String(n));
			return;
		}
		e.target.closest(".bt-menu-wrap") || h(t);
		let c = e.target.closest("[data-expansion-toggle]");
		if (c) {
			let e = c.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let u = e.target.closest("[data-snackbar-open]");
		if (u) {
			let e = f(u, u.dataset.snackbarOpen, t);
			e && (e.dataset.open = "true", setTimeout(() => {
				e.dataset.open = "false";
			}, 3200));
			return;
		}
		let d = e.target.closest("[data-snackbar-close]");
		if (d) {
			let e = d.closest(".bt-snackbar");
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
		let g = e.target.closest("[data-tab]");
		if (g) {
			let e = g.closest("[data-tabs]");
			if (!e) return;
			l("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === g));
			}), l(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== g.dataset.tab));
			});
		}
	}, { signal: a }), () => {
		i.abort(), o.disconnect();
	};
}
//#endregion
export { o as BtCombobox, s as BtFlash, e as CalendarDaySelection, c as DEFAULT_THEME_STORAGE_KEY, v as applyStoredTheme, y as initBtInteractions, g as setTheme, d as syncThemeLabels, _ as toggleTheme };
