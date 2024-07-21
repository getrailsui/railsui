import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "submitContainer", "saving"]

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

  connect() {
    this.toggleLoader()
  }

  saveChanges(event) {
    event.preventDefault()
    // Show loading state
    this.savingTarget.classList.add("config-loader--active")
    document.body.classList.add("overflow-hidden")
    // Disable button
    this.submitTarget.setAttribute("disabled", true)
    // Continue submission
    this.element.submit()
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
