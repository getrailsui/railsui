require "rails/generators"
require "rails/generators/named_base"

module Railsui
  module Generators
    class ComponentGenerator < Rails::Generators::NamedBase
      include Thor::Actions
      source_root File.expand_path("templates", __dir__)

      class_option :stimulus, type: :boolean, default: false, desc: "Generate a Stimulus controller"
      class_option :directory, type: :string, default: nil, desc: "Custom output directory"
      class_option :list, type: :boolean, default: false, desc: "List available components"

      def handle_component
        if options[:list]
          print_available_components
          return
        end
        return unless railsui_installed?

        if behavior == :invoke
          create_component
          create_stimulus_controller if options[:stimulus]
        elsif behavior == :revoke
          destroy_component
          remove_stimulus_controller if File.exist?(Rails.root.join("app/javascript/controllers/#{file_name}_controller.js"))
        end
      end

      private

      def create_component
        directory_path = options[:directory] || "app/views/rui/components"
        target_path = File.join(directory_path, "_#{file_name}.html.erb")
        partial_template = themed_path("_#{file_name}.html.erb.tt") || "default_component.html.erb"

        template partial_template, target_path
      end

      def create_stimulus_controller
        controller_path = "app/javascript/controllers/#{file_name}_controller.js"
        theme_template = themed_path("#{file_name}_controller.js.erb")
        fallback_template = "stimulus_controller.js.erb"
        template_path = theme_template || fallback_template

        template template_path, controller_path
      end

      def destroy_component
        relative_path = "app/views/rui/components/_#{file_name}.html.erb"
        say_status :remove, relative_path, :red
        FileUtils.rm(Rails.root.join(relative_path))
      end

      def remove_stimulus_controller
        controller_path = "app/javascript/controllers/#{file_name}_controller.js"
        index_path = Rails.root.join("app/javascript/controllers/index.js")

        say_status :remove, controller_path, :red
        FileUtils.rm(controller_path)
      end

      def print_available_components
        theme = Railsui.config.theme
        path = File.expand_path("templates/themes/#{theme}", __dir__)
        say "🎨 Available components for theme `#{theme}`:\n", :green

        Dir.glob("#{path}/*.html.erb.tt").each do |template|
          name = File.basename(template, ".html.erb.tt")
          say "  • #{name.camelize}"
        end
      end

      def railsui_installed?
        defined?(Railsui) && Railsui.respond_to?(:config)
      end

      def themed_path(filename)
        theme = Railsui.config.theme
        path = File.expand_path("templates/themes/#{theme}/#{filename}", __dir__)
        File.exist?(path) ? path : nil
      end
    end
  end
end
