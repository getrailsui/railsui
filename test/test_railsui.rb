# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "railsui/version"

require "minitest/autorun"

class TestRailsui < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Railsui::VERSION
  end

  def test_that_it_includes_tailwindcss_rails_dependency
    # Check that tailwindcss-rails is included in the gem dependencies
    spec = Gem::Specification.find_by_name("railsui")
    dependencies = spec.dependencies.map(&:name)
    assert_includes dependencies, "tailwindcss-rails"
  end
end
