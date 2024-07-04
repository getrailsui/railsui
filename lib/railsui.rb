require "railsui/version"
require "railsui/engine"
require "railsui/configuration"
require "railsui/theme_registry"
require "view_component/engine"

module Railsui
  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield(config)
    end

    def theme
      self.config.theme
    end

    def const_missing(name)
      if name.to_s.end_with?("Component")
        theme_module = ThemeRegistry.get_theme_module(theme.to_s)
        component_class_name = "#{theme_module}::#{name}"
        component_class_name.split('::').inject(Object) { |mod, class_name| mod.const_get(class_name) }
      else
        super
      end
    end
  end

  class Error < StandardError; end

  mattr_accessor :config
  @@config = {}

  def self.clear
    run_command "rails tmp:clear"
  end

  def self.restart
    run_command "rails restart"
  end

  def self.bundle
    run_command "bundle"
  end

  def self.build_css
    run_command "yarn build:css"
  end

  def self.theme_logo_url
    "https://f001.backblazeb2.com/file/railsui/themes/#{self.theme}/logo.svg"
  end

  def self.asset_url
    "https://f001.backblazeb2.com/file/railsui"
  end

  def self.parameterized_app_name
    Railsui.config.application_name.parameterize(separator:"")
  end

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end
end
