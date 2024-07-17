import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    useTransition(this, {
      element: this.containerTarget,
    })
  }

  toggle() {
    this.toggleTransition()
  }

  disconnect() {
    this.leave()
  }
}
