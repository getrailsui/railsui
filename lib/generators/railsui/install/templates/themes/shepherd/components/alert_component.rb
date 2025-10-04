# frozen_string_literal: true

# Alert component for Rails UI
#
# Usage:
#   <%= rui :alert, title: "Success!", description: "Operation completed", variant: :success %>
#   <%= rui :alert, title: "Custom Icon", icon: "rocket-launch", variant: :info %>
#   <%= rui :alert, title: "No Icon", icon: false, variant: :success %>
#   <%= rui :alert, title: "Custom Icon Style", icon: "star", icon_class: "size-6 text-yellow-500" %>
#   <%= rui :alert, title: "Custom Title Style", title_class: "text-lg font-bold text-purple-800" %>
#
#   <!-- Dismissible alert with custom Stimulus controller -->
#   <%= rui :alert, title: "Dismissible", variant: :info,
#                   data: { controller: "railsui-toggle" } do |alert| %>
#     This alert can be dismissed
#     <% alert.with_actions do %>
#       <%= rui :button, type: "button", variant: :transparent,
#                        class: "text-current opacity-60 hover:opacity-100 transition-opacity",
#                        data: { action: "click->railsui-toggle#toggle" } do %>
#         <%= icon "x-mark", class: "size-5" %>
#       <% end %>
#     <% end %>
#   <% end %>
#
#   <!-- Alert with multiple actions -->
#   <%= rui :alert, variant: :warning do |alert| %>
#     <% alert.with_actions do %>
#       <%= rui :button, "Retry", size: :sm, variant: :outline %>
#       <%= rui :button, type: "button", variant: :transparent,
#                        class: "text-current opacity-60 hover:opacity-100 transition-opacity" do %>
#         <%= icon "x-mark", class: "size-5" %>
#       <% end %>
#     <% end %>
#   <% end %>
#
# Options:
#   title: String - Alert title
#   description: String - Alert description
#   icon: String/Boolean - Custom icon name, or false to hide icon (default: auto-selected by variant)
#   icon_class: String - Custom CSS classes for the icon (default: variant-based styling)
#   title_class: String - Custom CSS classes for the title (default: variant-based styling)
#   variant: Symbol - :info, :success, :warning, :danger/:error (default: :info)
#   border_accent: Boolean - Adds left border accent (default: false)
#   **html_options - Additional HTML attributes (including data attributes for Stimulus)
module Rui
  class AlertComponent < BaseComponent
    renders_one :actions

    def initialize(
      title: nil,
      description: nil,
      icon: nil,
      icon_class: nil,
      title_class: nil,
      variant: :info,
      border_accent: false,
      **html_options
    )
      @title = title
      @description = description
      @icon = icon
      @icon_class = icon_class
      @title_class = title_class
      @variant = variant.to_sym
      @border_accent = border_accent
      @html_options = html_options
    end

    private

    def alert_classes
      base_classes = "py-4 px-6 rounded-xl flex items-start justify-between space-x-3 text-sm"
      variant_classes = variant_class
      border_classes = @border_accent ? "border-l-4" : ""
      custom_classes = @html_options[:class]

      [base_classes, variant_classes, border_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end

    def variant_config
      @variant_config ||= case @variant
      when :success
        {
          background: "bg-green-50/90 text-green-700 dark:bg-green-300/10 dark:border dark:border-green-400/30 dark:text-green-50",
          icon_name: "check-circle",
          icon_class: "text-green-400 size-5 flex-shrink-0 dark:text-green-400/90",
          title_class: "text-green-800 dark:text-green-400/90 font-semibold"
        }
      when :warning
        {
          background: "bg-amber-100/60 text-amber-800 dark:bg-amber-300/10 dark:border dark:border-amber-400/30 dark:text-amber-50 dark:selection:bg-amber-50/10",
          icon_name: "exclamation-triangle",
          icon_class: "text-amber-500/90 size-5 flex-shrink-0 dark:text-amber-400/90",
          title_class: "text-amber-900 dark:text-amber-400/90 font-medium font-heading"
        }
      when :danger, :error
        {
          background: "bg-red-50/90 text-red-700 dark:bg-red-300/10 dark:border dark:border-red-400/30 dark:text-red-50",
          icon_name: "x-circle",
          icon_class: "text-red-400 size-5 flex-shrink-0 dark:text-red-400/90",
          title_class: "text-red-800 dark:text-red-400/90 font-semibold"
        }
      else # info
        {
          background: "bg-blue-50/90 text-blue-700 dark:bg-blue-300/10 dark:border dark:border-blue-400/30 dark:text-blue-50",
          icon_name: "information-circle",
          icon_class: "text-blue-400 size-5 flex-shrink-0 dark:text-blue-400/90",
          title_class: "text-blue-800 dark:text-blue-400/90 font-semibold"
        }
      end
    end

    def variant_class
      variant_config[:background]
    end

    def icon_name
      return nil if @icon == false
      return @icon if @icon.present?
      variant_config[:icon_name]
    end

    def icon_classes
      return @icon_class if @icon_class.present?
      variant_config[:icon_class]
    end

    def title_classes
      return @title_class if @title_class.present?
      variant_config[:title_class]
    end

  end
end