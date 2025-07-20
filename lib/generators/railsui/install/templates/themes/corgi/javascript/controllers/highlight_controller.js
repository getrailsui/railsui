import { Controller } from "@hotwired/stimulus"
import hljs from "highlight.js"

export default class extends Controller {
  static targets = ["code"]
  connect() {
    this.codeTargets.forEach((target) => {
      target.querySelectorAll("pre code").forEach((c) => {
        hljs.highlightElement(c)
      })
    })
  }
}
