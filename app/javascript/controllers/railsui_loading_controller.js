import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "saving"]
  static values = {
    label: { type: String, default: "Loading..." },
  }

  initialize() {
    const urlParams = new URLSearchParams(window.location.search)

    if (urlParams.get("update") === "true") {
      // Reload the page
      setTimeout(() => {
        this.removeURLParameter("update")
        window.location.reload()
      }, 3000)
    }
  }

  start() {
    this.contentTarget.innerHTML = this.labelValue

    this.savingTarget.classList.add("config-loader--active")
    document.body.classList.add("overflow-hidden")
  }

  connect() {
    this.toggleLoader()
  }

  toggleLoader() {
    // Remove loader
    this.savingTarget.classList.remove("config-loader--active")
    document.body.classList.remove("overflow-hidden")
  }

  removeURLParameter(param) {
    const url = new URL(window.location.href)
    url.searchParams.delete(param)
    window.history.replaceState({}, "", url)
  }
}
