import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    event.preventDefault()

    const target = document.querySelector(event.currentTarget.hash)
    if (target) {
      target.scrollIntoView({ behavior: "smooth" })

      // Update the URL with the clicked link's href
      const href = event.currentTarget.getAttribute("href")
      if (href) {
        history.pushState({}, "", href)
      }
    }
  }
}
