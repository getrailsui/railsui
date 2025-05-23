# frozen_string_literal: true

require 'fileutils'

module Railsui
  module ThemeSetup
    # gems
    def install_gems
      rails_command "generate railsui_icon:install"
      rails_command "action_text:install"
    end

    # Assets
    def copy_theme_javascript(theme)
      say("Adding theme-specific stimulus.js controllers", :yellow)

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
        "import #{import_name}Controller from \"./#{File.basename(file, '.js')}\";\napplication.register(\"#{registration_name}\", #{import_name}Controller);"
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
      create_file railsui_index_js_path, "import { application } from \"../application\"\n\n#{railsui_index_content}", force: true

      # Read the existing main index.js content
      index_js_content = File.exist?(index_js_path) ? File.read(index_js_path) : ""

      # Remove old import statements for railsui controllers
      new_index_js_content = index_js_content.gsub(/import .* from "\.\/railsui\/.*";\n*/, "")

      # Add the new import statement for railsui/index.js if not already present
      unless new_index_js_content.include?('import "./railsui"')
        new_index_js_content += "import \"./railsui\"\n"
      end

      # Write the updated content back to main index.js
      create_file index_js_path, new_index_js_content, force: true
      say("Updated app/javascript/controllers/index.js and created app/javascript/controllers/railsui/index.js successfully.", :green)
    end

   def copy_theme_stylesheets(theme)
      say("Copying theme-specific stylesheets", :yellow)

      # Define paths
      source_path = "themes/#{theme}/stylesheets/railsui"
      destination_path = "app/assets/stylesheets/railsui"
      application_css_path = Rails.root.join("app/assets/stylesheets/application.tailwind.css")

      # Empty the destination directory before copying
      FileUtils.rm_rf(Dir.glob("#{destination_path}/*"))

      # Copy the directory and overwrite if theme is modified
      directory source_path, destination_path, force: true

      # Get the list of stylesheet files
      stylesheet_files = Dir.children(Rails.root.join(destination_path)).select { |f| f.end_with?(".css") }
      puts "Stylesheet files: 🗄️ #{stylesheet_files}"

      # Generate import statements for stylesheets
      import_statements = stylesheet_files.map do |file|
        "@import \"../stylesheets/railsui/#{File.basename(file, '.css')}\";"
      end.join("\n")

      # Read the existing application.tailwind.css content
      application_css_content = File.exist?(application_css_path) ? File.read(application_css_path) : ""

      # Remove old @tailwind directives and import statements for tailwindcss and railsui stylesheets
      cleaned_css_content = application_css_content
      cleaned_css_content = cleaned_css_content.gsub(/@import "tailwindcss";\n*/, "")
      cleaned_css_content = cleaned_css_content.gsub(/@import "\.\.\/stylesheets\/railsui\/.*";\n*/, "")

      # Add the new import statements in the correct order
      new_application_css_content = [
        '@import "tailwindcss";',
        cleaned_css_content.strip,  # Preserving existing content
        import_statements
      ].join("\n")

      # Write the updated content back to application.tailwind.css
      File.write(application_css_path, new_application_css_content)
      say("Updated app/assets/stylesheets/application.tailwind.css successfully.", :green)
    end

    def install_theme_dependencies(theme)
      say("Installing dependencies", :yellow)
      add_yarn_packages(theme_dependencies(theme))
    end


    def remove_action_text_defaults
      say "Remove default ActionText CSS"
      # remove import from application.tailwind.css if present as we add it to another imported css file.

      gsub_file "app/assets/stylesheets/application.tailwind.css", /@import 'actiontext.css';/, ""
    end

    def humanize_theme(theme)
      theme.humanize
    end

    def theme_dependencies(theme)
      case theme
      when "hound"
        ["@tailwindcss/typography", "apexcharts", "railsui-stimulus", "stimulus-use","tailwindcss@latest", "@tailwindcss/cli@latest", "tippy.js"]
      when "shepherd"
        ["@tailwindcss/typography", "apexcharts", "flatpickr", "hotkeys-js", "photoswipe", "railsui-stimulus", "stimulus-use", "tippy.js", "tailwindcss@latest", "@tailwindcss/cli@latest"]
      when "retriever"
        ["@tailwindcss/typography", "apexcharts", "autoprefixer", "flatpickr","railsui-stimulus", "stimulus-use", "tailwindcss@latest", "@tailwindcss/cli@latest", "tippy.js"]
      when "setter"
        ["@tailwindcss/typography", "railsui-stimulus", "stimulus-use", "tailwindcss@latest", "@tailwindcss/cli@latest", "tippy.js"]
      else
        ["@tailwindcss/typography", "railsui-stimulus", "stimulus-use", "tailwindcss@latest", "@tailwindcss/cli@latest" "tippy.js"]
      end
    end

    def add_yarn_packages(packages)
      run "yarn add #{packages.join(' ')} --latest"
    end

    # Mailers
    def generate_sample_mailers(theme)
      say "Adding Rails UI mailers", :yellow

      rails_command "generate mailer Railsui minimal promotion transactional"

combined_mailer_setup = <<-RUBY
  layout "rui/railsui_mailer"
  helper :application
RUBY

      insert_into_file Rails.root.join("app/mailers/railsui_mailer.rb").to_s, combined_mailer_setup, after: "class RailsuiMailer < ApplicationMailer\n"

      copy_sample_mailers(theme)
    end

    def copy_sample_mailers(theme)
      source_directory = "themes/#{theme}/mail/railsui_mailer"
      destination_directory = Rails.root.join("app/views/railsui_mailer")
      directory source_directory, destination_directory, force: true
    end

    def update_railsui_mailer_layout(theme)
      source_file = Rails.root.join('app/views/layouts/rui/railsui_mailer.html.erb')
      if File.exist?(source_file)
        remove_file source_file
      end

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
      routes_file = Rails.root.join('config/routes.rb')

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
      updated_content = route_content.gsub(namespace_pattern, '')

      # Append the new routes block after the initial `Rails.application.routes.draw do` line
      updated_content.sub!("Rails.application.routes.draw do\n", "Rails.application.routes.draw do\n#{routes_block}")

      # Write the updated content back to the routes file
      File.open(routes_file, 'w') { |file| file.write(updated_content) }
    end

    # Pages
    def copy_railsui_page_controller(theme)
      copy_file "controllers/pages_controller.rb", "app/controllers/rui/pages_controller.rb", force: true
    end

    def copy_railsui_pages(theme)
      # Copy Pages
      directory "themes/#{theme}/views/rui", "app/views/rui", force: true

      # Copy layouts
      directory "themes/#{theme}/views/layouts/rui", "app/views/layouts/rui", force: true
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
