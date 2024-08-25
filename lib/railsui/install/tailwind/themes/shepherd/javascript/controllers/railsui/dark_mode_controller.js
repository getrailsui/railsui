import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Check system preference and set dark mode if preferred
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)")

    // Function to handle changes in the system color scheme
    const handleSystemColorChange = (event) => {
      if (event.matches) {
        this.setDarkMode()
      } else {
        this.setLightMode()
      }
    }

    // Initial check and set the theme based on system preference or user preference
    if (
      localStorage.theme === "dark" ||
      (!("theme" in localStorage) && prefersDark.matches)
    ) {
      this.setDarkMode()
    } else {
      this.setLightMode()
    }

    // Listen for changes in system color scheme
    prefersDark.addListener(handleSystemColorChange)
  }

  toggle(event) {
    const selectedTheme = event.currentTarget.getAttribute("data-theme")

    if (selectedTheme === "dark") {
      this.setDarkMode()
    } else if (selectedTheme === "light") {
      this.setLightMode()
    } else {
      this.setSystemMode()
    }
  }

  setDarkMode() {
    document.documentElement.classList.add("dark")
    localStorage.theme = "dark"
  }

  setLightMode() {
    document.documentElement.classList.remove("dark")
    localStorage.theme = "light"
  }

  setSystemMode() {
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)")

    if (prefersDark.matches) {
      this.setDarkMode()
    } else {
      this.setLightMode()
    }

    delete localStorage.theme
  }
}
