# frozen_string_literal: true

require "rails/generators/named_base"

module Railsui
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      desc "Adds additional routing and views for a given page."

      # TODO: Figure out how to add mutliple actions to the only: array reliably
      def copy_controller_action
        action_code = if namespace.present?
          "\n\tdef #{display_name}\n\t\trender layout: '#{namespace}'\n\tend\n"
        else
          "\n\tdef #{display_name}\n\tend\n"
        end

        append_to_file "app/controllers/page_controller.rb", after: "class PageController < ApplicationController\n" do
          action_code
        end

        @add_to_nav = pages_config[Railsui.config.theme][display_name]&.fetch("add_to_nav", true)
      end

      def display_name
        name
      end

      # TODO: Support for other view types (haml, slim, etc...)
      def copy_view_files
        return unless Railsui.config.pages.include?(display_name)

        unless File.exist?(File.join("app/views/page", "#{display_name}.html.erb"))
          template "#{Railsui.config.theme}/#{display_name}.html.erb.tt", File.join("app/views/page", "#{display_name}.html.erb")
        end

        if namespace.present?
          layout_name = "#{namespace.underscore}"
          layout_path = File.join("app/views/layouts", "#{layout_name}.html.erb")

          unless File.exist?(layout_path)
            layout_source = Railsui::Engine.root.join("lib", "generators", "railsui", "templates", "#{Railsui.config.theme}", "#{namespace}.html.erb.tt")

            template layout_source, layout_path
          end
          # copies folder associated with namespace i.e. app/views/shared/admin
          source_directory = Railsui::Engine.root.join("lib", "install", "tailwind", "themes", "#{Railsui.config.theme}", "page", namespace)
          destination_directory = Rails.root.join("app", "views", "shared", namespace)

          if Dir.exist?(source_directory) && !Dir.exist?(destination_directory)
            directory source_directory, destination_directory, force: true
          end
        end
      end

      def add_to_navigation
        @add_to_nav = pages_config[Railsui.config.theme][display_name]&.fetch("add_to_nav", true)

        return unless @add_to_nav
        # TODO: Adjust nav link based on
        # Dynamically append a navigation link for the page
        link_path = namespace.present? ? "#{namespace}_#{display_name}_path" : "#{display_name}_path"
        inserted_link = <<-ERB
<li>
  <%= nav_link_to "#{display_name.titleize}", send("#{link_path}"), class: "nav-link" %>
</li>
ERB
        # Here I scope partials per namespace if present. Typically with a new namespace, there will be a new layout and thus navigation pattern. i.e. Marketing vs. Admin
        partial_folder = namespace.present? ? File.join("app/views/shared", namespace) : "app/views/shared"
        partial_path = File.join(partial_folder, "_nav_links.html.erb")

        append_to_file partial_path, inserted_link
      end

      def add_routes
        if namespace.present?
          route_path = "#{namespace}/#{display_name}"
          controller_action = "page##{display_name}"
        else
          route_path = display_name.to_sym
          controller_action = "page##{display_name}"
        end

        route_definition = "\tget '#{route_path}', to: '#{controller_action}'\n"
        insert_into_file "#{Rails.root}/config/routes.rb", route_definition, after: "Rails.application.routes.draw do\n"
      end

      def invoke!
        if behavior == :revoke
          destroy_files!
        else
          create_files!
        end
      end

      private

      def create_files!
        say_status("add", "railsui.yml config", :green)
      end

      def destroy_files!
        say_status("subtract", "app/views/page/#{file_name}.html.erb", :green)
        # weird quirk to heavy hand delete
        system("rm #{Rails.root}/app/views/page/#{file_name}.html.erb")

        say_status("subtract", "railsui.yml config", :green)
        Railsui::Configuration.delete_page(display_name)
        Railsui::Configuration.synchronize_pages

        remove_nav_link_from_partial

        Railsui.clear
        Railsui.restart
      end

      def namespace
        pages_config[Railsui.config.theme][display_name]&.fetch("namespace", nil)
      end

      def pages_config
        @pages_config ||= YAML.load_file(File.join(Railsui::Engine.root, "config", "pages.yml"))
      end

      def remove_nav_link_from_partial
        link_path = namespace.present? ? "#{namespace}_#{display_name}_path" : "#{display_name}_path"

        link_code = "<%= nav_link_to \"#{display_name.titleize}\", send(\"#{link_path}\"), class: \"nav-link\" %>"
        partial_path = namespace.present? ? "app/views/shared/#{namespace}/_nav_links.html.erb" : "app/views/shared/_nav_links.html.erb"

        if File.exist?(partial_path)
          # Read the content of the partial
          partial_content = File.read(partial_path)

          # Remove the link code from the partial content
          partial_content.gsub!(link_code, '')

          # Write the modified content back to the partial
          File.open(partial_path, 'w') { |file| file.write(partial_content) }
        end
      end
    end
  end
end
