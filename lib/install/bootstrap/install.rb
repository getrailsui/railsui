theme_stylesheet_path = "themes/#{Railsui.config.theme}/stylesheets"

if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "🛑 Bootstrap is already installed. For best results uninstall it and re-run the Rails UI installer."
else
  if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
    append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)

    say "Stop linking stylesheets automatically"
    gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
  end

  say "🔥 Installing Bootstrap"
  # source: https://github.com/rails/cssbundling-rails/blob/main/lib/install/bootstrap/install.rb

  # Copy customized Bootstrap CSS
  copy_file "#{__dir__}/#{theme_stylesheet_path}/application.bootstrap.scss",
    "app/assets/stylesheets/application.bootstrap.scss"
  run "yarn add sass bootstrap bootstrap-icons @popperjs/core"

  # Add bootstrap icons even though Rails UI doesn't make use of them
  inject_into_file "config/initializers/assets.rb", after: /.*Rails.application.config.assets.paths.*\n/ do
    <<~RUBY
      Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
    RUBY
  end

  # Add Bootstrap JS
  if Rails.root.join("app/javascript/application.js").exist?
    say "⚡️ Appending Bootstrap JavaScript import to default entry point"
    append_to_file "app/javascript/application.js", %(import * as bootstrap from "bootstrap"\n)
  else
    say %(Add import * as bootstrap from "bootstrap" to your entry point JavaScript file), :red
  end

  # build scripts
  say "⚡️ Add build:css script"
  build_script = "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"

  case `npx -v`.to_f
  when 7.1...8.0
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  when (8.0..)
    run %(npm pkg set scripts.build:css="#{build_script}")
    run %(yarn build:css)
  else
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :green
  end

  # remove application.css
  say "Remove app/assets/stylesheets/application.css so build output can take over"
  remove_file "app/assets/stylesheets/application.css"

  # Copy custom CSS/SCSS
  say "Copy custom CSS/SCSS"
  directory "#{__dir__}/#{theme_stylesheet_path}", force: true

  run "yarn build:css"

  # Add themed devise views
  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "⚡️ Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise"), force: true
  end

  say "Append to Procfile.dev"
  append_to_file "Procfile.dev", %(css: yarn build:css --watch\n)

  # Theme assets
  say "⚡️ Copy images and assets"
  directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true

  say "⚡️ Copy shared partial files"
  shared_files = ["_error_messages.html.erb", "_flash.html.erb"]
  shared_files.each do |shared_file|
    unless Rails.root.join("app/views/shared/#{shared_file}").exist?
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/shared/#{shared_file}", Rails.root.join('app/view/shared')
    else
      "🛑 #{shared_file} already exists, skipping."
    end
  end

  # TODO: Not copying correctly as a directory so we go 1:1
  say "Add Bootstrap-themed scaffold .erb templates"
  # directory "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold", Rails.root.join("lib/templates/erb/scaffold"), force: true
  file_names = ["_form.html.erb.tt", "edit.html.erb.tt", "index.html.erb.tt", "new.html.erb.tt", "partial.html.erb.tt", "show.html.erb.tt"]

  file_names.each do |name|
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
  end

  # Fin
  say "Bootstrap theme installed 👍", :green
end
