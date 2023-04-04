# frozen_string_literal: true

require "rails/generators/named_base"

module Railsui
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      # include Rails.application.routes.url_helpers
      # include Railsui::Generators::GeneratorHelpers
      # hook_for :test_framework, as: :controller
      # TODO: Include arguments at some point? i.e. Pricing tier count or something
      source_root File.expand_path('../templates', __FILE__)

      desc "Adds additional routing and associated views with given page."

      def copy_controller_action
        append_to_file "app/controllers/page_controller.rb", after: "class PageController < ApplicationController\n" do
        "\tdef #{display_name}\n\tend\n\n"
        end
      end

      # The NAME attribute when the generator is run
      def display_name
        name
      end

      # TODO: Support for other view types (haml, slim, etc...)
      def copy_view_files
        # only return active Rails UI pages
        return unless Railsui.config.pages.include?(display_name)
        template "#{Railsui.config.css_framework}/#{Railsui.config.theme}/#{display_name}.html.erb.tt", File.join("app/views/page", "#{display_name}.html.erb")
      end

      def add_to_navigation
inserted_link = <<-ERB
<li #{'class="nav-item"' if Railsui.bootstrap? }>
  <%= nav_link_to "#{display_name.titleize}", send("#{display_name}_path"), class: "nav-link" %>
</li>
ERB
        append_to_file "app/views/shared/_nav_links.html.erb", inserted_link
      end

      def add_routes
        insert_into_file "#{Rails.root}/config/routes.rb", "\t\tget #{display_name.prepend(':')}\n", after: "scope controller: :page do\n"
      end
    end
  end
end
