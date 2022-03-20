source_root = File.expand_path('../templates', __FILE__)

def add_gems
  gem 'devise', '~> 4.8', '>= 4.8.1'
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

# Add the gems!
say "Adding gems..."
add_gems

run "bundle install"

say "Configuring Devise..."
add_users

say "Adding ActiveStorage and ActionText dependencies..."
add_storage_and_rich_text

say "Adding static assets..."
add_static_assets

say "Adding sidekiq..."
add_sidekiq

say "Extending layout and views..."
extend_layout_and_views

say "Configuring template engine with fallbacks..."
add_custom_template_engine

# Migrate
rails_command "db:create"
rails_command "db:migrate"

say
say "Rails UI installation successful! 👍", :green
say
say "Next, run $ bin/rails server", :yellow
