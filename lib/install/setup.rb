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

    # remove default application.css file
    gsub_file Rails.root.join("app/views/layouts/application.html.erb"), '<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>', ""

    # load css with trix.css
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
  if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
    append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)
    gsub_file "app/assets/config/manifest.js", "//= link_tree ../../javascript .js\n", ""
    gsub_file "app/assets/config/manifest.js", "//= link_tree ../../../vendor/javascript .js\n", ""
  end

  if Rails.root.join(".gitignore").exist?
    append_to_file(".gitignore", %(\n/app/assets/builds/*\n!/app/assets/builds/.keep\n))
    append_to_file(".gitignore", %(\n/node_modules\n))
  end

  unless (app_js_entrypoint_path = Rails.root.join("app/javascript/application.js")).exist?
    say "Create default entrypoint in app/javascript/application.js"
    empty_directory app_js_entrypoint_path.parent.to_s
    copy_file "#{__dir__}/application.js", app_js_entrypoint_path
  end

  unless Rails.root.join("package.json").exist?
    say "Add Rails UI default package.json which includes esbuild build script"
    copy_file "#{__dir__}/package.json", "package.json"
  end

  if Rails.root.join("Procfile.dev").exist?
    append_to_file "Procfile.dev", "js: yarn build --watch\n"
  else
    say "Add default Procfile.dev"
    copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

    say "Ensure foreman is installed"
    run "gem install foreman"
  end

  say "Add bin/dev to start foreman"
  copy_file "#{__dir__}/dev", "bin/dev"
  chmod "bin/dev", 0755, verbose: false

  # esbuild specific
  run "yarn add esbuild"
end

def add_stimulus
  rails_command "stimulus:install:node"
end

def add_turbo
  rails_command "turbo:install"
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

def setup_routes
  content = <<-RUBY
  if Rails.env.development? || Rails.env.test?
    mount Railsui::Engine, at: "/railsui"
  end

  # Inherits from Railsui::PageController#index
  # To overide, add your own page#index view or change to a new root
  # Visit the start page for Rails UI any time at /railsui/start
  root action: :index, controller: "railsui/page"
  RUBY

  insert_into_file "#{Rails.root}/config/routes.rb", "#{content}\n", after: "Rails.application.routes.draw do\n"
end

def add_page_controller
 generate "controller", "page --skip-test-framework --skip-assets --skip-helper --skip-routes --skip-template-engine"
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
  # Default application layout template
  copy_file "#{__dir__}/layouts/application.html.erb", Rails.root.join("app/views/layouts/application.html.erb"), force: true

  # Default devise layout template
  copy_file "#{__dir__}/layouts/devise.html.erb", Rails.root.join("app/views/layouts/devise.html.erb"), force: true
end

def add_devise_customizations
initializer_content = <<-RUBY
Rails.application.config.to_prepare do
  Devise::SessionsController.layout "devise"
  Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? "application" : "devise" }
  Devise::ConfirmationsController.layout "devise"
  Devise::UnlocksController.layout "devise"
  Devise::PasswordsController.layout "devise"
end
RUBY

  append_to_file Rails.root.join('config/initializers/devise.rb'), "\n#{initializer_content}"
end

def copy_hero_icons
  directory "#{__dir__}/icons", Rails.root.join("app/assets/images/icons"), force: true
end

def copy_application_mailer
   copy_file "#{__dir__}/application_mailer.rb", Rails.root.join("app/mailers/application_mailer.rb"), force: true
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
