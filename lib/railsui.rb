require "railsui/version"
require "railsui/engine"

module Railsui
  autoload :Configuration, "railsui/configuration"
  autoload :Pages, "railsui/pages"

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
    "https://f001.backblazeb2.com/file/railsui/themes/#{self.config.theme.parameterize}/logo.svg"
  end

  def self.asset_url
    "https://f001.backblazeb2.com/file/railsui"
  end

  def self.parameterized_app_name
    Railsui.config.application_name.parameterize(separator:"")
  end

  def self.tailwind?
    Railsui.config.css_framework == Railsui::Default::TAILWIND_CSS
  end

  def self.bootstrap?
    Railsui.config.css_framework == Railsui::Default::BOOTSTRAP
  end

  def self.no_framework_set?
    self.config.css_framework == "" # not yet configured
  end

  def self.framework?
    Railsui.config.css_framework.present?
  end

  def self.theme
    self.config.theme
  end

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end
end
