/**
 * LiveView hook for `.bt-flash`: auto-dismisses after `data-auto-dismiss` ms
 * by triggering the element's `phx-click` handler.
 */
export const BtFlash = {
  mounted() {
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
