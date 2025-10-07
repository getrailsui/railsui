// Use globals from CDN
// Use Stimulus.Controller from CDN
const { useTransition } = window.StimulusUse

export default class extends Stimulus.Controller {
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
