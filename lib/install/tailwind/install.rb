# General FYI: Tailwind requires more finesse to have ability to make use of more advanced PostCSS features. I'm borrowing from the cssbundling-rails gem install.rb file here to accomodate.

if Railsui.config.pages.any? && Railsui.config.theme.present?
  say "🔔 #{Railsui.config.theme.humanize} theme already installed and configured"
else
  say "🔔 Installing #{Railsui.config.theme.humanize} theme dependencies"

  # Skip it all if Tailwind already exists.
  if Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
    say "🛑 Tailwind CSS is already installed. For best results create a new app and run the Rails UI installer."
  else
    say "🔥 Install Tailwind (+PostCSS w/ autoprefixer)"
    # Getcha tailwind.config.js
    unless Rails.root.join("tailwind.config.js").exist?
      say "⬅️ Adding tailwind.config.js"
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/tailwind.config.js",
    "tailwind.config.js", force: true
    else
      say "✅ tailwind.config.js already exists"
    end

    # ensure sprockets plays nicely
    if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
      gsub_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets .css\n", ""
      gsub_file "app/assets/config/manifest.js", "//= link_tree ../../javascript .js\n", ""
      gsub_file "app/assets/config/manifest.js", "//= link_tree ../../../vendor/javascript .js\n", ""
    end

    # remove application.css
    say "⚡️ Remove app/assets/stylesheets/application.css so build output can take over"
    remove_file "app/assets/stylesheets/application.css"

    # add theme stylesheets
    directory "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets", "app/assets/stylesheets", force: true

    # Add postcss.config.js
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/postcss.config.js", "postcss.config.js", force: true

    # Yarn stuffs
    run "yarn add tailwindcss postcss autoprefixer postcss-import postcss-nesting @tailwindcss/forms @tailwindcss/typography stimulus-use tippy.js tailwind-scrollbar --latest"

    # Copy themed devise views
    if Rails.root.join("app/views/devise").exist?
      say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
    else
      say "⚡️ Add themed Devise views"
      directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
    end

    say "⚡️ Add Tailwind-themed scaffold .erb templates"
    file_names = ["_form.html.erb.tt", "edit.html.erb.tt", "index.html.erb.tt", "new.html.erb.tt", "partial.html.erb.tt", "show.html.erb.tt"]

    file_names.each do |name|
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
    end

    # Copy over image assets for corresponding theme
    say "⚡️ Copy images/assets"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true

    # Copy themed globally shared partials
    # These files overide those shipped during first install of Rails UI
    say "⚡️ Copy shared partial files"
    shared_files = ["_error_messages.html.erb", "_flash.html.erb", "_nav.html.erb", "_nav_menu.html.erb", "_footer.html.erb", "_fonts.html.erb"]

    shared_files.each do |shared_file|
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/shared/#{shared_file}", Rails.root.join("app/views/shared/#{shared_file}"), force: true
    end

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

    # update manifest
    rails_command "rails stimulus:manifest:update"

    # Get the content of package.json
    package_json_path = Rails.application.root.join("package.json")
    package_json_content = File.read(package_json_path)

    # Check if the build:css script already exists
    unless package_json_content.include?('"build:css"')
      say "Append build:css script to package.json"
      # Add the build:css script if it's not present
      insert_into_file package_json_path,
        after: '"scripts": {' do
          "\n\t\t" + '"build:css": "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify",'
        end
    else
      say "build:css script already exists in package.json. Skipping..."
    end

    say "Run build:css"
    run %(yarn build:css)

    say "Append to Procfile.dev"
    append_to_file "Procfile.dev", %(css: yarn build:css --watch\n)

    say "Update .gitignore"
    inject_into_file ".gitignore", "node_modules\n"

    # Fin
    say "#{Railsui.config.css_framework.humanize} theme: #{Railsui.config.theme.humanize} installed 👍", :green
  end
end
