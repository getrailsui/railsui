import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = {
    label: { type: String, default: "Loading..." },
  }
  start() {
    this.contentTarget.innerHTML = this.labelValue
  }
}
