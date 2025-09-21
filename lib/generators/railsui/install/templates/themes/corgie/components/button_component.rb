# frozen_string_literal: true

# Button component for Rails UI
#
# Usage:
#   <%= rui :button, "Click me" %>
#   <%= rui :button, "Submit", variant: :primary, size: :lg %>
#   <%= rui :button, "Link Button", href: "/path", variant: :secondary %>
#   <%= rui :button, expanded: true do %>
#     Custom content
#   <% end %>
#
# Options:
#   text: String - Button text (can also be passed as first argument)
#   variant: Symbol - :primary, :secondary, :dark, :light, :white, :transparent, :danger, :link (default: :primary)
#   size: Symbol - :sm, :md, :lg (default: :md)
#   type: String - Button type attribute (default: "button")
#   href: String - If provided, renders as <a> tag instead of <button>
#   expanded: Boolean - Makes button full width (default: false)
#   **html_options - Additional HTML attributes
module Rui
  class ButtonComponent < BaseComponent
    def initialize(
      text: nil,
      variant: :primary,
      size: :md,
      type: "button",
      href: nil,
      expanded: false,
      **html_options
    )
      @text = text
      @variant = variant.to_sym
      @size = size.to_sym
      @type = type
      @href = href
      @expanded = expanded
      @html_options = html_options
    end

    private

    def button_classes
      classes = ["btn"]

      # Add variant class
      classes << variant_class

      # Add size class
      classes << size_class if size_class

      # Add expanded class
      classes << "btn-expanded" if @expanded

      # Add any custom classes passed in
      classes << @html_options[:class] if @html_options[:class]

      classes.compact.join(" ")
    end

    def variant_class
      case @variant
      when :primary then "btn-primary"
      when :secondary then "btn-secondary"
      when :dark then "btn-dark"
      when :light then "btn-light"
      when :white then "btn-white"
      when :transparent then "btn-transparent"
      when :danger then "btn-danger"
      when :link then "btn-link"
      else "btn-primary"
      end
    end

    def size_class
      case @size
      when :lg then "btn-lg"
      when :sm then "btn-sm"
      else nil # Default size, no additional class needed
      end
    end

    def html_attributes
      @html_options.except(:class)
    end

    def link?
      @href.present?
    end

    def tag_name
      link? ? "a" : "button"
    end

    def tag_attributes
      if link?
        { href: @href, class: button_classes }
      else
        { type: @type, class: button_classes }
      end
    end
  end
end