require "railsui/version"
require "railsui/engine"
require "railsui/railtie" if defined?(Rails)

module Railsui
  autoload :Colors, "railsui/colors"
  autoload :Configuration, "railsui/configuration"
  autoload :Pages, "railsui/pages"
  autoload :ThemeHelper, "railsui/theme_helper"
  autoload :ThemeSetup, "railsui/theme_setup"

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

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end
end
