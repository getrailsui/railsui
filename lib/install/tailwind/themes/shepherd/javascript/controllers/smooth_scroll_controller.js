import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    event.preventDefault()
    const targetId = event.currentTarget.getAttribute("href").substring(1)
    const targetElement = document.getElementById(targetId)

    if (targetElement) {
      targetElement.scrollIntoView({ behavior: "smooth" })
    }
  }
}
