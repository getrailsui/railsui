const presets = require("railsui-tailwind-presets")
const execSync = require("child_process").execSync
const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"

module.exports = {
  // Load Rails UI Tailwind CSS preset
  // based on active theme in railsui.yml
  presets: [presets.hound],
  // Customizations specific to this project would go below here
  content: [
    "./config/initializers/railsui_icon.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/components/**/*.html.erb",
    "./app/components/**/*.rb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.html.erb",
    rails_ui_path,
    rails_ui_template_path,
  ],
  theme: {
    extend: {},
  },
}
