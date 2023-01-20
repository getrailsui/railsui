import { Controller } from "@hotwired/stimulus"
import { useTransition } from 'stimulus-use'

export default class extends Controller {
  static targets = ['container', 'content']

  connect() {
    useTransition(this, {
      element: this.contentTarget,
    })
  }

  open() {
    this.enableAppearance()
    this.toggleTransition()
  }

  close() {
    this.leave();
    this.disableAppearance()
  }

  closeWithKey(e){
    if (e.keyCode === 27 && !this.containerTarget.classList.contains('hidden')) {
      this.close(e);
    }
  }

  enableAppearance() {
    this.containerTarget.classList.add("bg-black/80")
    this.containerTarget.classList.remove('hidden')
  }

  disableAppearance() {
    this.containerTarget.classList.add('hidden')
    this.containerTarget.classList.remove("bg-black/80")
  }

  disconnect() {
    this.toggleTransition()
  }
}
