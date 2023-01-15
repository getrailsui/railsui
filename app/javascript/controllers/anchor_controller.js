import { Controller } from '@hotwired/stimulus'
import tippy from 'tippy.js'

export default class extends Controller {
  static values = {
    url: String,
  }

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.urlValue + `#${this.element.id}`)
  }
}
