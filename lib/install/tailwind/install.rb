# General FYI: Tailwind requires more finesse to have ability to make use of more advanced PostCSS features. We're borrowing from the cssbundling-rails gem install pattern here to accomodate.
say "🔔 Installing #{Railsui.config.theme.humanize} theme dependencies"

# Skip it all if Tailwind already exists.
if Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
  say "🛑 Tailwind CSS is already installed. For best results uninstall it and re-run the Rails UI installer."
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

  # remove application.css
  say "⚡️ Remove app/assets/stylesheets/application.css so build output can take over"
  remove_file "app/assets/stylesheets/application.css"

  # add theme stylesheets
  directory "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets", "app/assets/stylesheets", force: true

  # Add postcss.config.js
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/postcss.config.js", "postcss.config.js", force: true

  # Yarn stuffs
  run "yarn add tailwindcss postcss autoprefixer postcss-import postcss-nesting @tailwindcss/forms @tailwindcss/typography stimulus-use tippy.js --latest"

  # Copy themed devise views
  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "⚡️ Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
  end

  # TODO: Do we need this? - Inherited from railsui/lib/generators/railsui/templates/tailwind/<theme> somehow? Seems it's using the config in `application.rb - g.template_engine :railsui`. Pretty cool.
  # Keeping for now
  say "⚡️ Add Tailwind-themed scaffold .erb templates"
  # directory "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold", Rails.root.join("lib/templates/erb/scaffold"), force: true
  file_names = ["_form.html.erb.tt", "edit.html.erb.tt", "index.html.erb.tt", "new.html.erb.tt", "partial.html.erb.tt", "show.html.erb.tt"]

  file_names.each do |name|
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
  end

  # Copy over image assets for corresponding theme
  say "⚡️ Copy images/assets"
  directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true

  # Copy themed globally shared partials
  say "⚡️ Copy shared partial files"
  shared_files = ["_error_messages.html.erb", "_flash.html.erb", "_nav.html.erb"]

  shared_files.each do |shared_file|
    unless Rails.root.join("app/views/shared/#{shared_file}").exist?
      copy_file "#{__dir__}/themes/#{Railsui.config.theme}/shared/#{shared_file}", Rails.root.join("app/views/shared/#{shared_file}")
    else
      "🛑 #{shared_file} already exists, skipping."
    end
  end

  # Append partials to layout
  if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
    say "⚡️ Add shared nav partial"
    insert_into_file(
      app_layout_path.to_s,
      %(\n    <%= render "shared/nav" %>),
      after: '<%= render "shared/flash" %>'
    )
  end

  # Build scripts for good measure
  say "⚡️ Add build:css script"
  build_script = "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"

  if (`npx -v`.to_f < 7.1 rescue "Missing")
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :red
  else
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  end

  say "Append to Procfile.dev"
  append_to_file "Procfile.dev", %(css: yarn build:css --watch\n)

  say "Update .gitignore"
  inject_into_file ".gitignore", "node_modules\n"

  # Fin
  say "👍 Tailwind CSS theme installed", :green
end
