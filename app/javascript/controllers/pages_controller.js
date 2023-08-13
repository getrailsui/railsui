import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  checkAll() {
    const checkAllCheckbox = this.checkboxTargets[0]
    const checkboxes = this.checkboxTargets.slice(1)

    checkboxes.forEach((checkbox) => {
      checkbox.checked = !checkbox.checked
    })

    checkAllCheckbox.checked = checkboxes.every((checkbox) => checkbox.checked)
  }
}
