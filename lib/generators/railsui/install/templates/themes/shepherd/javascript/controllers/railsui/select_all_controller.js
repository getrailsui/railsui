import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "selectAll"]

  connect() {
    this.selectAllTarget.addEventListener("change", this.selectAll.bind(this))
  }

  selectAll() {
    const isChecked = this.selectAllTarget.checked
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = isChecked
    })
  }
}
