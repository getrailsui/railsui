# frozen_string_literal: true

# Toast component for Rails UI
#
# Basic Usage:
#   <%= rui :toast, title: "Success!", message: "Your changes have been saved." %>
#   <%= rui :toast, title: "Error", message: "Something went wrong.", variant: :error %>
#   <%= rui :toast, title: "Info", variant: :info, position: :bottom_left, auto_dismiss: false %>
#   <%= rui :toast, title: "Custom", message: "With custom icon", icon: "bell" %>
#
# Options:
#   title: String - Toast title (required)
#   message: String - Toast message (optional)
#   icon: String - Custom icon name (overrides variant-based icon)
#   variant: Symbol - :success, :error, :warning, :info (default: :success)
#   position: Symbol - :top_right, :top_left, :bottom_right, :bottom_left (default: :top_right)
#   dismissible: Boolean - Show close button (default: true)
#   auto_dismiss: Boolean - Auto dismiss after duration (default: true)
#   duration: Integer - Auto dismiss duration in ms (default: 5000)
#   **html_options - Additional HTML attributes
module Rui
  class ToastComponent < BaseComponent
    def initialize(
      title:,
      message: nil,
      icon: nil,
      variant: :success,
      position: :top_right,
      dismissible: true,
      auto_dismiss: true,
      duration: 5000,
      **html_options
    )
      @title = title
      @message = message
      @icon = icon
      @variant = variant.to_sym
      @position = position.to_sym
      @dismissible = dismissible
      @auto_dismiss = auto_dismiss
      @duration = duration
      @html_options = html_options
    end

    private

    def html_attributes
      base_data = {
        "data-controller": "railsui-toast"
      }

      if @auto_dismiss
        base_data["data-railsui-toast-duration-value"] = @duration
      end

      all_attrs = base_data.merge(@html_options)
      all_attrs.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    end

    def container_classes
      base_classes = "pointer-events-none absolute flex items-center px-4 py-6 sm:p-6 w-full"
      position_classes = case @position
      when :top_left then "justify-start top-0 left-0"
      when :top_center then "justify-center top-0 left-0 right-0"
      when :bottom_left then "justify-start bottom-0 left-0"
      when :bottom_right then "justify-end bottom-0 right-0"
      when :bottom_center then "justify-center bottom-0 left-0 right-0"
      else "justify-end top-0 right-0 left-0" # :top_right
      end
      animation_classes = case @position
      when :top_left, :bottom_left then "animate-toast-from-left"
      when :top_center, :bottom_center then "animate-toast-from-top"
      else "animate-toast-from-right" # top_right, bottom_right
      end

      [base_classes, position_classes, animation_classes].compact.join(" ")
    end

    def toast_classes
      base_classes = "pointer-events-auto w-full max-w-sm overflow-hidden rounded-md shadow-lg ring-1"
      variant_classes = case @variant
      when :error, :danger
        "bg-red-50 ring-red-200 dark:bg-red-950 dark:ring-red-800"
      when :warning
        "bg-yellow-50 ring-yellow-200 dark:bg-yellow-950 dark:ring-yellow-800"
      when :info
        "bg-blue-50 ring-blue-200 dark:bg-blue-950 dark:ring-blue-800"
      else # :success
        "bg-white ring-black/10 dark:bg-slate-950 dark:border dark:border-slate-700/80"
      end
      custom_classes = @html_options[:class]

      [base_classes, variant_classes, custom_classes].compact.join(" ")
    end

    def icon_name
      return @icon if @icon

      case @variant
      when :error, :danger then "x-circle"
      when :warning then "exclamation-triangle"
      when :info then "information-circle"
      else "check-circle" # :success
      end
    end

    def icon_classes
      case @variant
      when :error, :danger then "size-6 text-red-500 dark:text-red-400"
      when :warning then "size-6 text-yellow-500 dark:text-yellow-400"
      when :info then "size-6 text-blue-500 dark:text-blue-400"
      else "size-6 text-green-500 dark:text-green-400" # :success
      end
    end
  end
end