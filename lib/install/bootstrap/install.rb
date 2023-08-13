if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "🥾 Bootstrap is already installed."
else

  # ensure sprockets plays nicely
  def optimize_sprockets
    if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
      gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
      gsub_file "app/assets/config/manifest.js", "//= link_tree ../../javascript .js\n", ""
      gsub_file "app/assets/config/manifest.js", "//= link_tree ../../../vendor/javascript .js\n", ""
    end
  end

  def copy_custom_css
    # remove default application.css so build output takes over
    remove_file "app/assets/stylesheets/application.css"

    # Copy custom SCSS
    directory "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets", Rails.root.join("app/assets/stylesheets"), force: true
  end

  def install_bootstrap
    # Copy customized Bootstrap CSS
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets/application.bootstrap.scss",
      "app/assets/stylesheets/application.bootstrap.scss"
    run "yarn add sass #{Railsui::Default::BOOTSTRAP_INSTALL_PACKAGE} bootstrap-icons @popperjs/core stimulus-use"

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
  end

  # Add themed devise views
  def add_devise_views
    if Rails.root.join("app/views/devise").exist?
      say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
    else
      directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise"), force: true
    end
  end

  def copy_images_and_assets
    directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true
  end

  def copy_customized_shared_partials
    shared_files = Dir.children("#{__dir__}/themes/#{Railsui.config.theme}/shared")
    puts "Shared #{Railsui.config.theme.humanize} partials: 🗄️ #{shared_files}"

    shared_files.each do |shared_file|
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/shared/#{shared_file}", Rails.root.join("app/views/shared/#{shared_file}"), force: true
    end
  end

  def copy_tt_templates
    say "Add Bootstrap-themed scaffold .erb templates"
    file_names = Dir.children("#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold")
    puts "Templates: 🗄️ #{file_names}"

    file_names.each do |name|
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
    end
  end

  # build scripts
  def add_build_scripts
    say "Append build:css script to package.json"

    insert_into_file Rails.application.root.join("package.json"),
    after: '"scripts": {' do
      "\n\t\t" + '"build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules",'
    end

    say "Append to Procfile.dev"
    append_to_file "Procfile.dev", %(css: yarn build:css --watch\n)

    say "Run build:css"
    run "yarn build:css"
  end

  def copy_stimulus_js_controllers
    say "⚡️ Add Stimulus.js controllers"
    path = "#{__dir__}/themes/#{Railsui.config.theme}/javascript/controllers"
    files = Dir.children(path)
    puts "Controller files: 🗄️ #{files}"

    # copy each controller
    files.each do |file|
      file_name = file.gsub("_controller.js", "")
      copy_file "#{path}/#{file}", Rails.root.join("app/javascript/controllers/#{file}")

      # append each import to controllers/index.js
      append_to_file "#{Rails.application.root.join("app/javascript/controllers/index.js")}", %(\nimport #{file_name.classify}Controller from "./#{file_name}_controller.js";\napplication.register("#{file_name.dasherize}", #{file_name.classify}Controller);\n)
    end
  end

  say "Make Sprockets behave"
  optimize_sprockets

  say "🎨️ Copy custom CSS"
  copy_custom_css

  say "🔥 Installing Bootstrap"
  install_bootstrap

  say "⚡️ Add build:css script"
  add_build_scripts

  say "⚡️ Add themed Devise views"
  add_devise_views

  say "🎇 Copy images and assets"
  copy_images_and_assets

  say "🔗️ Copy themed shared partial files"
  copy_customized_shared_partials

  say "🤖️ Copy scaffold templates"
  copy_tt_templates

  say "⚡️ Copy Stimulus controllers"
  copy_stimulus_js_controllers

  # Fin
  say "#{Railsui.config.css_framework.humanize} theme: #{Railsui.config.theme.humanize} installed 👍", :green
end
