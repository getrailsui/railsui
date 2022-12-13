theme_stylesheet_path = "themes/#{Railsui.config.theme}/stylesheets"

if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "Bootstrap is already installed 👍"
else
  if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
    append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)

    say "Stop linking stylesheets automatically"
    gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
  end

  say "🔥 Installing Bootstrap"
  # source: https://github.com/rails/cssbundling-rails/blob/main/lib/install/bootstrap/install.rb

  copy_file "#{__dir__}/#{theme_stylesheet_path}/application.bootstrap.scss",
    "app/assets/stylesheets/application.bootstrap.scss"
  run "yarn add sass bootstrap bootstrap-icons @popperjs/core"

  inject_into_file "config/initializers/assets.rb", after: /.*Rails.application.config.assets.paths.*\n/ do
    <<~RUBY
      Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
    RUBY
  end

  if Rails.root.join("app/javascript/application.js").exist?
    say "Appending Bootstrap JavaScript import to default entry point"
    append_to_file "app/javascript/application.js", %(import * as bootstrap from "bootstrap"\n)
  else
    say %(Add import * as bootstrap from "bootstrap" to your entry point JavaScript file), :red
  end

  say "Add build:css script"
  build_script = "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"

  if (`npx -v`.to_f < 7.1 rescue "Missing")
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :red
  else
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  end

  # remove application.css
  say "Remove app/assets/stylesheets/application.css so build output can take over"
  remove_file "app/assets/stylesheets/application.css"

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
