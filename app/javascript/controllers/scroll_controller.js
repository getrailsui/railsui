import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollitem"]
  connect() {
    if (this.hasScrollitemTarget) {
      let scrollpos = localStorage.getItem("scrollpos")
      if (scrollpos) this.scrollitemTarget.scrollTo(0, scrollpos)


      window.onbeforeunload = () => {
        localStorage.setItem("scrollpos", this.scrollitemTarget.scrollTop)
      }
    }
  }
}
