module.exports = {
  important: true,
  content: [
    "./app/helpers/**/*.rb",
    "./app/views/**/*.html.erb",
    "./app/javascript/**/*.{js,vue,jsx}",
    "./lib/generators/templates/**/*.html.erb.tt",
  ],
  theme: {
    extend: {
      fontFamily: {
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
      },
      keyframes: {
        "fade-in": {
          "0%": { opacity: "0%" },
          "100%": { opacity: "100%" },
        },
      },
      animation: {
        "fade-in": "fade-in 0.3s ease-in-out",
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
  ],
}
