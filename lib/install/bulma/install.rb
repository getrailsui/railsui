if Rails.root.join("app/assets/stylesheets/application.bulma.scss").exist?
  say "Bulma is already installed 👍"
else
  say "🔥 Install Bulma"
  copy_file "#{__dir__}/application.bulma.scss",
    "app/assets/stylesheets/application.bulma.scss"
  run "yarn add sass bulma"

  say "Add build:css script"
  build_script = "sass ./app/assets/stylesheets/application.bulma.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"

  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
  end

  if (`npx -v`.to_f < 7.1 rescue "Missing")
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :red
  else
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  end

  say "Update .gitignore"
  inject_into_file ".gitignore", "node_modules\n"
end
