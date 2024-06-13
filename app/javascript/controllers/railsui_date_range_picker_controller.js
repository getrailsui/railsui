import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

const currentDate = new Date()
const oneWeekLater = new Date(currentDate.getTime() + 7 * 24 * 60 * 60 * 1000)

export default class extends Controller {
  static targets = ["label", "input"]
  static values = {
    mode: String || "",
    minDate: String || "today",
    dateFormat: String || "Y-m-d",
    range: {
      type: Array,
      default: [currentDate, oneWeekLater],
    },
  }

  connect() {
    // Parse the rangeValue if passed otherwise fallback to defaults (today + 1.week)
    // Add to data-controller wrapper data-date-range-picker-range-value='["2023-11-18", "2023-11-25"]' =>
    this.rangeValue = this.rangeValue.map((dateString) => new Date(dateString))

    let self = this
    const picker = flatpickr(this.element, {
      mode: "range",
      minDate: this.minDateValue,
      dateFormat: this.dateFormatValue,
      defaultDate: this.rangeValue,
      onChange: function (selectedDates, dateStr, instance) {
        self.setCurrentRange(instance)
      },
    })

    this.setCurrentRange(picker)
  }

  setCurrentRange(picker) {
    const formatDate = (date) => {
      const options = { month: "short", day: "numeric" }
      return date.toLocaleDateString("en-US", options)
    }

    const range = picker.selectedDates.map(formatDate).join(" - ")

    if (this.hasLabelTarget) {
      this.labelTarget.textContent = range

      // Update formatting to match your data type needs
      // See: https://flatpickr.js.org/options/
      this.inputTarget.value = picker.selectedDates
    }

    // Do something with the server to return dates
  }
}
