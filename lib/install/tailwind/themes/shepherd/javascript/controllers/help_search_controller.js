import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["searchMenu"]
  static values = {
    recentData: Array,
    linkClasses: String,
  }

  connect() {
    useTransition(this, {
      element: this.searchMenuTarget,
    })
  }

  toggle() {
    this.toggleTransition()
    this.showRecents()
  }

  hide(event) {
    if (
      !this.element.contains(event.target) &&
      !this.searchMenuTarget.classList.contains("hidden")
    ) {
      this.leave()
    }
  }

  disconnect() {
    this.leave()
  }

  closeMenu() {
    this.toggleTransition() // Close the menu
  }

  showRecents() {
    const data = this.recentDataValue
    const listContainer = this.searchMenuTarget
    const linkClasses = this.linkClassesValue
    const svgIcon = `<svg class="w-6 h-6 stroke-current opacity-50 group-hover:opacity-90" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><title>magnifying-glass</title><g fill="none"><path d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></g></svg>`

    // Clear any existing list items
    listContainer.innerHTML = ""

    // Iterate through the JSON data and create list items
    data.forEach((item) => {
      const li = `
      <li>
        <a href="${item.url}" class="group flex items-center ${linkClasses}" target="_blank">
          ${svgIcon} <span class="pl-2">${item.title}</span>
        </a>
      </li>
    `

      // Use insertAdjacentHTML to insert the HTML string
      listContainer.insertAdjacentHTML("afterbegin", li)
    })
  }
}
