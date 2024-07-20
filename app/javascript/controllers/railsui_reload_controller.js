import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Check if the URL has the 'update' parameter
    const urlParams = new URLSearchParams(window.location.search)
    if (urlParams.get("update") === "true") {
      // Reload the page
      setTimeout(() => {
        this.removeURLParameter("update")
        window.location.reload()
      }, 3000)
    }
  }

  removeURLParameter(param) {
    const url = new URL(window.location.href)
    url.searchParams.delete(param)
    window.history.replaceState({}, "", url)
  }
}
