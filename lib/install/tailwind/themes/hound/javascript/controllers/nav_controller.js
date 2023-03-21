import { Controller } from '@hotwired/stimulus'
import { useTransition } from 'stimulus-use'

export default class extends Controller {
  static targets = ['nav', 'menuBars', 'menuCross']

  connect() {
    useTransition(this, {
      element: this.navTarget
    })
  }

  toggle() {
    this.toggleTransition()
    this.swapIcon()
  }

  disconnect() {
    this.leave()
  }

  swapIcon() {
    this.menuBarsTarget.classList.toggle('hidden')
    this.menuCrossTarget.classList.toggle('hidden')
  }
}
