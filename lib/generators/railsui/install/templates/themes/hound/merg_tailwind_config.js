const fs = require("fs")
const path = require("path")
const deepmerge = require("deepmerge")

// Path to the existing Tailwind config
const tailwindConfigPath = path.resolve(__dirname, "tailwind.config.js")

// Function to load and parse the existing Tailwind config
const loadExistingConfig = () => {
  if (fs.existsSync(tailwindConfigPath)) {
    delete require.cache[require.resolve(tailwindConfigPath)]
    return require(tailwindConfigPath)
  }
  return {}
}

// Load the existing configuration
const existingConfig = loadExistingConfig()

// Paths to Rails UI files
const execSync = require("child_process").execSync
const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"

// Define the new configuration to be merged
const newConfig = {
  content: [
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.html.erb",
    "./app/components/**/*.html.erb",
    "./app/components/**/*.rb",
    rails_ui_path,
    rails_ui_template_path,
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          50: "rgb(var(--primary-50) / <alpha-value>)",
          100: "rgb(var(--primary-100) / <alpha-value>)",
          200: "rgb(var(--primary-200) / <alpha-value>)",
          300: "rgb(var(--primary-300) / <alpha-value>)",
          400: "rgb(var(--primary-400) / <alpha-value>)",
          500: "rgb(var(--primary-500) / <alpha-value>)",
          600: "rgb(var(--primary-600) / <alpha-value>)",
          700: "rgb(var(--primary-700) / <alpha-value>)",
          800: "rgb(var(--primary-800) / <alpha-value>)",
          900: "rgb(var(--primary-900) / <alpha-value>)",
          950: "rgb(var(--primary-950) / <alpha-value>)",
        },
        secondary: {
          50: "rgb(var(--secondary-50) / <alpha-value>)",
          100: "rgb(var(--secondary-100) / <alpha-value>)",
          200: "rgb(var(--secondary-200) / <alpha-value>)",
          300: "rgb(var(--secondary-300) / <alpha-value>)",
          400: "rgb(var(--secondary-400) / <alpha-value>)",
          500: "rgb(var(--secondary-500) / <alpha-value>)",
          600: "rgb(var(--secondary-600) / <alpha-value>)",
          700: "rgb(var(--secondary-700) / <alpha-value>)",
          800: "rgb(var(--secondary-800) / <alpha-value>)",
          900: "rgb(var(--secondary-900) / <alpha-value>)",
          950: "rgb(var(--secondary-950) / <alpha-value>)",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    // https://github.com/adoxography/tailwind-scrollbar
    require("tailwind-scrollbar")({ nocompatible: true }),
  ],
}

// Merge the existing config with the new config
const mergedConfig = deepmerge(existingConfig, newConfig)

// Convert the merged config to a string
const mergedConfigString = `module.exports = ${JSON.stringify(
  mergedConfig,
  null,
  2
)};`

// Write the merged config back to the file
fs.writeFileSync(tailwindConfigPath, mergedConfigString)

console.log("Tailwind CSS configuration has been successfully merged.")
