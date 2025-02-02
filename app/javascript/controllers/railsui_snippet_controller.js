import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "previewBtn", "code", "codeBtn"]

  ACTIVE_CLASSES = [
    "rui:bg-white",
    "rui:px-3",
    "rui:py-1.5",
    "rui:rounded-md",
    "rui:shadow-sm",
    "rui:flex",
    "rui:items-center",
    "rui:justify-center",
    "rui:gap-2",
    "rui:text-[13px]",
    "rui:font-semibold",
    "rui:focus:ring-4",
    "rui:focus:ring-blue-600",
    "rui:group",
    "rui:dark:bg-neutral-800/90",
    "rui:dark:text-neutral-100",
    "rui:dark:focus:ring-blue-600/50",
    "rui:dark:text-neutral-300",
  ]

  INACTIVE_CLASSES = [
    "rui:bg-transparent",
    "rui:px-3",
    "rui:py-1.5",
    "rui:rounded-md",
    "rui:shadow-none",
    "rui:flex",
    "rui:items-center",
    "rui:justify-center",
    "rui:gap-2",
    "rui:text-[13px]",
    "rui:font-semibold",
    "rui:dark:text-neutral-300",
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
      if (!this.previewTarget.classList.contains("rui:hidden")) {
        return // Already in the desired state
      }

      this.previewTarget.classList.toggle("rui:hidden")
      this.codeTarget.classList.add("rui:hidden")
      this.previewBtnTarget.className = ""
      this.codeBtnTarget.className = ""

      activeClasses.forEach((cls) => this.previewBtnTarget.classList.add(cls))
      inactiveClasses.forEach((cls) => this.codeBtnTarget.classList.add(cls))
    } else if (target === "code") {
      if (!this.codeTarget.classList.contains("rui:hidden")) {
        return // Already in the desired state
      }

      this.codeTarget.classList.toggle("rui:hidden")
      this.previewTarget.classList.add("rui:hidden")

      this.previewBtnTarget.className = ""
      this.codeBtnTarget.className = ""

      activeClasses.forEach((cls) => this.codeBtnTarget.classList.add(cls))
      inactiveClasses.forEach((cls) => this.previewBtnTarget.classList.add(cls))
    }
  }
}
