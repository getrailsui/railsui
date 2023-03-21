if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "🛑 Bootstrap is already installed. For best results uninstall it and re-run the Rails UI installer."
else

  def swap_sprockets_to_builds
    if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
    append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)

    gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
    end
  end

  def copy_custom_css
    # remove default application.css so build output takes over
    remove_file "app/assets/stylesheets/application.css"

    # Copy custom SCSS
    directory "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets", Rails.root.join("app/assets/stylesheets"), force: true
  end

  def install_bootstrap
    # source: https://github.com/rails/cssbundling-rails/blob/main/lib/install/bootstrap/install.rb

    # Copy customized Bootstrap CSS
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets/application.bootstrap.scss",
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

    run "yarn build:css"
  end

  # Add themed devise views
  def add_devise_views
    if Rails.root.join("app/views/devise").exist?
      say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
      directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise"), force: true
    end
  end

  def procfile_setup
    append_to_file "Procfile.dev", %(css: yarn build:css --watch\n)
  end

  def copy_images_and_assets
    directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true
  end

  def copy_customized_shared_partials
    shared_files = Dir.children("#{__dir__}/themes/#{Railsui.config.theme}/shared")
    puts "Shared partials: 🗄️ #{shared_files}"

    shared_files.each do |shared_file|
      unless Rails.root.join("app/views/shared/#{shared_file}").exist?
        copy_file   "#{__dir__}/themes/#{Railsui.config.theme}/shared/#{shared_file}", Rails.root.join("app/view/shared/#{shared_file}")
      else
        "🛑 #{shared_file} already exists, skipping."
        end
    end
  end

  def copy_tt_templates
    # TODO: .tt files get converted to erb with Thor. Need a workaround.
    say "Add Bootstrap-themed scaffold .erb templates"
    file_names = Dir.children("#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold")
    puts "Templates: 🗄️ #{file_names}"

    file_names.each do |name|
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
    end
  end

  # build scripts
  def add_build_scripts
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
  end

  say "Stop linking stylesheets automatically"
  swap_sprockets_to_builds

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

  say "🛹  Configure Procfile.dev"
  procfile_setup

  # Fin
  say "#{Railsui.config.css_framework.humanize} theme: #{Railsui.config.theme.humanize} installed 👍", :green
end
