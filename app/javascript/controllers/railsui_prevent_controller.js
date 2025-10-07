import { Controller } from '@hotwired/stimulus'

export default class extends Stimulus.Controller {
  prevent(event) {
    event.preventDefault()
  }
}
