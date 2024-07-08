require "rails/generators/rails/scaffold/scaffold_generator"

module Railsui
  module Generators
    class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
      source_root File.expand_path('templates', __dir__)

      def add_theme_files
        return unless Railsui.config.theme.present?

        theme = Railsui.config.theme

        directory "themes/#{theme}/views", "app/views"
      end
    end
  end
end
