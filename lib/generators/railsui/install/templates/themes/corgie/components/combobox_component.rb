# frozen_string_literal: true

# Combobox component for Rails UI
#
# Usage:
#   <%= rui :combobox, placeholder: "Select a format..." do |combobox| %>
#     <% combobox.with_option(value: "PDF", label: "PDF") %>
#     <% combobox.with_option(value: "CSV", label: "CSV") %>
#     <% combobox.with_option(value: "Excel", label: "Excel") %>
#     <% combobox.with_option(value: "JPEG", label: "JPEG") %>
#   <% end %>
#
#   <!-- With custom styling -->
#   <%= rui :combobox,
#           placeholder: "Choose format...",
#           class: "w-64" do |combobox| %>
#     <% combobox.with_option(value: "pdf", label: "PDF") %>
#     <% combobox.with_option(value: "csv", label: "CSV") %>
#   <% end %>
#
#   <!-- With custom options and styling -->
#   <%= rui :combobox,
#           name: "export_format",
#           placeholder: "Choose export format...",
#           search_placeholder: "Type to search...",
#           no_results_text: "No formats found",
#           class: "w-96",
#           data: { testid: "format-selector" } do |combobox| %>
#     <% formats.each do |format| %>
#       <% combobox.with_option(value: format.id, label: format.name) %>
#     <% end %>
#   <% end %>
#
#   <!-- Custom styled options -->
#   <%= rui :combobox, class: "w-72" do |combobox| %>
#     <% combobox.with_option(value: "high", label: "High Priority", class: "text-red-600 font-semibold") %>
#     <% combobox.with_option(value: "medium", label: "Medium Priority", class: "text-yellow-600") %>
#     <% combobox.with_option(value: "low", label: "Low Priority", class: "text-green-600") %>
#   <% end %>
#
# Options:
#   name: String - Name for the hidden input field (default: "selected_option")
#   placeholder: String - Placeholder text when nothing selected (default: "Select an option...")
#   search_placeholder: String - Search input placeholder (default: "Search...")
#   no_results_text: String - Message when no results found (default: "No results found")
#   **html_options - Additional HTML attributes
module Rui
  class ComboboxComponent < BaseComponent
    renders_many :options, "OptionComponent"

    def initialize(
      name: "selected_option",
      placeholder: "Select an option...",
      search_placeholder: "Search...",
      no_results_text: "No results found",
      **html_options
    )
      @name = name
      @placeholder = placeholder
      @search_placeholder = search_placeholder
      @no_results_text = no_results_text
      @html_options = html_options
    end

    private

    def combobox_classes
      base_classes = "relative"
      custom_classes = @html_options[:class] || "w-56"
      [base_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class).merge(
        data: {
          controller: "railsui-combobox",
          action: "click@window->railsui-combobox#handleOutsideClick",
          "railsui-combobox-active-class-value": "bg-gray-900 text-white hover:bg-gray-950",
          "railsui-combobox-inactive-class-value": "bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-100 dark:hover:bg-gray-900 hover:bg-gray-50"
        }.merge(@html_options[:data] || {})
      )
    end

    class OptionComponent < BaseComponent
      attr_reader :value, :label

      def initialize(value:, label: nil, **html_options)
        @value = value
        @label = label || value
        @html_options = html_options
      end

      def html_attributes
        @html_options.merge(
          "aria-selected": "false",
          data: {
            action: "click->railsui-combobox#selectOption keydown.enter->railsui-combobox#selectOption",
            "railsui-combobox-target": "option",
            value: @value
          }.merge(@html_options[:data] || {}),
          class: option_classes,
          role: "option",
          tabindex: "0"
        )
      end

      private

      def option_classes
        base_classes = "px-3 py-1.5 cursor-pointer flex items-center justify-between"
        custom_classes = @html_options[:class]
        [base_classes, custom_classes].compact.join(" ")
      end
    end
  end
end