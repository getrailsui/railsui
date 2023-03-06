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
        rails: {
          500: '#D30001',
          600: '#9b0203',
          700: '#800001'
        }
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
