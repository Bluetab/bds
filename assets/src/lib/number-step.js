const parseNum = (value, fallback) => {
  const n = parseFloat(value);
  return Number.isFinite(n) ? n : fallback;
};

const roundTo = (value, precision = 2) =>
  Math.round(value * 10 ** precision) / 10 ** precision;

/**
 * Number input with free-form manual entry but fixed increment on spinners / arrow keys.
 *
 * Set `data-step-increment` (e.g. "0.5") and `step="any"` on the element.
 */
export const BtNumberStep = {
  mounted() {
    this.increment = parseNum(this.el.dataset.stepIncrement, 0.5);
    this.min = this.el.hasAttribute('min') ? parseNum(this.el.min, null) : null;
    this.max = this.el.hasAttribute('max') ? parseNum(this.el.max, null) : null;
    this.typing = false;
    this.pasting = false;
    this.adjusting = false;
    this.previousValue = parseNum(this.el.value, 0);

    this.el.setAttribute('step', 'any');

    this.onKeyDown = (event) => {
      if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
        event.preventDefault();
        this.stepBy(event.key === 'ArrowUp' ? this.increment : -this.increment);
        return;
      }

      if (
        event.key.length === 1 ||
        event.key === 'Backspace' ||
        event.key === 'Delete' ||
        event.key === 'ArrowLeft' ||
        event.key === 'ArrowRight' ||
        event.key === 'Home' ||
        event.key === 'End'
      ) {
        this.typing = true;
      }
    };

    this.onKeyUp = () => {
      this.typing = false;
      this.previousValue = parseNum(this.el.value, this.previousValue);
    };

    this.onPaste = () => {
      this.pasting = true;
    };

    this.onInput = () => {
      if (this.adjusting) return;

      if (this.typing || this.pasting) {
        this.pasting = false;
        this.previousValue = parseNum(this.el.value, this.previousValue);
        return;
      }

      const next = parseNum(this.el.value, this.previousValue);
      const diff = roundTo(next - this.previousValue, 4);

      // Native spinners use step=1 when step="any"; remap ±1 to our increment.
      if (Math.abs(Math.abs(diff) - 1) < 0.0001) {
        this.stepBy(diff > 0 ? this.increment : -this.increment, true);
        return;
      }

      this.previousValue = next;
    };

    this.onWheel = (event) => {
      if (document.activeElement !== this.el) return;
      event.preventDefault();
      this.stepBy(event.deltaY < 0 ? this.increment : -this.increment);
    };

    this.el.addEventListener('keydown', this.onKeyDown);
    this.el.addEventListener('keyup', this.onKeyUp);
    this.el.addEventListener('paste', this.onPaste);
    this.el.addEventListener('input', this.onInput);
    this.el.addEventListener('wheel', this.onWheel, { passive: false });
  },

  destroyed() {
    this.el.removeEventListener('keydown', this.onKeyDown);
    this.el.removeEventListener('keyup', this.onKeyUp);
    this.el.removeEventListener('paste', this.onPaste);
    this.el.removeEventListener('input', this.onInput);
    this.el.removeEventListener('wheel', this.onWheel);
  },

  stepBy(delta, fromPrevious = false) {
    const current = fromPrevious
      ? this.previousValue
      : parseNum(this.el.value, this.previousValue);
    let next = roundTo(current + delta);

    if (this.min != null && next < this.min) next = this.min;
    if (this.max != null && next > this.max) next = this.max;

    this.adjusting = true;
    this.el.value = String(next);
    this.previousValue = next;
    this.adjusting = false;

    this.el.dispatchEvent(new Event('input', { bubbles: true }));
    this.el.dispatchEvent(new Event('change', { bubbles: true }));
  }
};
