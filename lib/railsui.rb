require "railsui/version"
require "railsui/engine"

module Railsui
  autoload :Configuration, "railsui/configuration"

  mattr_accessor :config
  @@config = {}

  def self.restart
    run_command "rails restart"
  end

  def self.bundle
    run_command "bundle"
  end

  def self.no_framework_set?
    self.config.css_framework == "" # not yet configured
  end

  def self.bootstrap_installed?
    Rails.root.join("app/assets/stylesheets/application.bootstrap.scss").exist?
  end

  def self.tailwind_installed?
    Rails.root.join("app/assets/stylesheets/application.tailwind.scss").exist?
  end

  def self.framework_installed?
    self.bootstrap_installed? ||
    self.tailwind_installed?
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
