import { Controller } from "@hotwired/stimulus"

/**
 * Character Count Controller
 *
 * A reusable Stimulus controller that tracks character count in text inputs/textareas
 * and displays real-time feedback with customizable limits and styling.
 *
 * Usage:
 * <div data-controller="character-count" data-character-count-max-value="280">
 *   <textarea data-character-count-target="input" placeholder="Type something..."></textarea>
 *   <div data-character-count-target="counter">0/280</div>
 * </div>
 *
 * Options:
 * - data-character-count-max-value: Maximum character limit (default: 4000)
 * - data-character-count-warn-at-value: Show warning at this count (default: 90% of max)
 * - data-character-count-format-value: Display format - "count", "remaining", or "fraction" (default: "fraction")
 *
 * CSS Classes (automatically applied):
 * - character-count-normal: Normal state
 * - character-count-warning: Warning state (near limit)
 * - character-count-danger: Danger state (at/over limit)
 */
export default class extends Controller {
  static targets = ["input", "counter"]
  static values = {
    max: { type: Number, default: 4000 },
    warnAt: { type: Number, default: null },
    format: { type: String, default: "fraction" }, // "count", "remaining", "fraction"
  }

  connect() {
    // Set default warn threshold if not provided (90% of max)
    if (this.warnAtValue === null) {
      this.warnAtValue = Math.floor(this.maxValue * 0.9)
    }

    // Initialize the counter
    this.updateCounter()

    // Set up event listeners
    this.inputTarget.addEventListener("input", this.updateCounter.bind(this))
    this.inputTarget.addEventListener("paste", () => {
      // Handle paste events with a slight delay to capture pasted content
      setTimeout(() => this.updateCounter(), 10)
    })
  }

  disconnect() {
    // Clean up event listeners if needed
    this.inputTarget.removeEventListener("input", this.updateCounter.bind(this))
  }

  updateCounter() {
    if (!this.hasInputTarget || !this.hasCounterTarget) return
    const currentLength = this.inputTarget.value.length
    const remaining = this.maxValue - currentLength

    // Update counter text based on format
    this.counterTarget.textContent = this.getFormattedCount(
      currentLength,
      remaining
    )

    // Update CSS classes based on character count
    this.updateCounterClasses(currentLength, remaining)

    // Dispatch custom event for external listeners
    this.dispatch("update", {
      detail: {
        current: currentLength,
        max: this.maxValue,
        remaining: remaining,
        percentage: (currentLength / this.maxValue) * 100,
      },
    })
  }

  getFormattedCount(current, remaining) {
    switch (this.formatValue) {
      case "count":
        return current.toString()
      case "remaining":
        return remaining.toString()
      case "fraction":
      default:
        return `${current}/${this.maxValue}`
    }
  }

  updateCounterClasses(currentLength, remaining) {
    const counter = this.counterTarget

    // Remove existing classes
    counter.classList.remove(
      "character-count-normal",
      "character-count-warning",
      "character-count-danger"
    )

    // Determine state and apply appropriate class
    if (currentLength >= this.maxValue) {
      counter.classList.add("character-count-danger")
    } else if (currentLength >= this.warnAtValue) {
      counter.classList.add("character-count-warning")
    } else {
      counter.classList.add("character-count-normal")
    }
  }


  reset() {
    this.inputTarget.value = ""
    this.updateCounter()
  }

  // Value change callbacks
  maxValueChanged() {
    // Recalculate warn threshold if it was auto-set
    if (this.data.get("warnAt") === null) {
      this.warnAtValue = Math.floor(this.maxValue * 0.9)
    }
    this.updateCounter()
  }

  warnAtValueChanged() {
    this.updateCounter()
  }

  formatValueChanged() {
    this.updateCounter()
  }
}
