# frozen_string_literal: true

# Dropdown component for Rails UI
#
# Basic Usage:
#   <%= rui :dropdown, label: "Options" do |dropdown| %>
#     <% dropdown.with_item(href: "/profile", label: "Profile") %>
#     <% dropdown.with_item(href: "/settings", label: "Settings") %>
#     <% dropdown.with_item(href: "/logout", label: "Logout") %>
#   <% end %>
#
#   <%= rui :dropdown, position: :right do |dropdown| %>
#     <% dropdown.with_trigger do %>
#       <button class="btn btn-white">Custom Trigger</button>
#     <% end %>
#     <% dropdown.with_item(href: "#", label: "Action 1") %>
#     <% dropdown.with_item(href: "#", label: "Action 2") %>
#   <% end %>
#
# Options:
#   label: String - Default trigger button text (default: "Options")
#   trigger_class: String - CSS classes for default trigger (default: "btn btn-primary")
#   position: Symbol - :left, :right (default: :left)
#   **html_options - Additional HTML attributes
#
# Item Options:
#   href: String - Link URL (default: "#")
#   label: String - Link text (can also pass content as block)
#   **html_options - Additional HTML attributes for the link
module Rui
  class DropdownComponent < BaseComponent
    renders_one :trigger
    renders_many :items, "DropdownItemComponent"

    def initialize(
      label: "Options",
      trigger_class: "btn btn-primary",
      position: :left,
      **html_options
    )
      @label = label
      @trigger_class = trigger_class
      @position = position.to_sym
      @html_options = html_options
    end

    private

    def dropdown_classes
      base_classes = "relative md:inline-block block md:w-auto w-full"
      custom_classes = @html_options[:class]

      [base_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end

    def menu_classes
      base_classes = "hidden transition transform origin-top-left absolute top-10 bg-white rounded-lg shadow-xl shadow-slate-900/10 border border-slate-200 md:w-[200px] w-full z-50 py-2 dark:bg-slate-700 dark:shadow-slate-900/50 dark:border-slate-500/60 md:text-sm text-base font-medium text-slate-600 dark:text-slate-200"
      position_class = case @position
      when :right then "right-0"
      else "left-0" # :left
      end

      [base_classes, position_class].compact.join(" ")
    end

    class DropdownItemComponent < BaseComponent
      def initialize(
        href: "#",
        label: nil,
        **html_options
      )
        @href = href
        @label = label
        @html_options = html_options
      end

      private

      def html_attributes
        @html_options
      end
    end
  end
end