# Tailwind requires more finesse to have ability to make use of more advanced PostCSS features. We're borrowing from the cssbundling-rails gem install pattern here to accomodate.
if Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
  say "Tailwind CSS is already installed. For best results uninstall it and re-run the Rails UI installer"
else
  say "🔥 Install Tailwind (+PostCSS w/ autoprefixer)"
  # tailwind.config.js
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/tailwind.config.js",
  "tailwind.config.js"

  # application.tailwind.css
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css", force: true

  # postcss.config.js
  copy_file "#{__dir__}/themes/#{Railsui.config.theme}/postcss.config.js", "postcss.config.js", force: true

  run "yarn add tailwindcss postcss autoprefixer postcss-import postcss-nesting @tailwindcss/forms @tailwindcss/typography --latest"

  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
  end

  say "Add Tailwind-themed scaffold .erb templates"
  directory "#{__dir__}/themes/#{Railsui.config.theme}/templates/erb/scaffold", Rails.root.join("lib/templates/erb/scaffold")

  say "Add build:css script"
  build_script = "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"

  if (`npx -v`.to_f < 7.1 rescue "Missing")
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :red
  else
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  end

  say "Update .gitignore"
  inject_into_file ".gitignore", "node_modules\n"
end
