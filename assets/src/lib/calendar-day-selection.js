/**
 * LiveView hook: shift/meta click + box drag selection on `.bt-calendar-month-grid`.
 * Plain clicks use `phx-click` on each selectable day.
 */
export const CalendarDaySelection = {
  mounted() {
    this.dragging = false
    this.dragMoved = false
    this.anchorDate = null
    this.lastFocusDate = null

    this.onPointerDown = (event) => {
      if (event.button !== 0) return
      if (event.shiftKey || event.metaKey || event.ctrlKey) return
      if (event.target.closest("[data-calendar-day-open]")) return

      const day = dayEl(event.target)
      if (!day || !selectable(day)) return

      this.anchorDate = day.dataset.calendarDay
      this.lastFocusDate = this.anchorDate
      this.dragging = true
      this.dragMoved = false
      this.el.classList.add("bt-calendar-month-grid--dragging")
      this.pushBox(this.anchorDate, this.anchorDate)
    }

    this.onPointerOver = (event) => {
      if (!this.dragging) return

      const day = dayEl(event.target)
      if (!day || !selectable(day)) return

      const focus = day.dataset.calendarDay
      if (focus === this.lastFocusDate) return

      this.lastFocusDate = focus
      this.dragMoved = true
      this.pushBox(this.anchorDate, focus)
    }

    this.onPointerUp = () => {
      if (!this.dragging) return
      this.dragging = false
      this.anchorDate = null
      this.lastFocusDate = null
      this.el.classList.remove("bt-calendar-month-grid--dragging")
      window.setTimeout(() => {
        this.dragMoved = false
      }, 0)
    }

    this.onClickCapture = (event) => {
      if (event.target.closest("[data-calendar-day-open]")) return

      const day = dayEl(event.target)
      if (!day || !selectable(day)) return

      if (this.dragMoved) {
        event.preventDefault()
        event.stopPropagation()
        return
      }

      if (!event.shiftKey && !event.metaKey && !event.ctrlKey) return

      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()

      this.pushEvent("day_select", {
        date: day.dataset.calendarDay,
        shift: event.shiftKey,
        meta: event.metaKey || event.ctrlKey
      })
    }

    this.el.addEventListener("pointerdown", this.onPointerDown)
    this.el.addEventListener("pointerover", this.onPointerOver)
    this.el.addEventListener("click", this.onClickCapture, true)
    window.addEventListener("pointerup", this.onPointerUp)
  },

  destroyed() {
    this.el.removeEventListener("pointerdown", this.onPointerDown)
    this.el.removeEventListener("pointerover", this.onPointerOver)
    this.el.removeEventListener("click", this.onClickCapture, true)
    window.removeEventListener("pointerup", this.onPointerUp)
  },

  pushBox(anchor, focus) {
    this.pushEvent("day_select_box", {anchor, focus})
  }
}

function dayEl(target) {
  return target.closest("[data-calendar-day]")
}

function selectable(day) {
  return day.dataset.calendarSelectable === "true"
}
