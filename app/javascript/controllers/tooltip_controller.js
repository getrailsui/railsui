import { Controller } from "@hotwired/stimulus"
import tippy from "tippy.js"

export default class extends Controller {
  static values = {
    content: String,
    allowHtml: Boolean
  }

  connect() {
    let options = {}
    if (this.hasContentValue) {
      options["content"] = this.contentValue
    }
    if (this.hasAllowHtmlValue) {
      options["allowHTML"] = this.allowHtmlValue
    }
    this.tippy = tippy(this.element, options)
  }

  disconnect() {
    this.tippy.destroy()
  }
}
