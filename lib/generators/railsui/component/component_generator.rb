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
        folder_path = themed_component_folder_path(file_name)

        if Dir.exist?(folder_path)
          directory folder_path, File.join(directory_path, file_name)
        else
          target_path = File.join(directory_path, "_#{file_name}.html.erb")
          partial_template = themed_path("_#{file_name}.html.erb.tt") || "default_component.html.erb"
          template partial_template, target_path
        end
      end

      def create_stimulus_controller
        controller_path = "app/javascript/controllers/#{file_name}_controller.js"
        theme_template = themed_path("#{file_name}_controller.js.erb")
        fallback_template = "stimulus_controller.js.erb"
        template_path = theme_template || fallback_template

        template template_path, controller_path
      end

      def destroy_component
        directory = options[:directory] || "app/views/rui/components"
        folder_path = File.join(directory, file_name)
        file_path = File.join(directory, "_#{file_name}.html.erb")

        if Dir.exist?(Rails.root.join(folder_path))
          FileUtils.rm_rf(Rails.root.join(folder_path))
          say_status :remove, folder_path, :red
        elsif File.exist?(Rails.root.join(file_path))
          FileUtils.rm(file_path)
          say_status :remove, file_path, :red
        else
          say "ℹ️  Component not found for deletion: #{folder_path} or #{file_path}", :blue
        end
      end

      def remove_stimulus_controller
        controller_path = "app/javascript/controllers/#{file_name}_controller.js"
        index_path = Rails.root.join("app/javascript/controllers/index.js")

        if File.exist?(Rails.root.join(controller_path))
          FileUtils.rm(controller_path)
          say_status :remove, controller_path, :red
        else
          say "ℹ️ File does not exist"
        end

        if File.exist?(index_path)
          import_line = "import #{file_name.camelize}Controller from \"./#{file_name.underscore}_controller\"\n"
          register_line = "application.register(\"#{file_name.dasherize}\", #{file_name.camelize}Controller)\n"

          content = File.read(index_path)
          content.gsub!(/#{Regexp.escape(import_line)}/, "")
          content.gsub!(/#{Regexp.escape(register_line)}/, "")
          File.write(index_path, content)
        end
      end

      def print_available_components
        theme = Railsui.config.theme
        path = File.expand_path("templates/themes/#{theme}", __dir__)
        say "🎨 Available components for theme `#{theme}`:\n", :green

        Dir.glob("#{path}/*").select { |f| File.directory?(f) }.each do |folder|
          name = File.basename(folder)
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

      def themed_component_folder_path(name)
        theme = Railsui.config.theme
        File.expand_path("templates/themes/#{theme}/#{name}", __dir__)
      end
    end
  end
end
