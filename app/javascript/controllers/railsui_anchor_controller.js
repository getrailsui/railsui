// Use globals from CDN
// Use Stimulus.Controller from CDN
const tippy = window.tippy

export default class extends Stimulus.Controller {
  static values = {
    url: String,
  }

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.urlValue + `#${this.element.id}`)
  }
}
