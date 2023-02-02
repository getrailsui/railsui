import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'pane']
  static values = {
    activeClasses: { type: String, default: "active" },
    inactiveClasses: { type: String, default: "inactive" }
  }

  connect() {
    this.showTab()
  }

  change(event) {
    event.preventDefault()

    // If target specifies an index, use that
    if (event.currentTarget.dataset.index) {
      this.index = event.currentTarget.dataset.index

    // If target specifies an id, use that
    } else if (event.currentTarget.dataset.id) {
      this.index = this.tabTargets.findIndex((tab) => tab.id == event.currentTarget.dataset.id)

    // Otherwise, use the index of the current target
    } else {
      this.index = this.tabTargets.indexOf(event.currentTarget)
    }
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const pane = this.paneTargets[index]
      const active = this.activeClassesValue.split(' ')
      const inactive = this.inactiveClassesValue.split(' ')

      if (index === this.index) {
        pane.classList.remove('hidden')
        active.forEach(c => tab.classList.add(c))
        inactive.forEach(c => tab.classList.remove(c))
      } else {
        pane.classList.add('hidden')
        active.forEach(c => tab.classList.remove(c))
        inactive.forEach(c => tab.classList.add(c))
      }
    })
  }

  get index() {
    return parseInt(this.data.get('index') || 0)
  }

  set index(value) {
    this.data.set('index', (value >= 0 ? value : 0))
    this.showTab()
  }
}
