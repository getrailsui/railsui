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
        target_folder = File.join(directory_path, file_name)
        theme = Railsui.config.theme
        template_dir = "themes/#{theme}/#{file_name}"

        FileUtils.mkdir_p(target_folder)

        Dir.chdir(self.class.source_root) do
          Dir.glob("#{template_dir}/*").each do |relative_path|
            filename = File.basename(relative_path)

            # Skip .js or .js.erb files unless --stimulus is passed
            if filename.match?(/\.js(\.erb)?$/)
              next unless options[:stimulus]
              next # prevent copying to views — handled in create_stimulus_controller
            end

            # Output file name (strip .erb/.tt if present)
            target_filename = filename.sub(/\.erb$/, "").sub(/\.tt$/, "")
            target_path = File.join(target_folder, target_filename)

            if filename.end_with?(".erb") || filename.end_with?(".tt")
              template relative_path, target_path
            else
              copy_file relative_path, target_path
            end
          end
        end
      end

      def create_stimulus_controller
        # Check for theme-specific template first
        theme_template = themed_path("#{file_name}/#{file_name}_controller.js.erb")
        fallback_template = File.expand_path("templates/stimulus_controller.js.erb", __dir__)
        template_path = theme_template || fallback_template

        controller_name = "#{file_name}_controller.js"
        controller_dest = Rails.root.join("app/javascript/controllers", controller_name)

        template template_path, controller_dest
        register_stimulus_controller(file_name)
      end

      def register_stimulus_controller(name)
        index_path = Rails.root.join("app/javascript/controllers/index.js")

        import_line   = "import #{name.camelize}Controller from \"./#{name.underscore}_controller\""
        register_line = "application.register(\"#{name.dasherize}\", #{name.camelize}Controller)"
        full_block    = "#{import_line}\n#{register_line}"

        content = File.exist?(index_path) ? File.read(index_path) : ""

        return if content.include?(import_line) && content.include?(register_line)

        needs_newline = !content.end_with?("\n")

        File.open(index_path, "a") do |file|
          file.write("\n") if needs_newline
          file.write(full_block)
        end

        say_status :update, "Appended #{name}_controller to index.js", :green
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
          say "ℹ️ File does not exist", :blue
        end

        return unless File.exist?(index_path)

        content = File.read(index_path)

        # Use regex to remove both lines regardless of spacing or order
        import_regex = /^import #{file_name.camelize}Controller from ["']\.\/#{file_name.underscore}_controller["']\s*\n?/
        register_regex = /^application\.register\(["']#{file_name.dasherize}["'], #{file_name.camelize}Controller\)\s*\n?/

        new_content = content.gsub(import_regex, "").gsub(register_regex, "")
        File.write(index_path, new_content)
        say_status :update, "Removed #{file_name}_controller from index.js", :red
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

      def themed_relative_path(name)
        theme = Railsui.config.theme
        "themes/#{theme}/#{name}"
      end

      def themed_component_folder_path(name)
        theme = Railsui.config.theme
        File.expand_path("templates/themes/#{theme}/#{name}", __dir__)
      end
    end
  end
end
