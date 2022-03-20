require 'generators/railsui/generator_helpers'
module Railsui
  module Generators
    class StaticGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Railsui::Generators::GeneratorHelpers
      hook_for :test_framework, as: :controller
      source_root File.expand_path('../templates', __FILE__)
      class_option :css, type: :string, default: nil, desc: "Pass CSS framework of choice"

      desc "Adds additional routing and views for the StaticController"

      def copy_controller_action
        append_to_file "app/controllers/static_controller.rb", after: "class StaticController < ApplicationController\n" do
        "\tdef #{display_name}\n\tend\n\n"
        end
      end

      # The NAME attribute when the generator is run
      def display_name
        name
      end

      def copy_view_files
        # only return files if we support them [about, pricing]
        return unless display_name == "about" || display_name == "pricing"
        template "static/#{display_name}.html.erb", File.join("app/views/static", "#{display_name}.html.erb")
      end

      def add_routes
        insert_into_file "#{Rails.root}/config/routes.rb", "\t\tget #{display_name.prepend(':')}\n", after: "scope controller: :static do\n"
      end
    end
  end
end
