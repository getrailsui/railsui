# frozen_string_literal: true

# Flash component for Rails UI
#
# Usage:
#   <%= rui :flash, type: :notice, message: "Settings saved successfully!" %>
#   <%= rui :flash, type: :alert, message: "An error occurred" %>
#   <%= rui :flash, type: :success, message: "Payment processed!" %>
#   <%= rui :flash, type: :warning, message: "Your session will expire soon" %>
#
#   <!-- With custom styling -->
#   <%= rui :flash, type: :notice, message: "Custom styled", class: "rounded-lg shadow-lg" %>
#
#   <!-- With icon -->
#   <%= rui :flash, type: :success, message: "Done!", icon: "check-circle" %>
#   <%= rui :flash, type: :success, message: "No icon", icon: false %>
#
#   <!-- With dismiss button (requires custom Stimulus controller) -->
#   <%= rui :flash, type: :notice, message: "Dismissible message",
#                   data: { controller: "dismiss" } do |flash| %>
#     <% flash.with_actions do %>
#       <%= rui :button, type: "button", variant: :transparent,
#                        class: "text-current opacity-75 hover:opacity-100",
#                        data: { action: "click->dismiss#remove" } do %>
#         <%= icon "x-mark", class: "size-5" %>
#       <% end %>
#     <% end %>
#   <% end %>
#
#   <!-- With block content and multiple actions -->
#   <%= rui :flash, type: :success do |flash| %>
#     <strong>Success!</strong> Your payment was processed.
#     <% flash.with_actions do %>
#       <%= link_to "View Receipt", receipt_path, class: "underline font-medium" %>
#       <%= rui :button, type: "button", variant: :transparent,
#                        class: "text-current opacity-75 hover:opacity-100 -mr-2",
#                        onclick: "this.closest('[role=alert]').remove()" do %>
#         <%= icon "x-mark", class: "size-5" %>
#       <% end %>
#     <% end %>
#   <% end %>
#
#   <!-- Auto-dismiss with Stimulus (requires custom controller) -->
#   <div data-controller="auto-dismiss" data-auto-dismiss-delay-value="3000">
#     <%= rui :flash, type: :notice, message: "This will disappear in 3 seconds" %>
#   </div>
#
# Options:
#   type: Symbol - :notice, :alert, :success, :warning, :error (default: :notice)
#   message: String - The message to display
#   icon: String/Boolean - Icon name or false to hide (default: auto based on type)
#   **html_options - Additional HTML attributes
module Rui
  class FlashComponent < BaseComponent
    renders_one :actions

    def initialize(
      type: :notice,
      message: nil,
      icon: nil,
      **html_options
    )
      @type = type.to_sym
      @message = message
      @icon = icon
      @html_options = html_options
    end

    private

    def flash_classes
      base_classes = "text-center p-4"
      type_classes = type_class
      custom_classes = @html_options[:class]

      [base_classes, type_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      attrs = @html_options.except(:class)
      attrs[:role] = "alert"
      attrs
    end

    def type_class
      case @type
      when :notice
        "bg-primary-600 text-white"
      when :alert, :error
        "bg-rose-600 text-white"
      when :success
        "bg-green-600 text-white"
      when :warning
        "bg-yellow-500 text-white"
      else
        "bg-gray-600 text-white"
      end
    end

    def icon_name
      return nil if @icon == false
      return @icon if @icon.present?

      case @type
      when :success
        "check-circle"
      when :alert, :error
        "exclamation-circle"
      when :warning
        "exclamation-triangle"
      when :notice
        "information-circle"
      else
        nil
      end
    end

  end
end