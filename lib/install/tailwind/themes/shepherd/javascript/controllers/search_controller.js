import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["input", "overlay", "content", "anchor"]

  connect() {
    if (this.hasOverlayTarget) {
      useTransition(this, {
        element: this.overlayTarget,
      })
      // Define your key combination (e.g., Command + K for macOS, Ctrl + K for Windows)
      const keyCombination = this.isMac() ? "command+k" : "ctrl+k"

      // Set up a hotkey for the key combination
      hotkeys(keyCombination, (event, handler) => {
        event.preventDefault()
        this.toggle()
      })
    }
  }

  isMac() {
    return navigator.platform.toUpperCase().indexOf("MAC") >= 0
  }

  toggle() {
    if (this.overlayTarget.classList.contains("hidden")) {
      this.toggleTransition()
      this.inputTarget.focus()
    } else {
      this.close()
    }
  }

  close() {
    this.inputTarget.blur()
    //this.overlayTarget.classList.add("hidden")
    this.toggleTransition()
    this.inputTarget.value = ""
  }
}
