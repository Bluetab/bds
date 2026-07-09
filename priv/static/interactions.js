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
}, c = (e, t) => {
	let n = parseFloat(e);
	return Number.isFinite(n) ? n : t;
}, l = (e, t = 2) => Math.round(e * 10 ** t) / 10 ** t, u = {
	mounted() {
		this.increment = c(this.el.dataset.stepIncrement, .5), this.min = this.el.hasAttribute("min") ? c(this.el.min, null) : null, this.max = this.el.hasAttribute("max") ? c(this.el.max, null) : null, this.typing = !1, this.pasting = !1, this.adjusting = !1, this.previousValue = c(this.el.value, 0), this.el.setAttribute("step", "any"), this.onKeyDown = (e) => {
			if (e.key === "ArrowUp" || e.key === "ArrowDown") {
				e.preventDefault(), this.stepBy(e.key === "ArrowUp" ? this.increment : -this.increment);
				return;
			}
			(e.key.length === 1 || e.key === "Backspace" || e.key === "Delete" || e.key === "ArrowLeft" || e.key === "ArrowRight" || e.key === "Home" || e.key === "End") && (this.typing = !0);
		}, this.onKeyUp = () => {
			this.typing = !1, this.previousValue = c(this.el.value, this.previousValue);
		}, this.onPaste = () => {
			this.pasting = !0;
		}, this.onInput = () => {
			if (this.adjusting) return;
			if (this.typing || this.pasting) {
				this.pasting = !1, this.previousValue = c(this.el.value, this.previousValue);
				return;
			}
			let e = c(this.el.value, this.previousValue), t = l(e - this.previousValue, 4);
			if (Math.abs(Math.abs(t) - 1) < 1e-4) {
				this.stepBy(t > 0 ? this.increment : -this.increment, !0);
				return;
			}
			this.previousValue = e;
		}, this.onWheel = (e) => {
			document.activeElement === this.el && (e.preventDefault(), this.stepBy(e.deltaY < 0 ? this.increment : -this.increment));
		}, this.el.addEventListener("keydown", this.onKeyDown), this.el.addEventListener("keyup", this.onKeyUp), this.el.addEventListener("paste", this.onPaste), this.el.addEventListener("input", this.onInput), this.el.addEventListener("wheel", this.onWheel, { passive: !1 });
	},
	destroyed() {
		this.el.removeEventListener("keydown", this.onKeyDown), this.el.removeEventListener("keyup", this.onKeyUp), this.el.removeEventListener("paste", this.onPaste), this.el.removeEventListener("input", this.onInput), this.el.removeEventListener("wheel", this.onWheel);
	},
	stepBy(e, t = !1) {
		let n = l((t ? this.previousValue : c(this.el.value, this.previousValue)) + e);
		this.min != null && n < this.min && (n = this.min), this.max != null && n > this.max && (n = this.max), this.adjusting = !0, this.el.value = String(n), this.previousValue = n, this.adjusting = !1, this.el.dispatchEvent(new Event("input", { bubbles: !0 })), this.el.dispatchEvent(new Event("change", { bubbles: !0 }));
	}
}, d = "bt-theme", f = (e, t = document) => [...t.querySelectorAll(e)], p = (e = document) => e.querySelector("[data-theme-icon]"), m = (e = document, t = e.documentElement.dataset.theme) => {
	let n = p(e);
	n && (n.textContent = t === "dark" ? "☀" : "◐"), f("[data-theme-value]", e).forEach((e) => {
		e.textContent = t === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, h = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), g = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, _ = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, v = (e = document, t) => {
	f("[data-open=\"true\"].bt-menu", e).forEach((e) => {
		e !== t && (e.dataset.open = "false");
	});
}, y = (e, t = {}) => {
	let { root: n = document, storageKey: r = d, persist: i = !0 } = t;
	n.documentElement.dataset.theme = e, m(n, e), i && localStorage.setItem(r, e);
}, b = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return y(t, e), t;
}, x = (e = {}) => {
	let { root: t = document, storageKey: n = d, fallbackTheme: r = "light" } = e, i = localStorage.getItem(n) || r;
	return y(i, {
		...e,
		root: t,
		persist: !1
	}), i;
};
function S(e = {}) {
	let { root: t = document, storageKey: n = d, autoApplyStoredTheme: r = !0 } = e, i = new AbortController(), { signal: a } = i;
	r ? x({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}) : m(t);
	let o = new MutationObserver(() => m(t));
	return o.observe(t.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: a }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			b({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			g(h(r, r.dataset.dialogOpen, t));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			_(i.closest(".bt-dialog"));
			return;
		}
		let a = e.target.closest("[data-overlay-open]");
		if (a) {
			h(a, a.dataset.overlayOpen, t)?.setAttribute("open", "");
			return;
		}
		let o = e.target.closest("[data-overlay-close]");
		if (o) {
			o.closest(".bt-overlay")?.removeAttribute("open");
			return;
		}
		let s = e.target.closest("[data-menu-toggle]");
		if (s) {
			let e = h(s, s.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			v(t, e), e && (e.dataset.open = String(n));
			return;
		}
		e.target.closest(".bt-menu-wrap") || v(t);
		let c = e.target.closest("[data-expansion-toggle]");
		if (c) {
			let e = c.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let l = e.target.closest("[data-snackbar-open]");
		if (l) {
			let e = h(l, l.dataset.snackbarOpen, t);
			e && (e.dataset.open = "true", setTimeout(() => {
				e.dataset.open = "false";
			}, 3200));
			return;
		}
		let u = e.target.closest("[data-snackbar-close]");
		if (u) {
			let e = u.closest(".bt-snackbar");
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
		let d = e.target.closest("[data-tab]");
		if (d) {
			let e = d.closest("[data-tabs]");
			if (!e) return;
			f("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === d));
			}), f(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== d.dataset.tab));
			});
		}
	}, { signal: a }), () => {
		i.abort(), o.disconnect();
	};
}
//#endregion
export { o as BtCombobox, s as BtFlash, u as BtNumberStep, e as CalendarDaySelection, d as DEFAULT_THEME_STORAGE_KEY, x as applyStoredTheme, S as initBtInteractions, y as setTheme, m as syncThemeLabels, b as toggleTheme };
