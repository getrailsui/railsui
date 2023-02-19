import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["darkIcon", "lightIcon", "systemIcon"]
  connect() {
    if (
      localStorage.theme === "dark" ||
      (!("theme" in localStorage) &&
        window.matchMedia("(prefers-color-scheme: dark)").matches)
    ) {
      this.element.classList.add("dark")
    } else {
      this.element.classList.remove("dark")
    }
  }

  toggle(event) {
    event.preventDefault()
    switch (event.target.dataset.theme) {
      case "light":
        localStorage.theme = "light"
        if (this.element.classList.contains("dark")) {
          this.element.classList.remove("dark")
        }
        break
      case "dark":
        localStorage.theme = "dark"
        this.element.classList.add("dark")
        break
      default:
        localStorage.removeItem("theme")
        if (this.element.classList.contains("dark")) {
          this.element.classList.remove("dark")
        }
    }
  }
}
