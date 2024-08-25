import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"

export default class extends Controller {
  static values = {
    name: String,
    data: Array,
    yAxisMin: Number,
    default: 0,
    yAxisMax: { type: Number, default: 100 },
    yAxisDenomination: { type: String, default: "%" },
  }

  connect() {
    // Add an event listener for changes in color scheme if theme switch
    window.matchMedia("(prefers-color-scheme: dark)").addListener(() => {
      this.initializeChart()
      this.updateChartTheme()
    })

    // Initial setup
    this.initializeChart()
    this.updateChartTheme()
  }

  initializeChart() {
    const options = {
      series: [
        {
          name: this.nameValue,
          data: this.dataValue,
        },
      ],
      chart: {
        height: 350,
        type: "line",
        background: "transparent",
        toolbar: {
          show: false,
        },
        // Add the theme property
        theme: {
          mode: this.isDarkMode() ? "dark" : "light",
        },
      },
      stroke: {
        width: 5,
        curve: "smooth",
      },
      xaxis: {
        type: "datetime",
        tickAmount: 6,
        labels: {
          formatter: function (value, timestamp, opts) {
            return opts.dateFormatter(new Date(timestamp), "MM/dd")
          },
          style: {
            fontFamily: "Lexend",
            fontSize: 14,
          },
        },
      },
      yaxis: {
        min: this.yAxisMinValue,
        max: this.yAxisMaxValue,
        tickAmount: 5,
        labels: {
          formatter: (value) =>
            `${value.toFixed(2)} ${this.yAxisDenominationValue}`,
          style: {
            fontFamily: "Lexend",
            fontSize: 14,
          },
        },
      },
      fill: {
        type: "gradient",
        gradient: {
          shade: "dark",
          gradientToColors: ["#F43F5E"],
          shadeIntensity: 1,
          type: "horizontal",
          opacityFrom: 1,
          opacityTo: 1,
          stops: [0, 100, 100, 100],
        },
      },
      tooltip: {
        x: {
          title: {
            formatter: (seriesName) =>
              `${seriesName.toFixed(2)} ${this.yAxisDenominationValue}`,
          },
        },
        marker: {
          show: false,
        },
      },
    }

    this.chart = new ApexCharts(this.element, options)
    this.chart.render()
  }

  updateChartTheme() {
    if (this.chart) {
      const newTheme = this.isDarkMode() ? "dark" : "light"
      this.chart.updateOptions({
        theme: {
          mode: newTheme,
        },
      })
    }
  }

  isDarkMode() {
    return (
      window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
    )
  }
}
