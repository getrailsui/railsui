import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "send"]
  static outlets = ["character-count"]

  connect() {
    this.setupInputHandling()
  }

  setupInputHandling() {
    this.sendTarget.disabled = this.inputTarget.value.trim().length === 0
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.sendMessage()
    }
  }

  sendMessage() {
    const message = this.inputTarget.value.trim()
    if (!message) return
    this.inputTarget.value = ""
    this.sendTarget.disabled = true
    this.resetCharacterCount()
    this.showMessageSent()
  }

  resetCharacterCount() {
    if (this.hasCharacterCountOutlet) {
      this.characterCountOutlet.reset()
    }
  }

  showMessageSent() {
    const originalText = this.sendTarget.innerHTML
    this.sendTarget.innerHTML =
      '<svg class="size-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>'
    setTimeout(() => {
      this.sendTarget.innerHTML = originalText
    }, 1000)
  }
}
