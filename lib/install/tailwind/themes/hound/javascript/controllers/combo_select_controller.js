import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["input", "options", "active"]
  static values = {
    items: Array,
  }

  toggle() {
    this.toggleTransition()
  }

  hide(event) {
    if (
      event &&
      !this.element.contains(event.target) &&
      !this.optionsTarget.classList.contains("hidden")
    ) {
      this.hideOptions()
    }
  }

  handleKeyboardNavigation(event) {
    // If dropdown is not open, handle opening it with Enter or ArrowDown/ArrowUp keys
    if (this.optionsTarget.classList.contains("hidden")) {
      if (
        event.key === "Enter" ||
        event.key === "ArrowDown" ||
        event.key === "ArrowUp"
      ) {
        event.preventDefault()
        this.showOptions()

        // Set initial focus to the first option in the list
        this.optionsTarget.firstElementChild.focus()
      }
    } else {
      // If dropdown is open, handle navigation and selection within the dropdown
      const options = Array.from(this.optionsTarget.children)
      const currentIndex = options.findIndex(
        (option) => option === document.activeElement
      )
      let nextIndex

      switch (event.key) {
        case "Tab":
        case "Escape":
          this.hideOptions()
          break
        case "ArrowUp":
          event.preventDefault()
          nextIndex = currentIndex > 0 ? currentIndex - 1 : options.length - 1
          options[nextIndex].focus()
          break
        case "ArrowDown":
          event.preventDefault()
          nextIndex = currentIndex < options.length - 1 ? currentIndex + 1 : 0
          options[nextIndex].focus()
          break
        case "Enter":
          event.preventDefault()
          this.selectOption(options[currentIndex])
          break
        default:
          break
      }
    }
  }

  handleOptionFocus(event) {
    const option = event.target
    const container = this.optionsTarget

    const optionTop = option.offsetTop
    const optionBottom = optionTop + option.offsetHeight
    const containerTop = container.scrollTop
    const containerBottom = containerTop + container.offsetHeight

    if (optionTop < containerTop) {
      container.scrollTop = optionTop
    } else if (optionBottom > containerBottom) {
      container.scrollTop = optionBottom - container.offsetHeight
    }
  }

  selectOption(option) {
    if (!option) {
      console.error("Invalid option element")
      return
    }

    if (!option.dataset.index) {
      console.error("Missing option index")
      return
    }

    const index = parseInt(option.dataset.index, 10)
    if (isNaN(index)) {
      console.error("Invalid option index")
      return
    }

    const { name, thumbnail } = this.itemsValue[index]
    this.inputTarget.value = name
    this.updateActiveOption(name, thumbnail)
    this.hideOptions()
  }

  updateActiveOption(name, thumbnail) {
    const activeContent = `
      <div class="absolute inset-y-0 flex items-center space-x-2 left-2">
        <span class="flex items-center">
          <div class="flex items-center">
            <img src="${thumbnail}" alt="${name}" class="h-6 w-6 flex-shrink-0 rounded-full">
            <span class="ml-2 whitespace-nowrap font-medium text-sm">${name}</span>
          </div>
        </span>
      </div>
    `

    this.activeTarget.innerHTML = activeContent

    const options = Array.from(this.optionsTarget.children)
    options.forEach((option) => {
      const index = parseInt(option.dataset.index, 10)
      const { name: optionName, thumbnail: optionThumbnail } =
        this.itemsValue[index]
      const isActive = optionName === name && optionThumbnail === thumbnail
      const checkmark = option.querySelector(".hasCheckmark")

      if (isActive && !checkmark) {
        const checkmarkContainer = document.createElement("span")
        checkmarkContainer.classList.add(
          "absolute",
          "inset-y-0",
          "right-2",
          "flex",
          "items-center",
          "pr-4",
          "text-indigo-600",
          "hover:bg-indigo-50",
          "dark:text-indigo-300",
          "dark:hover:bg-indigo-500/20",
          "hasCheckmark"
        )
        checkmarkContainer.innerHTML = `<svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z" clip-rule="evenodd" /></svg>`
        option.appendChild(checkmarkContainer)
      } else if (!isActive && checkmark) {
        checkmark.remove()
      }
    })
  }

  generateOptions() {
    const optionsContainer = this.optionsTarget
    const items = this.itemsValue

    items.forEach((item, index) => {
      const li = document.createElement("li")
      li.classList.add(
        "hover:bg-indigo-50",
        "dark:hover:bg-indigo-500/20",
        "relative",
        "cursor-default",
        "select-none",
        "py-2",
        "px-2",
        "pr-9",
        "text-slate-900",
        "dark:text-slate-200"
      )
      li.dataset.name = item.name
      li.dataset.thumbnail = item.thumbnail
      // Set the role attribute to "option" for each <li> element
      li.setAttribute("role", "option")
      li.dataset.index = index.toString() // Convert index to a string

      li.setAttribute("tabindex", "-1") // Set tabindex to -1 by default

      const div = document.createElement("div")
      div.classList.add("flex", "items-center")

      const img = document.createElement("img")
      img.src = item.thumbnail
      img.alt = "Avatar"
      img.classList.add("h-6", "w-6", "flex-shrink-0", "rounded-full")

      const span = document.createElement("span")
      span.classList.add("ml-2", "truncate", "font-medium")
      span.textContent = item.name

      div.appendChild(img)
      div.appendChild(span)

      li.appendChild(div)

      optionsContainer.appendChild(li)
    })
  }

  handleInputFocus() {
    this.activeTarget.classList.remove("focus")
  }

  showOptions() {
    this.toggleTransition()
  }

  hideOptions() {
    this.leave()
  }

  handleOptionClick(event) {
    const option = event.currentTarget
    if (!option) {
      console.error("Invalid option element")
      return
    }

    this.selectOption(option)
  }

  connect() {
    useTransition(this, {
      element: this.optionsTarget,
    })
    this.generateOptions()
    this.hideOptions()

    this.element.addEventListener(
      "keydown",
      this.handleKeyboardNavigation.bind(this)
    )
    this.inputTarget.addEventListener("focus", this.handleInputFocus.bind(this))

    const options = Array.from(this.optionsTarget.children)
    options.forEach((option) => {
      option.setAttribute("tabindex", "0")
      // Remove the existing "mousedown" event listener
      option.removeEventListener("mousedown", this.handleOptionClick.bind(this))
      // Add a new "click" event listener for handling option selection
      option.addEventListener("click", this.handleOptionClick.bind(this))
    })
  }

  disconnect() {
    this.element.removeEventListener(
      "keydown",
      this.handleKeyboardNavigation.bind(this)
    )
    this.inputTarget.removeEventListener(
      "focus",
      this.handleInputFocus.bind(this)
    )

    const options = Array.from(this.optionsTarget.children)
    options.forEach((option) => {
      option.removeEventListener("mousedown", this.handleOptionClick.bind(this)) // Change "click" to "mousedown"
    })
  }
}
