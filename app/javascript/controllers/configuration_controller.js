const BOOTSTRAP = "Bootstrap"
const TAILWIND = "Tailwind CSS"
const BULMA = "Bulma"
const NONE = "None"

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bootstrap", "bulma", "tailwind", "frameworks"]
  static values = {
    chosenTheme: String,
  }
  connect() {
    if (this.hasChosenThemeValue) {
      let value = this.chosenThemeValue

      switch (value) {
        case "bootstrap":
          this.frameworksTarget.classList.remove("hidden")
          this.bootstrapTarget.classList.remove("hidden")
          break
        case "tailwind":
          this.frameworksTarget.classList.remove("hidden")
          this.tailwindTarget.classList.remove("hidden")
          break
        case "bulma":
          this.frameworksTarget.classList.remove("hidden")
          this.bulmaTarget.classList.remove("hidden")
          break
        default:
          this._toggleAllThemes()
      }
    }
  }

  toggleTheme(event) {
    switch (event.target.value) {
      case "bootstrap":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.bootstrapTarget.classList.remove("hidden")
        break
      case "tailwind":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.tailwindTarget.classList.remove("hidden")
        break
      case "bulma":
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
