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
        update_tailwind_config(@config.theme)
        update_body_classes

        if @config.pages.any?
          copy_railsui_pages_routes
          copy_railsui_page_controller(@config.theme)
          copy_railsui_images(@config.theme)
          copy_railsui_pages(@config.theme)
        end

        Railsui::Configuration.synchronize_pages

        @config.save
        say "✅ Configuration updated successfully", :green
      end
    end
  end
end
