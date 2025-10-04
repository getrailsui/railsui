# frozen_string_literal: true

# Breadcrumb component for Rails UI
#
# Usage:
#   <%= rui :breadcrumb do |breadcrumb| %>
#     <% breadcrumb.with_item(label: "Home", href: "/") %>
#     <% breadcrumb.with_item(label: "Products", href: "/products") %>
#     <% breadcrumb.with_item(label: "Current Page", current: true) %>
#   <% end %>
#
#   <%= rui :breadcrumb, separator: ">" do |breadcrumb| %>
#     <% breadcrumb.with_item(label: "Dashboard", href: "/dashboard") %>
#     <% breadcrumb.with_item(label: "Settings", current: true) %>
#   <% end %>
#
#   <%= rui :breadcrumb, separator: nil do |breadcrumb| %>
#     <% breadcrumb.with_item(label: "Home", href: "/") %>
#     <% breadcrumb.with_item(label: "About", current: true) %>
#   <% end %>
#
# Options:
#   separator: String - Separator between breadcrumb items (default: "/", set to nil for no separator)
#   **html_options - Additional HTML attributes
#
# Item Options:
#   label: String - Text to display for breadcrumb item
#   href: String - Link URL (if nil, renders as span)
#   current: Boolean - Whether this is the current page (default: false)
#   **html_options - Additional HTML attributes for the item
module Rui
  class BreadcrumbComponent < BaseComponent
    renders_many :items, "BreadcrumbItemComponent"

    def initialize(
      separator: "/",
      **html_options
    )
      @separator = separator
      @html_options = html_options
    end

    private

    def nav_classes
      base_classes = "my-6 font-medium flex text-zinc-500 dark:text-zinc-200 text-sm"
      custom_classes = @html_options[:class]

      [base_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end


    class BreadcrumbItemComponent < BaseComponent
      def initialize(
        label:,
        href: nil,
        current: false,
        **html_options
      )
        @label = label
        @href = href
        @current = current
        @html_options = html_options
      end

      private

      def link_classes
        "hover:underline hover:text-zinc-600 dark:hover:text-zinc-400"
      end

      def current_classes
        "text-primary-500 dark:text-primary-500"
      end

      def html_attributes
        @html_options
      end

      def html_attributes_hash
        @html_options
      end

      def aria_html
        if @current
          'aria-current="page"'
        else
          ""
        end
      end
    end
  end
end