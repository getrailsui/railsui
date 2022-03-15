import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.element) {
      setTimeout(() => {
        this.element.remove()
      }, 4000)
    }
  }
}
