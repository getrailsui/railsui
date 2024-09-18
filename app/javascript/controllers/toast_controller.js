import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  connect() {
    useTransition(this, {
      element: this.element,
    })

    // Remove to not trigger toggle on load
    this.toggleTransition()
  }

  toggle() {
    this.toggleTransition()
  }

  hide() {
    this.leave()

    let self = this
    setTimeout(() => {
      self.toggleTransition()
    }, 1000)
  }

  disconnect() {
    this.leave()
  }
}
