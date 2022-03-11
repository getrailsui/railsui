import { Controller } from "@hotwired/stimulus"
import tippy from "tippy.js"

export default class extends Controller {
  static values = {
    content: String,
  }

  connect() {
    let options = {}
    if (this.hasContentValue) {
      options["content"] = this.contentValue
    }
    this.tippy = tippy(this.element, options)
  }

  disconnect() {
    this.tippy.destroy()
  }
}
