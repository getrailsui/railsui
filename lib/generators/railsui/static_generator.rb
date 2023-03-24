require 'generators/railsui/generator_helpers'
module Railsui
  module Generators
    class StaticGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Rails.application.routes.url_helpers
      include Railsui::Generators::GeneratorHelpers
      hook_for :test_framework, as: :controller
      source_root File.expand_path('../templates', __FILE__)
      class_option :css, type: :string, default: nil, desc: "Pass CSS framework of choice"

      desc "Adds StaticController, additional routing and associated pages for views"

      def copy_controller_action
        append_to_file "app/controllers/static_controller.rb", after: "class StaticController < ApplicationController\n" do
        "\tdef #{display_name}\n\tend\n\n"
        end
      end

      # The NAME attribute when the generator is run
      def display_name
        name
      end

      # TODO: Support for other view types (haml, slim, etc...)
      def copy_view_files
        # only return active Rails UI pages
        return unless Railsui.config.pages.include?(display_name)
        template "#{Railsui.config.css_framework}/#{Railsui.config.theme}/#{display_name}.html.erb.tt", File.join("app/views/static", "#{display_name}.html.erb")
      end

      def add_to_navigation
inserted_link = <<-ERB
<li>
  <%= nav_link_to "#{display_name.titleize}", send("#{display_name}_path"), class: "nav-link" %>
</li>
ERB
        append_to_file "app/views/shared/_nav_links.html.erb", inserted_link
      end

      def add_routes
        insert_into_file "#{Rails.root}/config/routes.rb", "\t\tget #{display_name.prepend(':')}\n", after: "scope controller: :static do\n"
      end
    end
  end
end
