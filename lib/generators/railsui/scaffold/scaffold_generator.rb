require "rails/generators"
require "rails/generators/rails/scaffold/scaffold_generator"

module Railsui
  module Generators
    class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
      source_root File.expand_path('templates', __dir__)

       def generate_model
        invoke 'active_record:model', [name] + attributes.map { |attr| "#{attr.name}:#{attr.type}" }, migration: true
      end

      def copy_view_files
        available_views.each do |view|
          if view == 'partial'
            template "themes/#{Railsui.config.theme}/views/partial.html.erb.tt", File.join("app/views", controller_file_path, "_#{singular_name}.html.erb"), force: true
          else
            template "themes/#{Railsui.config.theme}/views/#{view}.html.erb.tt", File.join("app/views", controller_file_path, "#{view}.html.erb"), force: true
          end
        end
      end

      private

      def available_views
        %w(index edit show new _form partial)
      end
    end
  end
end
