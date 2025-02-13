const execSync = require("child_process").execSync
const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"

module.exports = {
  content: [
    "./lib/generators/templates/**/*.html.erb.tt",
    "./config/initializers/railsui_icon.rb",
    rails_ui_path,
    rails_ui_template_path,
  ],
}
