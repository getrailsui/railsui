import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "interval", "intervalBtn", "promotion"]

  initialize() {
    this.interval = "month"
  }

  toggle(event) {
    // Toggle the interval
    this.interval = this.interval === "month" ? "year" : "month"

    // Update the plan prices and intervals
    this.priceTargets.forEach((price) => {
      const monthlyPrice = price.dataset.month
      const annualPrice = price.dataset.year

      price.innerText = this.interval === "month" ? monthlyPrice : annualPrice
    })

    // Update the plan intervals
    this.intervalTargets.forEach((interval) => {
      interval.innerText = `/${this.interval}`
    })

    // Toggle button appearance
    this.intervalBtnTargets.forEach((btn) => {
      if (event.currentTarget === btn) {
        btn.classList.remove("btn", "btn-transparent")
        btn.classList.add("btn", "btn-primary")
      } else {
        btn.classList.remove("btn", "btn-primary")
        btn.classList.add("btn", "btn-transparent")
      }
    })

    // Show promotion on annual plans
    this.promotionTarget.classList.toggle("hidden")
  }
}
