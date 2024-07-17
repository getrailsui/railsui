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
        update_body_classes

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

        say "📌 To change the default colors for this theme, update your config/railsui.yml file directly or use the Rails UI configuration form. If editing the railsui.yml file, copy and paste the hex codes below."
        say "🎨 Default colors for #{theme.humanize} theme:", :yellow
        puts output.to_yaml
      end

      def sync_pages
        if @config.pages.any?
          # Remove old theme's pages. Forcefully for now.
          pages_directory = Rails.root.join("app/views/railsui/pages")
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
      end

      def copy_new_theme_pages(theme)
        new_theme_pages = Railsui::Pages.get_pages(theme)

        new_theme_pages.each do |page|
          source_path = "themes/#{theme}/views/railsui/pages/#{page}.html.erb"
          destination_path = Rails.root.join("app/views/railsui/pages", "#{page}.html.erb")

          # Overwrite existing view files
          copy_file source_path, destination_path, force: true
        end
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
