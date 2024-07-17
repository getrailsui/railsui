import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "inboxBtn",
    "inboxContainer",
    "messageContainer",
    "bookingContainer",
  ]

  toggle(event) {
    console.log(event.target.dataset.buttonValue)
    this.resetButtons()

    switch (event.target.dataset.buttonValue) {
      case "inbox":
        event.target.classList.add("text-primary-600")
        this.showInbox()
        break
      case "message":
        event.target.classList.add("text-primary-600")
        this.showMessage()
        break
      case "booking":
        event.target.classList.add("text-primary-600")
        this.showBooking()
    }
  }

  showInbox() {
    this.inboxContainerTarget.style.display = "block"
    this.messageContainerTarget.style.display = "none"
    this.bookingContainerTarget.style.display = "none"
  }

  showMessage() {
    this.messageContainerTarget.style.display = "block"
    this.inboxContainerTarget.style.display = "none"
    this.bookingContainerTarget.style.display = "none"
  }

  showBooking() {
    this.bookingContainerTarget.style.display = "block"
    this.inboxContainerTarget.style.display = "none"
    this.messageContainerTarget.style.display = "none"
  }

  resetButtons() {
    this.inboxBtnTargets.forEach((btn) => {
      btn.classList.remove("text-primary-600")
    })
  }
}
