import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"

export default class extends Controller {
  static targets = ["companygoals", "teamgoals"]

  connect() {
    this.isDarkMode = this.isSystemInDarkMode()
    this.chart = null
    this.teamChart = null

    this.currencyFormatter = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })

    this.valueFormatter = (value) => {
      return this.currencyFormatter.format(value)
    }

    this.totalFormatter = (w) => {
      const seriesTotals = w.globals.seriesTotals
      return seriesTotals[0].toLocaleString("en-US", {
        style: "currency",
        currency: "USD",
        minimumFractionDigits: 0,
      })
    }

    this.updateCharts()
    this.setDarkModeListener()
  }

  isSystemInDarkMode() {
    return (
      window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
    )
  }

  setDarkModeListener() {
    window
      .matchMedia("(prefers-color-scheme: dark)")
      .addEventListener("change", (e) => {
        this.isDarkMode = e.matches
        this.updateCharts()
      })
  }

  setChartColors() {
    const colorScheme = this.isDarkMode
      ? ["#d9826b", "#f1a03b"]
      : ["#4f46e5", "#cbd5e1"]

    const options = {
      series: [800530, 1500000],
      colors: colorScheme,
      labels: ["Gross Revenue", "Total Revenue Goal"],
      chart: {
        type: "donut",
      },
      dataLabels: {
        enabled: false,
      },
      plotOptions: {
        pie: {
          expandOnClick: false,
          donut: {
            labels: {
              show: true,
              name: {
                show: false,
              },
              value: {
                show: true,
                fontSize: 13,
                offsetY: 5,
                formatter: this.valueFormatter,
                style: {
                  colors: this.isDarkMode ? "#ffffff" : "#333",
                },
              },
              total: {
                show: true,
                formatter: this.totalFormatter,
              },
            },
          },
        },
      },
      tooltip: {
        y: {
          formatter: this.valueFormatter,
        },
      },
      legend: {
        show: false,
      },
      states: {
        hover: {
          filter: {
            type: "none",
          },
        },
      },
      yaxis: {
        labels: {
          formatter: this.valueFormatter,
        },
      },
    }

    if (this.chart) {
      this.chart.destroy()
    }

    this.chart = new ApexCharts(this.companygoalsTarget, options)

    this.chart.render()

    const totalElement = this.chart.w.globals.dom.baseEl.querySelector(
      ".apexcharts-datalabels-group text"
    )

    totalElement.style.color = this.isDarkMode ? "#ffffff" : "#333"
    totalElement.style.fill = this.isDarkMode ? "#ffffff" : "#333"
  }

  setTeamChartColors() {
    const teamColorScheme = this.isDarkMode
      ? ["#d9826b", "#f1a03b"]
      : ["#4f46e5", "#cbd5e1"]
    const teamChartOptions = {
      series: [
        {
          name: "Net revenue",
          data: [
            129000, 123993, 134003, 128400, 122340, 131400, 133293, 149000,
            132993, 125302,
          ],
        },
      ],
      dataLabels: {
        enabled: false,
      },
      colors: teamColorScheme,
      chart: {
        type: "bar",
        toolbar: {
          show: false,
        },
      },
      plotOptions: {
        bar: {
          barHeight: "100%",
        },
      },
      xaxis: {
        labels: {
          style: {
            colors: this.isDarkMode ? "#ffffff" : "#333",
          },
        },
        categories: [
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
        ],

        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
      yaxis: {
        labels: {
          show: false,
        },
      },
      tooltip: {
        theme: "dark",
        x: {
          show: false,
        },
        y: {
          formatter: this.valueFormatter,
        },
      },
      legend: {
        show: false,
      },
    }

    if (this.teamChart) {
      this.teamChart.destroy()
    }

    this.teamChart = new ApexCharts(this.teamgoalsTarget, teamChartOptions)

    this.teamChart.render()
  }

  updateCharts() {
    this.setChartColors()
    this.setTeamChartColors()
  }
}
