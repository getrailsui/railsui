require "railsui/theme_setup"

module Railsui
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Railsui::ThemeSetup

      source_root File.expand_path("templates", __dir__)

      def create_config
        configuration_params = {
          application_name: "Rails UI",
          support_email: "support@example.com",
          theme: "hound",
          colors: Railsui::Colors.theme_colors('hound'),
          pages: Railsui::Pages.get_pages('hound')
        }

        config = Railsui::Configuration.new(configuration_params)

        config.save
      end

      def install_dependencies
        config = Railsui::Configuration.load!

        @theme = Railsui.config.theme

        if File.exist?("#{Rails.root}/config/importmap.rb")
          say "❌ Detected importmaps which is unfortunately not supported by Rails UI. For best results, please use another bundling solution from jsbundling-rails (i.e., esbuild, bun) before installing", :yellow
        else
          say "🔥 Installing default theme: #{@theme.humanize} 🐶. Don't worry, you can change this."

          # Add engine routes
          # Add a GUI for easier theme configuration
          copy_railsui_routes

          # gems
          install_gems

          # action_text
          # Needed for the rich text editor
          install_action_text

          # mailers
          update_application_helper
          update_railsui_mailer_layout(@theme)
          generate_sample_mailers(@theme)

          # rails ui deps
          install_theme_dependencies(@theme)

          # assets
          copy_theme_javascript(@theme)
          copy_theme_stylesheets(@theme)

          # view related
          copy_railsui_head(@theme)
          copy_railsui_launcher(@theme)
          copy_railsui_shared_directory(@theme)

          # tailwind related
          update_tailwind_config(@theme)

          # cleanup
          remove_action_text_defaults

          # Copy the pages related files.
          copy_railsui_pages_routes
          copy_railsui_page_controller(@theme)
          copy_railsui_images(@theme)
          copy_railsui_pages(@theme)

          # migrate
          rails_command "db:migrate"

          config.save
say "
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMWXOxooodOXMMMMMMMMMMWXxxXMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXd:,..     'dXMMMMWWKx:.  ,OWMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMXO0KK0x:     cXWKxool'     .oXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMNc    .:o:.lNWXl.     ,OWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    'O0;oMMMWk'     .dNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMWo     :NK;dMMMMMKc     .xWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMWKdl,     :NK;dMMMMMMNd. .lONMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMNkooxKd     :NK;dMMMMWKxllkXMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMW0l' .:ONd     :NK;oMMXk:..dNMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMNx,.    ,'     :NK;;xl.    .;xNMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMW0o,         :NK,.::,.      ,kWMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMNx'       :NK;oMMWKx,     .lNMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMXc      :NK;oMMMMMNo.     oWMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMX:     :NK;dMMMMMMWd.    .xMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMx.    :X0;dMMMMMMMNl     '0MMMMMMMMMMMMMM
MMMMMMMMMMMMMMMXOo:.      ''.,dx0NMMMMXc     ;KMMMMMMMMMMMMM
MMMMMMMMMMMMNkc.                .'codXMK;     'dxKMMMMMMMMMM
MMMMMMMMMMNx,. .',;:::;,..        .lKWMMK;     ,dXMMMMMMMMMM
MMMMMMMMMNxldk0XNWMMMMMWNKkl,.  .lKWMMMMMXo. ,xNMMMMMMMMMMMM
MMMMMMMMMWWMMMMMMMMMMMMMMMMMW0kkKWMMMMMMMMWKONMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
"
          say "✅ Install complete", :green
          say "--"
          say "🔥 Rails UI is now installed. You can access your configuration at /railsui"
          say "Read documentation at https://railsui.com/docs for FAQs, guides, and more."
        end
      end
    end
  end
end
