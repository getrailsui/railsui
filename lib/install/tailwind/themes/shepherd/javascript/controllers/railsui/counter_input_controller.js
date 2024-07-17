import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "decrementBtn"]

  connect() {
    this.disableDecrementIfZero()
  }

  increment(event) {
    event.preventDefault()
    // Increment value by 1
    this.valueTarget.value = parseInt(this.valueTarget.value) + 1
    this.disableDecrementIfZero()
  }

  decrement(event) {
    event.preventDefault()
    // Decrement value by 1, but ensure it doesn't go below 0
    this.valueTarget.value = Math.max(parseInt(this.valueTarget.value) - 1, 0)
    this.disableDecrementIfZero()
  }

  disableDecrementIfZero() {
    // Apply or remove classes based on the presence of the "disabled" attribute
    if (this.decrementBtnTarget && this.valueTarget.value == 0) {
      this.decrementBtnTarget.classList.add("pointer-events-none", "opacity-50")
    } else {
      this.decrementBtnTarget.classList.remove(
        "pointer-events-none",
        "opacity-50"
      )
    }
  }
}
