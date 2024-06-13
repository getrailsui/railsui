import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["extension"]
  static values = {
    path: String,
    url: String
  }

  togglePath(event) {
    event.preventDefault()
    this.extensionTargets.forEach(t => {
      t.textContent = this.pathValue
    })

  }
  toggleUrl(event) {
    event.preventDefault()
    this.extensionTargets.forEach(t => {
      t.textContent = this.urlValue
    })
  }

}
