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
    "saving",
    "theme",
    "themeCopy",
  ]
  static values = {
    chosenTheme: String,
  }
  connect() {
    if (this.hasChosenThemeValue) {
      let value = this.chosenThemeValue

      switch (value) {
        case "bootstrap":
          this.frameworksTarget.classList.remove("tw-hidden")
          this.themeCopyTarget.classList.remove("tw-hidden")
          if (this.hasBootstrapTarget) {
            this.bootstrapTarget.classList.remove("tw-hidden")
          }
          break
        case "tailwind":
          this.frameworksTarget.classList.remove("tw-hidden")
          this.themeCopyTarget.classList.remove("tw-hidden")
          if (this.hasTailwindTarget) {
            this.tailwindTarget.classList.remove("tw-hidden")
          }
          break
        default:
          this._toggleAllThemes()
      }
    }
    this.submitTarget.removeAttribute("disabled")
  }

  saveChanges(event) {
    event.preventDefault()
    // Show loading state
    this.savingTarget.classList.remove("tw-hidden")
    // Disable button
    this.submitTarget.setAttribute("disabled", true)
    // Continue submission
    this.element.submit()

    // let urlParams = new URLSearchParams(window.location.search)
    // let reload = urlParams.get("reload")
    // if (reload) {
    //   setTimeout(function () {
    //     window.location.href = "/railsui"
    //   }, 4000)
    // }
  }

  toggleTheme(event) {
    switch (event.target.value) {
      case "bootstrap":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("tw-hidden")
        this.themeCopyTarget.classList.remove("tw-hidden")
        this.bootstrapTarget.classList.remove("tw-hidden")
        this.bootstrapTarget.querySelector("label").control.checked = true

        break
      case "tailwind":
        this._toggleAllThemes()
        this.frameworksTarget.classList.remove("tw-hidden")
        this.themeCopyTarget.classList.remove("tw-hidden")
        this.tailwindTarget.classList.remove("tw-hidden")
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
      this.themeCopyTarget,
    ]
    all.forEach((t) => t.classList.add("tw-hidden"))
  }
}
