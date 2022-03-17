# Tailwind requires more finesse to have ability to make use of more advanced PostCSS features. We're borrowing from the cssbundling-rails gem install pattern here to accomodate.
if Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
  say "Tailwind CSS is already installed 👍"
else
  say "🔥 Install Tailwind (+PostCSS w/ autoprefixer)"
  copy_file "#{__dir__}/tailwind.config.js", "tailwind.config.js"
  copy_file "#{__dir__}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css"
  run "yarn add tailwindcss postcss autoprefixer postcss-import postcss-nesting @tailwindcss/forms @tailwindcss/typography --latest"

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
