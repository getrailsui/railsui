require "rails/generators"
require "rails/generators/named_base"

module Railsui
  module Generators
    class ComponentGenerator < Rails::Generators::Base
      include Thor::Actions
      source_root File.expand_path("templates", __dir__)

      argument :name, type: :string, required: false, desc: "Component name"
      class_option :stimulus, type: :boolean, default: false, desc: "Generate a Stimulus controller"
      class_option :directory, type: :string, default: nil, desc: "Custom output directory for ViewComponent files"
      class_option :list, type: :boolean, default: false, desc: "List available components"
      class_option :help, type: :boolean, default: false, desc: "Show detailed usage tutorial"

      def handle_component
        if options[:help]
          print_help_tutorial
          return
        end

        if options[:list]
          print_available_components
          return
        end

        unless name.present?
          say "Error: Component name is required when not using --list or --help", :red
          say "Usage: rails g railsui:component COMPONENT_NAME [options]", :yellow
          say "   or: rails g railsui:component --list", :yellow
          say "   or: rails g railsui:component --help", :yellow
          return
        end

        return unless railsui_installed?

        if behavior == :invoke
          create_viewcomponent
          create_stimulus_controller if options[:stimulus]
        elsif behavior == :revoke
          destroy_viewcomponent
          remove_stimulus_controller if File.exist?(Rails.root.join("app/javascript/controllers/#{file_name}_controller.js"))
        end
      end

      private

      # Helper methods that were provided by NamedBase
      def class_name
        name.classify
      end

      def file_name
        name.underscore
      end

      def destroy_viewcomponent
        base_dir = options[:directory] || "app/components/railsui"
        
        # Remove main component files
        component_file_path = Rails.root.join(base_dir, "#{file_name}_component.rb")
        template_file_path = Rails.root.join(base_dir, "#{file_name}_component.html.erb")

        [component_file_path, template_file_path].each do |file_path|
          if File.exist?(file_path)
            FileUtils.rm(file_path)
            say_status :remove, file_path.to_s.gsub("#{Rails.root}/", ""), :red
          end
        end
        
        # Remove child component files
        destroy_additional_component_files(base_dir)
      end

      def create_viewcomponent
        theme = Railsui.config.theme
        component_class_name = "Railsui::#{class_name}Component"

        # Use custom directory if provided - follows Rails naming conventions
        base_dir = options[:directory] || "app/components/railsui"
        component_file_path = File.join(base_dir, "#{file_name}_component.rb")
        template_file_path = File.join(base_dir, "#{file_name}_component.html.erb")

        # Check for theme-specific templates in folder structure
        theme_folder = "themes/#{theme}/#{file_name}"
        theme_class_template = "#{theme_folder}/#{file_name}.rb.tt"
        theme_view_template = "#{theme_folder}/#{file_name}.html.erb.tt"

        class_template_path = nil
        view_template_path = nil

        # Look for theme-specific templates
        Dir.chdir(self.class.source_root) do
          if File.exist?(theme_class_template)
            class_template_path = theme_class_template
          end

          if File.exist?(theme_view_template)
            view_template_path = theme_view_template
          end
        end

        if class_template_path && view_template_path
          # Use theme-specific templates
          template class_template_path, component_file_path
          template view_template_path, template_file_path

          # Check for additional component files (like accordion_item)
          create_additional_component_files(theme_folder, base_dir)
        else
          # Fallback to generic template
          create_generic_viewcomponent(component_class_name, component_file_path, template_file_path)
        end
      end

      def create_generic_viewcomponent(component_class_name, component_file_path, template_file_path)
        # Create component class
        create_file component_file_path, <<~RUBY
          # frozen_string_literal: true

          class #{component_class_name} < RailsuiComponent
            def initialize(
              # Add your component parameters here
              **tag_options
            )
              @tag_options = tag_options
            end

            private

            attr_reader :tag_options
          end
        RUBY

        # Create component template
        create_file template_file_path, <<~ERB
          <%# Add your component template here %>
          <div class="<%= theme_class('#{file_name}') %>">
            <%= content %>
          </div>
        ERB

        say_status :create, "Generic ViewComponent #{component_class_name}", :green
      end

      def create_additional_component_files(theme_folder, base_dir)
        # Look for child component files like accordion_item.rb.tt
        Dir.chdir(self.class.source_root) do
          Dir.glob("#{theme_folder}/*_*.rb.tt").each do |additional_template|
            next if additional_template.include?("_controller.js")

            # Extract component name from template filename
            basename = File.basename(additional_template, ".rb.tt")
            additional_file_path = File.join(base_dir, "#{basename}_component.rb")
            additional_view_path = File.join(base_dir, "#{basename}_component.html.erb")
            additional_view_template = additional_template.gsub('.rb.tt', '.html.erb.tt')

            if File.exist?(additional_view_template)
              template additional_template, additional_file_path
              template additional_view_template, additional_view_path
            end
          end
        end
      end
      
      def destroy_additional_component_files(base_dir)
        theme = Railsui.config.theme
        theme_folder = "themes/#{theme}/#{file_name}"
        
        # Look for child component files like accordion_item
        Dir.chdir(self.class.source_root) do
          if Dir.exist?(theme_folder)
            Dir.glob("#{theme_folder}/*_*.rb.tt").each do |additional_template|
              next if additional_template.include?("_controller.js")
              
              # Extract component name from template filename
              basename = File.basename(additional_template, ".rb.tt")
              additional_file_path = Rails.root.join(base_dir, "#{basename}_component.rb")
              additional_view_path = Rails.root.join(base_dir, "#{basename}_component.html.erb")
              
              # Remove the files if they exist
              [additional_file_path, additional_view_path].each do |file_path|
                if File.exist?(file_path)
                  FileUtils.rm(file_path)
                  say_status :remove, file_path.to_s.gsub("#{Rails.root}/", ""), :red
                end
              end
            end
          end
        end
      end


      def create_stimulus_controller
        theme = Railsui.config.theme

        # Check for theme-specific Stimulus template in folder structure
        theme_folder = "themes/#{theme}/#{file_name}"
        theme_stimulus_template = "#{theme_folder}/#{file_name}_controller.js.erb"
        fallback_template = File.expand_path("templates/stimulus_controller.js.erb", __dir__)

        template_path = nil

        Dir.chdir(self.class.source_root) do
          if File.exist?(theme_stimulus_template)
            template_path = theme_stimulus_template
          end
        end

        template_path ||= fallback_template

        controller_name = "#{file_name}_controller.js"
        controller_dest = Rails.root.join("app/javascript/controllers/railsui", controller_name)

        template template_path, controller_dest
        register_stimulus_controller(file_name)

        say_status :create, "Stimulus controller for #{file_name}", :green
      end

      def register_stimulus_controller(name)
        index_path = Rails.root.join("app/javascript/controllers/index.js")

        import_line   = "import #{name.camelize}Controller from \"./railsui/#{name.underscore}_controller\""
        register_line = "application.register(\"railsui-#{name.dasherize}\", #{name.camelize}Controller)"
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


      def remove_stimulus_controller
        controller_path = "app/javascript/controllers/railsui/#{file_name}_controller.js"
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
        import_regex = /^import #{file_name.camelize}Controller from ["']\.\/railsui\/#{file_name.underscore}_controller["']\s*\n?/
        register_regex = /^application\.register\(["']railsui-#{file_name.dasherize}["'], #{file_name.camelize}Controller\)\s*\n?/

        new_content = content.gsub(import_regex, "").gsub(register_regex, "")
        File.write(index_path, new_content)
        say_status :update, "Removed #{file_name}_controller from index.js", :red
      end

      def print_help_tutorial
        theme = Railsui.config.theme

        say "\n🚀 Rails UI ViewComponent Generator Tutorial", :cyan
        say "=" * 50, :cyan

        say "\n📋 BASIC USAGE:", :green
        say "  rails g railsui:component COMPONENT_NAME [options]", :white

        say "\n🔍 DISCOVERY COMMANDS:", :green
        say "  rails g railsui:component --list    # List available components", :white
        say "  rails g railsui:component --help    # Show this tutorial", :white

        say "\n⚡ GENERATION EXAMPLES:", :green
        say "  # Generate a basic component", :yellow
        say "  rails g railsui:component button", :white
        say "", :white
        say "  # Generate component with Stimulus controller", :yellow
        say "  rails g railsui:component modal --stimulus", :white
        say "", :white
        say "  # Generate to custom directory", :yellow
        say "  rails g railsui:component card --directory app/components/custom", :white

        say "\n🎨 USING COMPONENTS IN VIEWS:", :green
        say "  # Basic usage with options", :yellow
        say "  <%= rui(:button, label: \"Click me\", variant: :primary) %>", :white
        say "", :white
        say "  # With block content", :yellow
        say "  <%= rui(:alert, title: \"Success\") do %>", :white
        say "    Your action was completed successfully!", :white
        say "  <% end %>", :white
        say "", :white
        say "  # Complex components with child components (auto-generated)", :yellow
        say "  <%= rui(:accordion) do |accordion| %>", :white
        say "    <% accordion.with_item(title: \"Section 1\") do %>", :white
        say "      Content for section 1", :white
        say "    <% end %>", :white
        say "  <% end %>", :white

        say "\n🎯 CURRENT THEME: #{theme.upcase}", :green
        say "  Components will be generated using #{theme} theme styling", :white

        say "\n📂 FILES CREATED:", :green
        say "  app/components/railsui/COMPONENT_NAME_component.rb        # ViewComponent class", :white
        say "  app/components/railsui/COMPONENT_NAME_component.html.erb  # Template file", :white
        say "  app/javascript/controllers/railsui/COMPONENT_NAME_controller.js  # Stimulus (if --stimulus)", :white

        say "\n🔧 AVAILABLE OPTIONS:", :green
        say "  --stimulus     Generate Stimulus controller for JavaScript functionality", :white
        say "  --directory    Custom output directory (default: app/components/railsui)", :white
        say "  --list         List all available components for current theme", :white
        say "  --help         Show this tutorial", :white

        say "\n🎪 COMPONENT FEATURES:", :green
        say "  ✅ Theme isolation (#{theme} theme styling)", :white
        say "  ✅ Namespace isolation (Railsui::*Component)", :white
        say "  ✅ ViewComponent slots for complex components", :white
        say "  ✅ Auto-generation of child components (accordion_item, table_row, etc.)", :white
        say "  ✅ Stimulus integration with railsui-* controllers", :white
        say "  ✅ Familiar rui() helper syntax", :white
        say "  ✅ Full Rails integration", :white

        say "\n📚 MORE INFORMATION:", :green
        say "  Documentation: See COMPONENTS.md in your Rails UI installation", :white
        say "  Examples: Check the generated component files for usage patterns", :white

        say "\n💡 NEXT STEPS:", :green
        say "  1. Run: rails g railsui:component --list", :yellow
        say "  2. Pick a component: rails g railsui:component button", :yellow
        say "  3. Use in views: <%= rui(:button, label: \"Test\") %>", :yellow
        say "  4. Customize styling and behavior as needed", :yellow

        say "\n" + "=" * 50, :cyan
        say "🎉 Happy component building!", :cyan
      end

      def print_available_components
        theme = Railsui.config.theme
        say "🎨 Available components for #{theme} theme:\n", :green

        # Show generated components
        if defined?(Railsui) && Railsui.respond_to?(:constants)
          Railsui.constants.each do |const|
            next unless const.to_s.end_with?('Component')
            component_class = Railsui.const_get(const)
            if component_class.is_a?(Class) && (component_class < ViewComponent::Base || component_class < RailsuiComponent)
              component_name = const.to_s.gsub(/Component$/, '').underscore
              say "  ✓ #{component_name} (generated)"
            end
          end
        end

        # Show available templates in folder structure
        template_path = File.expand_path("templates/themes/#{theme}", __dir__)
        if Dir.exist?(template_path)
          # Look for folders that contain component templates
          Dir.glob("#{template_path}/*/").each do |folder|
            component_name = File.basename(folder)
            if File.exist?(File.join(folder, "#{component_name}.rb.tt"))
              component_const = "#{component_name.classify}Component"
              unless defined?(Railsui) && Railsui.const_defined?(component_const)
                say "  • #{component_name} (available to generate)"
              end
            end
          end
        else
          say "  No templates found for #{theme} theme"
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
