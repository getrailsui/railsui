require "railsui/version"
require "railsui/engine"

module Railsui
  autoload :Colors, "railsui/colors"
  autoload :Configuration, "railsui/configuration"
  autoload :Pages, "railsui/pages"
  autoload :Themes, "railsui/themes"
  autoload :ThemeHelper, "railsui/theme_helper"
  autoload :ThemeSetup, "railsui/theme_setup"
  autoload :UserSetup, "railsui/user_setup"

  mattr_accessor :config
  @@config = Railsui::Configuration.new

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
    theme = Railsui.config.theme
    "https://f001.backblazeb2.com/file/railsui/themes/#{theme}/logo.svg"
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
