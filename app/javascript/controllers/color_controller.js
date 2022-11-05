import "vanilla-colorful"
import 'vanilla-colorful/hex-input.js';

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker"]
  connect() {
    this.pickerTargets.forEach((picker) => {
      picker.addEventListener("color-changed", (event) => {
        p.previousElementSibling.value = event.detail.value
        p.nextElementSibling.color = event.detail.value
        p.color = event.detail.value
        p.value = event.detail.value
      })

      p.nextElementSibling.addEventListener("color-changed", (event) => {
        p.color = event.detail.value
      })
    })
  }
}
