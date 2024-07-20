const BOOTSTRAP = "Bootstrap"
const TAILWIND = "Tailwind CSS"
const NONE = "None"

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "bootstrap",
    "tailwind",
    "frameworks",
    "submit",
    "submitContainer",
    "saving",
    "theme",
  ]
  static values = {
    chosenTheme: String,
  }
  connect() {
    if (this.hasChosenThemeValue) {
      let value = this.chosenThemeValue

      switch (value) {
        case "bootstrap":
          this.frameworksTarget.classList.remove("hidden")
          this.submitContainerTarget.classList.remove("hidden")
          if (this.hasBootstrapTarget) {
            this.bootstrapTarget.classList.remove("hidden")
          }
          break
        case "tailwind":
          this.frameworksTarget.classList.remove("hidden")
          this.submitContainerTarget.classList.remove("hidden")
          if (this.hasTailwindTarget) {
            this.tailwindTarget.classList.remove("hidden")
          }
          break
        default:
          this._toggleAllThemes()
      }
    }
  }

  saveChanges(event) {
    event.preventDefault()
    // Show loading state
    this.savingTarget.classList.add("config-loader--active")
    document.body.classList.add("overflow-hidden")
    // Disable button
    this.submitTarget.setAttribute("disabled", true)
    // Continue submission
    this.element.submit()
  }

  toggleTheme(event) {
    switch (event.target.value) {
      case "bootstrap":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.bootstrapTarget.classList.remove("hidden")
        this.submitContainerTarget.classList.remove("hidden")
        this.bootstrapTarget.querySelector("label").control.checked = true

        break
      case "tailwind":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("hidden")
        this.tailwindTarget.classList.remove("hidden")
        this.submitContainerTarget.classList.remove("hidden")
        this.tailwindTarget.querySelector("label").control.checked = true
        break
      default:
        this._toggleAllThemes()
    }
  }

  _toggleAllThemes() {
    let all = [
      this.bootstrapTarget,
      this.tailwindTarget,
      this.frameworksTarget,
      this.submitContainerTarget,
    ]
    all.forEach((t) => t.classList.add("hidden"))
    // Remove loader
    this.savingTarget.classList.remove("config-loader--active")
    document.body.classList.remove("overflow-hidden")
  }
}
