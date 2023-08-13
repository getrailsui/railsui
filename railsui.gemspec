# frozen_string_literal: true
require_relative "lib/railsui/version"

Gem::Specification.new do |spec|
  spec.name = "railsui"
  spec.version = Railsui::VERSION
  spec.authors = ["Andy Leverenz"]
  spec.email = ["railsui@justalever.com"]
  spec.summary = "Plug and play UI for Rails"
  spec.description = "Professionally designed UI components and views for Ruby on Rails."
  spec.homepage = "https://railsui.com"
  spec.metadata = {
    "homepage_uri" => "https://railsui.com",
    "documentation_uri" => "https://railsui.com/docs",
    "mailing_list_uri" => "https://railsui.com/updates"
  }
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.required_ruby_version = '>= 2.7.0'
  spec.require_paths = ["lib"]
  spec.license = "Unlicense" # https://choosealicense.com/no-permission/
  # spec.files = Dir["lib/**/*", "README.md"]

  spec.add_dependency 'rails', '>= 7.0'
  spec.add_dependency 'inline_svg', '>= 1.9'
  spec.add_dependency 'psych'
  spec.add_dependency 'name_of_person'
  spec.add_dependency 'meta-tags'
end
