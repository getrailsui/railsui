# frozen_string_literal: true

# Table component for Rails UI
#
# Usage:
#   <%= rui :table do %>
#     <thead>
#       <tr>
#         <th>Name</th>
#         <th>Email</th>
#         <th>Actions</th>
#       </tr>
#     </thead>
#     <tbody>
#       <% users.each do |user| %>
#         <tr>
#           <td><%= user.name %></td>
#           <td><%= user.email %></td>
#           <td>
#             <%= link_to "Edit", edit_user_path(user), class: "text-primary-600" %>
#           </td>
#         </tr>
#       <% end %>
#     </tbody>
#   <% end %>
#
#   <!-- With options -->
#   <%= rui :table, striped: true, hoverable: true, responsive: true do %>
#     ...
#   <% end %>
#
# Options:
#   responsive: Boolean - Make table horizontally scrollable (default: false)
#   striped: Boolean - Alternate row colors (default: false)
#   hoverable: Boolean - Highlight rows on hover (default: false)
#   bordered: Boolean - Add borders to all cells (default: false)
#   **html_options - Additional HTML attributes
module Rui
  class TableComponent < BaseComponent
    def initialize(
      responsive: false,
      striped: false,
      hoverable: false,
      bordered: false,
      **html_options
    )
      @responsive = responsive
      @striped = striped
      @hoverable = hoverable
      @bordered = bordered
      @html_options = html_options
    end

    private

    def wrapper_classes
      "overflow-x-auto"
    end

    def table_classes
      base = "min-w-full"
      custom = @html_options[:class]

      [base, custom].compact.join(" ")
    end

    def html_attributes
      attrs = @html_options.except(:class)

      # Add classes and data attributes for CSS targeting
      attrs[:class] = [table_classes, variant_classes].join(" ")
      attrs[:data] ||= {}
      attrs[:data][:striped] = @striped
      attrs[:data][:hoverable] = @hoverable
      attrs[:data][:bordered] = @bordered

      attrs
    end

    def variant_classes
      classes = []
      classes << "divide-y divide-gray-200 dark:divide-gray-700"
      classes.join(" ")
    end
  end
end