require "railsui/theme_setup"

module Railsui
  module Generators
    class UpdateGenerator < Rails::Generators::Base
      include Railsui::ThemeSetup

      source_root File.expand_path("../install/templates", __dir__)

      def setup_theme
        @config = Railsui::Configuration.load!
        @build_mode = @config.build_mode

        say "Updating theme: #{@config.theme} (#{@build_mode} mode)", :yellow

        # Migrate old CSS path to new tailwindcss-rails v4 location if needed
        migrate_css_path_if_needed

        say "Updating Rails UI config", :yellow
        # mailers
        update_railsui_mailer_layout(@config.theme)
        copy_sample_mailers(@config.theme)

        # Install dependencies based on build mode
        if @build_mode == "nobuild"
          install_js_dependencies_nobuild(@config.theme)
        else
          install_js_dependencies_build(@config.theme)
        end

        # CSS dependencies (unified for both modes)
        install_css_dependencies

        # themed assets
        copy_theme_javascript(@config.theme)
        copy_theme_stylesheets(@config.theme)

        # Update Procfile for current mode
        copy_procfile

        # update body classes
        update_railsui_theme_classes

        # sync pages
        sync_pages

        Railsui::Configuration.synchronize_pages

        # Run bundle install to ensure all gems are available
        say "Running bundle install...", :yellow
        run "bundle install"

        @config.save
        say "✅ Configuration updated successfully for #{@build_mode} mode", :green
      end

      private

      def migrate_css_path_if_needed
        old_path = Rails.root.join("app/assets/stylesheets/application.tailwind.css")
        new_path = Rails.root.join("app/assets/tailwind/application.css")

        # If using old path and new path doesn't exist, migrate
        if File.exist?(old_path) && !File.exist?(new_path)
          say "📦 Migrating CSS to tailwindcss-rails v4 location...", :yellow

          # Create new directory
          FileUtils.mkdir_p(Rails.root.join("app/assets/tailwind"))

          # Move the file
          FileUtils.mv(old_path, new_path)

          say "✓ Moved #{old_path.relative_path_from(Rails.root)} → #{new_path.relative_path_from(Rails.root)}", :green
          say "  Layouts will now use stylesheet_link_tag 'tailwind' instead of 'application'", :cyan
        end
      end

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
