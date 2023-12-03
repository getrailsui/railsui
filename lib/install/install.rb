source_root = File.expand_path('../templates', __FILE__)

require_relative "setup"
require_relative "tailwind_setup"

if Railsui.config.theme == nil
  say "⚡️⚡️⚡️⚡️ Rails UI first run ⚡️⚡️⚡️⚡️"

  run "bundle install"

  say "❌ Remove importmaps"
  remove_importmaps

  say "➡️ Copy optimized application_mailer.rb file"
  copy_application_mailer

  say "👨‍💻 Configuring Devise..."
  add_users

  say "✨ Add esbuild"
  add_esbuild

  say "✨ Add Stimulus.js"
  add_stimulus

  say "🚀 Installing turbo for good measure"
  add_turbo

  say "🎨 Add custom css-bundling setup"
  add_css_bundling_setup

  say "⛏️ Setup routes"
  setup_routes

  say "🤖 Generate PageController"
  add_page_controller

  # Make sure it's before the extend_layout_and_views method
  say "👨‍💻 Add devise layout and customizations..."
  add_devise_customizations

  say "👨‍💻 Extending layout and views..."
  extend_layout_and_views

  say "👨‍💻 Configuring template engine with fallbacks..."
  add_custom_template_engine

  say "👨‍💻 Configure application controller"
  add_application_controller_code

  say "👨‍💻 Adding ActiveStorage and ActionText dependencies..."
  add_storage_and_rich_text

  say "☕️ Copy hero icon library"
  copy_hero_icons

  say "⚡️ Add additional user.rb attributes"
  add_user_attributes

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"
else
  say "⚡️ Setup themes"
  add_tailwind
end

say "
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMWXOxooodOXMMMMMMMMMMWXxxXMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXd:,..     'dXMMMMWWKx:.  ,OWMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXO0KK0x:     cXWKxool'     .oXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMNc    .:o:.lNWXl.     ,OWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    'O0;oMMMWk'     .dNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMWo     :NK;dMMMMMKc     .xWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMWKdl,     :NK;dMMMMMMNd. .lONMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMNkooxKd     :NK;dMMMMWKxllkXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMW0l' .:ONd     :NK;oMMXk:..dNMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMNx,.    ,'     :NK;;xl.    .;xNMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMW0o,         :NK,.::,.      ,kWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMNx'       :NK;oMMWKx,     .lNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMXc      :NK;oMMMMMNo.     oWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMX:     :NK;dMMMMMMWd.    .xMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    :X0;dMMMMMMMNl     '0MMMMMMMMMMMMMM
MMMMMMMMMMMMMMMXOo:.      ''.,dx0NMMMMXc     ;KMMMMMMMMMMMMM
MMMMMMMMMMMMNkc.                .'codXMK;     'dxKMMMMMMMMMM
MMMMMMMMMMNx,. .',;:::;,..        .lKWMMK;     ,dXMMMMMMMMMM
MMMMMMMMMNxldk0XNWMMMMMWNKkl,.  .lKWMMMMMXo. ,xNMMMMMMMMMMMM
MMMMMMMMMWWMMMMMMMMMMMMMMMMMW0kkKWMMMMMMMMWKONMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
"
say "✅"
say "Run bin/dev to boot the rails server", :yellow
