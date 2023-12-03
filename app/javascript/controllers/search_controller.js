import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result", "form", "resultList"]
  currentResults = this.resultListTarget.innerHTML

  search(event) {
    this.filterList(event)
  }

  clear(event) {
    event.target.value = ""
    this._resetList()
  }

  filterList(event) {
    this.resultTargets.forEach((result) => {
      if (result.dataset.searchRouteValue.includes(event.target.value)) {
        result.style.cssText = "display: block !important"
      } else {
        result.style.cssText = "display: none !important"
      }
    })
  }

  _resetList() {
    this.resultListTarget.innerHTML = this.currentResults
  }
}
