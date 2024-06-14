import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "scrollContainer"]

  static values = {
    activeClass: String,
    inactiveClass: String,
  }

  connect() {
    if (this.hasScrollContainerTarget) {
      this.scrollHandler = this.scrollHandler.bind(this)
      this.scrollContainerTarget.addEventListener("scroll", this.scrollHandler)
    }
  }

  disconnect() {
    this.scrollContainerTarget.removeEventListener("scroll", this.scrollHandler)
  }

  scrollHandler() {
    const scrollPosition = this.scrollContainerTarget.scrollTop

    // Loop through each link and check if its corresponding section is in view
    this.linkTargets.forEach((link) => {
      // Add a check for null or undefined link
      // if (!link) {
      //   return
      // }

      const targetId = link.getAttribute("href")

      // // Add a check for null or undefined targetId
      if (!targetId) {
        return
      }

      const targetElement = document.querySelector(targetId)

      if (targetElement) {
        const targetPosition = targetElement.offsetTop
        const targetHeight = targetElement.offsetHeight

        if (
          scrollPosition >= targetPosition &&
          scrollPosition < targetPosition + targetHeight
        ) {
          this.activateLink(link)
        } else {
          this.deactivateLink(link)
        }
      }
    })
  }

  activateLink(link) {
    const activeClasses = this.activeClassValue.split(" ")

    activeClasses.forEach((className) => {
      link.classList.add(className)
    })

    const inactiveClasses = this.inactiveClassValue.split(" ")

    inactiveClasses.forEach((className) => {
      link.classList.remove(className)
    })
  }

  deactivateLink(link) {
    const activeClasses = this.activeClassValue.split(" ")

    activeClasses.forEach((className) => {
      link.classList.remove(className)
    })

    const inactiveClasses = this.inactiveClassValue.split(" ")

    inactiveClasses.forEach((className) => {
      link.classList.add(className)
    })
  }
}
