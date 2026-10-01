/**
 * LiveView hook for `.bt-flash`: auto-dismisses after `data-auto-dismiss` ms
 * by triggering the element's `phx-click` handler.
 *
 * The timer pauses while the pointer is over the message or focus is inside it,
 * so people who read slowly or use a screen reader don't lose it (WCAG 2.2.1).
 */
export const BtFlash = {
  mounted() {
    this.pause = () => this.clearDismiss()
    this.resume = () => {
      if (!this.el.matches(':hover') && !this.el.contains(document.activeElement)) this.scheduleDismiss()
    }

    this.el.addEventListener('mouseenter', this.pause)
    this.el.addEventListener('focusin', this.pause)
    this.el.addEventListener('mouseleave', this.resume)
    this.el.addEventListener('focusout', this.resume)
    this.scheduleDismiss()
  },

  updated() {
    this.scheduleDismiss()
  },

  destroyed() {
    this.clearDismiss()
  },

  scheduleDismiss() {
    this.clearDismiss()

    const ms = parseInt(this.el.dataset.autoDismiss, 10)
    if (!ms || ms <= 0) return

    this.dismissTimer = setTimeout(() => {
      this.el.click()
    }, ms)
  },

  clearDismiss() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
      this.dismissTimer = null
    }
  }
}
