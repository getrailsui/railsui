require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

# Inspiration
# https://github.com/rails/rails/blob/main/railties/lib/rails/generators/erb/scaffold/scaffold_generator.rb
# TODO: This is all types of hacky :)

module Railsui
  module Generators
    class Base < Rails::Generators::NamedBase
      protected

      def format
        :html
      end

      def handler
        :erb
      end

      def filename_with_extensions(name)
        cformat = name[/\.js/] ? nil : format
        [name, cformat, handler].compact.join(".")
      end
    end

    class ScaffoldGenerator < Base
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          # dynamically choose a template
          template_path = "#{Railsui.config.css_framework}/#{Railsui.config.theme}/#{filename}"

          template template_path, File.join("app/views",controller_file_path, filename)
        end

        template "#{Railsui.config.css_framework}/#{Railsui.config.theme}/partial.html.erb", File.join("app/views", controller_file_path, "_#{singular_name}.html.erb")
      end

      def add_to_navigation
inserted_link = <<-ERB
<li #{'class="nav-item"' if Railsui.bootstrap? }>
  <%= nav_link_to "#{plural_table_name.titleize}", #{index_helper(type: :path)}, class: "nav-link" %>
</li>

ERB
        append_to_file "app/views/shared/_nav_links.html.erb", inserted_link
      end

    protected
      def available_views
        %w(index edit show new _form)
      end
    end
  end
end
