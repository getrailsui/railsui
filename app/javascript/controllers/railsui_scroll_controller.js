import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollitem", "launcher"]
  connect() {
    if (this.hasScrollitemTarget) {
      let scrollpos = localStorage.getItem("scrollpos")
      if (scrollpos) this.scrollitemTarget.scrollTo(0, scrollpos)


      window.onbeforeunload = () => {
        localStorage.setItem("scrollpos", this.scrollitemTarget.scrollTop)
      }
    }

    if (this.hasLauncherTarget) {
      window.addEventListener('scroll', () => {
        if (window.scrollY >= 800) {
          this.launcherTarget.classList.remove('hidden')
        } else {
          this.launcherTarget.classList.add('hidden')
        }
      })
    }
  }

  scrollToTop(event) {
    event.preventDefault()
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}
