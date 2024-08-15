# frozen_string_literal: true

require 'fileutils'

module Railsui
  module UserSetup
    # Note: Devise views are copied directly in generators
    def copy_railsui_devise_views(theme)
      # Copy Devise views
      directory "themes/#{theme}/views/rui/devise", "app/views/rui/devise", force: true
      # Copy Devise layout
      copy_file "themes/#{theme}/views/layouts/rui/devise.html.erb", "app/views/layouts/rui/devise.html.erb", force: true
    end

    def add_devise_email_previews(theme)
      # Add devise email preview support in # test/mailers/previews/devise_mailer_preview.rb
      copy_file "themes/#{theme}/mail/devise_mailer_preview.rb", Rails.root.join("test/mailers/previews/devise_mailer_preview.rb"), force: true
    end

    def setup_users
      unless devise_installed?
        # Install Devise
        generate "devise:install"

        # Configure Devise
        environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

        # Create Devise User
        generate :devise, "User", "first_name:string", "last_name:string", "admin:boolean"

        # Set default value for admin column if not already set
        in_root do
          migration = Dir.glob("db/migrate/*").max_by { |f| File.mtime(f) }
          unless File.read(migration).include?(":admin, default:")
            gsub_file migration, /:admin/, ":admin, default: false"
          end
        end

        # Run migrations
        rails_command "db:migrate"

        # Extend user.rb if needed
        say "Add has_person_name and has_one_attached :avatar to User model"
        extend_user_model unless user_model_extended?

        say "Add application_controller code"
        add_application_controller_code

        say "Update devise mailer sender email with Railsui.config.support_email"
        update_devise_mailer_sender

        # scope devise views
        scope_devise_views

        say "Set and Devise view and layout paths"

        set_devise_view_and_layout_paths
      else
        say "Devise already installed, skipping", :yellow

        say "Update devise mailer sender email with Railsui.config.support_email"
        update_devise_mailer_sender

        say "Set and Devise view and layout paths"
        set_devise_view_and_layout_paths
      end
    end

    def update_devise_mailer_sender
      # Path to the devise initializer file
      devise_initializer_path = Rails.root.join("config", "initializers", "devise.rb")

      if File.exist?(devise_initializer_path)
        # Update the config.mailer_sender value with Railsui.config.support_email
        gsub_file devise_initializer_path, /config.mailer_sender\s*=\s*['"][^'"]+['"]/, "config.mailer_sender = Railsui.config.support_email"

        say "Devise mailer sender updated to #{Railsui.config.support_email}.", :green
      else
        say "Devise initializer file not found.", :red
      end
    end

    def set_devise_view_and_layout_paths
content = <<-RUBY
  config.to_prepare do
    Devise::SessionsController.prepend_view_path "app/views/rui"
    Devise::RegistrationsController.prepend_view_path "app/views/rui"
    Devise::ConfirmationsController.prepend_view_path "app/views/rui"
    Devise::UnlocksController.prepend_view_path "app/views/rui"
    Devise::PasswordsController.prepend_view_path "app/views/rui"

    Devise::SessionsController.layout "rui/devise"
    Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? "rui/railsui" : "rui/devise" }
    Devise::ConfirmationsController.layout "rui/devise"
    Devise::PasswordsController.layout "rui/devise"
    Devise::UnlocksController.layout "rui/devise"
    Devise::Mailer.helper Railsui::MailHelper
  end
RUBY

      insert_into_file Rails.root.join('config/application.rb'), "\n#{content}", after: "class Application < Rails::Application"
    end

    def add_application_controller_code
  app_controller_code = <<-RUBY
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name])
  end
  RUBY
      insert_into_file "#{Rails.root}/app/controllers/application_controller.rb", "#{app_controller_code}\n", after: "class ApplicationController < ActionController::Base\n"
    end

    def scope_devise_views
      # Path to the devise initializer file
      devise_initializer_path = Rails.root.join("config", "initializers", "devise.rb")

      if File.exist?(devise_initializer_path)
        # Uncomment and set config.scoped_views to true
        gsub_file devise_initializer_path, /#\s*config\.scoped_views\s*=\s*false/, "config.scoped_views = true"
        say "Devise scoped views enabled.", :green
      else
        say "Devise initializer file not found.", :red
      end
    end

    private

    def devise_installed?
      File.exist?(Rails.root.join('config/initializers/devise.rb'))
    end

    def user_model_extended?
      content = File.read(Rails.root.join('app/models/user.rb'))
      content.include?('has_person_name') && content.include?('has_one_attached :avatar')
    end

    def extend_user_model
      say "Adding name_of_person and :avatar to User model", :yellow

      user_model_path = Rails.root.join("app/models/user.rb").to_s
      content = File.read(user_model_path)

      if columns_present? && !content.include?('has_person_name')
        insert_into_file user_model_path, "  has_person_name\n", after: "class User < ApplicationRecord\n"
      end

      unless content.include?('has_one_attached :avatar')
        insert_into_file user_model_path, "  has_one_attached :avatar\n", after: "class User < ApplicationRecord\n"
      end
    end

    def columns_present?
      ActiveRecord::Base.connection.column_exists?(:users, :first_name) &&
        ActiveRecord::Base.connection.column_exists?(:users, :last_name)
    end
  end
end
