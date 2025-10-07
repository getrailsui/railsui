// Use global hljs from CDN
const hljs = window.hljs

export default class extends Stimulus.Controller {
  static targets = ["snippet"]
  connect() {
    this.snippetTargets.forEach((el) => {
      hljs.highlightElement(el)
    })
  }
}
