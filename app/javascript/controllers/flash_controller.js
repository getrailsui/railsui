import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    hideAfter: { type: Number, default: 4000 },
    leaveClass: {
      type: String,
      default: "transition ease-in duration-300 opacity-0 scale-95",
    },
  }

  connect() {
    if (this.hideAfterValue > 0) {
      this.timeout = setTimeout(() => this.dismiss(), this.hideAfterValue)
    }
  }

  dismiss() {
    this.element.classList.add(...this.leaveClassValue.split(" "))

    setTimeout(() => this.element.remove(), 300) // match your transition
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
