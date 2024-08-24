require "rails/generators"
require "rails/generators/rails/scaffold/scaffold_generator"

module Railsui
  module Generators
    class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
      source_root File.expand_path('templates', __dir__)

      # Custom view generation
      def create_custom_views
        %w[index show new edit _form].each do |view|
          template "themes/#{Railsui.config.theme}/views/#{view}.html.erb", File.join("app/views", file_name.pluralize, "#{view}.html.erb"), force: true
        end
      end
    end
  end
end
