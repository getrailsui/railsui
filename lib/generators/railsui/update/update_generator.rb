require "railsui/theme_setup"

module Railsui
  module Generators
    class UpdateGenerator < Rails::Generators::Base
      include Railsui::ThemeSetup

      source_root File.expand_path("../install/templates", __dir__)

      def setup_theme
        @config = Railsui::Configuration.load!

        say "Updating Rails UI config", :yellow

        # mailers
        update_railsui_mailer_layout(@config.theme)
        copy_sample_mailers(@config.theme)

        # rails ui deps
        install_theme_dependencies(@config.theme)

        # themed assets
        copy_theme_javascript(@config.theme)
        copy_theme_stylesheets(@config.theme)

        # view related
        copy_railsui_shared_directory(@config.theme)

        # tailwind related
        update_tailwind_preset(@config.theme)

        # update body classes
        update_railsui_theme_classes

        # sync pages
        sync_pages

        Railsui::Configuration.synchronize_pages

        @config.save
        say "✅ Configuration updated successfully", :green

        output_colors(@config.theme)
      end

      private

      def output_colors(theme)
        default_colors = Railsui::Colors.theme_colors(theme)
        output = default_colors

        say "📌Tip: Run `bin/rails railsui:colors` to print the default colors for this theme."
        say "🎨 Default colors for #{theme.humanize} theme:", :yellow
        puts output.to_yaml
      end

      def sync_pages
        # Remove old theme's pages. Forcefully for now.
        pages_directory = Rails.root.join("app/views/rui/pages")
        FileUtils.rm_rf(Dir.glob("#{pages_directory}/*"))

        # Copy new theme's pages
        copy_new_theme_pages(@config.theme)

        # Update rails ui config with new pages
        update_railsui_config_with_new_pages(@config.theme)

        # Copy new theme's pages routes
        copy_railsui_pages_routes

        # Copy new theme's images
        copy_railsui_images(@config.theme)
      end

       def copy_new_theme_pages(theme)
        # Get the new theme pages
        new_theme_pages = Railsui::Pages.get_pages(theme)

        # Ensure directories exist
        FileUtils.mkdir_p("app/views/rui/pages")
        FileUtils.mkdir_p("app/views/layouts/rui")

        # Loop through and copy each theme page
        new_theme_pages.each do |page|
          source_path = "themes/#{theme}/views/rui/pages/#{page}.html.erb"
          destination_path = Rails.root.join("app/views/rui/pages", "#{page}.html.erb")

          # Overwrite existing view files
          copy_file source_path, destination_path, force: true
        end

        # Copy default layout
        copy_file "themes/#{theme}/views/layouts/rui/railsui.html.erb", "app/views/layouts/rui/railsui.html.erb", force: true

        # Copy admin layout if it exists
        copy_admin_layout_if_exists(theme)
      end

      # Helper method to copy the admin layout if it exists
      def copy_admin_layout_if_exists(theme)
        # Manually build the path to the file in the source directory
        admin_layout = File.expand_path("themes/#{theme}/views/layouts/rui/railsui_admin.html.erb", self.class.source_root)

        # Check if the file exists before attempting to copy it
        if File.exist?(admin_layout)
          copy_file admin_layout, "app/views/layouts/rui/railsui_admin.html.erb", force: true
        else
          # Optionally, log that the admin layout is being skipped.
          say "Skipping admin layout for #{theme}, file not required."
        end
      end

      def update_railsui_theme_classes
        @config.body_classes =  Railsui::Themes.theme_classes[@config.theme]['body_classes']
      end

      def update_railsui_config_with_new_pages(theme)
        # Get all pages for the new theme
        new_theme_pages = Railsui::Pages.get_pages(theme)

        # Update the pages in the config
        @config.pages = new_theme_pages
      end

      def update_tailwind_preset(theme)
        tailwind_config_path = Rails.root.join("tailwind.config.js")

        if File.exist?(tailwind_config_path)
          content = File.read(tailwind_config_path)

          tailwind_preset_content = "presets: [presets.#{theme}],"

          # Update the preset theme
          if content =~ /presets: \[presets\..+\],/
            content.gsub!(/presets: \[presets\..+\],/, tailwind_preset_content)
            say("Updated Tailwind preset to #{theme}.", :green)
          else
            content.sub!("module.exports = {", "module.exports = {\n#{tailwind_preset_content}")
            say("Added Tailwind preset #{theme}.", :green)
          end

          # Write the updated content back to the file
          File.write(tailwind_config_path, content)
        else
          say("No tailwind.config.js file found.", :red)
        end
      end
    end
  end
end
