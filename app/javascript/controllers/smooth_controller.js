import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    event.preventDefault()
    let item = event.currentTarget.hash

    let target = document.querySelector(item)
    target.scrollIntoView({
      behavior: 'smooth'
    })
  }
}
