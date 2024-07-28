require "railsui/theme_setup"
require "railsui/user_setup"

module Railsui
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Railsui::ThemeSetup
      include Railsui::UserSetup

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
        say "🔥 Installing #{@theme.humanize} theme."

        # Add engine routes
        # Add a GUI for easier theme configuration
        copy_railsui_routes

        # gems
        install_gems

        # add users
        setup_users
        add_devise_email_previews(@theme)
        copy_railsui_devise_views(@theme)

        # action_text
        # Needed for the rich text editor
        install_action_text

        # mailers
        update_application_mailer
        update_railsui_mailer_layout(@theme)
        generate_sample_mailers(@theme)

        # rails ui deps
        install_theme_dependencies(@theme)
        setup_stimulus(@theme)

        # themed assets
        copy_theme_javascript(@theme)
        copy_theme_stylesheets(@theme)

        # view related
        copy_railsui_head(@theme)
        copy_railsui_launcher(@theme)
        copy_railsui_shared_directory(@theme)

        # tailwind related
        update_tailwind_config(@theme)
        # Each theme requires unique body classes. Instead of blowing away the layout, we'll just add the classes to the config.
        update_body_classes

        # cleanup
        remove_action_text_defaults

        # If pages are present, copy the pages related files.
        if Railsui.config.pages.any?
          copy_railsui_pages_routes
          copy_railsui_page_controller(@theme)
          copy_railsui_images(@theme)
          copy_railsui_pages(@theme)
        end

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
say "📌 Tip: To change your theme options modify your config/railsui.yml file or use the Rails UI configuration form. Read the docs at https://railsui.com/docs for available options."
      end
    end
  end
end
