# frozen_string_literal: true

# Base datalist component for tabular data
#
# Usage:
#   <%= rui :datalist do %>
#     <thead>
#       <th>Column 1</th>
#       <th>Column 2</th>
#     </thead>
#     <tbody>
#       <tr>
#         <td>Data 1</td>
#         <td>Data 2</td>
#       </tr>
#     </tbody>
#   <% end %>
#
#   # With items
#   <%= rui :datalist do |datalist| %>
#     <thead>...</thead>
#     <% datalist.with_item do %>
#       <td>Custom row content</td>
#     <% end %>
#   <% end %>
module Rui
  class DatalistComponent < BaseComponent
    renders_many :items

    def initialize(**html_options)
      @html_options = html_options
    end

    private

    def wrapper_classes
      "overflow-x-auto"
    end

    def table_classes
      base = "table table-auto w-full"
      custom = @html_options[:class]
      [base, custom].compact.join(" ")
    end
  end
end