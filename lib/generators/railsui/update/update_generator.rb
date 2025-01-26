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

        # update body classes
        update_railsui_theme_classes

        # sync pages
        sync_pages

        Railsui::Configuration.synchronize_pages

        @config.save
        say "✅ Configuration updated successfully", :green
      end

      private

      def sync_pages
        # Remove old theme's pages. Forcefully for now.
        pages_directory = Rails.root.join("app/views/rui")
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
        # Copy Pages
        directory "themes/#{theme}/views/rui", "app/views/rui", force: true

        # Copy layouts
        directory "themes/#{theme}/views/layouts/rui", "app/views/layouts/rui", force: true
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
    end
  end
end
