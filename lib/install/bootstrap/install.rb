if Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  say "Bootstrap is already installed 👍"
else
  say "🔥 Install Bootstrap with Bootstrap Icons and Popperjs/core "
  copy_file "#{__dir__}/application.bootstrap.scss",
    "app/assets/stylesheets/application.bootstrap.scss"
  run "yarn add sass bootstrap bootstrap-icons @popperjs/core"

  inject_into_file "config/initializers/assets.rb", after: /.*Rails.application.config.assets.paths.*\n/ do
    <<~RUBY
      Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
    RUBY
  end

  if Rails.root.join("app/views/devise").exist?
    say "🛑 app/views/devise already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "Add themed Devise views"
    directory "#{__dir__}/themes/#{Railsui.config.theme}/devise", Rails.root.join("app/views/devise")
  end

  if Rails.root.join("app/javascript/application.js").exist?
    say "Appending Bootstrap JavaScript import to default entry point"
    append_to_file "app/javascript/application.js", %(import * as bootstrap from "bootstrap"\n)
  else
    say %(Add import * as bootstrap from "bootstrap" to your entry point JavaScript file), :red
  end

  copy_file("#{__dir__}/manifest.js", "app/assets/config/manifest.js", force: true)

  say "Add build:css script"
  build_script = "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"

  if (`npx -v`.to_f < 7.1 rescue "Missing")
    say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :red
  else
    run %(npm set-script build:css "#{build_script}")
    run %(yarn build:css)
  end

  say "Update .gitignore"
  inject_into_file ".gitignore", "node_modules\n"
end
