/**
 * LiveView hook on `.bt-combobox`: when open, portals the panel to `document.body`
 * and pins it with fixed positioning so it escapes overflow/stacking ancestors.
 * Cleans up the portaled panel when the combobox closes or is removed.
 */
const GAP = 4
const PANEL_Z_INDEX = 250

export const BtCombobox = {
  mounted() {
    this.sync()
  },

  updated() {
    this.sync()
  },

  destroyed() {
    this.cleanup()
  },

  sync() {
    const open = this.el.classList.contains("bt-combobox--open")

    if (!open) {
      this.cleanup()
      return
    }

    const panel = this.el.querySelector(".bt-combobox__panel") || this.activePanel()

    if (panel) {
      this.portal(panel)
    }
  },

  activePanel() {
    return this.panel?.isConnected ? this.panel : null
  },

  portal(panel) {
    if (this.panel === panel && panel.parentNode === document.body) {
      requestAnimationFrame(() => this.position())
      return
    }

    this.cleanup()

    this.panel = panel
    this.anchor = this.el.querySelector(".bt-combobox__input-wrap") || this.el

    panel.classList.add("bt-combobox__panel--portal")
    document.body.appendChild(panel)

    if (!this.reposition) {
      this.reposition = () => this.position()
      window.addEventListener("scroll", this.reposition, true)
      window.addEventListener("resize", this.reposition)
    }

    requestAnimationFrame(() => this.position())
  },

  cleanup() {
    if (this.panel?.isConnected) {
      this.panel.remove()
    }

    this.panel = null
    this.anchor = null

    if (this.reposition) {
      window.removeEventListener("scroll", this.reposition, true)
      window.removeEventListener("resize", this.reposition)
      this.reposition = null
    }
  },

  position() {
    if (!this.anchor || !this.panel) return

    const rect = this.anchor.getBoundingClientRect()
    const el = this.panel

    el.style.position = "fixed"
    el.style.zIndex = String(PANEL_Z_INDEX)
    el.style.left = `${rect.left}px`
    el.style.width = `${rect.width}px`
    el.style.right = "auto"

    const panelHeight = el.offsetHeight
    const spaceBelow = window.innerHeight - rect.bottom
    const openUp = spaceBelow < panelHeight + GAP && rect.top > spaceBelow

    el.style.top = openUp
      ? `${Math.max(GAP, rect.top - GAP - panelHeight)}px`
      : `${rect.bottom + GAP}px`
  }
}
