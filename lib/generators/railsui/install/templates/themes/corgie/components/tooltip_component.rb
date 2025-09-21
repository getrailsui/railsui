# frozen_string_literal: true

# Tooltip component for Rails UI
#
# Basic Usage:
#   <%= rui :tooltip, content: "This is a tooltip" do %>
#     <button>Hover me</button>
#   <% end %>
#
#   <%= rui :tooltip, content: "Bottom tooltip", placement: "bottom" do %>
#     <%= icon "information-circle", class: "size-4" %>
#   <% end %>
#
#   <%= rui :tooltip, content: "<strong>HTML tooltip</strong>",
#       data: { railsui_tooltip_allow_html_value: true, railsui_tooltip_interactive_value: true } do %>
#     <button>Interactive tooltip</button>
#   <% end %>
#
# Options:
#   content: String - Tooltip content (required)
#   placement: String - "top", "bottom", "left", "right", etc. (default: "bottom")
#   **html_options - Additional HTML attributes and data attributes for Tippy.js options https://github.com/getrailsui/railsui-stimulus/blob/main/src/railsui_tooltip.js
module Rui
  class TooltipComponent < BaseComponent
    def initialize(
      content:,
      placement: "bottom",
      **html_options
    )
      @content = content
      @placement = placement
      @html_options = html_options
    end

    private

    def html_attributes
      base_data = {
        "data-controller": "railsui-tooltip",
        "data-railsui-tooltip-content-value": @content,
        "data-railsui-tooltip-placement-value": @placement
      }

      base_data.merge(@html_options)
    end
  end
end