import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  expand() {
    this.element.style.height = `${this.element.scrollHeight + 2}px`

    if (this.element.scrollHeight > 60) {
      this.element.classList.remove("rounded-full")
      this.element.classList.add("rounded-lg")
    } else {
      this.resetTextarea()
    }

    if (this.element.value.trim() === "") {
      this.resetTextarea()
    }
  }

  resetTextarea() {
    this.element.style.height = "auto"
    this.element.classList.add("rounded-full")
    this.element.classList.remove("rounded-lg")
  }
}
