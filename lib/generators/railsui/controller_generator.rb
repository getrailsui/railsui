require 'generators/railsui/generator_helpers'
# https://www.nopio.com/blog/creating-scaffold-generator-rails/
module Railsui
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Railsui::Generators::GeneratorHelpers
      hook_for :test_framework, as: :controller
      source_root File.expand_path('../templates', __FILE__)

      desc "Generates controller, test, helper, routing, and views for the model with the given NAME."

      class_option :skip_show, type: :boolean, default: false, desc: "Skip #show action"
      class_option :c, type: :string, default: nil, desc: "Pass CSS framework of choice"

      def create_helper_files
        template "helper.rb", File.join("app/helpers", class_path, "#{file_name}_helper.rb")
      end

      def copy_controller_and_spec_files
        template "controller.rb", File.join("app/controllers", "#{controller_file_name}_controller.rb")
      end

      def copy_view_files
        directory_path = File.join("app/views", controller_file_path)
        empty_directory directory_path

        view_files.each do |file_name|
          template "views/#{file_name}.html.erb", File.join(directory_path, "#{file_name}.html.erb")
        end
      end

      def add_routes
        routes_string = "resources :#{singular_name}"
        routes_string += ', except: :show' unless show_action?
        route routes_string
      end
    end
  end
end
