import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "previewBtn", "code", "codeBtn"]

  ACTIVE_CLASSES = [
    "bg-white",
    "px-3",
    "py-1.5",
    "rounded-md",
    "shadow",
    "flex",
    "items-center",
    "justify-center",
    "gap-2",
    "text-[13px]",
    "font-semibold",
    "focus:ring-4",
    "focus:ring-blue-600",
    "group",
    "dark:bg-neutral-800/90",
    "dark:text-neutral-100",
    "dark:focus:ring-blue-600/50",
    "dark:text-neutral-300",
  ]

  INACTIVE_CLASSES = [
    "bg-transparent",
    "px-3",
    "py-1.5",
    "rounded-md",
    "shadow-none",
    "flex",
    "items-center",
    "justify-center",
    "gap-2",
    "text-[13px]",
    "font-semibold",
    "dark:text-neutral-300",
  ]

  togglePreview(event) {
    event.preventDefault()
    this.toggle("preview")
  }

  toggleCode(event) {
    event.preventDefault()
    this.toggle("code")
  }

  toggle(target) {
    const activeClasses = this.ACTIVE_CLASSES
    const inactiveClasses = this.INACTIVE_CLASSES

    if (target === "preview") {
      if (!this.previewTarget.classList.contains("hidden")) {
        return // Already in the desired state
      }

      this.previewTarget.classList.toggle("hidden")
      this.codeTarget.classList.add("hidden")
      this.previewBtnTarget.className = ""
      this.codeBtnTarget.className = ""

      activeClasses.forEach((cls) => this.previewBtnTarget.classList.add(cls))
      inactiveClasses.forEach((cls) => this.codeBtnTarget.classList.add(cls))
    } else if (target === "code") {
      if (!this.codeTarget.classList.contains("hidden")) {
        return // Already in the desired state
      }

      this.codeTarget.classList.toggle("hidden")
      this.previewTarget.classList.add("hidden")

      this.previewBtnTarget.className = ""
      this.codeBtnTarget.className = ""

      activeClasses.forEach((cls) => this.codeBtnTarget.classList.add(cls))
      inactiveClasses.forEach((cls) => this.previewBtnTarget.classList.add(cls))
    }
  }
}
