if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "Bootstrap is already installed 👍"
else
  if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
    append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)

    say "Stop linking stylesheets automatically"
    gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
  end

  say "🔥 Installing Bootstrap"
  rails_command "css:install:bootstrap", force: true

  theme_stylesheet_path = "themes/#{Railsui.config.theme}/stylesheets"

  copy_file "#{__dir__}/#{theme_stylesheet_path}/application.bootstrap.scss",
    "app/assets/stylesheets/application.bootstrap.scss", force: true
  copy_file "#{__dir__}/#{theme_stylesheet_path}/custom.scss", "app/assets/stylesheets/custom.scss"

  run "yarn build:css"

  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise"), force: true
  end

  say "Copy images"
  directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true

  # TODO: Figure out why this won't copy
  say "Add Bootstrap-themed scaffold .erb templates"
  # directory "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold", Rails.root.join("lib/templates/erb/scaffold"), force: true
  file_names = ["_form.html.erb.tt", "edit.html.erb.tt", "index.html.erb.tt", "new.html.erb.tt", "partial.html.erb.tt", "show.html.erb.tt"]

  file_names.each do |name|
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
  end

  say "Bootstrap theme installed 👍", :green
end
