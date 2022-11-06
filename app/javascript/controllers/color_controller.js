import "vanilla-colorful"
import "vanilla-colorful/hex-input.js"

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker"]
  connect() {
    this.pickerTargets.forEach((picker) => {
      picker.addEventListener("color-changed", (event) => {
        picker.previousElementSibling.value = event.detail.value
        picker.nextElementSibling.color = event.detail.value
        picker.color = event.detail.value
        picker.value = event.detail.value
      })
    })
  }
}
