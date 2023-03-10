import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";

export default class extends Controller {
  static targets = ["result", "form", "resultList"]
  currentResults = this.resultListTarget.innerHTML;

  search(event) {
    if (event.target.value) {
      this.filterList(event)
    } else {
      this._resetList()
    }
  }

  clear(event) {
    console.log(event)
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
    } else {
      temp = `No results`
    }
    this.resultListTarget.innerHTML = temp;
  }

  _resetList() {
    this.resultListTarget.innerHTML = this.currentResults
  }
}
