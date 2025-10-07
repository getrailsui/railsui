# frozen_string_literal: true

require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions

    attr_accessor :application_name, :support_email, :theme, :body_classes, :build_mode
    attr_writer :pages

    def initialize(options = {})
      options ||= {}
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.support_email ||= "support@example.com"
      self.build_mode ||= detect_build_mode
      theme
      initialize_theme_classes if theme
    end

    def initialize_theme_classes
      self.body_classes ||= Railsui::Themes.body_classes(theme)
    end

    def self.load!
      if File.exist?(config_path)
        begin
          config = Psych.load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])
          return config if config.is_a?(Railsui::Configuration)

          new(config)
        rescue Psych::SyntaxError => e
          raise "❌ Failed to parse config/railsui.yml: #{e.message}. Please check the YAML syntax."
        rescue => e
          raise "❌ Failed to load Rails UI configuration: #{e.message}"
        end
      else
        new
      end
    end

    def self.delete_page(page)
      # update config
      config_path = Rails.root.join("config", "railsui.yml")
      if File.exist?(config_path)
        config = Psych.safe_load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])
        config.pages.delete(page)
        File.write(config_path, config.to_yaml)
        Railsui.restart
      end

      # remove view
      view_path = Rails.root.join("app", "views", "rui", "pages", "#{page}.html.erb")

      if File.exist?(view_path)
        File.delete(view_path)
      else
        puts "View #{view_path} does not exist"
      end
    end

    def pages
      Array.wrap(@pages)
    end

    def self.config_path
      Rails.root.join("config", "railsui.yml")
    end

    def save(skip_build: false)
      # Validate configuration before saving
      validate_configuration!

      begin
        # Create config/railsui.yml
        File.write(self.class.config_path, to_yaml)
      rescue => e
        raise "❌ Failed to save configuration to config/railsui.yml: #{e.message}"
      end

      # Change the Rails UI config to the latest version
      Railsui.config = self

      sleep 1

      # Only build CSS if not explicitly skipped and CSS file exists
      if !skip_build && should_build_css? && File.exist?(Rails.root.join("app/assets/tailwind/application.css"))
        begin
          Railsui.build_css
        rescue => e
          puts "⚠️  Warning: CSS build failed: #{e.message}"
          puts "You can rebuild manually with: rails tailwindcss:build"
        end
      end
    end

    def self.update(params = {})
      begin
        config = load!
        config.assign_attributes(params)
        config.pages = Railsui::Pages.theme_pages.keys
        config.save

        Railsui.run_command "rails g railsui:update"
      rescue => e
        puts "❌ Failed to update configuration: #{e.message}"
        raise
      end
    end

    def self.synchronize_pages
      config_path = Rails.root.join("config", "railsui.yml")
      return unless File.exist?(config_path)

      loaded_config = Psych.safe_load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])

      # Ensure that the loaded configuration is an instance of Railsui::Configuration
      config = loaded_config.is_a?(Railsui::Configuration) ? loaded_config : new(loaded_config)

      existing_pages_in_dir = Dir[File.join(Railsui::Pages::VIEWS_FOLDER, "*.html.erb")].map do |filepath|
        File.basename(filepath, ".html.erb")
      end

      # Combine and sort the pages
      combined_pages = (config.pages + existing_pages_in_dir).uniq.sort

      # Update the configuration instance
      config.pages = combined_pages

      # Save the updated configuration back to the file
      File.write(config_path, config.to_yaml)
    end

    def self.convert_keys_to_strings(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = key.to_s
        new_value = value.is_a?(Hash) ? convert_keys_to_strings(value) : value
        result[new_key] = new_value
      end
    end

    # Validate build mode
    def build_mode=(value)
      valid_modes = ["build", "nobuild", :build, :nobuild]
      unless valid_modes.include?(value)
        raise ArgumentError, "❌ Invalid build_mode: '#{value}'. Must be 'build' or 'nobuild'"
      end
      @build_mode = value.to_s
    end

    # Validate entire configuration
    def validate_configuration!
      errors = []

      errors << "Application name cannot be blank" if application_name.blank?
      errors << "Support email cannot be blank" if support_email.blank?
      errors << "Theme cannot be blank" if theme.blank?

      # Validate theme exists (check against available themes)
      available_themes = ["hound", "shepherd", "corgie"]
      unless available_themes.include?(theme)
        errors << "Invalid theme: '#{theme}'. Available themes: #{available_themes.join(', ')}"
      end

      # Validate build mode
      unless ["build", "nobuild"].include?(build_mode.to_s)
        errors << "Invalid build_mode: '#{build_mode}'. Must be 'build' or 'nobuild'"
      end

      # Validate email format
      unless support_email =~ URI::MailTo::EMAIL_REGEXP
        errors << "Invalid email format for support_email: '#{support_email}'"
      end

      if errors.any?
        raise ArgumentError, "❌ Configuration validation failed:\n  - #{errors.join("\n  - ")}"
      end
    end

    # Check if build mode is nobuild
    def nobuild?
      build_mode.to_s == "nobuild"
    end

    # Check if build mode is build
    def build?
      build_mode.to_s == "build"
    end

    private

    def detect_build_mode
      return "build" unless defined?(Rails) && Rails.root

      # Check for importmap.rb existence
      if File.exist?(Rails.root.join("config", "importmap.rb"))
        "nobuild"
      else
        "build"
      end
    rescue
      # Fallback to build mode if detection fails
      "build"
    end

    def should_build_css?
      # Always try to build CSS if tailwindcss-rails is available
      return true if defined?(Tailwindcss)

      # Fallback to checking for package.json in build mode
      return false unless defined?(Rails) && Rails.root

      build? && File.exist?(Rails.root.join("package.json"))
    rescue
      false
    end

    def copy_template(filename)
      return if File.exist?(Rails.root.join(filename))

      FileUtils.cp template_path(filename), Rails.root.join(filename)
    end

    def template_path(filename)
      Rails.root.join("lib/templates", filename)
    end
  end
end
