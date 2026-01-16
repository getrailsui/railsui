# frozen_string_literal: true

require "fileutils"

module Railsui
  module ThemeSetup
    # gems
    def install_gems
      rails_command "generate railsui_icon:install"

      # Only install Action Text if not already installed
      unless action_text_installed?
        rails_command "action_text:install"
      else
        say "✓ Action Text already installed", :green
      end
    end

    def action_text_installed?
      # Check if Action Text migration exists
      migration_files = Dir.glob(Rails.root.join("db/migrate/*_create_action_text_tables*.rb"))
      return true if migration_files.any?

      # Check if table exists in database
      ActiveRecord::Base.connection.table_exists?('action_text_rich_texts')
    rescue
      false
    end

    # Assets
    def copy_theme_javascript(theme)
      config = Railsui::Configuration.load!

      if config.nobuild?
        copy_theme_javascript_nobuild(theme)
      else
        copy_theme_javascript_build(theme)
      end
    end

    def copy_theme_javascript_build(theme)
      say("Adding theme-specific stimulus.js controllers (build mode)", :yellow)

      # Define paths
      source_path = "themes/#{theme}/javascript/controllers/railsui"
      destination_path = "app/javascript/controllers/railsui"
      index_js_path = Rails.root.join("app/javascript/controllers/index.js")
      railsui_index_js_path = Rails.root.join("app/javascript/controllers/railsui/index.js")

      # Empty the railsui folder
      remove_dir destination_path
      empty_directory destination_path

      # Copy the directory
      directory source_path, destination_path, force: true

      # Get the list of controller files
      controller_files = Dir.children(Rails.root.join(destination_path)).select { |f| f.end_with?("_controller.js") }
      say("Controller files: 🗄️ #{controller_files}", :cyan)

      # Generate import and register statements for railsui/index.js
      railsui_index_content = controller_files.map do |file|
        controller_name = File.basename(file, ".js").sub("_controller", "")
        import_name = controller_name.camelize
        registration_name = controller_name.dasherize
        "import #{import_name}Controller from \"./#{File.basename(file, ".js")}\";\napplication.register(\"#{registration_name}\", #{import_name}Controller);"
      end.join("\n")

      js_content = <<-JAVASCRIPT.strip_heredoc
        import { RailsuiClipboard, RailsuiCountUp, RailsuiCombobox, RailsuiDateRangePicker, RailsuiDropdown, RailsuiModal, RailsuiRange, RailsuiReadMore,RailsuiSelectAll, RailsuiTabs, RailsuiToast, RailsuiToggle, RailsuiTooltip } from 'railsui-stimulus'

        application.register('railsui-clipboard', RailsuiClipboard)
        application.register('railsui-count-up', RailsuiCountUp)
        application.register('railsui-combobox', RailsuiCombobox)
        application.register('railsui-date-range-picker', RailsuiDateRangePicker)
        application.register('railsui-dropdown', RailsuiDropdown)
        application.register('railsui-modal', RailsuiModal)
        application.register('railsui-range', RailsuiRange)
        application.register('railsui-read-more', RailsuiReadMore)
        application.register('railsui-select-all', RailsuiSelectAll)
        application.register('railsui-tabs', RailsuiTabs)
        application.register('railsui-toast', RailsuiToast)
        application.register('railsui-toggle', RailsuiToggle)
        application.register('railsui-tooltip', RailsuiTooltip)
      JAVASCRIPT

      # Add js_content to railsui_index_content
      railsui_index_content += "\n\n#{js_content}"

      # Write the railsui/index.js file
      create_file railsui_index_js_path, "import { application } from \"../application\"\n\n#{railsui_index_content}",
                  force: true

      # Read the existing main index.js content
      index_js_content = File.exist?(index_js_path) ? File.read(index_js_path) : ""

      # Remove old import statements for railsui controllers
      new_index_js_content = index_js_content.gsub(%r{import .* from "\./railsui/.*";\n*}, "")

      # Add the new import statement for railsui/index.js if not already present
      new_index_js_content += "import \"./railsui\"\n" unless new_index_js_content.include?('import "./railsui"')

      # Write the updated content back to main index.js
      create_file index_js_path, new_index_js_content, force: true
      say("Updated app/javascript/controllers/index.js and created app/javascript/controllers/railsui/index.js successfully.", :green)
    end

    def copy_theme_javascript_nobuild(theme)
      say("Adding theme-specific stimulus.js controllers (importmap mode)", :yellow)

      # Define paths
      source_path = "themes/#{theme}/javascript/controllers/railsui"
      destination_path = "app/javascript/controllers/railsui"
      railsui_index_js_path = Rails.root.join("app/javascript/controllers/railsui/index.js")

      # Empty the railsui folder
      remove_dir destination_path
      empty_directory destination_path

      # Copy the directory
      directory source_path, destination_path, force: true

      # Get the list of controller files
      controller_files = Dir.children(Rails.root.join(destination_path)).select { |f| f.end_with?("_controller.js") }
      say("Controller files: 🗄️ #{controller_files}", :cyan)

      # Generate import and register statements for theme-specific controllers
      theme_controllers = controller_files.map do |file|
        controller_name = File.basename(file, ".js").sub("_controller", "")
        import_name = controller_name.camelize
        registration_name = controller_name.dasherize
        "import #{import_name}Controller from \"controllers/railsui/#{File.basename(file, ".js")}\"\napplication.register(\"#{registration_name}\", #{import_name}Controller)"
      end.join("\n")

      # Import railsui-stimulus components and register them
      js_content = <<-JAVASCRIPT.strip_heredoc
        import { application } from "controllers/application"
        import {
          RailsuiClipboard,
          RailsuiCountUp,
          RailsuiCombobox,
          RailsuiDateRangePicker,
          RailsuiDropdown,
          RailsuiModal,
          RailsuiRange,
          RailsuiReadMore,
          RailsuiSelectAll,
          RailsuiTabs,
          RailsuiToast,
          RailsuiToggle,
          RailsuiTooltip
        } from "railsui-stimulus"

        // Register railsui-stimulus components
        application.register("railsui-clipboard", RailsuiClipboard)
        application.register("railsui-count-up", RailsuiCountUp)
        application.register("railsui-combobox", RailsuiCombobox)
        application.register("railsui-date-range-picker", RailsuiDateRangePicker)
        application.register("railsui-dropdown", RailsuiDropdown)
        application.register("railsui-modal", RailsuiModal)
        application.register("railsui-range", RailsuiRange)
        application.register("railsui-read-more", RailsuiReadMore)
        application.register("railsui-select-all", RailsuiSelectAll)
        application.register("railsui-tabs", RailsuiTabs)
        application.register("railsui-toast", RailsuiToast)
        application.register("railsui-toggle", RailsuiToggle)
        application.register("railsui-tooltip", RailsuiTooltip)

        // Register theme-specific controllers
        #{theme_controllers}
      JAVASCRIPT

      # Write the railsui/index.js file
      create_file railsui_index_js_path, js_content, force: true

      # Update the main index.js to import railsui controllers
      index_js_path = Rails.root.join("app/javascript/controllers/index.js")
      if File.exist?(index_js_path)
        index_js_content = File.read(index_js_path)
        # Use absolute importmap path (importmap maps index.js to controllers/railsui without /index)
        unless index_js_content.include?('import "controllers/railsui"')
          # Remove old relative import if it exists
          index_js_content.gsub!(/import\s+["']\.\/railsui["']\s*\n?/, '')
          File.write(index_js_path, index_js_content)
          File.open(index_js_path, 'a') { |f| f.write("\nimport \"controllers/railsui\"\n") }
          say("✓ Added railsui import to controllers/index.js", :green)
        end
      end

      say("✅ Controllers configured for importmap mode", :green)
    end

    def copy_theme_stylesheets(theme)
      say("Copying theme-specific stylesheets", :yellow)

      # Define paths
      source_path = "themes/#{theme}/stylesheets/railsui"
      destination_path = "app/assets/stylesheets/railsui"

      # Use tailwindcss-rails v4 default path
      application_css_path = Rails.root.join("app/assets/tailwind/application.css")

      # Ensure the directory exists
      FileUtils.mkdir_p(application_css_path.dirname)

      # Create the file if it doesn't exist (in case tailwindcss:install failed)
      unless File.exist?(application_css_path)
        File.write(application_css_path, '@import "tailwindcss";')
        say "✓ Created #{application_css_path.relative_path_from(Rails.root)}", :green
      end

      # Empty the destination directory before copying
      FileUtils.rm_rf(Dir.glob("#{destination_path}/*"))

      # Copy the directory and overwrite if theme is modified
      directory source_path, destination_path, force: true

      # Get the list of stylesheet files
      stylesheet_files = Dir.children(Rails.root.join(destination_path)).select { |f| f.end_with?(".css") }
      puts "Stylesheet files: 🗄️ #{stylesheet_files}"

      # Generate import statements for stylesheets
      # Path is relative from app/assets/tailwind/ to app/assets/stylesheets/railsui/
      import_statements = stylesheet_files.map do |file|
        "@import \"../stylesheets/railsui/#{File.basename(file, ".css")}\";"
      end.join("\n")

      # Read the existing application.tailwind.css content
      application_css_content = File.exist?(application_css_path) ? File.read(application_css_path) : ""

      # Remove old import statements for tailwindcss and railsui stylesheets
      # BUT preserve actiontext import (core Rails ActionText CSS)
      cleaned_css_content = application_css_content
      cleaned_css_content = cleaned_css_content.gsub(/@import "tailwindcss";\n*/, "")
      cleaned_css_content = cleaned_css_content.gsub(%r{@import "\.\./stylesheets/railsui/.*";\n*}, "")
      cleaned_css_content = cleaned_css_content.gsub(%r{@import "railsui/.*";\n*}, "")
      cleaned_css_content = cleaned_css_content.gsub(%r{@import "\./railsui/.*";\n*}, "")

      # Extract and preserve actiontext import if it exists
      actiontext_import_match = cleaned_css_content.match(%r{@import ['"]\.\./stylesheets/actiontext['"];?\n*})
      cleaned_css_content = cleaned_css_content.gsub(%r{@import ['"]\.\./stylesheets/actiontext['"];?\n*}, "") if actiontext_import_match

      # Check if actiontext.css exists (from action_text:install)
      actiontext_css_path = Rails.root.join("app/assets/stylesheets/actiontext.css")
      actiontext_import = File.exist?(actiontext_css_path) ? '@import "../stylesheets/actiontext";' : nil

      # Add the new import statements in the correct order
      new_application_css_content = [
        '@import "tailwindcss";',
        actiontext_import,
        cleaned_css_content.strip, # Preserving existing content
        import_statements
      ].compact.join("\n")

      # Write the updated content back to application.tailwind.css
      File.write(application_css_path, new_application_css_content)
      say("Updated #{application_css_path.relative_path_from(Rails.root)} successfully.", :green)
    end

    # CSS Dependencies (unified for both build and nobuild modes)
    def install_css_dependencies
      say("Installing CSS dependencies (tailwindcss-rails)", :yellow)

      unless gem_installed?('tailwindcss-rails')
        say "tailwindcss-rails not found. Installing...", :green
        begin
          run "bundle add tailwindcss-rails"
        rescue => e
          say "❌ Failed to install tailwindcss-rails gem", :red
          say "Error: #{e.message}", :red
          say "Please install manually: bundle add tailwindcss-rails", :yellow
          raise
        end
      end

      # Create builds directory for tailwindcss-rails
      unless File.exist?(Rails.root.join("app/assets/builds/.keep"))
        say "Setting up Tailwind CSS...", :yellow
        FileUtils.mkdir_p(Rails.root.join("app/assets/builds"))
        FileUtils.touch(Rails.root.join("app/assets/builds/.keep"))
        say "✓ Tailwind CSS configured", :green
      end
    end

    # JS Dependencies for build mode (existing behavior)
    def install_js_dependencies_build(theme)
      say("Installing JS dependencies via package manager", :yellow)

      # Fix application.js imports for bundler (convert importmap style to bundler style)
      fix_application_js_for_bundler

      # Install theme-specific packages
      add_yarn_packages(js_theme_dependencies(theme))
    end

    def fix_application_js_for_bundler
      app_js = Rails.root.join("app/javascript/application.js")
      return unless File.exist?(app_js)

      content = File.read(app_js)
      original = content.dup

      # Fix relative imports
      content.gsub!('import "controllers"', 'import "./controllers"')

      File.write(app_js, content) if content != original
    end

    # JS Dependencies for nobuild mode (importmap)
    def install_js_dependencies_nobuild(theme)
      say("Installing JS dependencies via importmap", :yellow)

      # Check if importmap-rails gem is installed
      unless gem_installed?('importmap-rails')
        say "📦 importmap-rails not found. Installing...", :green
        begin
          run "bundle add importmap-rails"
        rescue => e
          say "❌ Failed to install importmap-rails gem", :red
          say "Error: #{e.message}", :red
          say "Please install manually: bundle add importmap-rails", :yellow
          raise
        end
      end

      # Only run importmap:install if importmap.rb doesn't exist
      # (Rails 8 apps already have it configured)
      unless File.exist?(Rails.root.join("config/importmap.rb"))
        begin
          rails_command "importmap:install"
        rescue => e
          say "❌ Failed to run importmap:install", :red
          say "Error: #{e.message}", :red
          say "Please run manually: rails importmap:install", :yellow
          raise
        end
      end

      pin_importmap_dependencies(theme)
    end

    # Legacy method for backward compatibility
    def install_theme_dependencies(theme)
      install_js_dependencies_build(theme)
    end

    def remove_action_text_defaults
      # This method is kept for backwards compatibility but no longer needed
      # ActionText CSS import is now handled in copy_theme_stylesheets
    end

    def humanize_theme(theme)
      theme.humanize
    end

    # JS-only dependencies (Tailwind v4 plugins handled by standalone binary via @plugin directive)
    def js_theme_dependencies(theme)
      case theme
      when "hound"
        ["apexcharts", "railsui-stimulus", "stimulus-use", "tippy.js"]
      when "shepherd"
        ["apexcharts", "flatpickr", "hotkeys-js", "photoswipe", "railsui-stimulus", "stimulus-use", "tippy.js"]
      when "corgie"
        ["railsui-stimulus", "stimulus-use", "tippy.js", "marked", "highlight.js", "sanitize-html"]
      else
        ["railsui-stimulus", "stimulus-use", "tippy.js"]
      end
    end

    # Legacy method for backward compatibility
    def theme_dependencies(theme)
      js_theme_dependencies(theme)
    end

    # Importmap pins for nobuild mode
    def importmap_theme_dependencies(theme)
      # Core railsui-stimulus dependencies (required for all themes)
      # Note: @hotwired/stimulus is already provided by Rails, so we don't pin it
      # Using esm.sh CDN which provides optimized ESM builds without process.env references
      base_pins = {
        "railsui-stimulus" => "https://unpkg.com/railsui-stimulus@1.1.2/dist/importmap/index.js",
        "tippy.js" => "https://esm.sh/tippy.js@6.3.7",
        "@popperjs/core" => "https://esm.sh/@popperjs/core@2.11.8",
        "stimulus-use" => "https://esm.sh/stimulus-use@0.52.2",
        "flatpickr" => "https://esm.sh/flatpickr@4.6.13"
      }

      # Theme-specific dependencies
      theme_specific = case theme
      when "hound"
        {
          "apexcharts" => "https://esm.sh/apexcharts@3.45.2"
        }
      when "shepherd"
        {
          "apexcharts" => "https://esm.sh/apexcharts@3.45.2",
          "hotkeys-js" => "https://esm.sh/hotkeys-js@3.13.15",
          "photoswipe" => "https://esm.sh/photoswipe@5.4.3",
          "photoswipe/lightbox" => "https://esm.sh/photoswipe@5.4.3/lightbox"
        }
      when "corgie"
        {
          "marked" => "https://esm.sh/marked@11.1.1",
          "highlight.js" => "https://esm.sh/highlight.js@11.9.0",
          "sanitize-html" => "https://esm.sh/sanitize-html@2.11.0"
        }
      else
        {}
      end

      base_pins.merge(theme_specific)
    end

    def pin_importmap_dependencies(theme)
      importmap_file = Rails.root.join("config/importmap.rb")
      return unless File.exist?(importmap_file)

      importmap_content = File.read(importmap_file)

      say "Pinning Rails UI dependencies to importmap...", :yellow

      # Pin external theme dependencies (railsui-stimulus, tippy.js, etc.)
      importmap_theme_dependencies(theme).each do |package, url|
        pin_statement = "pin \"#{package}\", to: \"#{url}\"\n"
        unless importmap_content.include?("pin \"#{package}\"")
          File.open(importmap_file, 'a') { |f| f.write(pin_statement) }
          say "✓ Pinned #{package}", :green
        else
          say "- #{package} already pinned", :cyan
        end
      end

      # Note: Gem's internal controllers are NOT pinned to importmap because:
      # - They're only used on /railsui/* routes (gem's internal pages)
      # - Those pages use CDN dependencies loaded inline via _cdn_dependencies.html.erb
      # - User-installed theme pages (/rui/*) use theme-specific controllers from app/javascript/controllers/railsui/

      say "✅ All importmap dependencies pinned successfully!", :green
    end

    def gem_controllers_dependencies
      # Map import names to propshaft-served paths for gem controllers
      {
        "controllers/railsui/index" => "controllers/railsui/index.js",
        "controllers/railsui/application" => "controllers/application.js",
        "controllers/railsui_anchor_controller" => "controllers/railsui_anchor_controller.js",
        "controllers/railsui_configuration_controller" => "controllers/railsui_configuration_controller.js",
        "controllers/railsui_code_controller" => "controllers/railsui_code_controller.js",
        "controllers/railsui_canvas_controller" => "controllers/railsui_canvas_controller.js",
        "controllers/railsui_dialog_controller" => "controllers/railsui_dialog_controller.js",
        "controllers/railsui_flash_controller" => "controllers/railsui_flash_controller.js",
        "controllers/railsui_helper_controller" => "controllers/railsui_helper_controller.js",
        "controllers/railsui_nav_controller" => "controllers/railsui_nav_controller.js",
        "controllers/railsui_prevent_controller" => "controllers/railsui_prevent_controller.js",
        "controllers/railsui_scroll_controller" => "controllers/railsui_scroll_controller.js",
        "controllers/railsui_scroll_spy_controller" => "controllers/railsui_scroll_spy_controller.js",
        "controllers/railsui_search_controller" => "controllers/railsui_search_controller.js",
        "controllers/railsui_smooth_controller" => "controllers/railsui_smooth_controller.js",
        "controllers/railsui_snippet_controller" => "controllers/railsui_snippet_controller.js",
        "controllers/railsui_pages_controller" => "controllers/railsui_pages_controller.js",
        "controllers/railsui_loading_controller" => "controllers/railsui_loading_controller.js"
      }
    end

    def add_yarn_packages(packages)
      package_manager = detect_package_manager
      say "Using #{package_manager} to install packages...", :green

      begin
        case package_manager
        when "yarn"
          run "yarn add #{packages.join(" ")}"
        when "npm"
          run "npm install #{packages.join(" ")}"
        when "pnpm"
          run "pnpm add #{packages.join(" ")}"
        when "bun"
          run "bun add #{packages.join(" ")}"
        else
          # Fallback to yarn if no package manager detected
          say "⚠️  No package manager detected, falling back to yarn", :yellow
          run "yarn add #{packages.join(" ")}"
        end
        say "✅ Installed packages: #{packages.join(', ')}", :green
      rescue => e
        say "❌ Failed to install JavaScript packages", :red
        say "Error: #{e.message}", :red
        say "Please install manually:", :yellow
        say "  #{package_manager} add #{packages.join(' ')}", :yellow
        raise
      end
    end

    def detect_package_manager
      # Check for lock files in order of preference
      if File.exist?(Rails.root.join("yarn.lock"))
        "yarn"
      elsif File.exist?(Rails.root.join("package-lock.json"))
        "npm"
      elsif File.exist?(Rails.root.join("pnpm-lock.yaml"))
        "pnpm"
      elsif File.exist?(Rails.root.join("bun.lockb"))
        "bun"
      elsif File.exist?(Rails.root.join("package.json"))
        # Check for package.json to determine if we should use npm as default
        "npm" # Default to npm if package.json exists but no lock file
      else
        "yarn" # Fallback to yarn
      end
    end

    def detect_js_bundler
      # Check for bundler configs first (since Rails 8 apps have importmap.rb by default)
      # Check package.json for build script as primary indicator
      package_json = Rails.root.join("package.json")
      if File.exist?(package_json)
        content = File.read(package_json)
        data = JSON.parse(content) rescue {}
        build_script = data.dig("scripts", "build").to_s

        return "esbuild" if build_script.include?("esbuild")
        return "webpack" if build_script.include?("webpack")
        return "rollup" if build_script.include?("rollup")
        return "bun" if build_script.include?("bun")
      end

      # Fall back to config file detection
      if File.exist?(Rails.root.join("esbuild.config.js")) || File.exist?(Rails.root.join("esbuild.config.mjs"))
        "esbuild"
      elsif File.exist?(Rails.root.join("webpack.config.js"))
        "webpack"
      elsif File.exist?(Rails.root.join("rollup.config.js"))
        "rollup"
      elsif File.exist?(Rails.root.join("bun.lockb"))
        "bun"
      elsif File.exist?(Rails.root.join("config/importmap.rb"))
        "importmap"
      else
        "unknown"
      end
    end

    def gem_installed?(gem_name)
      Gem::Specification.find_by_name(gem_name)
      true
    rescue Gem::LoadError
      false
    end

    def detect_and_warn_about_setup
      warnings = []
      recommendations = []

      # Check for existing setup
      has_cssbundling = gem_installed?('cssbundling-rails')
      has_jsbundling = gem_installed?('jsbundling-rails')
      has_importmap = File.exist?(Rails.root.join("config/importmap.rb"))

      # Check for Tailwind in package.json
      has_tailwind_npm = false
      package_json_path = Rails.root.join("package.json")
      if File.exist?(package_json_path)
        package_json = JSON.parse(File.read(package_json_path))
        has_tailwind_npm = package_json.dig('dependencies', 'tailwindcss') ||
                           package_json.dig('devDependencies', 'tailwindcss')
      end

      # Detect legacy build mode setup (cssbundling + jsbundling)
      legacy_build_setup = (has_cssbundling || has_tailwind_npm) && has_jsbundling

      if legacy_build_setup && !options[:build]
        say ""
        say "=" * 70, :red
        say "❌ Build mode setup detected but --build flag not provided", :red
        say "=" * 70, :red
        say ""
        say "Your app uses build mode (cssbundling + jsbundling).", :yellow
        say "You must choose a mode before installing:", :yellow
        say ""
        say "Keep build mode (recommended):", :cyan
        say "  rails railsui:install --build", :cyan
        say "  rails railsui:migrate_to_tailwindcss_rails", :cyan
        say ""
        say "Or switch to no-build (requires manual JS refactoring):", :cyan
        say "  bundle add importmap-rails && rails importmap:install", :cyan
        say "  rails railsui:install", :cyan
        say ""
        exit(1)
      elsif has_cssbundling && !has_jsbundling
        warnings << "⚠️  Detected cssbundling-rails gem"
        recommendations << "After install, migrate to tailwindcss-rails:"
        recommendations << "  rails railsui:migrate_to_tailwindcss_rails"
      elsif has_jsbundling && !has_importmap && !options[:build]
        say ""
        say "=" * 70, :red
        say "❌ jsbundling-rails detected but --build flag not provided", :red
        say "=" * 70, :red
        say ""
        say "Your app has jsbundling-rails installed.", :yellow
        say "You must choose a mode before installing:", :yellow
        say ""
        say "Use JS bundler (recommended): rails railsui:install --build", :cyan
        say ""
        say "Or switch to importmap (requires manual JS refactoring):", :cyan
        say "  bundle add importmap-rails && rails importmap:install", :cyan
        say "  rails railsui:install", :cyan
        say ""
        exit(1)
      end

      # Inform about coexisting importmap when using build mode
      if options[:build] && has_importmap && bundler != "importmap"
        warnings << "ℹ️  Both importmap.rb and JS bundler detected"
        recommendations << "Rails UI will install packages for the bundler and migrate imports"
        recommendations << "It's recommended to use the bundler format rather than mixing both"
        recommendations << "You can remove config/importmap.rb if you don't need it"
        recommendations << ""
        recommendations << "Note: You may see build errors during installation - these will be"
        recommendations << "resolved as Rails UI installs the required packages"
      end

      if !has_jsbundling && !has_importmap
        warnings << "ℹ️  No JS bundler or importmap detected"
        if options[:build]
          recommendations << "Please install a JS bundler first:"
          recommendations << "  bundle add jsbundling-rails"
          recommendations << "  rails javascript:install:[bun|esbuild|rollup|webpack]"
          recommendations << "Then run: rails railsui:install --build"
        else
          recommendations << "Will install importmap-rails for you (Rails 8 default)"
        end
      end

      # Display warnings
      if warnings.any?
        say ""
        say "=" * 60, :yellow
        warnings.each { |w| say w, :yellow }
        say "=" * 60, :yellow
        say ""
        if recommendations.any?
          say "Recommendations:", :cyan
          recommendations.each { |r| say "  #{r}", :cyan }
          say ""
        end

        unless ENV['RAILSUI_SKIP_WARNINGS']
          print "Continue with installation? (y/n): "
          response = STDIN.gets.chomp.downcase
          unless response == 'y'
            say "Installation cancelled", :red
            exit
          end
          say ""
        end
      end
    end

    # Mailers
    def generate_sample_mailers(theme)
      say "Adding Rails UI mailers", :yellow

      rails_command "generate mailer Railsui minimal promotion transactional"

      combined_mailer_setup = <<-RUBY
  layout "rui/railsui_mailer"
  helper :application
      RUBY

      insert_into_file Rails.root.join("app/mailers/railsui_mailer.rb").to_s, combined_mailer_setup,
                       after: "class RailsuiMailer < ApplicationMailer\n"

      copy_sample_mailers(theme)
    end

    def copy_sample_mailers(theme)
      source_directory = "themes/#{theme}/mail/railsui_mailer"
      destination_directory = Rails.root.join("app/views/railsui_mailer")
      directory source_directory, destination_directory, force: true
    end

    def update_railsui_mailer_layout(theme)
      source_file = Rails.root.join("app/views/layouts/rui/railsui_mailer.html.erb")
      remove_file source_file if File.exist?(source_file)

      copy_file "themes/#{theme}/views/layouts/rui/railsui_mailer.html.erb", source_file, force: true
    end

    def update_application_helper
      content = <<-RUBY
  def spacer(amount = 16)
    render "rui/shared/email_spacer", amount: amount
  end

  def email_action(action, url, options={})
    align = options[:align] ||= "left"
    theme = options[:theme] ||= "primary"
    fullwidth = options[:fullwidth] ||= false
    render "rui/shared/email_action", align: align, theme: theme, action: action, url: url, fullwidth: fullwidth
  end

  def email_callout(&block)
    render "rui/shared/email_callout", block: block
  end
      RUBY

      insert_into_file "#{Rails.root}/app/helpers/application_helper.rb", content, after: "module ApplicationHelper\n"
    end

    # Routes
    def copy_railsui_routes
      routes_file = "#{Rails.root}/config/routes.rb"
      route_content = File.read(routes_file)

      content = <<-RUBY
  if Rails.env.development?
     # Visit the start page for Rails UI any time at /railsui/start
    mount Railsui::Engine, at: "/railsui"
  end

      RUBY

      # Check if a root route already exists
      unless route_content.match?(/^\s*root\s+/)
        content += <<-RUBY
  # Inherits from Railsui::PageController#index
  # To override, add your own page#index view or change to a new root
  root action: :index, controller: "railsui/default"
        RUBY
      end

      insert_into_file routes_file, "\n#{content}\n", after: "Rails.application.routes.draw do\n", force: true
    end

    def copy_railsui_pages_routes
      routes_file = Rails.root.join("config/routes.rb")

      # Define the regex pattern for the `rui` namespace block
      namespace_pattern = /^\s*namespace :rui do.*?end\n/m

      # Generate new routes content based on the active pages
      new_routes = Railsui::Pages.theme_pages.keys.map do |page|
        "    get \"#{page}\", to: \"pages##{page}\""
      end.join("\n")

      # Define the routes block to be inserted within the namespace
      routes_block = "\n  namespace :rui do\n#{new_routes}\n  end\n"

      # Read the current content of the routes file
      route_content = File.read(routes_file)

      # Remove the existing `rui` namespace block if present
      updated_content = route_content.gsub(namespace_pattern, "")

      # Append the new routes block after the initial `Rails.application.routes.draw do` line
      updated_content.sub!("Rails.application.routes.draw do\n", "Rails.application.routes.draw do\n#{routes_block}")

      # Write the updated content back to the routes file
      File.write(routes_file, updated_content)
    end

    # Pages
    def copy_railsui_page_controller(_theme)
      copy_file "controllers/pages_controller.rb", "app/controllers/rui/pages_controller.rb", force: true
    end

    def copy_railsui_pages(theme)
      # Copy Pages
      directory "themes/#{theme}/views/rui", "app/views/rui", force: true

      # Copy layouts
      directory "themes/#{theme}/views/layouts/rui", "app/views/layouts/rui", force: true
    end

    def copy_railsui_head(_theme)
      layout_file = "app/views/layouts/application.html.erb"
      return unless File.exist?(layout_file)

      return if File.read(layout_file).include?("<%= railsui_head %>")

      content = <<-ERB
    <%= railsui_head %>
      ERB
      insert_into_file layout_file, "\n#{content}", before: "</head>"
    end

    def copy_railsui_launcher(_theme)
      layout_file = "app/views/layouts/application.html.erb"
      return unless File.exist?(layout_file)

      return if File.read(layout_file).include?("<%= railsui_launcher if Rails.env.development? %>")

      content = <<-ERB
    <%= railsui_launcher if Rails.env.development? %>
      ERB
      insert_into_file layout_file, "\n#{content}", before: "</body>"
    end

    def copy_railsui_images(theme)
      # Define paths
      theme_images_dir = "themes/#{theme}/images/railsui"
      target_images_dir = Rails.root.join("app/assets/images/railsui")

      # Remove existing target directory
      remove_directory(target_images_dir, "images")
      # add new images based on theme passed
      directory theme_images_dir, target_images_dir, force: true
    end

    def copy_procfile
      config = Railsui::Configuration.load!
      procfile_path = Rails.root.join("Procfile.dev")

      if config.build?
        # In build mode, jsbundling-rails already created the Procfile
        # We just need to add the CSS line if it's not already there
        if File.exist?(procfile_path)
          content = File.read(procfile_path)
          unless content.include?("tailwindcss:watch")
            File.open(procfile_path, "a") do |f|
              f.puts "css: bin/rails tailwindcss:watch"
            end
            say("Added CSS watch to existing Procfile.dev", :green)
          else
            say("✓ Procfile.dev already has CSS watch (skipping)", :yellow)
          end
        else
          # Fallback if Procfile doesn't exist (shouldn't happen with jsbundling-rails)
          copy_file "Procfile.dev.build", procfile_path
          say("Created Procfile.dev for build mode", :green)
        end
      else
        # In nobuild mode, ensure required processes exist without being destructive
        if File.exist?(procfile_path)
          content = File.read(procfile_path)
          lines_to_add = []

          # Check for web process
          unless content.match?(/^web:/)
            lines_to_add << "web: bin/rails server -p 3000"
          end

          # Check for CSS process
          unless content.include?("tailwindcss:watch")
            lines_to_add << "css: bin/rails tailwindcss:watch"
          end

          if lines_to_add.any?
            File.open(procfile_path, "a") do |f|
              lines_to_add.each { |line| f.puts line }
            end
            say("Added missing processes to Procfile.dev: #{lines_to_add.join(', ')}", :green)
          else
            say("✓ Procfile.dev already has required processes (skipping)", :yellow)
          end
        else
          # No Procfile exists, create it
          copy_file "Procfile.dev.nobuild", procfile_path
          say("Created Procfile.dev for no-build mode", :green)
        end
      end
    end

    def copy_bin_dev
      bin_dev_path = Rails.root.join("bin/dev")

      # Only copy if it doesn't exist or if it's the simple Rails server version
      if !File.exist?(bin_dev_path) || File.read(bin_dev_path).include?('exec "./bin/rails", "server"')
        copy_file "bin/dev", bin_dev_path, force: true
        chmod bin_dev_path, 0755
        say("Created bin/dev script", :green)
      else
        say("✓ bin/dev already exists (skipping)", :yellow)
      end
    end

    private

    def remove_directory(directory_path, thing)
      if Dir.exist?(directory_path)
        FileUtils.rm_rf(directory_path)
        say("Removed existing #{thing} in #{directory_path}")
      end
    rescue StandardError => e
      say("Error removing directory #{directory_path}: #{e.message}", :red)
      raise e
    end

    def remove_route(file, page)
      # Read the current content of the routes file
      route_content = File.read(file)

      # Remove route associated with railsui/pages#<page>
      route_content.gsub!(%r{^\s*get\s+'#{page}',\s+to:\s+'railsui/pages##{page}'\s*$}, "")

      # Write the updated content back to the file
      File.write(file, route_content)
    end
  end
end
