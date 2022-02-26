require "open-uri"
require "thor"

module Railsui
  class Configuration
    include ActiveModel::Model
    include Thor::Actions
     # Attributes
    attr_accessor :application_name
    attr_accessor :css_framework
    attr_accessor :primary_color
    attr_accessor :secondary_color
    attr_accessor :tertiary_color
    attr_accessor :font_family
    attr_accessor :about
    attr_accessor :pricing
    attr_accessor :blog

    def initialize(options = {})
      assign_attributes(options)
      self.application_name ||= "Rails UI"
      self.css_framework ||= ""
      self.primary_color ||= "4338CA"
      self.secondary_color ||= "FF8C69"
      self.tertiary_color ||= "333333"
      self.font_family ||= "Inter, sans-serif"
      self.about ||= false
      self.pricing ||= false
      self.blog ||= false
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

    def self.create_default_config
      FileUtils.cp File.join(File.dirname(__FILE__), "../templates/railsui.yml"), config_path
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

    def blog=(value)
      @blog = ActiveModel::Type::Boolean.new.cast(value)
    end

    def blog?
      @blog.nil? ? false : ActiveModel::Type::Boolean.new.cast(@blog)
    end

    def save
      # Creates config/railsui.yml
      File.write(self.class.config_path, to_yaml)

      # Change the Rails UI config to the latest version
      Railsui.config = self

      # Install and configure framework of choice
      set_framework

      # Install any static pages
      create_about_page
      create_pricing_page
    end

    def chosen_framework
      Railsui.config.css_framework
    end

    def set_framework
      case Railsui.config.css_framework
      when Railsui::Default::BOOTSTRAP
        install_bootstrap
      when Railsui::Default::TAILWIND_CSS
        install_tailwind_css
      when Railsui::Default::BULMA
        install_bulma
      else
        # no framework => None
      end
    end

    def create_about_page
      Railsui.run_command "rails generate railsui:static about -c #{chosen_framework}" if Railsui.config.about?
    end

    def create_pricing_page
      Railsui.run_command "rails generate railsui:static pricing -c #{chosen_framework}" if Railsui.config.pricing?
    end

    def create_blog
      # Do stuff if Railsui.config.blog?
    end

    def install_tailwind_css
      Railsui.run_command "rails railsui:framework:install:tailwind"
    end

    def intall_bootstrap
      Railsui.run_command "rails railsui:framework:install:bootstrap"
    end

    def install_bulma
      Railsui.run_command "rails railsui:framework:install:bulma"
    end

    private

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
