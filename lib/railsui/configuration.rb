require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions

    attr_accessor :application_name, :css_framework, :support_email, :about, :pricing, :theme

    def initialize(options = {})
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.css_framework ||= ""
      self.support_email ||= "support@example.com"
      self.theme ||= ""
      self.about ||= false
      self.pricing ||= false
    end

    def self.load!
      if File.exist?(config_path)
        config = Psych.safe_load_file(config_path, permitted_classes: [Hash, Railsui::Configuration])
        return config if config.is_a?(Railsui::Configuration)
        new(config)
      else
        new
      end
    end


    def self.config_path
      Rails.root.join("config", "railsui.yml")
    end

    def about=(value)
      @about = ActiveModel::Type::Boolean.new.cast(value)
    end

    def about?
      @about.nil? ? false : ActiveModel::Type::Boolean.new.cast(@about)
    end

    def pricing=(value)
      @pricing = ActiveModel::Type::Boolean.new.cast(value)
    end

    def pricing?
      @pricing.nil? ? false : ActiveModel::Type::Boolean.new.cast(@pricing)
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

      # Install any static pages
      if !about_page_exists? && Railsui.config.about?
        create_about_page
      end

      if !pricing_page_exists? && Railsui.config.pricing?
        create_pricing_page
      end
    end

    private

    def update_framework
      Railsui.config.css_framework = self.css_framework
      Railsui.config.theme = self.theme
    end

    def create_about_page
      Railsui.run_command "rails g railsui:static about"
    end

    def create_pricing_page
      Railsui.run_command "rails g railsui:static pricing"
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

    def about_page_exists?
      Rails.root.join("app/views/static/about.html.erb").exist?
    end

    def pricing_page_exists?
      Rails.root.join("app/views/static/pricing.html.erb").exist?
    end
  end
end
