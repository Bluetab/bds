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
}, f = (e) => t(e) && !e.closest("[data-demo-static]"), p = (e) => [...e.querySelectorAll("[data-focus-trap][open], .bt-modal [role=\"dialog\"]")].filter(f), m = (e) => {
	let t = e.querySelector("[autofocus]") || n(e)[0] || e;
	t === e && !e.hasAttribute("tabindex") && (e.tabIndex = -1), t.focus();
}, h = (e, t) => {
	if (e.key !== "Tab") return !1;
	let r = p(t), i = r[r.length - 1];
	if (!i) return !1;
	let a = n(i);
	if (a.length === 0) return e.preventDefault(), !0;
	let o = a[0], s = a[a.length - 1];
	return i.contains(document.activeElement) ? e.shiftKey && document.activeElement === o ? (e.preventDefault(), s.focus()) : !e.shiftKey && document.activeElement === s && (e.preventDefault(), o.focus()) : (e.preventDefault(), o.focus()), !0;
}, g = /* @__PURE__ */ new WeakMap(), _ = (e, t) => {
	t && g.set(e, t);
}, v = (e) => setTimeout(() => m(e), 0), y = (e) => {
	let t = g.get(e);
	g.delete(e), t?.isConnected && t.focus();
}, b = (e, t, n) => {
	if (e.key !== "Escape") return !1;
	let r = [...t.querySelectorAll("[data-focus-trap][open]")].filter(f), i = r[r.length - 1];
	return i ? (e.preventDefault(), n(i), !0) : !1;
}, x = (e) => {
	let t = e.dataset.tooltipDescribes, r = n(e)[0];
	if (!t || !r) return;
	let i = (r.getAttribute("aria-describedby") || "").split(/\s+/).filter(Boolean);
	i.includes(t) || r.setAttribute("aria-describedby", [...i, t].join(" "));
}, S = (e, n) => {
	let r = n.getElementById(e.getAttribute("aria-controls"));
	return r ? [...r.querySelectorAll("[role=\"option\"]")].filter(t) : [];
}, C = (e, t) => {
	if (e.closest(".bt-combobox")?.querySelectorAll("[role=\"option\"][data-active]").forEach((e) => e.removeAttribute("data-active")), !t) {
		e.removeAttribute("aria-activedescendant");
		return;
	}
	t.dataset.active = "true", e.setAttribute("aria-activedescendant", a(t, "bt-option")), t.scrollIntoView({ block: "nearest" });
}, w = (e, t) => {
	let n = e.target.closest("[data-combobox-input]");
	if (!n) return !1;
	let r = S(n, t), i = n.getAttribute("aria-activedescendant"), a = r.findIndex((e) => e.id === i);
	return e.key === "ArrowDown" || e.key === "ArrowUp" ? r.length === 0 ? !1 : (e.preventDefault(), C(n, r[e.key === "ArrowDown" ? (a + 1) % r.length : (a - 1 + r.length) % r.length]), !0) : e.key === "Enter" && a >= 0 ? (e.preventDefault(), r[a].click(), C(n, null), !0) : e.key === "Escape" && i ? (e.preventDefault(), C(n, null), !0) : !1;
}, T = (e) => e.querySelector(".bt-tree__body button, .bt-tree__body a[href]") || e.querySelector("[data-tree-toggle]"), E = (e) => {
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
	let a = [...n.querySelectorAll(".bt-tree__row")].filter(t).filter(T), o = i.querySelector("[data-tree-toggle]"), s = o?.getAttribute("aria-expanded") === "true";
	if (e.key === "ArrowRight") o && !s ? o.click() : o && a[a.indexOf(i) + 1] && T(a[a.indexOf(i) + 1]).focus();
	else if (e.key === "ArrowLeft") o && s ? o.click() : T(i.closest(".bt-tree--nested")?.closest(".bt-tree__item")?.querySelector(".bt-tree__row") || i)?.focus();
	else {
		let t = r(e.key, a.indexOf(i), a.length);
		if (t === null) return !1;
		if (e.key === "ArrowDown" && t === 0 || e.key === "ArrowUp" && t === a.length - 1) return e.preventDefault(), !0;
		T(a[t])?.focus();
	}
	return e.preventDefault(), !0;
}, D = (e) => {
	let t = e.querySelector("[data-navbar-user-trigger]");
	if (!t) return;
	let n = e.dataset.dismissed !== "true" && (e.dataset.open === "true" || e.matches(":hover") || e.matches(":focus-within"));
	t.setAttribute("aria-expanded", String(n));
};
function O(e, { signal: t, closeDialog: n }) {
	let r = null;
	e.addEventListener("focusin", (e) => {
		e.target.closest("[data-focus-trap], .bt-modal") || (r = e.target);
		let t = e.target.closest(".bt-tooltip");
		t && x(t);
		let n = e.target.closest("[data-navbar-user]");
		n && D(n);
	}, { signal: t }), e.addEventListener("focusout", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && !t.contains(e.relatedTarget) && (delete t.dataset.dismissed, t.dataset.open = "false", setTimeout(() => D(t), 0));
		let n = e.target.closest(".bt-tooltip");
		n && !n.contains(e.relatedTarget) && delete n.dataset.tooltipHidden;
	}, { signal: t }), e.addEventListener("mouseover", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && D(t);
	}, { signal: t }), e.addEventListener("mouseout", (e) => {
		let t = e.target.closest("[data-navbar-user]");
		t && !t.contains(e.relatedTarget) && setTimeout(() => D(t), 0);
	}, { signal: t }), e.addEventListener("click", (e) => {
		let t = e.target.closest("[data-navbar-user-trigger]");
		if (t) {
			let e = t.closest("[data-navbar-user]");
			t.getAttribute("aria-expanded") === "true" && e.dataset.dismissed !== "true" ? (e.dataset.dismissed = "true", e.dataset.open = "false") : (delete e.dataset.dismissed, e.dataset.open = "true"), D(e);
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
		if (!t.defaultPrevented && !s(t) && !d(t, e) && !w(t, e) && !E(t) && !h(t, e) && !b(t, e, n)) {
			if (t.key === "Escape") {
				let e = t.target.closest(".bt-tooltip");
				e && (e.dataset.tooltipHidden = "true");
				let n = t.target.closest("[data-navbar-user]");
				n && (n.dataset.dismissed = "true", n.dataset.open = "false", D(n), n.querySelector("[data-navbar-user-trigger]")?.focus());
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
var k = {
	mounted() {
		this.dragging = !1, this.dragMoved = !1, this.anchorDate = null, this.lastFocusDate = null, this.onPointerDown = (e) => {
			if (e.button !== 0 || e.shiftKey || e.metaKey || e.ctrlKey || e.target.closest("[data-calendar-day-open]")) return;
			let t = A(e.target);
			!t || !j(t) || M(t) || (this.anchorDate = t.dataset.calendarDay, this.lastFocusDate = this.anchorDate, this.dragging = !0, this.dragMoved = !1, this.el.classList.add("bt-calendar-month-grid--dragging"), this.pushBox(this.anchorDate, this.anchorDate));
		}, this.onPointerOver = (e) => {
			if (!this.dragging) return;
			let t = A(e.target);
			if (!t || !j(t)) return;
			let n = t.dataset.calendarDay;
			n !== this.lastFocusDate && (this.lastFocusDate = n, this.dragMoved = !0, this.pushBox(this.anchorDate, n));
		}, this.onPointerUp = () => {
			this.dragging && (this.dragging = !1, this.anchorDate = null, this.lastFocusDate = null, this.el.classList.remove("bt-calendar-month-grid--dragging"), window.setTimeout(() => {
				this.dragMoved = !1;
			}, 0));
		}, this.onClickCapture = (e) => {
			if (e.target.closest("[data-calendar-day-open]")) return;
			let t = A(e.target);
			if (!(!t || !j(t))) {
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
			let t = A(e.target);
			if (!t || !j(t) || e.target !== t) return;
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
function A(e) {
	return e.closest("[data-calendar-day]");
}
function j(e) {
	return e.dataset.calendarSelectable === "true";
}
function M(e) {
	return e.dataset.templateDraggable === "true";
}
//#endregion
//#region src/lib/combobox.js
var N = 4, P = 250, F = {
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
		t.style.position = "fixed", t.style.zIndex = String(P), t.style.left = `${e.left}px`, t.style.width = `${e.width}px`, t.style.right = "auto";
		let n = t.offsetHeight, r = window.innerHeight - e.bottom, i = r < n + N && e.top > r;
		t.style.top = i ? `${Math.max(N, e.top - N - n)}px` : `${e.bottom + N}px`;
	}
}, I = {
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
}, L = (e, t) => {
	let n = parseFloat(e);
	return Number.isFinite(n) ? n : t;
}, R = (e, t = 2) => Math.round(e * 10 ** t) / 10 ** t, z = {
	mounted() {
		this.increment = L(this.el.dataset.stepIncrement, .5), this.min = this.el.hasAttribute("min") ? L(this.el.min, null) : null, this.max = this.el.hasAttribute("max") ? L(this.el.max, null) : null, this.typing = !1, this.pasting = !1, this.adjusting = !1, this.previousValue = L(this.el.value, 0), this.el.setAttribute("step", "any"), this.onKeyDown = (e) => {
			if (e.key === "ArrowUp" || e.key === "ArrowDown") {
				e.preventDefault(), this.stepBy(e.key === "ArrowUp" ? this.increment : -this.increment);
				return;
			}
			(e.key.length === 1 || e.key === "Backspace" || e.key === "Delete" || e.key === "ArrowLeft" || e.key === "ArrowRight" || e.key === "Home" || e.key === "End") && (this.typing = !0);
		}, this.onKeyUp = () => {
			this.typing = !1, this.previousValue = L(this.el.value, this.previousValue);
		}, this.onPaste = () => {
			this.pasting = !0;
		}, this.onInput = () => {
			if (this.adjusting) return;
			if (this.typing || this.pasting) {
				this.pasting = !1, this.previousValue = L(this.el.value, this.previousValue);
				return;
			}
			let e = L(this.el.value, this.previousValue), t = R(e - this.previousValue, 4);
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
		let n = R((t ? this.previousValue : L(this.el.value, this.previousValue)) + e);
		this.min != null && n < this.min && (n = this.min), this.max != null && n > this.max && (n = this.max), this.adjusting = !0, this.el.value = String(n), this.previousValue = n, this.adjusting = !1, this.el.dispatchEvent(new Event("input", { bubbles: !0 })), this.el.dispatchEvent(new Event("change", { bubbles: !0 }));
	}
}, B = "bt-theme", V = (e, t = document) => [...t.querySelectorAll(e)], H = (e = document) => e.querySelector("[data-theme-icon]"), U = (e = document, t = e.documentElement.dataset.theme) => {
	let n = H(e);
	n && (n.textContent = t === "dark" ? "light_mode" : "dark_mode"), V("[data-theme-value]", e).forEach((e) => {
		e.textContent = t === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, W = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), G = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, K = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, q = (e, t, n = document) => {
	e.dataset.open = String(t), V(`[data-menu-toggle="${CSS.escape(e.id)}"]`, n).forEach((e) => {
		e.setAttribute("aria-expanded", String(t));
	});
}, J = (e = document, t) => {
	V("[data-open=\"true\"].bt-menu", e).forEach((n) => {
		n !== t && q(n, !1, e);
	});
}, Y = (e) => {
	e && (e.classList.contains("bt-overlay") ? e.removeAttribute("open") : K(e), y(e));
}, X = (e, t = {}) => {
	let { root: n = document, storageKey: r = B, persist: i = !0 } = t;
	n.documentElement.dataset.theme = e, U(n, e), i && localStorage.setItem(r, e);
}, Z = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return X(t, e), t;
}, Q = (e = {}) => {
	let { root: t = document, storageKey: n = B, fallbackTheme: r = "light" } = e, i = localStorage.getItem(n) || r;
	return X(i, {
		...e,
		root: t,
		persist: !1
	}), i;
};
function $(e = {}) {
	let { root: t = document, storageKey: n = B, autoApplyStoredTheme: r = !0 } = e, i = new AbortController(), { signal: a } = i;
	r ? Q({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}) : U(t);
	let o = new MutationObserver(() => U(t));
	o.observe(t.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: a }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			Z({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			let e = W(r, r.dataset.dialogOpen, t);
			e && (_(e, r), G(e), v(e));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			Y(i.closest(".bt-dialog"));
			return;
		}
		let a = e.target.closest("[data-overlay-open]");
		if (a) {
			let e = W(a, a.dataset.overlayOpen, t);
			e && (_(e, a), e.setAttribute("open", ""), v(e));
			return;
		}
		let o = e.target.closest("[data-overlay-close]");
		if (o) {
			Y(o.closest(".bt-overlay"));
			return;
		}
		let s = e.target.closest("[data-menu-toggle]");
		if (s) {
			let e = W(s, s.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			J(t, e), e && q(e, n, t);
			return;
		}
		let c = e.target.closest(".bt-menu [role=\"menuitem\"]");
		if (c) {
			let e = c.closest(".bt-menu");
			q(e, !1, t), t.querySelector(`[data-menu-toggle="${CSS.escape(e.id)}"]`)?.focus();
		}
		e.target.closest(".bt-menu-wrap") || J(t);
		let l = e.target.closest("[data-expansion-toggle]");
		if (l) {
			let e = l.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let u = e.target.closest("[data-snackbar-open]");
		if (u) {
			let e = W(u, u.dataset.snackbarOpen, t);
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
			V("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === f));
			}), V(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== f.dataset.tab));
			});
		}
	}, { signal: a });
	let s = O(t, {
		signal: a,
		closeDialog: Y
	});
	return () => {
		i.abort(), o.disconnect(), s();
	};
}
//#endregion
export { F as BtCombobox, I as BtFlash, z as BtNumberStep, k as CalendarDaySelection, B as DEFAULT_THEME_STORAGE_KEY, Q as applyStoredTheme, $ as initBtInteractions, X as setTheme, U as syncThemeLabels, Z as toggleTheme };
