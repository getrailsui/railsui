# frozen_string_literal: true

require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions

    attr_accessor :application_name, :support_email, :theme, :body_classes, :form_classes, :wrapper_classes
    attr_writer :pages

    def initialize(options = {})
      options ||= {}
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.support_email ||= "support@example.com"
      self.theme
      initialize_theme_classes if self.theme
      @form_classes = {}
      @wrapper_classes = {}
    end

    def initialize_theme_classes
      self.body_classes ||= Railsui::Themes::body_classes(self.theme)
    end

    def self.load!
      if File.exist?(config_path)
        config = Psych.load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])
        return config if config.is_a?(Railsui::Configuration)
        new(config)
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

    def save
      # Create config/railsui.yml
      File.write(self.class.config_path, to_yaml)

      # Change the Rails UI config to the latest version
      Railsui.config = self

      sleep 1

      Railsui.build_css
    end

    def self.update(params={})
      config = load!
      config.assign_attributes(params)
      config.pages = Railsui::Pages.theme_pages.keys
      config.save

      Railsui.run_command "rails g railsui:update"
    end

    def self.synchronize_pages
      config_path = Rails.root.join("config", "railsui.yml")
      if File.exist?(config_path)
        loaded_config = Psych.safe_load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])

        # Ensure that the loaded configuration is an instance of Railsui::Configuration
        config = loaded_config.is_a?(Railsui::Configuration) ? loaded_config : new(loaded_config)

        existing_pages_in_dir = Dir[File.join(Railsui::Pages::VIEWS_FOLDER, '*.html.erb')].map do |filepath|
          File.basename(filepath, '.html.erb')
        end

        # Combine and sort the pages
        combined_pages = (config.pages + existing_pages_in_dir).uniq.sort

        # Update the configuration instance
        config.pages = combined_pages

        # Save the updated configuration back to the file
        File.write(config_path, config.to_yaml)
      end
    end

    def self.convert_keys_to_strings(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = key.to_s
        new_value = value.is_a?(Hash) ? convert_keys_to_strings(value) : value
        result[new_key] = new_value
      end
    end

    private

    def copy_template(filename)
      unless File.exist?(Rails.root.join(filename))
        FileUtils.cp template_path(filename), Rails.root.join(filename)
      end
    end

    def template_path(filename)
      Rails.root.join("lib/templates", filename)
    end

    # Method to easily override form classes
    def override_form_classes(theme, classes_hash)
      @form_classes[theme.to_s] ||= {}
      @form_classes[theme.to_s].merge!(classes_hash.stringify_keys)
    end

    # Method to easily override wrapper classes
    def override_wrapper_classes(theme, classes_hash)
      @wrapper_classes[theme.to_s] ||= {}
      @wrapper_classes[theme.to_s].merge!(classes_hash.stringify_keys)
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end
end
