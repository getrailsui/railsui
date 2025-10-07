require "railsui/theme_setup"

module Railsui
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Railsui::ThemeSetup

      source_root File.expand_path("templates", __dir__)

      class_option :build, type: :boolean, default: false, desc: "Install with JS bundler (esbuild, bun, webpack, rollup)"

      def check_build_mode_requirements
        # If --build flag is used, verify jsbundling-rails is installed BEFORE doing anything
        if options[:build]
          unless gem_installed?('jsbundling-rails')
            say ""
            say "=" * 70, :red
            say "❌ Build mode requires jsbundling-rails", :red
            say "=" * 70, :red
            say ""
            say "You've used the --build flag, but jsbundling-rails is not installed.", :yellow
            say ""
            say "Please install a JS bundler first:", :cyan
            say ""
            say "  bundle add jsbundling-rails", :cyan
            say "  rails javascript:install:[bun|esbuild|rollup|webpack]", :cyan
            say "  rails railsui:install --build", :cyan
            say ""
            say "Or use importmap mode (no --build flag needed):", :cyan
            say ""
            say "  rails railsui:install", :cyan
            say ""
            say "📚 See README for more details on installation modes", :cyan
            say ""
            exit(1)
          end

          # Also verify a JS bundler is configured
          bundler = detect_js_bundler
          if bundler == "unknown" || bundler == "importmap"
            say ""
            say "=" * 70, :red
            say "❌ Build mode requires a configured JS bundler", :red
            say "=" * 70, :red
            say ""
            say "jsbundling-rails is installed, but no bundler is configured.", :yellow
            say ""
            say "Install one with:", :cyan
            say ""
            say "  rails javascript:install:[bun|esbuild|rollup|webpack]", :cyan
            say "  rails railsui:install --build", :cyan
            say ""
            say "Or use importmap mode (no --build flag needed):", :cyan
            say ""
            say "  rails railsui:install", :cyan
            say ""
            say "📚 See README for more details on installation modes", :cyan
            say ""
            exit(1)
          end
        end
      end

      def create_config
        build_mode = options[:build] ? "build" : "nobuild"

        configuration_params = {
          application_name: "Rails UI",
          support_email: "support@example.com",
          theme: "hound",
          pages: Railsui::Pages.get_pages('hound'),
          build_mode: build_mode
        }

        config = Railsui::Configuration.new(configuration_params)
        config.save(skip_build: true) # Skip CSS build - file doesn't exist yet
      end

      def install_dependencies
        # Detect and warn about existing setup
        detect_and_warn_about_setup

        config = Railsui::Configuration.load!

        @theme = Railsui.config.theme
        @build_mode = config.build_mode

        mode_label = @build_mode == "nobuild" ? "no-build (importmap)" : "build"
        say "🔥 Installing default theme: #{@theme.humanize} 🐶 in #{mode_label} mode. Don't worry, you can change this."

        # Add engine routes
        # Add a GUI for easier theme configuration
        copy_railsui_routes

        # gems railsui_icon and action_text
        install_gems

        # Install CSS dependencies (unified for both modes)
        install_css_dependencies

        # mailers
        update_application_helper
        update_railsui_mailer_layout(@theme)
        generate_sample_mailers(@theme)

        # Install JS dependencies based on build mode
        if @build_mode == "nobuild"
          install_js_dependencies_nobuild(@theme)
        else
          install_js_dependencies_build(@theme)
        end

        # assets
        copy_theme_javascript(@theme)
        copy_theme_stylesheets(@theme)

        # view related
        copy_railsui_head(@theme)
        copy_railsui_launcher(@theme)

        # cleanup
        remove_action_text_defaults

        # Copy the pages related files.
        copy_railsui_pages_routes
        copy_railsui_page_controller(@theme)
        copy_railsui_images(@theme)
        copy_railsui_pages(@theme)

        # Copy Procfile for the correct mode
        copy_procfile

        # Copy bin/dev script
        copy_bin_dev

        # Run bundle install to ensure all gems are available
        say "Running bundle install...", :yellow
        run "bundle install"

        # migrate
        rails_command "db:migrate"

        # Build JavaScript if in build mode (after all packages are installed)
        if @build_mode == "build"
          say "Building JavaScript...", :yellow
          run "yarn build"
          say "✓ JavaScript built successfully", :green
        end

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
        say ""
        say "Next steps:", :cyan
        say "  1. Run: bin/dev", :cyan
        say "  2. Visit: http://localhost:3000/railsui", :cyan
        say ""
        say "📚 Documentation: https://railsui.com/docs"
      end
    end
  end
end
