import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "list", "listbutton", "gridbutton"]

  connect() {}

  toggle(event) {
    event.preventDefault()

    const view = event.target.getAttribute("data-view")

    if (view === "grid") {
      this.gridTarget.classList.remove("hidden")
      this.listTarget.classList.add("hidden")
      this.listbuttonTarget.dataset.active = "false"
      this.gridbuttonTarget.dataset.active = "true"
    } else if (view === "list") {
      this.gridTarget.classList.add("hidden")
      this.listTarget.classList.remove("hidden")
      this.listbuttonTarget.dataset.active = "true"
      this.gridbuttonTarget.dataset.active = "false"
    }
  }
}
