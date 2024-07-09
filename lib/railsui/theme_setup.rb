require 'fileutils'

module Railsui
  module ThemeSetup

    def install_theme_dependencies(theme)
      say("Installing dependencies", :yellow)
      add_yarn_packages(theme_dependencies(theme))
    end

    def generate_sample_mailers(theme)
      say "Adding Rails UI mailers", :yellow

      rails_command "generate mailer Railsui minimal promotion transactional"

      copy_sample_mailers(theme)

      insert_into_file Rails.root.join("app/mailers/railsui_mailer.rb").to_s, '  layout "railsui/railsui_mailer"', after: "class RailsuiMailer < ApplicationMailer\n"
    end

    def copy_sample_mailers(theme)
      source_directory = "themes/#{theme}/mail/railsui_mailer"
      destination_directory = Rails.root.join("app/views/railsui_mailer")
      directory source_directory, destination_directory, force: true
    end

    def update_railsui_mailer_layout(theme)
      source_file = Rails.root.join('app/views/layouts/railsui/railsui_mailer.html.erb')
      if File.exist?(source_file)
        remove_file source_file
      end

      copy_file "themes/#{theme}/views/layouts/railsui/railsui_mailer.html.erb", source_file, force: true
    end

    def update_application_mailer
      content = <<-RUBY.strip_heredoc
      helper Railsui::MailHelper
      RUBY

      insert_into_file "#{Rails.root}/app/mailers/application_mailer.rb", "  #{content}\n", after: "class ApplicationMailer < ActionMailer::Base\n"
    end

    def install_action_text
      rails_command "action_text:install"
    end

    def copy_railsui_routes
  content = <<-RUBY
  if Rails.env.development?
    mount Railsui::Engine, at: "/railsui"
  end

  # Inherits from Railsui::PageController#index
  # To overide, add your own page#index view or change to a new root
  # Visit the start page for Rails UI any time at /railsui/start
  root action: :index, controller: "railsui/default"
  RUBY

      insert_into_file "#{Rails.root}/config/routes.rb", "\n#{content}\n", after: "Rails.application.routes.draw do\n"
    end

    def copy_railsui_pages_routes
      # Path to the routes file
      routes_file = Rails.root.join('config/routes.rb')

      # Read the current content of the routes file
      route_content = File.read(routes_file)

      # Remove existing routes associated with railsui/pages
      existing_routes = route_content.scan(/^\s*get\s+'(\w+)',\s+to:\s+'railsui\/pages#(\w+)'/)

      if existing_routes.any?
        existing_routes.each do |route|
          remove_route(routes_file, route[0])
        end
      end

      # Generate new routes content based on the active pages with proper indentation
      new_routes = Railsui.config.pages.map do |page|
        "  get '#{page}', to: 'railsui/pages##{page}'"
      end.join("\n")

      # Define the routes block to be inserted
      routes_block = "\n#{new_routes}\n"

      # Insert the routes block into the routes file
      insert_into_file(routes_file, routes_block, after: "Rails.application.routes.draw do\n")
    end

    def copy_railsui_page_controller(theme)
      copy_file "themes/#{theme}/controllers/railsui/pages_controller.rb", "app/controllers/railsui/pages_controller.rb", force: true
    end

    def copy_railsui_pages(theme)
      Railsui::Pages.theme_pages.each do | page, details |
        if Railsui::Pages.page_enabled?(page) && !Railsui::Pages.page_exists?(page)
          copy_file "themes/#{theme}/views/railsui/pages/#{page}.html.erb", "app/views/railsui/pages/#{page}.html.erb", force: true
        end
      end

      copy_file "themes/#{theme}/views/layouts/railsui/railsui.html.erb", "app/views/layouts/railsui/railsui.html.erb", force: true
    end

    def update_body_classes
      layout_file = Rails.root.join("app/views/layouts/application.html.erb")

      if File.exist?(layout_file)
        # Read the entire layout file
        layout_content = File.read(layout_file)

        # Check if the body tag already has the helper
        if layout_content.include?('<%= railsui_body_classes %>')
          say("Body classes helper already added.", :yellow)
        else
          # Append the railsui_body_classes helper to the body tag
          updated_content = layout_content.gsub(
            /<body([^>]*)class="([^"]*)"/,
            '<body\1class="\2 <%= railsui_body_classes %>"'
          )

          # Write the updated content back to the layout file
          File.open(layout_file, "w") { |file| file.write(updated_content) }

          say("Body classes updated successfully.", :yellow)
        end
      else
        say("Layout file not found!", :red)
      end
    end

    def copy_railsui_head(theme)
      layout_file = "app/views/layouts/application.html.erb"
      return unless File.exist?(layout_file)

      unless File.read(layout_file).include?('<%= railsui_head %>')
    content = <<-ERB
    <%= railsui_head %>
    ERB
        insert_into_file layout_file, "\n#{content}", before: '</head>'
      end
    end

    def copy_railsui_launcher(theme)
      layout_file = "app/views/layouts/application.html.erb"
      return unless File.exist?(layout_file)

      unless File.read(layout_file).include?('<%= railsui_launcher if Rails.env.development? %>')
    content = <<-ERB
    <%= railsui_launcher if Rails.env.development? %>
    ERB
        insert_into_file layout_file, "\n#{content}", before: '</body>'
      end
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

    def copy_railsui_shared_directory(theme)
      theme_dir = "themes/#{theme}/views/railsui/shared"
      target_dir = Rails.root.join("app/views/railsui/shared")

      remove_directory(target_dir, "shared views")
      directory theme_dir, target_dir, force: true
    end

    def setup_stimulus(theme)
      say("Setting up Stimulus controllers", :yellow)
      insert_stimulus_controllers
    end

    def update_tailwind_config(theme)
      say("Updating Tailwind CSS configuration", :yellow)
      copy_tailwind_config(theme)
    end

    def humanize_theme(theme)
      theme.humanize
    end

    def theme_dependencies(theme)
      case theme
      when "hound"
        ["tailwindcss", "postcss", "autoprefixer", "postcss-import", "postcss-nesting", "@tailwindcss/forms", "@tailwindcss/typography", "stimulus-use", "tippy.js", "tailwind-scrollbar", "railsui-stimulus"]
      when "shepherd"
        ["tailwindcss", "postcss", "autoprefixer", "postcss-import", "postcss-nesting", "@tailwindcss/forms", "@tailwindcss/typography", "stimulus-use", "tippy.js", "flatpickr", "hotkeys-js", "photoswipe", "apexcharts", "railsui-stimulus"]
      when "retriever"
        ["tailwindcss", "postcss", "autoprefixer", "postcss-import", "postcss-nesting", "@tailwindcss/forms", "@tailwindcss/typography", "stimulus-use", "tippy.js", "flatpickr", "apexcharts", "tailwind-scrollbar", "railsui-stimulus"]
      when "setter"
        ["tailwindcss", "postcss", "autoprefixer", "postcss-import", "postcss-nesting", "@tailwindcss/forms", "@tailwindcss/typography", "stimulus-use", "tippy.js", "tailwind-scrollbar", "railsui-stimulus"]
      else
        ["tailwindcss", "postcss", "autoprefixer", "postcss-import", "postcss-nesting", "@tailwindcss/forms", "@tailwindcss/typography", "stimulus-use", "tippy.js", "tailwind-scrollbar", "railsui-stimulus"]
      end
    end

    def add_yarn_packages(packages)
      run "yarn add #{packages.join(' ')} --latest"
    end

    def insert_stimulus_controllers
      js_content = <<-JAVASCRIPT.strip_heredoc
        import { RailsuiClipboard, RailsuiCountUp, RailsuiDateRangePicker, RailsuiDropdown, RailsuiModal, RailsuiTabs, RailsuiToast, RailsuiToggle, RailsuiTooltip } from 'railsui-stimulus'

        application.register('railsui-clipboard', RailsuiClipboard)
        application.register('railsui-count-up', RailsuiCountUp)
        application.register('railsui-date-range-picker', RailsuiDateRangePicker)
        application.register('railsui-dropdown', RailsuiDropdown)
        application.register('railsui-modal', RailsuiModal)
        application.register('railsui-tabs', RailsuiTabs)
        application.register('railsui-toast', RailsuiToast)
        application.register('railsui-toggle', RailsuiToggle)
        application.register('railsui-tooltip', RailsuiTooltip)
      JAVASCRIPT

      insert_into_file "#{Rails.root}/app/javascript/controllers/index.js", "\n#{js_content}", after: 'import { application } from "./application"'
    end

    def copy_tailwind_config(theme)
      tailwind_config_path = Rails.root.join("tailwind.config.js")
      tailwind_preset = Rails.root.join("railsui.#{theme}.preset.js")

      # Remove existing theme preset if present
      if File.exist?(tailwind_preset)
        say "Removing existing theme preset"
        remove_file tailwind_preset
      end

      # Copy theme preset
      copy_file "themes/#{theme}/railsui.#{theme}.preset.js", Rails.root.join("railsui.#{theme}.preset.js")

      if File.exist?(tailwind_config_path)
        tailwind_setup = <<-JAVASCRIPT.strip_heredoc
          const execSync = require("child_process").execSync
          const outputRailsUI = execSync("bundle show railsui", { encoding: "utf-8" })
          const rails_ui_path = outputRailsUI.trim() + "/**/*.rb"
          const rails_ui_template_path = outputRailsUI.trim() + "/**/*.html.erb"
        JAVASCRIPT

        tailwind_preset_content = <<-JAVASCRIPT.strip_heredoc
            presets: [require("./railsui.#{theme}.preset.js")],
        JAVASCRIPT

        # Insert the setup vars at the top of the file
        unless File.read(tailwind_config_path).include?(tailwind_setup)
          say "Adding setup variables...", :green
          insert_into_file tailwind_config_path.to_s, tailwind_setup + "\n", before: "module.exports = {"
        end

        # Insert the preset require statement after "module.exports = {"
        unless File.read(tailwind_config_path).include?(tailwind_preset_content)
          say "Adding preset require statement...", :green
          insert_into_file tailwind_config_path.to_s, "\n  #{tailwind_preset_content}", after: "module.exports = {"
        end

        # Update the content array
        new_content_paths = ["./app/components/**/*.html.erb","./app/components/**/*.rb", "./app/helpers/**/*.rb", "./app/javascript/**/*.js", "./app/views/**/*.html.erb"]

        new_content_paths.each_with_index do |path, index|
          unless File.read(tailwind_config_path).include?(path)
            say "Adding content path #{path}...", :green
            if index == new_content_paths.length - 1
              insert_into_file tailwind_config_path.to_s, "    '#{path}'\n", after: "content: [\n"
            else
              insert_into_file tailwind_config_path.to_s, "    '#{path}',\n", after: "content: [\n"
            end
          end
        end

    tailwind_variables = <<-JAVASCRIPT
    rails_ui_path,
    rails_ui_template_path,
    JAVASCRIPT

        insert_into_file tailwind_config_path.to_s, tailwind_variables, after: "content: [\n"
      else
        say("No tailwind.config.js file. Creating one...", :yellow)
        copy_file "themes/#{theme}/tailwind.config.js", tailwind_config_path, force: true
      end
    end

    private


    def remove_directory(directory_path, thing)
      if Dir.exist?(directory_path)
        FileUtils.rm_rf(directory_path)
        say("Removed existing #{thing} in #{directory_path}")
      end
    rescue => e
      say("Error removing directory #{directory_path}: #{e.message}", :red)
      raise e
    end

    def remove_route(file, page)
      # Read the current content of the routes file
      route_content = File.read(file)

      # Remove route associated with railsui/pages#<page>
      route_content.gsub!(/^\s*get\s+'#{page}',\s+to:\s+'railsui\/pages##{page}'\s*$/, '')

      # Write the updated content back to the file
      File.open(file, 'w') { |f| f.write(route_content) }
    end
  end
end
