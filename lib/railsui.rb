# frozen_string_literal: true

require "railsui/version"
require "railsui/engine"
require "railsui_icon"
require "tailwindcss-rails"

module Railsui
  autoload :Configuration, "railsui/configuration"
  autoload :Pages, "railsui/pages"
  autoload :Themes, "railsui/themes"
  autoload :ThemeHelper, "railsui/theme_helper"
  autoload :MetaTagsHelper, "railsui/meta_tags_helper"
  autoload :ThemeSetup, "railsui/theme_setup"
  autoload :FormBuilder, "railsui/form_builder"

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
    # Use tailwindcss-rails gem for all CSS compilation (unified approach)
    if defined?(Tailwindcss)
      run_command "rails tailwindcss:build"

      # Touch the built CSS file to update its timestamp and bust browser cache
      css_file = Rails.root.join("app/assets/builds/tailwind.css")
      if File.exist?(css_file)
        FileUtils.touch(css_file)
      end
    else
      puts "tailwindcss-rails gem not found. Please install it to build CSS."
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
