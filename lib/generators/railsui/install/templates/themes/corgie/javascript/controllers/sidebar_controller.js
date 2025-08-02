import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.isCollapsed = false
    this.setupMediaQuery()
    this.setupKeyboardShortcuts()
  }

  setupMediaQuery() {
    this.mediaQuery = window.matchMedia("(max-width: 1024px)")
    this.handleMediaQuery(this.mediaQuery)
    this.mediaQuery.addListener(this.handleMediaQuery.bind(this))
  }

  handleMediaQuery(mq) {
    if (mq.matches) {
      this.collapse()
    } else {
      this.expand()
    }
  }

  toggle() {
    if (this.isCollapsed) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  collapse() {
    this.isCollapsed = true
    this.containerTarget.classList.remove("sidebar-expanded", "w-64")
    this.containerTarget.classList.add("sidebar-collapsed", "w-16")
  }

  expand() {
    this.isCollapsed = false
    this.containerTarget.classList.remove("sidebar-collapsed", "w-16")
    this.containerTarget.classList.add("sidebar-expanded", "w-64")
  }

  setupKeyboardShortcuts() {
    document.addEventListener("keydown", this.handleKeyboardShortcut.bind(this))
  }

  handleKeyboardShortcut(event) {
    if (
      event.shiftKey &&
      (event.metaKey || event.ctrlKey) &&
      event.key === "O"
    ) {
      event.preventDefault()
      this.newChat()
    }
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.openSearch()
    }
    if ((event.metaKey || event.ctrlKey) && event.key === "b") {
      event.preventDefault()
      this.toggle()
    }
  }

  newChat() {
    window.location.href = "/chats/new/"
  }

  openSearch() {
    const searchElement = document.querySelector('[data-controller*="search"]')
    if (searchElement) {
      const searchController =
        this.application.getControllerForElementAndIdentifier(
          searchElement,
          "search"
        )
      if (searchController && searchController.open) {
        searchController.open()
      }
    }
  }


  disconnect() {
    if (this.mediaQuery) {
      this.mediaQuery.removeListener(this.handleMediaQuery.bind(this))
    }
    document.removeEventListener(
      "keydown",
      this.handleKeyboardShortcut.bind(this)
    )
  }
}
