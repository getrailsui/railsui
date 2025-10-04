# frozen_string_literal: true

# Generic datalist item component
# Can be used with DatalistComponent for custom list items
#
# Usage:
#   <%= rui :datalist do |datalist| %>
#     <% datalist.with_item do %>
#       <td>Custom content</td>
#       <td>More content</td>
#     <% end %>
#   <% end %>
module Rui
  class DatalistItemComponent < BaseComponent
    def initialize(**html_options)
      @html_options = html_options
    end

    private

    def row_classes
      "md:whitespace-normal whitespace-nowrap"
    end

    def html_attributes
      @html_options
    end
  end
end