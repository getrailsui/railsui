require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions

    attr_accessor :application_name, :support_email, :theme, :colors
    attr_writer :pages, :colors

    def initialize(options = {})
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.support_email ||= "support@example.com"
      self.theme
      initialize_colors_for_theme if self.theme
    end

    def initialize_colors_for_theme
      self.colors ||= Railsui::Colors.theme_colors(self.theme)
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
      config_path = Rails.root.join("config", "railsui.yml")
      if File.exist?(config_path)
        config = Psych.safe_load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])
        config.pages.delete(page)
        File.write(config_path, config.to_yaml)
        Railsui.restart
      end
    end

    def pages
      Array.wrap(@pages)
    end

    def self.config_path
      Rails.root.join("config", "railsui.yml")
    end

    def save
      # Creates config/railsui.yml
      File.write(self.class.config_path, to_yaml)

      # Change the Rails UI config to the latest version
      Railsui.config = self

      install

      # Install optional pages per theme
      create_pages

      sleep 1

      Railsui.build_css
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

    def create_pages
      Railsui::Pages.theme_pages.each do | page, details |
        if Railsui::Pages.page_enabled?(page) && !Railsui::Pages.page_exists?(page)
          Railsui.run_command "rails g railsui:page #{page} --force-plural"
        end
      end
    end

    private

    def install
      Railsui.run_command "rails railsui:install"
    end

    def copy_template(filename)
      unless File.exist?(Rails.root.join(filename))
        FileUtils.cp template_path(filename), Rails.root.join(filename)
      end
    end

    def template_path(filename)
      Rails.root.join("lib/templates", filename)
    end
  end
end
