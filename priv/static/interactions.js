//#region src/lib/a11y.js
var e = [
	"a[href]",
	"area[href]",
	"button:not([disabled])",
	"input:not([disabled]):not([type=\"hidden\"])",
	"select:not([disabled])",
	"textarea:not([disabled])",
	"iframe",
	"summary",
	"[tabindex]:not([tabindex=\"-1\"])",
	"[contenteditable=\"true\"]"
].join(","), t = (e) => !!(e.offsetWidth || e.offsetHeight || e.getClientRects().length), n = (n) => [...n.querySelectorAll(e)].filter(t), r = (e, t, n) => {
	switch (e) {
		case "ArrowRight":
		case "ArrowDown": return (t + 1) % n;
		case "ArrowLeft":
		case "ArrowUp": return (t - 1 + n) % n;
		case "Home": return 0;
		case "End": return n - 1;
		default: return null;
	}
}, i = 0, a = (e, t) => (e.id ||= `${t}-${++i}`, e.id), o = (e, { focus: t = !1 } = {}) => {
	let n = e.closest("[data-tabs]");
	n && (n.querySelectorAll("[role=\"tab\"]").forEach((t) => {
		let n = t === e;
		t.setAttribute("aria-selected", String(n)), t.tabIndex = n ? 0 : -1;
	}), n.querySelectorAll(".bt-tab-panel").forEach((t) => {
		t.setAttribute("aria-hidden", String(t.id !== e.dataset.tab));
	}), t && e.focus());
}, s = (e) => {
	let t = e.target.closest("[role=\"tab\"]"), n = t?.closest("[role=\"tablist\"]");
	if (!n) return !1;
	let i = [...n.querySelectorAll("[role=\"tab\"]")], a = r(e.key, i.indexOf(t), i.length);
	return a === null ? !1 : (e.preventDefault(), o(i[a], { focus: !0 }), !0);
}, c = (e) => [...e.querySelectorAll("[role=\"menuitem\"]")].filter(t), l = (e, t, n) => {
	e && (e.dataset.open = String(t), n.querySelectorAll(`[data-menu-toggle="${CSS.escape(e.id)}"]`).forEach((e) => {
		e.setAttribute("aria-expanded", String(t));
	}));
}, u = (e, t) => t.querySelector(`[data-menu-toggle="${CSS.escape(e.id)}"]`), d = (e, t) => {
	let n = e.target.closest("[data-menu-toggle]");
	if (n && [
		"ArrowDown",
		"ArrowUp",
		"Enter",
		" "
	].includes(e.key)) {
		let r = t.getElementById(n.dataset.menuToggle);
		if (!r) return !1;
		e.preventDefault(), l(r, !0, t);
		let i = c(r);
		return (e.key === "ArrowUp" ? i[i.length - 1] : i[0])?.focus(), !0;
	}
	let i = e.target.closest(".bt-menu[role=\"menu\"]");
	if (!i) return !1;
	let a = c(i);
	if (e.key === "Escape") return e.preventDefault(), l(i, !1, t), u(i, t)?.focus(), !0;
	if (e.key === "Tab") return l(i, !1, t), !1;
	let o = r(e.key, a.indexOf(e.target.closest("[role=\"menuitem\"]")), a.length);
	return o === null ? !1 : (e.preventDefault(), a[o]?.focus(), !0);
}, f = (e) => [...e.querySelectorAll("[data-focus-trap][open], .bt-modal [role=\"dialog\"]")].filter(t), p = (e) => {
	let t = e.querySelector("[autofocus]") || n(e)[0] || e;
	t === e && !e.hasAttribute("tabindex") && (e.tabIndex = -1), t.focus();
}, m = (e, t) => {
	if (e.key !== "Tab") return !1;
	let r = f(t), i = r[r.length - 1];
	if (!i) return !1;
	let a = n(i);
	if (a.length === 0) return e.preventDefault(), !0;
	let o = a[0], s = a[a.length - 1];
	return i.contains(document.activeElement) ? e.shiftKey && document.activeElement === o ? (e.preventDefault(), s.focus()) : !e.shiftKey && document.activeElement === s && (e.preventDefault(), o.focus()) : (e.preventDefault(), o.focus()), !0;
}, h = /* @__PURE__ */ new WeakMap(), g = (e, t) => {
	t && h.set(e, t);
}, _ = (e) => setTimeout(() => p(e), 0), v = (e) => {
	let t = h.get(e);
	h.delete(e), t?.isConnected && t.focus();
}, y = (e, n, r) => {
	if (e.key !== "Escape") return !1;
	let i = [...n.querySelectorAll("[data-focus-trap][open]")].filter(t), a = i[i.length - 1];
	return a ? (e.preventDefault(), r(a), !0) : !1;
}, b = (e) => {
	let t = e.dataset.tooltipDescribes, r = n(e)[0];
	if (!t || !r) return;
	let i = (r.getAttribute("aria-describedby") || "").split(/\s+/).filter(Boolean);
	i.includes(t) || r.setAttribute("aria-describedby", [...i, t].join(" "));
}, x = (e, n) => {
	let r = n.getElementById(e.getAttribute("aria-controls"));
	return r ? [...r.querySelectorAll("[role=\"option\"]")].filter(t) : [];
}, S = (e, t) => {
	if (e.closest(".bt-combobox")?.querySelectorAll("[role=\"option\"][data-active]").forEach((e) => e.removeAttribute("data-active")), !t) {
		e.removeAttribute("aria-activedescendant");
		return;
	}
	t.dataset.active = "true", e.setAttribute("aria-activedescendant", a(t, "bt-option")), t.scrollIntoView({ block: "nearest" });
}, C = (e, t) => {
	let n = e.target.closest("[data-combobox-input]");
	if (!n) return !1;
	let r = x(n, t), i = n.getAttribute("aria-activedescendant"), a = r.findIndex((e) => e.id === i);
	return e.key === "ArrowDown" || e.key === "ArrowUp" ? r.length === 0 ? !1 : (e.preventDefault(), S(n, r[e.key === "ArrowDown" ? (a + 1) % r.length : (a - 1 + r.length) % r.length]), !0) : e.key === "Enter" && a >= 0 ? (e.preventDefault(), r[a].click(), S(n, null), !0) : e.key === "Escape" && i ? (e.preventDefault(), S(n, null), !0) : !1;
}, w = (e) => e.querySelector(".bt-tree__body button, .bt-tree__body a[href]") || e.querySelector("[data-tree-toggle]"), T = (e) => {
	let n = e.target.closest("[data-bt-tree]");
	if (!n || ![
		"ArrowUp",
		"ArrowDown",
		"ArrowLeft",
		"ArrowRight",
		"Home",
		"End"
	].includes(e.key)) return !1;
	let i = e.target.closest(".bt-tree__row");
	if (!i) return !1;
	let a = [...n.querySelectorAll(".bt-tree__row")].filter(t).filter(w), o = i.querySelector("[data-tree-toggle]"), s = o?.getAttribute("aria-expanded") === "true";
	if (e.key === "ArrowRight") o && !s ? o.click() : o && a[a.indexOf(i) + 1] && w(a[a.indexOf(i) + 1]).focus();
	else if (e.key === "ArrowLeft") o && s ? o.click() : w(i.closest(".bt-tree--nested")?.closest(".bt-tree__item")?.querySelector(".bt-tree__row") || i)?.focus();
	else {
		let t = r(e.key, a.indexOf(i), a.length);
		if (t === null) return !1;
		if (e.key === "ArrowDown" && t === 0 || e.key === "ArrowUp" && t === a.length - 1) return e.preventDefault(), !0;
		w(a[t])?.focus();
	}
	return e.preventDefault(), !0;
}, E = (e) => {
	let t = e.querySelector("[data-navbar-user-trigger]");
	if (!t) return;
	let n = e.dataset.dismissed !== "true" && (e.dataset.open === "true" || e.matches(":hover") || e.matches(":focus-within"));
	t.setAttribute("aria-expanded", String(n));
};
function D(e, { signal: t, closeDialog: n }) {
	let r = null;
	e.addEventListener("focusin", (e) => {
		e.target.closest("[data-focus-trap], .bt-modal") || (r = e.target);
		let t = e.target.closest(".bt-tooltip");
		t && b(t);
		let n = e.target.closest("[data-navbar-user]");
		n && E(n);
	}, { signal: t }), e.addEventListener("focusout", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && !t.contains(e.relatedTarget) && (delete t.dataset.dismissed, t.dataset.open = "false", setTimeout(() => E(t), 0));
		let n = e.target.closest(".bt-tooltip");
		n && !n.contains(e.relatedTarget) && delete n.dataset.tooltipHidden;
	}, { signal: t }), e.addEventListener("mouseover", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && E(t);
	}, { signal: t }), e.addEventListener("mouseout", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && !t.contains(e.relatedTarget) && setTimeout(() => E(t), 0);
	}, { signal: t }), e.addEventListener("click", (e) => {
		let t = e.target.closest("[data-navbar-user-trigger]");
		if (t) {
			let e = t.closest("[data-navbar-user]");
			t.getAttribute("aria-expanded") === "true" && e.dataset.dismissed !== "true" ? (e.dataset.dismissed = "true", e.dataset.open = "false") : (delete e.dataset.dismissed, e.dataset.open = "true"), E(e);
			return;
		}
		let n = e.target.closest("[data-expansion-toggle]");
		if (n) {
			let e = n.closest("[data-expansion]");
			n.setAttribute("aria-expanded", String(e?.dataset.open === "true"));
		}
		let r = e.target.closest("[role=\"tab\"][data-tab]");
		r && o(r);
	}, { signal: t }), e.addEventListener("keydown", (t) => {
		if (!t.defaultPrevented && !s(t) && !d(t, e) && !C(t, e) && !T(t) && !m(t, e) && !y(t, e, n)) {
			if (t.key === "Escape") {
				let e = t.target.closest(".bt-tooltip");
				e && (e.dataset.tooltipHidden = "true");
				let n = t.target.closest("[data-navbar-user]");
				n && (n.dataset.dismissed = "true", n.dataset.open = "false", E(n), n.querySelector("[data-navbar-user-trigger]")?.focus());
				return;
			}
			(t.key === "Enter" || t.key === " ") && t.target.matches("[role=\"button\"]:not(button):not(a):not(input)") && (t.preventDefault(), t.target.click());
		}
	}, { signal: t });
	let i = new MutationObserver((e) => {
		e.some((e) => [...e.removedNodes].some((e) => e.nodeType === 1 && (e.matches?.("[data-focus-return]") || e.querySelector?.("[data-focus-return]")))) && r?.isConnected && (document.activeElement === document.body || !document.activeElement) && r.focus();
	});
	return i.observe(e.body || e, {
		childList: !0,
		subtree: !0
	}), () => i.disconnect();
}
//#endregion
//#region src/lib/calendar-day-selection.js
var O = {
	mounted() {
		this.dragging = !1, this.dragMoved = !1, this.anchorDate = null, this.lastFocusDate = null, this.onPointerDown = (e) => {
			if (e.button !== 0 || e.shiftKey || e.metaKey || e.ctrlKey || e.target.closest("[data-calendar-day-open]")) return;
			let t = k(e.target);
			!t || !A(t) || j(t) || (this.anchorDate = t.dataset.calendarDay, this.lastFocusDate = this.anchorDate, this.dragging = !0, this.dragMoved = !1, this.el.classList.add("bt-calendar-month-grid--dragging"), this.pushBox(this.anchorDate, this.anchorDate));
		}, this.onPointerOver = (e) => {
			if (!this.dragging) return;
			let t = k(e.target);
			if (!t || !A(t)) return;
			let n = t.dataset.calendarDay;
			n !== this.lastFocusDate && (this.lastFocusDate = n, this.dragMoved = !0, this.pushBox(this.anchorDate, n));
		}, this.onPointerUp = () => {
			this.dragging && (this.dragging = !1, this.anchorDate = null, this.lastFocusDate = null, this.el.classList.remove("bt-calendar-month-grid--dragging"), window.setTimeout(() => {
				this.dragMoved = !1;
			}, 0));
		}, this.onClickCapture = (e) => {
			if (e.target.closest("[data-calendar-day-open]")) return;
			let t = k(e.target);
			if (!(!t || !A(t))) {
				if (this.dragMoved) {
					e.preventDefault(), e.stopPropagation();
					return;
				}
				e.preventDefault(), e.stopPropagation(), e.stopImmediatePropagation(), this.pushEvent("day_select", {
					date: t.dataset.calendarDay,
					shift: e.shiftKey,
					meta: e.metaKey || e.ctrlKey
				});
			}
		}, this.onKeyDown = (e) => {
			let t = k(e.target);
			if (!t || !A(t) || e.target !== t) return;
			if (e.key === " " || e.key === "Enter") {
				e.preventDefault(), this.pushEvent("day_select", {
					date: t.dataset.calendarDay,
					shift: e.shiftKey,
					meta: e.metaKey || e.ctrlKey
				});
				return;
			}
			let n = this.neighbour(t, e.key);
			n && (e.preventDefault(), n.focus());
		}, this.el.addEventListener("keydown", this.onKeyDown), this.el.addEventListener("pointerdown", this.onPointerDown), this.el.addEventListener("pointerover", this.onPointerOver), this.el.addEventListener("click", this.onClickCapture, !0), window.addEventListener("pointerup", this.onPointerUp);
	},
	destroyed() {
		this.el.removeEventListener("keydown", this.onKeyDown), this.el.removeEventListener("pointerdown", this.onPointerDown), this.el.removeEventListener("pointerover", this.onPointerOver), this.el.removeEventListener("click", this.onClickCapture, !0), window.removeEventListener("pointerup", this.onPointerUp);
	},
	neighbour(e, t) {
		let n = parseInt(e.dataset.calendarGridRow, 10), r = parseInt(e.dataset.calendarGridCol, 10);
		if (Number.isNaN(n) || Number.isNaN(r)) return null;
		let i = [...this.el.querySelectorAll("[data-calendar-selectable=\"true\"]")], a = (e, t) => i.find((n) => n.dataset.calendarGridRow === String(e) && n.dataset.calendarGridCol === String(t)), o = i.filter((e) => e.dataset.calendarGridRow === String(n));
		switch (t) {
			case "ArrowRight": return a(n, r + 1) || i[i.indexOf(e) + 1];
			case "ArrowLeft": return a(n, r - 1) || i[i.indexOf(e) - 1];
			case "ArrowDown": return a(n + 1, r);
			case "ArrowUp": return a(n - 1, r);
			case "Home": return o[0];
			case "End": return o[o.length - 1];
			default: return null;
		}
	},
	pushBox(e, t) {
		this.pushEvent("day_select_box", {
			anchor: e,
			focus: t
		});
	}
};
function k(e) {
	return e.closest("[data-calendar-day]");
}
function A(e) {
	return e.dataset.calendarSelectable === "true";
}
function j(e) {
	return e.dataset.templateDraggable === "true";
}
//#endregion
//#region src/lib/combobox.js
var M = 4, N = 250, P = {
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
		t.style.position = "fixed", t.style.zIndex = String(N), t.style.left = `${e.left}px`, t.style.width = `${e.width}px`, t.style.right = "auto";
		let n = t.offsetHeight, r = window.innerHeight - e.bottom, i = r < n + M && e.top > r;
		t.style.top = i ? `${Math.max(M, e.top - M - n)}px` : `${e.bottom + M}px`;
	}
}, F = {
	mounted() {
		this.pause = () => this.clearDismiss(), this.resume = () => {
			!this.el.matches(":hover") && !this.el.contains(document.activeElement) && this.scheduleDismiss();
		}, this.el.addEventListener("mouseenter", this.pause), this.el.addEventListener("focusin", this.pause), this.el.addEventListener("mouseleave", this.resume), this.el.addEventListener("focusout", this.resume), this.scheduleDismiss();
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
}, I = (e, t) => {
	let n = parseFloat(e);
	return Number.isFinite(n) ? n : t;
}, L = (e, t = 2) => Math.round(e * 10 ** t) / 10 ** t, R = {
	mounted() {
		this.increment = I(this.el.dataset.stepIncrement, .5), this.min = this.el.hasAttribute("min") ? I(this.el.min, null) : null, this.max = this.el.hasAttribute("max") ? I(this.el.max, null) : null, this.typing = !1, this.pasting = !1, this.adjusting = !1, this.previousValue = I(this.el.value, 0), this.el.setAttribute("step", "any"), this.onKeyDown = (e) => {
			if (e.key === "ArrowUp" || e.key === "ArrowDown") {
				e.preventDefault(), this.stepBy(e.key === "ArrowUp" ? this.increment : -this.increment);
				return;
			}
			(e.key.length === 1 || e.key === "Backspace" || e.key === "Delete" || e.key === "ArrowLeft" || e.key === "ArrowRight" || e.key === "Home" || e.key === "End") && (this.typing = !0);
		}, this.onKeyUp = () => {
			this.typing = !1, this.previousValue = I(this.el.value, this.previousValue);
		}, this.onPaste = () => {
			this.pasting = !0;
		}, this.onInput = () => {
			if (this.adjusting) return;
			if (this.typing || this.pasting) {
				this.pasting = !1, this.previousValue = I(this.el.value, this.previousValue);
				return;
			}
			let e = I(this.el.value, this.previousValue), t = L(e - this.previousValue, 4);
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
		let n = L((t ? this.previousValue : I(this.el.value, this.previousValue)) + e);
		this.min != null && n < this.min && (n = this.min), this.max != null && n > this.max && (n = this.max), this.adjusting = !0, this.el.value = String(n), this.previousValue = n, this.adjusting = !1, this.el.dispatchEvent(new Event("input", { bubbles: !0 })), this.el.dispatchEvent(new Event("change", { bubbles: !0 }));
	}
}, z = "bt-theme", B = (e, t = document) => [...t.querySelectorAll(e)], V = (e = document) => e.querySelector("[data-theme-icon]"), H = (e = document, t = e.documentElement.dataset.theme) => {
	let n = V(e);
	n && (n.textContent = t === "dark" ? "light_mode" : "dark_mode"), B("[data-theme-value]", e).forEach((e) => {
		e.textContent = t === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, U = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), W = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, G = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, K = (e, t, n = document) => {
	e.dataset.open = String(t), B(`[data-menu-toggle="${CSS.escape(e.id)}"]`, n).forEach((e) => {
		e.setAttribute("aria-expanded", String(t));
	});
}, q = (e = document, t) => {
	B("[data-open=\"true\"].bt-menu", e).forEach((n) => {
		n !== t && K(n, !1, e);
	});
}, J = (e) => {
	e && (e.classList.contains("bt-overlay") ? e.removeAttribute("open") : G(e), v(e));
}, Y = (e, t = {}) => {
	let { root: n = document, storageKey: r = z, persist: i = !0 } = t;
	n.documentElement.dataset.theme = e, H(n, e), i && localStorage.setItem(r, e);
}, X = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return Y(t, e), t;
}, Z = (e = {}) => {
	let { root: t = document, storageKey: n = z, fallbackTheme: r = "light" } = e, i = localStorage.getItem(n) || r;
	return Y(i, {
		...e,
		root: t,
		persist: !1
	}), i;
};
function Q(e = {}) {
	let { root: t = document, storageKey: n = z, autoApplyStoredTheme: r = !0 } = e, i = new AbortController(), { signal: a } = i;
	r ? Z({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}) : H(t);
	let o = new MutationObserver(() => H(t));
	o.observe(t.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: a }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			X({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			let e = U(r, r.dataset.dialogOpen, t);
			e && (g(e, r), W(e), _(e));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			J(i.closest(".bt-dialog"));
			return;
		}
		let a = e.target.closest("[data-overlay-open]");
		if (a) {
			let e = U(a, a.dataset.overlayOpen, t);
			e && (g(e, a), e.setAttribute("open", ""), _(e));
			return;
		}
		let o = e.target.closest("[data-overlay-close]");
		if (o) {
			J(o.closest(".bt-overlay"));
			return;
		}
		let s = e.target.closest("[data-menu-toggle]");
		if (s) {
			let e = U(s, s.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			q(t, e), e && K(e, n, t);
			return;
		}
		let c = e.target.closest(".bt-menu [role=\"menuitem\"]");
		if (c) {
			let e = c.closest(".bt-menu");
			K(e, !1, t), t.querySelector(`[data-menu-toggle="${CSS.escape(e.id)}"]`)?.focus();
		}
		e.target.closest(".bt-menu-wrap") || q(t);
		let l = e.target.closest("[data-expansion-toggle]");
		if (l) {
			let e = l.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let u = e.target.closest("[data-snackbar-open]");
		if (u) {
			let e = U(u, u.dataset.snackbarOpen, t);
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
		let f = e.target.closest("[data-tab]");
		if (f) {
			let e = f.closest("[data-tabs]");
			if (!e) return;
			B("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === f));
			}), B(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== f.dataset.tab));
			});
		}
	}, { signal: a });
	let s = D(t, {
		signal: a,
		closeDialog: J
	});
	return () => {
		i.abort(), o.disconnect(), s();
	};
}
//#endregion
export { P as BtCombobox, F as BtFlash, R as BtNumberStep, O as CalendarDaySelection, z as DEFAULT_THEME_STORAGE_KEY, Z as applyStoredTheme, Q as initBtInteractions, Y as setTheme, H as syncThemeLabels, X as toggleTheme };
