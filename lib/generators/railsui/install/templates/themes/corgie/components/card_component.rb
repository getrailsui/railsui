# frozen_string_literal: true

# Card component for Rails UI
#
# Basic Usage:
#   <%= rui :card, title: "Welcome", description: "Card description" do %>
#     Card content goes here
#   <% end %>
#
#   <%= rui :card do |card| %>
#     <% card.with_header do %>
#       <h3>Custom Header</h3>
#     <% end %>
#     Card body content
#     <% card.with_footer do %>
#       <button>Action</button>
#     <% end %>
#   <% end %>
#
# Extension Example - Create a UserCard:
#   class UserCardComponent < Rui::CardComponent
#     def initialize(user:, **options)
#       @user = user
#       super(**options)
#     end
#   end
#
#   <!-- user_card_component.html.erb -->
#   <div class="<%= card_classes %>" <%= html_attributes %>>
#     <div class="flex items-center space-x-4">
#       <%= image_tag @user.avatar, class: "size-12 rounded-full" %>
#       <div>
#         <h3><%= @user.name %></h3>
#         <p><%= @user.email %></p>
#       </div>
#     </div>
#   </div>
#
# Options:
#   title: String - Card title (displays as h3 in header)
#   description: String - Card description (displays as prose paragraph)
#   padding: Symbol - :none, :small, :normal, :large (default: :normal)
#   **html_options - Additional HTML attributes
module Rui
  class CardComponent < BaseComponent
    renders_one :header
    renders_one :footer

    def initialize(
      title: nil,
      description: nil,
      padding: :normal,
      **html_options
    )
      @title = title
      @description = description
      @padding = padding
      @html_options = html_options
    end

    private

    def card_classes
      base_classes = "rounded-lg bg-white dark:bg-slate-800 dark:text-white border border-slate-300/70 dark:border-slate-600/70"
      custom_classes = @html_options[:class]

      [base_classes, custom_classes].compact.join(" ")
    end

    def body_classes
      padding_class
    end

    def header_classes
      "px-6 py-4 border-b border-slate-200 dark:border-slate-700"
    end

    def footer_classes
      "px-6 py-4 border-t border-slate-200 dark:border-slate-700"
    end

    def html_attributes
      @html_options.except(:class)
    end

    def padding_class
      case @padding
      when :none then ""
      when :small then "p-4"
      when :large then "p-8"
      else "p-6" # normal
      end
    end

  end
end