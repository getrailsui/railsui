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
        %(\n    <%= stylesheet_link_tag "application", "https://unpkg.com/trix@2.0.0/dist/trix.css", "data-turbo-track": "reload" %>) :
        %(\n    <%= stylesheet_link_tag "application" %>),
      before: /\s*<\/head>/
    )
  else
    say "Default application.html.erb is missing!", :red
    if defined?(Turbo)
      say %(        Add <%= stylesheet_link_tag "application", "https://unpkg.com/trix@2.0.0/dist/trix.css", "data-turbo-track": "reload" %> within the <head> tag in your custom layout.)
    else
      say %(        Add <%= stylesheet_link_tag "application", "https://unpkg.com/trix@2.0.0/dist/trix.css" %> within the <head> tag in your custom layout.)
    end
  end

  unless Rails.root.join("package.json").exist?
    say "Add default package.json"
    copy_file "#{__dir__}/package.json", "package.json"
  end
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
  gem 'meta-tags'
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
end

# Add active storage and action text
def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"

  if Rails.root.join("app/assets/stylesheets/actiontext.css").exist?
    remove_file Rails.root.join("app/assets/stylesheets/actiontext.css")
  end
end

# Extend user.rb
def add_user_attributes
  content = <<-RUBY
  has_person_name
  has_one_attached :avatar
  RUBY

  insert_into_file "app/models/user.rb", "#{content}\n\n", after: "class User < ApplicationRecord\n"
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

  say "⚡️ Add default RailsUI routing and engine"
  content = <<-RUBY
  if Rails.env.development? || Rails.env.test?
    mount Railsui::Engine, at: "/railsui"
  end

  scope controller: :static do

  end
  # Inherits from Railsui StaticController#index
  # To overide, add your own static#index view or change to a new root
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

    config.to_prepare do
      Devise::Mailer.layout "mailer"
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
    head_content = <<-RUBY
    <%= render "shared/meta" %>
    <%= yield :head %>
    RUBY

    say "⚡️ Add <head> includes"
    insert_into_file(
      app_layout_path.to_s, head_content,
      before:/\s*<\/head>/
    )

    # Layout content with conditional header block
    layout_content = <<-RUBY
    <%= render "shared/flash" %>
    <% if content_for(:header).present? %>
      <%= yield :header %>
      <% else %>
      <%= render "shared/nav" %>
    <% end %>
    RUBY

    say "⚡️ Add layout content"
    insert_into_file(app_layout_path.to_s, layout_content, after:"<body>")
  end
end

def copy_hero_icons
  directory "#{__dir__}/icons", Rails.root.join("app/assets/images/icons"), force: true
end

def copy_application_mailer
   copy_file "#{__dir__}/application_mailer.rb", Rails.root.join("app/mailers/application_mailer.rb"), force: true
end

def scope_body_class
  gsub_file Rails.root.join('app/views/layouts/application.html.erb'), '<body>', '<body class="rui">'
end

# Extend this gems helper into the client app + extend devise
def add_application_controller_code
  app_controller_code = <<-RUBY
  helper Railsui::ThemeHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name])
  end
  RUBY
  insert_into_file "#{Rails.root}/app/controllers/application_controller.rb", "#{app_controller_code}\n", after: "class ApplicationController < ActionController::Base\n"
end

# TODO
# def add_meta
#  generate "meta_tags:install"
# end

# Add all the things!
say "⚡️ Adding gems..."
add_gems

run "bundle install"

say "⚡️ Remove importmaps"
remove_importmaps

say "⚡️ Copy optimized application_mailer.rb file"
copy_application_mailer

say "⚡️ Configuring Devise..."
add_users

say "⚡️ Add esbuild"
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

say "⚡️ Scope styles to body"
scope_body_class

say "⚡️ Configuring template engine with fallbacks..."
add_custom_template_engine

say "⚡️ Configure application controller"
add_application_controller_code

say "⚡️ Adding ActiveStorage and ActionText dependencies..."
add_storage_and_rich_text

say "⚡️ Copy hero icon library"
copy_hero_icons

# Migrate
rails_command "db:create"
rails_command "db:migrate"

say "⚡️ Add additional user.rb attributes"
add_user_attributes

say "
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
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
