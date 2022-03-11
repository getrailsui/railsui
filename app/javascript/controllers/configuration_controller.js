const BOOTSTRAP = "Bootstrap"
const TAILWIND = "Tailwind CSS"
const BULMA = "Bulma"
const NONE = "None"

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bootstrap", "bulma", "tailwind", "frameworks"]

  connect() {}

  toggleTheme(event) {
    switch (event.target.value) {
      case "Bootstrap":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.bootstrapTarget.classList.remove("hidden")
        break
      case "Tailwind CSS":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.tailwindTarget.classList.remove("hidden")
        break
      case "Bulma":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.bulmaTarget.classList.remove("hidden")
        break
      default:
        this._toggleAllThemes()
    }
  }

  _toggleAllThemes() {
    let all = [
      this.bootstrapTarget,
      this.bulmaTarget,
      this.tailwindTarget,
      this.frameworksTarget,
    ]
    all.forEach((t) => t.classList.add("hidden"))
  }
}
