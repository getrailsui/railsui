source_root = File.expand_path('../templates', __FILE__)

def add_css_bundling_setup
  say "Build into app/assets/builds"
  empty_directory "app/assets/builds", force: true
  keep_file "app/assets/builds"

  if Rails.root.join(".gitignore").exist?
    append_to_file(".gitignore", %(\n/app/assets/builds/*\n!/app/assets/builds/.keep\n))
    append_to_file(".gitignore", %(\n/node_modules\n))
  end

  if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
    say "Add stylesheet link tag in application layout"
    insert_into_file(
      app_layout_path.to_s,
      defined?(Turbo) ?
        %(\n    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>) :
        %(\n    <%= stylesheet_link_tag "application" %>),
      before: /\s*<\/head>/
    )
  else
    say "Default application.html.erb is missing!", :red
    if defined?(Turbo)
      say %(        Add <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %> within the <head> tag in your custom layout.)
    else
      say %(        Add <%= stylesheet_link_tag "application" %> within the <head> tag in your custom layout.)
    end
  end

  unless Rails.root.join("package.json").exist?
    say "Add default package.json"
    copy_file "#{__dir__}/package.json", "package.json"
  end

  return if Rails.root.join("Procfile.dev").exist?
  say "Add default Procfile.dev"
  copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

  say "Ensure foreman is installed"
  run "gem install foreman"

  say "Add bin/dev to start foreman"
  copy_file "#{__dir__}/dev", "bin/dev"
  chmod "bin/dev", 0755, verbose: false
end

def remove_importmaps
  if Rails.root.join("config/importmap.rb").exist?
    run "bundle remove importmap-rails"
    remove_file Rails.root.join("config/importmap.rb")
    remove_file Rails.root.join("app/javascript/application.js")
    remove_file Rails.root.join("app/javascript/controllers/index.js")
    remove_file Rails.root.join("app/javascript/controllers/application.js")
    remove_file Rails.root.join("app/javascript/controllers/hello_controller.js")

    copy_file "#{__dir__}/application.js", "app/javascript/application.js"

    say "Remove javascript_import_tags helper"
    gsub_file Rails.root.join("app/views/layouts/application.html.erb"), "<%= javascript_importmap_tags %>", ""

    say "Remove bin/importmap"
    remove_file Rails.root.join("bin/importmap")
  end
end

def add_esbuild
  rails_command "javascript:install:esbuild", force: true
end

def add_stimulus
  rails_command "stimulus:install:node"
end

def add_gems
  gem "cssbundling-rails"
  gem 'devise'
  gem "jsbundling-rails"
  gem 'name_of_person'
  gem 'sidekiq'
end

# Install Devise
def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")
end

# Add active storage and action text
def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"
end

# Add sidkiq
def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY

  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_static_assets
  say "⚡️ Generate StaticController"
  generate "controller", "static index --skip-test-framework --skip-assets --skip-helper --skip-routes --skip-template-engine"

  # Note: this roots to static/index in gem as front page when first booting

  say "⚡️ Add default RailsUI routing and engine"
  content = <<-RUBY
    if Rails.env.development? || Rails.env.test?
      mount Railsui::Engine, at: "/railsui"
    end

    scope controller: :static do

    end

    root to: "static#index"
  RUBY

  insert_into_file "#{Rails.root}/config/routes.rb", "#{content}\n", after: "Rails.application.routes.draw do\n"
end

def add_custom_template_engine
  content = <<-RUBY
    config.generators do |g|
      g.template_engine :railsui
      g.fallbacks[:railsui] = :erb
    end
  RUBY

  insert_into_file "#{Rails.root}/config/application.rb", "#{content}\n", after: "class Application < Rails::Application\n"
end

def extend_layout_and_views
  if Rails.root.join("app/views/shared").exist?
  say "🛑 app/views/shared already exists. Files can't be copied. Refer to the gem source for reference."
  else
    say "⚡️ Adding shared partials"
    directory "#{__dir__}/shared", Rails.root.join("app/views/shared")
  end

  if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
    say "⚡️ Add meta tag partial"
    insert_into_file(
      app_layout_path.to_s,
      %(\n    <%= render "shared/meta" %>),
      before:/\s*<\/head>/
    )

    say "⚡️ Add :head yield"
    insert_into_file(
      app_layout_path.to_s,
      %(\n    <%= yield :head %>),
      before:/\s*<\/head>/
    )

    say "⚡️ Add flash and nav partials"
    insert_into_file(
      app_layout_path.to_s,
      %(
    <%= render "shared/flash" %>
    <%= render "shared/nav" %>
      ),
      after:"<body>"
    )

    say "⚡️ Add stylesheet link"

    stylesheet_link = '<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>'

    insert_into_file(
      app_layout_path.to_s,
      %(
    <% if current_page?(root_path) && !Railsui.config.css_framework.present? %>
      ), before: stylesheet_link
    )

    insert_into_file(
      app_layout_path.to_s,
      %(
    <% end %>
      ), after: stylesheet_link
    )

  end
end

def copy_hero_icons
  directory "#{__dir__}/icons", Rails.root.join("app/assets/images/icons")
end

# Add the gems!
say "⚡️ Remove importmaps"
remove_importmaps

say "⚡️ Adding gems..."
add_gems

run "bundle install"

say "⚡️ Configuring Devise..."
add_users

say "⚡️ Add ESBuild"
add_esbuild

say "⚡️ Add Stimulus.js"
add_stimulus

say "⚡️ Add custom css-bundling setup"
add_css_bundling_setup

say "⚡️ Adding static assets..."
add_static_assets

say "⚡️ Adding sidekiq..."
add_sidekiq

say "⚡️ Extending layout and views..."
extend_layout_and_views

say "⚡️ Configuring template engine with fallbacks..."
add_custom_template_engine

say "⚡️ Adding ActiveStorage and ActionText dependencies..."
add_storage_and_rich_text

say "⚡️ Copy hero icon library"
copy_hero_icons

# Migrate
rails_command "db:create"
rails_command "db:migrate"


"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMWXOxooodOXMMMMMMMMMMWXxxXMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXd:,..     'dXMMMMWWKx:.  ,OWMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXO0KK0x:     cXWKxool'     .oXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMNc    .:o:.lNWXl.     ,OWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    'O0;oMMMWk'     .dNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMWo     :NK;dMMMMMKc     .xWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMWKdl,     :NK;dMMMMMMNd. .lONMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMNkooxKd     :NK;dMMMMWKxllkXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMW0l' .:ONd     :NK;oMMXk:..dNMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMNx,.    ,'     :NK;;xl.    .;xNMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMW0o,         :NK,.::,.      ,kWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMNx'       :NK;oMMWKx,     .lNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMXc      :NK;oMMMMMNo.     oWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMX:     :NK;dMMMMMMWd.    .xMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    :X0;dMMMMMMMNl     '0MMMMMMMMMMMMMM
MMMMMMMMMMMMMMMXOo:.      ''.,dx0NMMMMXc     ;KMMMMMMMMMMMMM
MMMMMMMMMMMMNkc.                .'codXMK;     'dxKMMMMMMMMMM
MMMMMMMMMMNx,. .',;:::;,..        .lKWMMK;     ,dXMMMMMMMMMM
MMMMMMMMMNxldk0XNWMMMMMWNKkl,.  .lKWMMMMMXo. ,xNMMMMMMMMMMMM
MMMMMMMMMWWMMMMMMMMMMMMMMMMMW0kkKWMMMMMMMMWKONMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
"
say
say "Rails UI installation successful! 👍", :green
say
say "Run bin/dev to boot the rails server", :yellow
