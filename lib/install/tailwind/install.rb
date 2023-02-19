# Tailwind requires more finesse to have ability to make use of more advanced PostCSS features. We're borrowing from the cssbundling-rails gem install pattern here to accomodate.
if Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
  say "Tailwind CSS is already installed. For best results uninstall it and re-run the Rails UI installer"
else
  say "🔥 Install Tailwind (+PostCSS w/ autoprefixer)"
  # tailwind.config.js
  unless Rails.root.join("tailwind.config.js").exist?
    say "⬅️ Adding tailwind.config.js"
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/tailwind.config.js",
  "tailwind.config.js", force: true
  else
    say "✅ tailwind.config.js already exists"
  end

  # remove application.css
  say "Remove app/assets/stylesheets/application.css so build output can take over"
  remove_file "app/assets/stylesheets/application.css"

  # add application.tailwind.css
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/stylesheets/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css", force: true

  # postcss.config.js
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/postcss.config.js", "postcss.config.js", force: true

  run "yarn add tailwindcss postcss autoprefixer postcss-import postcss-nesting @tailwindcss/forms @tailwindcss/typography stimulus-use --latest"

  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
  end

  # TODO: Figure out why this won't copy
  say "Add Tailwind-themed scaffold .erb templates"
  # directory "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold", Rails.root.join("lib/templates/erb/scaffold"), force: true
  file_names = ["_form.html.erb.tt", "edit.html.erb.tt", "index.html.erb.tt", "new.html.erb.tt", "partial.html.erb.tt", "show.html.erb.tt"]

  file_names.each do |name|
    copy_file "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold/#{name}", Rails.root.join("lib/templates/erb/scaffold/#{name}")
  end

  say "Copy images/assets"
  directory "#{__dir__}/themes/#{Railsui.config.theme}/images", Rails.root.join("app/assets/images"), force: true

  say "Add build:css script"
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

  say "👍 Tailwind CSS theme installed", :green
end
