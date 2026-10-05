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
//#region src/lib/interactions.js
var k = "bt-theme", A = (e, t = document) => [...t.querySelectorAll(e)], j = (e = document) => e.querySelector("[data-theme-icon]"), M = (e = document, t = e.documentElement.dataset.theme) => {
	let n = j(e);
	n && (n.textContent = t === "dark" ? "light_mode" : "dark_mode"), A("[data-theme-value]", e).forEach((e) => {
		e.textContent = t === "dark" ? e.dataset.dark || "Dark" : e.dataset.light || "Light";
	});
}, N = (e, t, n = document) => (e.closest(".bt-example, .bt-doc-card, .bt-shell, main, body") || n).querySelector(`#${CSS.escape(t)}`) || n.getElementById(t), P = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			!e.open && typeof e.showModal == "function" && e.showModal();
			return;
		}
		e.setAttribute("open", "");
	}
}, F = (e) => {
	if (e) {
		if (typeof HTMLDialogElement < "u" && e instanceof HTMLDialogElement) {
			e.open && typeof e.close == "function" && e.close();
			return;
		}
		e.removeAttribute("open");
	}
}, I = (e, t, n = document) => {
	e.dataset.open = String(t), A(`[data-menu-toggle="${CSS.escape(e.id)}"]`, n).forEach((e) => {
		e.setAttribute("aria-expanded", String(t));
	});
}, L = (e = document, t) => {
	A("[data-open=\"true\"].bt-menu", e).forEach((n) => {
		n !== t && I(n, !1, e);
	});
}, R = (e) => {
	e && (e.classList.contains("bt-overlay") ? e.removeAttribute("open") : F(e), y(e));
}, z = (e, t = {}) => {
	let { root: n = document, storageKey: r = k, persist: i = !0 } = t;
	n.documentElement.dataset.theme = e, M(n, e), i && localStorage.setItem(r, e);
}, B = (e = {}) => {
	let t = (e.root || document).documentElement.dataset.theme === "dark" ? "light" : "dark";
	return z(t, e), t;
}, V = (e = {}) => {
	let { root: t = document, storageKey: n = k, fallbackTheme: r = "light" } = e, i = localStorage.getItem(n) || r;
	return z(i, {
		...e,
		root: t,
		persist: !1
	}), i;
};
function H(e = {}) {
	let { root: t = document, storageKey: n = k, autoApplyStoredTheme: r = !0 } = e, i = new AbortController(), { signal: a } = i;
	r ? V({
		root: t,
		storageKey: n,
		fallbackTheme: t.documentElement.dataset.theme || "light"
	}) : M(t);
	let o = new MutationObserver(() => M(t));
	o.observe(t.documentElement, {
		attributes: !0,
		attributeFilter: ["data-theme"]
	}), t.addEventListener("mousedown", (e) => {
		e.target.closest(".bt-combobox__panel") && e.preventDefault();
	}, { signal: a }), t.addEventListener("click", (e) => {
		if (e.target.closest("[data-theme-toggle]")) {
			B({
				root: t,
				storageKey: n
			});
			return;
		}
		let r = e.target.closest("[data-dialog-open]");
		if (r) {
			let e = N(r, r.dataset.dialogOpen, t);
			e && (_(e, r), P(e), v(e));
			return;
		}
		let i = e.target.closest("[data-dialog-close]");
		if (i) {
			R(i.closest(".bt-dialog"));
			return;
		}
		let a = e.target.closest("[data-overlay-open]");
		if (a) {
			let e = N(a, a.dataset.overlayOpen, t);
			e && (_(e, a), e.setAttribute("open", ""), v(e));
			return;
		}
		let o = e.target.closest("[data-overlay-close]");
		if (o) {
			R(o.closest(".bt-overlay"));
			return;
		}
		let s = e.target.closest("[data-menu-toggle]");
		if (s) {
			let e = N(s, s.dataset.menuToggle, t), n = e?.dataset.open !== "true";
			L(t, e), e && I(e, n, t);
			return;
		}
		let c = e.target.closest(".bt-menu [role=\"menuitem\"]");
		if (c) {
			let e = c.closest(".bt-menu");
			I(e, !1, t), t.querySelector(`[data-menu-toggle="${CSS.escape(e.id)}"]`)?.focus();
		}
		e.target.closest(".bt-menu-wrap") || L(t);
		let l = e.target.closest("[data-expansion-toggle]");
		if (l) {
			let e = l.closest("[data-expansion]");
			e.dataset.open = e.dataset.open === "true" ? "false" : "true";
			return;
		}
		let u = e.target.closest("[data-snackbar-open]");
		if (u) {
			let e = N(u, u.dataset.snackbarOpen, t);
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
			A("[role=\"tab\"]", e).forEach((e) => {
				e.setAttribute("aria-selected", String(e === f));
			}), A(".bt-tab-panel", e).forEach((e) => {
				e.setAttribute("aria-hidden", String(e.id !== f.dataset.tab));
			});
		}
	}, { signal: a });
	let s = O(t, {
		signal: a,
		closeDialog: R
	});
	return () => {
		i.abort(), o.disconnect(), s();
	};
}
//#endregion
export { k as DEFAULT_THEME_STORAGE_KEY, V as applyStoredTheme, H as initBtInteractions, z as setTheme, B as toggleTheme };
