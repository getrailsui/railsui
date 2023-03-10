import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";

export default class extends Controller {
  static targets = ["result", "form", "resultList"]
  currentResults = this.resultListTarget.innerHTML;

  search(event) {
    this.filterList(event)
  }

  clear(event) {
    event.target.value = ''
    this._resetList()
  }

  filterList(event) {
    let temp = ''
    const result  = this.resultTargets.filter(item=> item.dataset.searchRouteValue.includes(event.target.value));

    if (result.length > 0) {
      temp = `<div class="divide-slate-200 divide-y">`
      result.forEach((item) => {
        temp += `${item.outerHTML}`
      })
      temp += `</div>`

      this.resultListTarget.innerHTML = temp;
    } else {
      temp = `No results`
      this._resetList()
    }

  }

  _resetList() {
    this.resultListTarget.innerHTML = this.currentResults
  }
}
