const BOOTSTRAP = "Bootstrap"
const TAILWIND = "Tailwind CSS"
const BULMA = "Bulma"
const NONE = "None"

document.addEventListener("DOMContentLoaded", () => {
  const frameworkList = document.querySelector("[data-framework-list]")
  const frameworks = document.querySelectorAll("[data-framework]")
  const frameworkSelection = document.querySelector(
    "#configuration_css_framework"
  )
  const bootstrap = document.querySelector("[data-bootstrap]")
  const bulma = document.querySelector("[data-bulma]")
  const tailwind = document.querySelector("[data-tailwind]")

  frameworkSelection.addEventListener("change", (event) => {
    frameworkList.classList.remove("hidden")

    if (event.target.value === BOOTSTRAP) {
      toggleFrameworks()
      bootstrap.classList.toggle("hidden")
    } else if (event.target.value === TAILWIND) {
      toggleFrameworks()
      tailwind.classList.toggle("hidden")
    } else if (event.target.value === BULMA) {
      toggleFrameworks()
      bulma.classList.toggle("hidden")
    } else {
      toggleFrameworks()
      frameworkList.classList.add("hidden")
    }
  })

  function toggleFrameworks() {
    frameworks.forEach((f) => f.classList.add("hidden"))
  }
})
