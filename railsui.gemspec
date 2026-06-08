# frozen_string_literal: true
require_relative "lib/railsui/version"

Gem::Specification.new do |spec|
  spec.name = "railsui"
  spec.version = Railsui::VERSION
  spec.authors = ["Andy Leverenz"]
  spec.email = ["railsui@justalever.com"]
  spec.summary = "The product UI system for Rails SaaS builders"
  spec.description = "Rails UI is the product UI system for Rails SaaS builders. Complete app kits and the Rails-native components behind them, in clean ERB and Tailwind, so you ship a finished product instead of a blank page."
  spec.homepage = "https://railsui.com"
  spec.metadata = {
    "homepage_uri" => "https://railsui.com",
    "documentation_uri" => "https://railsui.com/docs",
    "mailing_list_uri" => "https://railsui.com/updates"
  }
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.required_ruby_version = '>= 2.7.0'
  spec.require_paths = ["lib"]
  spec.license = "Unlicense" # https://choosealicense.com/no-permission/

  spec.add_dependency 'rails', '>= 7.0'
  spec.add_dependency 'psych'
  spec.add_dependency 'railsui_icon'
  spec.add_dependency 'tailwindcss-rails', '>= 2.0'
end
