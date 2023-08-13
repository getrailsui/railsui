import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "button", "cancel"]

  launch(event) {
    event.preventDefault()
    this.dialogTarget.showModal()
  }

  cancel(event) {
    event.preventDefault()
    this.dialogTarget.close()
  }

  perform() {
    this.buttonTarget.textContent = "Processing..."
    this.buttonTarget.classList.add("opacity-50", "pointer-events-none")
    this.cancelTarget.classList.add("hidden")
  }
}
