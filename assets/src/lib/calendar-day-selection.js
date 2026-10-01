/**
 * LiveView hook: shift/meta click + box drag selection on `.bt-calendar-month-grid`.
 * Plain clicks use `phx-click` on each selectable day.
 *
 * Keyboard (the drag selection has no keyboard equivalent otherwise, WCAG 2.1.1):
 *   Space / Enter      select the focused day (Shift extends, Cmd/Ctrl toggles)
 *   Arrow keys         move between days in the grid; Home / End: start / end of week
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
      if (!day || !selectable(day) || templateDraggable(day)) return

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

      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()

      this.pushEvent("day_select", {
        date: day.dataset.calendarDay,
        shift: event.shiftKey,
        meta: event.metaKey || event.ctrlKey
      })
    }

    this.onKeyDown = (event) => {
      const day = dayEl(event.target)
      if (!day || !selectable(day) || event.target !== day) return

      if (event.key === " " || event.key === "Enter") {
        event.preventDefault()
        this.pushEvent("day_select", {
          date: day.dataset.calendarDay,
          shift: event.shiftKey,
          meta: event.metaKey || event.ctrlKey
        })
        return
      }

      const target = this.neighbour(day, event.key)
      if (target) {
        event.preventDefault()
        target.focus()
      }
    }

    this.el.addEventListener("keydown", this.onKeyDown)
    this.el.addEventListener("pointerdown", this.onPointerDown)
    this.el.addEventListener("pointerover", this.onPointerOver)
    this.el.addEventListener("click", this.onClickCapture, true)
    window.addEventListener("pointerup", this.onPointerUp)
  },

  destroyed() {
    this.el.removeEventListener("keydown", this.onKeyDown)
    this.el.removeEventListener("pointerdown", this.onPointerDown)
    this.el.removeEventListener("pointerover", this.onPointerOver)
    this.el.removeEventListener("click", this.onClickCapture, true)
    window.removeEventListener("pointerup", this.onPointerUp)
  },

  neighbour(day, key) {
    const row = parseInt(day.dataset.calendarGridRow, 10)
    const col = parseInt(day.dataset.calendarGridCol, 10)
    if (Number.isNaN(row) || Number.isNaN(col)) return null

    const days = [...this.el.querySelectorAll('[data-calendar-selectable="true"]')]
    const at = (r, c) =>
      days.find((d) => d.dataset.calendarGridRow === String(r) && d.dataset.calendarGridCol === String(c))
    const inRow = days.filter((d) => d.dataset.calendarGridRow === String(row))

    switch (key) {
      case "ArrowRight": return at(row, col + 1) || days[days.indexOf(day) + 1]
      case "ArrowLeft": return at(row, col - 1) || days[days.indexOf(day) - 1]
      case "ArrowDown": return at(row + 1, col)
      case "ArrowUp": return at(row - 1, col)
      case "Home": return inRow[0]
      case "End": return inRow[inRow.length - 1]
      default: return null
    }
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

function templateDraggable(day) {
  return day.dataset.templateDraggable === "true"
}
