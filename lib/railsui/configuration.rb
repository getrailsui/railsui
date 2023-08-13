require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions

    attr_accessor :application_name, :css_framework, :support_email, :theme
    attr_writer :pages

    def initialize(options = {})
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.css_framework ||= ""
      self.support_email ||= "support@example.com"
      self.theme ||= ""
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

      # Install and configure framework of choice
      case self.css_framework
      when Railsui::Default::BOOTSTRAP
        Railsui.run_command "rails railsui:framework:install:bootstrap"
      when Railsui::Default::TAILWIND_CSS
        Railsui.run_command "rails railsui:framework:install:tailwind"
      end

      create_pages
      sleep 1
    end

    def create_pages
      Railsui::Pages.theme_pages.each do | page, details |
        if Railsui::Pages.page_enabled?(page) && !Railsui::Pages.page_exists?(page)
          Railsui.run_command "rails g railsui:page #{page} --force-plural"
          Railsui.build_css
        end
      end
    end

    private

    def update_framework
      Railsui.config.css_framework = self.css_framework
      Railsui.config.theme = self.theme
    end


    def copy_template(filename)
      # Safely copy template, so we don't blow away any customizations you made
      unless File.exist?(Rails.root.join(filename))
        FileUtils.cp template_path(filename), Rails.root.join(filename)
      end
    end

    def template_path(filename)
      Rails.root.join("lib/templates", filename)
    end
  end
end
