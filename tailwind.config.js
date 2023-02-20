module.exports = {
  important: true,
  content: [
    "./app/helpers/**/*.rb",
    "./app/views/**/*.html.erb",
    "./app/javascript/**/*.{js,vue,jsx}",
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
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/aspect-ratio"),
  ],
}
