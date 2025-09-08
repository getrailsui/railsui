import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["modal", "input", "results"]

  connect() {
    if (this.hasModalTarget) {
      useTransition(this, {
        element: this.modalTarget,
        enterActive: "transition ease-out duration-200",
        enterFrom: "opacity-0 scale-95",
        enterTo: "opacity-100 scale-100",
        leaveActive: "transition ease-in duration-150",
        leaveFrom: "opacity-100 scale-100",
        leaveTo: "opacity-0 scale-95",
      })
      this.isOpen = false
      this.activeIndex = -1
      this.currentResults = []
    }
  }

  open() {
    this.isOpen = true
    this.activeIndex = -1
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
    this.enter()

    // Show recent chats by default
    this.showRecentChats()

    // Focus the input and set up ARIA
    setTimeout(() => {
      this.inputTarget.focus()
      this.inputTarget.setAttribute("aria-expanded", "true")
      this.inputTarget.setAttribute("aria-activedescendant", "")
      this.resultsTarget.setAttribute("role", "listbox")
      this.resultsTarget.setAttribute("aria-label", "Search results")
    }, 100)

    // Add escape key listener
    document.addEventListener("keydown", this.handleEscape.bind(this))
  }

  close() {
    this.isOpen = false
    this.activeIndex = -1
    this.leave(() => {
      this.modalTarget.classList.add("hidden")
      this.modalTarget.classList.remove("flex")
    })

    // Clear input and results
    this.inputTarget.value = ""
    this.resultsTarget.innerHTML = ""
    this.inputTarget.setAttribute("aria-expanded", "false")
    this.inputTarget.removeAttribute("aria-activedescendant")

    // Remove escape key listener
    document.removeEventListener("keydown", this.handleEscape.bind(this))
  }

  handleEscape(event) {
    if (event.key === "Escape" && this.isOpen) {
      this.close()
    }
  }

  handleInput(event) {
    const query = event.target.value.trim()
    this.activeIndex = -1 // Reset active index on new input

    if (query.length === 0) {
      this.showRecentChats()
    } else {
      this.search(query)
    }
  }

  search(query) {
    // Mock search results - in a real app, this would likely be API calls or turbo_streams
    const mockResults = [
      {
        type: "chat",
        title: "How to optimize Rails performance?",
        subtitle: "Yesterday • 15 messages",
        icon: "chat-bubble-left-right",
      },
      {
        type: "chat",
        title: "JavaScript async/await patterns",
        subtitle: "2 days ago • 8 messages",
        icon: "chat-bubble-left-right",
      },
      {
        type: "action",
        title: "New chat",
        subtitle: "Start a new conversation",
        icon: "plus",
      },
      {
        type: "action",
        title: "Clear all chats",
        subtitle: "Delete all conversation history",
        icon: "trash",
      },
    ].filter((item) => item.title.toLowerCase().includes(query.toLowerCase()))

    this.renderResults(mockResults)
  }

  showRecentChats() {
    const recentChats = [
      {
        type: "chat",
        title: "How to optimize Rails performance?",
        subtitle: "Yesterday • 15 messages",
        icon: "chat-bubble-left-right",
      },
      {
        type: "chat",
        title: "Explain machine learning concepts",
        subtitle: "2 days ago • 12 messages",
        icon: "chat-bubble-left-right",
      },
      {
        type: "chat",
        title: "JavaScript async/await patterns",
        subtitle: "3 days ago • 8 messages",
        icon: "chat-bubble-left-right",
      },
    ]

    this.renderResults(recentChats)
  }

  renderResults(results) {
    this.currentResults = results
    this.activeIndex = -1

    if (results.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="p-4 text-center text-neutral-500">
          <div class="size-12 bg-neutral-100 rounded-lg flex items-center justify-center mx-auto dark:bg-neutral-900 mb-3">
            <svg class="size-5 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </div>
          <p>No results found</p>
        </div>
      `
      return
    }

    const resultHTML = results
      .map(
        (result, index) => `
      <div class="px-4 py-3 hover:bg-neutral-50 cursor-pointer border-b border-neutral-100 last:border-b-0 dark:border-neutral-700/50 dark:hover:bg-neutral-700"
           data-action="click->search#selectResult"
           data-search-result-index="${index}"
           id="search-result-${index}"
           role="option"
           aria-selected="false"
           tabindex="-1">
        <div class="flex items-center space-x-3">
          <div class="size-8 bg-neutral-100 rounded-lg flex items-center justify-center shrink-0">
            <svg class="size-4 text-neutral-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              ${this.getIconPath(result.icon)}
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-neutral-900 truncate dark:text-neutral-100">${
              result.title
            }</p>
            <p class="text-xs text-neutral-500 dark:text-neutral-400 truncate">${
              result.subtitle
            }</p>
          </div>
        </div>
      </div>
    `
      )
      .join("")

    this.resultsTarget.innerHTML = resultHTML
    this.updateActiveDescendant()
  }

  getIconPath(iconName) {
    const icons = {
      "chat-bubble-left-right":
        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>',
      plus: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>',
      trash:
        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>',
    }
    return icons[iconName] || icons["chat-bubble-left-right"]
  }

  selectResult(event) {
    const index = parseInt(event.currentTarget.dataset.searchResultIndex)
    this.selectResultByIndex(index)
  }

  selectResultByIndex(index) {
    const result = this.currentResults[index]
    if (!result) return

    // Handle different result types
    if (result.type === "chat") {
      // Open the selected chat
      this.close()
      // In a real app, this would navigate to the chat
    } else if (result.type === "action") {
      if (result.title === "New chat") {
        // Navigate to new chat page
        window.location.href = "/chats/new/"
      }
      this.close()
    }
  }

  preventClose(event) {
    event.stopPropagation()
  }

  handleKeydown(event) {
    if (!this.isOpen || this.currentResults.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.navigateDown()
        break
      case "ArrowUp":
        event.preventDefault()
        this.navigateUp()
        break
      case "Enter":
        event.preventDefault()
        if (this.activeIndex >= 0) {
          this.selectResultByIndex(this.activeIndex)
        }
        break
      case "Home":
        event.preventDefault()
        this.setActiveIndex(0)
        break
      case "End":
        event.preventDefault()
        this.setActiveIndex(this.currentResults.length - 1)
        break
    }
  }

  navigateDown() {
    const newIndex =
      this.activeIndex < this.currentResults.length - 1
        ? this.activeIndex + 1
        : 0 // Wrap to first item
    this.setActiveIndex(newIndex)
  }

  navigateUp() {
    const newIndex =
      this.activeIndex > 0
        ? this.activeIndex - 1
        : this.currentResults.length - 1 // Wrap to last item
    this.setActiveIndex(newIndex)
  }

  setActiveIndex(index) {
    // Remove active state from previous item
    if (this.activeIndex >= 0) {
      const prevElement = this.resultsTarget.querySelector(
        `#search-result-${this.activeIndex}`
      )
      if (prevElement) {
        prevElement.classList.remove("bg-neutral-200/60")
        prevElement.setAttribute("aria-selected", "false")
      }
    }

    this.activeIndex = index

    // Add active state to new item
    if (this.activeIndex >= 0) {
      const activeElement = this.resultsTarget.querySelector(
        `#search-result-${this.activeIndex}`
      )
      if (activeElement) {
        activeElement.classList.add("bg-neutral-200/60")
        activeElement.setAttribute("aria-selected", "true")

        // Scroll into view if needed
        activeElement.scrollIntoView({
          block: "nearest",
          behavior: "smooth",
        })
      }
    }

    this.updateActiveDescendant()
  }

  updateActiveDescendant() {
    const activeId =
      this.activeIndex >= 0 ? `search-result-${this.activeIndex}` : ""
    this.inputTarget.setAttribute("aria-activedescendant", activeId)
  }
}
