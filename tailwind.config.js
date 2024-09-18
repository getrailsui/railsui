const execSync = require("child_process").execSync
const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"

const defaultTheme = require("tailwindcss/defaultTheme")
module.exports = {
  //important: true,
  content: [
    "./app/helpers/**/*.rb",
    "./app/views/**/*.html.erb",
    "./app/components/**/*.html.erb",
    "./app/javascript/**/*.{js,vue,jsx}",
    "./lib/generators/templates/**/*.html.erb.tt",
    "./config/initializers/railsui_icon.rb",
    rails_ui_path,
    rails_ui_template_path,
  ],
  theme: {
    extend: {
      fontFamily: {
        rui: ["Inter", ...defaultTheme.fontFamily.sans],
        mono: ["Fira Code", "monospace"],
      },
      colors: {
        salmon: {
          500: "#FA8072",
        },
        rails: {
          500: "#D30001",
          600: "#9b0203",
          700: "#800001",
        },
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
      animation: {
        "fade-in": "fade-in 0.3s ease-in-out",
        "toast-from-right":
          "toast-from-right 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55)",
        "toast-from-left":
          "toast-from-left 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55)",
      },

      keyframes: {
        "fade-in": {
          "0%": { opacity: "0%" },
          "100%": { opacity: "100%" },
        },
        "toast-from-right": {
          "0%": { transform: "translateX(50%)", opacity: "0%" },
          "100%": { transform: "translateX(0)", opacity: "100%" },
        },
        "toast-from-left": {
          "0%": { transform: "translateX(-50%)", opacity: "0%" },
          "100%": { transform: "translateX(0)", opacity: "100%" },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("tailwind-scrollbar"),
  ],
}
