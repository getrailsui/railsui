require "railsui/version"
require "railsui/engine"
require 'railsui_icon'
require 'meta-tags'

module Railsui
  autoload :Configuration, "railsui/configuration"
  autoload :Pages, "railsui/pages"
  autoload :Themes, "railsui/themes"
  autoload :ThemeHelper, "railsui/theme_helper"
  autoload :ThemeSetup, "railsui/theme_setup"

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
    # Use tailwindcss-rails build command
    begin
      run_command "rails tailwindcss:build"
    rescue => e
      puts "Warning: tailwindcss:build command not found. CSS may not be compiled."
      puts "You may need to restart your Rails server or run 'rails tailwindcss:build' manually."
    end
  end

  def self.theme_logo_url
    theme = Railsui.config.theme
    file_extension = if defined?(Rails.application) && Rails.application.config.action_mailer
                     "png"
                   else
                     "svg"
                   end
    "https://f001.backblazeb2.com/file/railsui/themes/#{theme}/logo.#{file_extension}"
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
