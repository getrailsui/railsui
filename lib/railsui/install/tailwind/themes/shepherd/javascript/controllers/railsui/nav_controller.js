import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["nav"]

  connect() {
    useTransition(this, {
      element: this.navTarget,
    })
  }

  toggle() {
    this.toggleTransition()
  }

  disconnect() {
    this.leave()
  }
}
