import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.isOpen = false
    this.activeIndex = -1
    this.currentResults = []
    this.helpArticles = this.getHelpArticles()

    document.addEventListener("keydown", this.handleGlobalKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleGlobalKeydown.bind(this))
  }

  handleGlobalKeydown(event) {
    // Handle ⌘K or Ctrl+K to focus search
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.inputTarget.focus()
    }
  }

  handleFocus() {
    // Only show results if there's content in the input
    const query = this.inputTarget.value.trim()
    if (query.length > 0) {
      this.showResults()
    }
  }

  handleBlur(event) {
    setTimeout(() => {
      if (!this.element.contains(document.activeElement)) {
        this.hideResults()
      }
    }, 200)
  }

  handleInput(event) {
    const query = event.target.value.trim()
    this.activeIndex = -1

    if (query.length === 0) {
      this.hideResults()
    } else {
      this.searchArticles(query)
    }
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
      case "Escape":
        event.preventDefault()
        this.hideResults()
        this.inputTarget.blur()
        break
    }
  }

  navigateDown() {
    const newIndex = this.activeIndex < this.currentResults.length - 1 
      ? this.activeIndex + 1 
      : 0 // Wrap to first item
    this.setActiveIndex(newIndex)
  }

  navigateUp() {
    const newIndex = this.activeIndex > 0 
      ? this.activeIndex - 1 
      : this.currentResults.length - 1 // Wrap to last item
    this.setActiveIndex(newIndex)
  }

  setActiveIndex(index) {
    // Remove active state from previous item
    if (this.activeIndex >= 0) {
      const prevElement = this.resultsTarget.querySelector(`#help-search-result-${this.activeIndex}`)
      if (prevElement) {
        prevElement.classList.remove("bg-neutral-100", "dark:bg-neutral-700")
        prevElement.setAttribute("aria-selected", "false")
      }
    }

    this.activeIndex = index

    // Add active state to new item
    if (this.activeIndex >= 0) {
      const activeElement = this.resultsTarget.querySelector(`#help-search-result-${this.activeIndex}`)
      if (activeElement) {
        activeElement.classList.add("bg-neutral-100", "dark:bg-neutral-700")
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
    const activeId = this.activeIndex >= 0 ? `help-search-result-${this.activeIndex}` : ""
    this.inputTarget.setAttribute("aria-activedescendant", activeId)
  }

  searchArticles(query) {
    const results = this.helpArticles.filter(
      (article) =>
        article.title.toLowerCase().includes(query.toLowerCase()) ||
        article.description.toLowerCase().includes(query.toLowerCase()) ||
        article.tags.some((tag) =>
          tag.toLowerCase().includes(query.toLowerCase())
        )
    )

    this.renderResults(results.slice(0, 6)) // Limit to 6 results
  }


  renderResults(results) {
    this.currentResults = results
    this.activeIndex = -1

    if (results.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="p-6 text-center">
          <div class="size-12 bg-neutral-100 dark:bg-neutral-800 rounded-lg flex items-center justify-center mx-auto mb-3">
            <svg class="size-6 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </div>
          <p class="text-neutral-500 dark:text-neutral-400">No articles found</p>
          <p class="text-xs text-neutral-400 dark:text-neutral-500 mt-1">Try a different search term</p>
        </div>
      `
      this.showResults()
      return
    }

    const resultHTML = results
      .map(
        (result, index) => `
        <div class="px-4 py-3 hover:bg-neutral-50 dark:hover:bg-neutral-700/50 cursor-pointer border-b border-neutral-100 dark:border-neutral-700/50 last:border-b-0 transition-colors"
             data-action="click->help-search#selectResult"
             data-help-search-result-index="${index}"
             id="help-search-result-${index}"
             role="option"
             aria-selected="false"
             tabindex="-1">
          <div class="flex items-start gap-3">
            <div class="size-8 ${
              result.iconBg
            } rounded-lg flex items-center justify-center shrink-0">
              ${this.getIconSvg(result.icon, result.iconColor)}
            </div>
            <div class="flex-1 min-w-0 text-left">
              <p class="text-sm font-medium text-neutral-900 dark:text-neutral-100 truncate">${
                result.title
              }</p>
              <p class="text-xs text-neutral-500 dark:text-neutral-400 truncate">${
                result.description
              }</p>
              <div class="flex items-center gap-2 mt-2">
                <span class="text-xs text-neutral-400">${result.readTime}</span>
                ${
                  result.popular
                    ? '<span class="px-1.5 py-0.5 font-medium text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded-full">Popular</span>'
                    : ""
                }
              </div>
            </div>
          </div>
        </div>
      `
      )
      .join("")

    this.resultsTarget.innerHTML = resultHTML
    this.showResults()
  }

  showResults() {
    if (!this.isOpen) {
      this.isOpen = true
      this.resultsTarget.classList.remove("hidden")
      this.resultsTarget.setAttribute("role", "listbox")
      this.resultsTarget.setAttribute("aria-label", "Help search results")
    }
  }

  hideResults() {
    if (this.isOpen) {
      this.isOpen = false
      this.resultsTarget.classList.add("hidden")
      this.activeIndex = -1
    }
  }

  selectResult(event) {
    const index = parseInt(event.currentTarget.dataset.helpSearchResultIndex)
    this.selectResultByIndex(index)
  }

  selectResultByIndex(index) {
    const result = this.currentResults[index]
    if (!result) return

    // In a real application, this would navigate to the article
    console.log("Opening article:", result.title)
    this.hideResults()
    this.inputTarget.blur()
  }

  getIconSvg(iconName, colorClass) {
    const icons = {
      "rocket-launch": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.59 14.37a6 6 0 01-5.84 7.38v-4.8m5.84-2.58a14.98 14.98 0 006.16-12.12A14.98 14.98 0 009.631 8.41m5.96 5.96a14.926 14.926 0 01-5.841 2.58m-.119-8.54a6 6 0 00-7.381 5.84h4.8m2.581-5.84a14.927 14.927 0 00-2.58 5.84m2.58-5.84a14.927 14.927 0 00-2.58 5.84"></path></svg>`,
      "code-bracket": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"></path></svg>`,
      "shield-check": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>`,
      "cog-6-tooth": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>`,
      "exclamation-triangle": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.728-.833-2.498 0L4.316 16.5c-.77.833.192 2.5 1.732 2.5z"></path></svg>`,
      "light-bulb": `<svg class="size-4 ${colorClass}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path></svg>`,
    }
    return icons[iconName] || icons["rocket-launch"]
  }

  getHelpArticles() {
    return [
      {
        title: "Getting Started Guide",
        description: "Learn the basics of using Corgie AI effectively",
        readTime: "5 min read",
        popular: true,
        icon: "rocket-launch",
        iconBg: "bg-blue-100 dark:bg-blue-900/30",
        iconColor: "text-blue-600 dark:text-blue-400",
        tags: ["basics", "tutorial", "getting started", "new user"],
      },
      {
        title: "API Integration",
        description: "Connect Corgie AI to your applications",
        readTime: "10 min read",
        popular: false,
        icon: "code-bracket",
        iconBg: "bg-green-100 dark:bg-green-900/30",
        iconColor: "text-green-600 dark:text-green-400",
        tags: ["api", "integration", "development", "sdk"],
      },
      {
        title: "Privacy & Security",
        description: "Understanding data protection and privacy",
        readTime: "7 min read",
        popular: false,
        icon: "shield-check",
        iconBg: "bg-purple-100 dark:bg-purple-900/30",
        iconColor: "text-purple-600 dark:text-purple-400",
        tags: ["privacy", "security", "data protection", "gdpr"],
      },
      {
        title: "Account Settings",
        description: "Manage your profile and preferences",
        readTime: "3 min read",
        popular: false,
        icon: "cog-6-tooth",
        iconBg: "bg-orange-100 dark:bg-orange-900/30",
        iconColor: "text-orange-600 dark:text-orange-400",
        tags: ["account", "settings", "profile", "preferences"],
      },
      {
        title: "Troubleshooting",
        description: "Common issues and solutions",
        readTime: "8 min read",
        popular: false,
        icon: "exclamation-triangle",
        iconBg: "bg-red-100 dark:bg-red-900/30",
        iconColor: "text-red-600 dark:text-red-400",
        tags: ["troubleshooting", "issues", "problems", "fixes"],
      },
      {
        title: "Tips & Best Practices",
        description: "Get the most out of Corgie AI",
        readTime: "12 min read",
        popular: false,
        icon: "light-bulb",
        iconBg: "bg-indigo-100 dark:bg-indigo-900/30",
        iconColor: "text-indigo-600 dark:text-indigo-400",
        tags: ["tips", "best practices", "optimization", "productivity"],
      },
      {
        title: "Billing & Subscriptions",
        description: "Managing your account billing",
        readTime: "4 min read",
        popular: false,
        icon: "credit-card",
        iconBg: "bg-yellow-100 dark:bg-yellow-900/30",
        iconColor: "text-yellow-600 dark:text-yellow-400",
        tags: ["billing", "subscription", "payment", "plan"],
      },
      {
        title: "Mobile App Guide",
        description: "Using Corgie AI on mobile devices",
        readTime: "6 min read",
        popular: false,
        icon: "device-phone-mobile",
        iconBg: "bg-pink-100 dark:bg-pink-900/30",
        iconColor: "text-pink-600 dark:text-pink-400",
        tags: ["mobile", "app", "ios", "android"],
      },
    ]
  }
}
