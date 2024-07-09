const execSync = require("child_process").execSync
const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"

module.exports = {
  // Load Rails UI Tailwind CSS preset
  // based on active theme in railsui.yml
  presets: [require("./railsui.hound.preset.js")],
  // Customizations specific to this project would go here
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
    extend: {},
  },
}
