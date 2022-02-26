require "railsui/version"
require "railsui/engine"

module Railsui
  autoload :Configuration, "railsui/configuration"
  autoload :Controller, "railsui/controller"

  mattr_accessor :config
  @@config = {}

  def self.restart
    run_command "rails restart"
  end

  def self.bundle
    run_command "bundle"
  end

  def self.tailwind?
    self.config.css_framework == self::Default::TAILWIND_CSS
  end

  def self.bootstrap?
    self.config.css_framework == self::Default::BOOTSTRAP
  end

  def self.bulma?
    self.config.css_framework == self::Default::BULMA
  end

  def self.no_framework_set?
    self.config.css_framework == "" # not yet configured
  end

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end
end
