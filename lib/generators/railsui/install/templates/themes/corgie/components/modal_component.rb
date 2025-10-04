# frozen_string_literal: true

# Modal component for Rails UI
#
# IMPORTANT: This component requires the railsui-modal controller to be attached to a parent element
# (typically the body tag or a high-level container). Add this to your layout or parent template:
#   <body data-controller="railsui-modal">
#
# Basic Usage:
#   <!-- Modal definition -->
#   <%= rui :modal, id: "confirm-modal", title: "Confirm Action" do %>
#     Are you sure you want to continue?
#   <% end %>
#
#   <!-- Trigger button (separate from modal) -->
#   <%= rui :button, "Open Modal", data: { action: "click->railsui-modal#open", railsui_modal_target_param: "confirm-modal" } %>
#
# Advanced Usage:
#   <%= rui :modal, id: "custom-modal", size: :lg do |modal| %>
#     <% modal.with_header do %>
#       <h2>Custom Header</h2>
#     <% end %>
#     Modal content goes here
#     <% modal.with_footer do %>
#       <%= rui :button, "Cancel", data: { action: "click->railsui-modal#close" } %>
#       <%= rui :button, "Confirm", variant: :primary %>
#     <% end %>
#   <% end %>
#
#   <!-- Multiple trigger options -->
#   <%= link_to "Open Modal", "#", data: { action: "click->railsui-modal#open", railsui_modal_target_param: "custom-modal" } %>
#   <%= rui :button, "Delete Item", variant: :danger, data: { action: "click->railsui-modal#open", railsui_modal_target_param: "custom-modal" } %>
#
# Options:
#   id: String - Modal DOM ID (required for targeting from triggers)
#   title: String - Modal title (displays in header)
#   size: Symbol - :sm, :md, :lg, :xl (default: :md)
#   closeable: Boolean - Show close button (default: true)
#   **html_options - Additional HTML attributes
module Rui
  class ModalComponent < BaseComponent
    renders_one :header
    renders_one :footer

    def initialize(
      id:,
      title: nil,
      size: :md,
      closeable: true,
      **html_options
    )
      @id = id
      @title = title
      @size = size.to_sym
      @closeable = closeable
      @html_options = html_options
    end

    private

    def html_attributes
      base_data = @html_options.except(:class)
      all_attrs = base_data
      all_attrs.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    end

    def modal_content_classes
      base_classes = "hidden rounded shadow-xl bg-white m-1 p-8 prose origin-bottom mx-auto dark:bg-neutral-700 dark:text-neutral-200"
      size_classes = size_class
      custom_classes = @html_options[:class]

      [base_classes, size_classes, custom_classes].compact.join(" ")
    end

    def size_class
      case @size
      when :sm then "max-w-sm"
      when :lg then "max-w-2xl"
      when :xl then "max-w-4xl"
      else "max-w-lg" # :md
      end
    end

  end
end