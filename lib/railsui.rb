require "railsui/version"
require "railsui/engine"

module Railsui
  autoload :Configuration, "railsui/configuration"
  autoload :Controller, "railsui/controller"

  mattr_accessor :config
  @@config = {}

  def self.save_preferences
    set_framework
    install_pages_and_content
  end

  def self.restart
    run_command "rails restart"
  end

  def self.bundle
    run_command "bundle"
  end

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end
end
