# frozen_string_literal: true

# Tab component for Rails UI
#
# Basic Usage:
#   <%= rui :tab, active_index: 0 do |tab| %>
#     <% tab.with_tab(label: "Tab 1") %>
#     <% tab.with_tab(label: "Tab 2") %>
#     <% tab.with_tab(label: "Tab 3") %>
#
#     <% tab.with_panel do %>
#       Content for tab 1
#     <% end %>
#     <% tab.with_panel do %>
#       Content for tab 2
#     <% end %>
#     <% tab.with_panel do %>
#       Content for tab 3
#     <% end %>
#   <% end %>
#
# With custom styling:
#   <%= rui :tab, active_index: 0 do |tab| %>
#     <% tab.with_tab(label: "Tab 1", class: "font-bold", id: "first-tab") %>
#     <% tab.with_tab(label: "Tab 2", data: { testid: "second-tab" }) %>
#
#     <% tab.with_panel(class: "bg-gray-50 rounded", id: "panel-1") do %>
#       Content for tab 1
#     <% end %>
#     <% tab.with_panel(class: "bg-blue-50") do %>
#       Content for tab 2
#     <% end %>
#   <% end %>
#
# Options:
#   active_index: Integer - Index of initially active tab (default: 0)
#   **html_options - Additional HTML attributes
module Rui
  class TabComponent < BaseComponent
    renders_many :tabs, "TabItemComponent"
    renders_many :panels, "TabPanelComponent"

    def initialize(
      active_index: 0,
      **html_options
    )
      @active_index = active_index
      @html_options = html_options
    end

    private

    def tab_classes
      custom_classes = @html_options[:class]
      [custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end

    def active_tab_classes
      "border-b border-primary-600 inline-block bg-white text-primary-600 dark:bg-transparent dark:text-white dark:border-primary-400 py-3 px-4"
    end

    def inactive_tab_classes
      "border-b border-zinc-200 inline-block bg-white text-zinc-600 dark:bg-transparent dark:text-zinc-100 dark:border-zinc-600 py-3 px-4"
    end

    def tab_link_classes(index)
      base = index == @active_index ? active_tab_classes : inactive_tab_classes
      custom = tabs[index].tab_item_classes if tabs[index]
      [base, custom].compact.join(" ")
    end

    def panel_div_classes(index)
      base = index == @active_index ? "p-4" : "hidden p-4"
      custom = panels[index].panel_classes if panels[index]
      [base, custom].compact.join(" ")
    end


    class TabItemComponent < BaseComponent
      attr_reader :label

      def initialize(label:, **html_options)
        @label = label
        @html_options = html_options
      end

      def html_attributes
        @html_options.except(:class)
      end

      def tab_item_classes
        custom_classes = @html_options[:class]
        [custom_classes].compact.join(" ")
      end
    end

    class TabPanelComponent < BaseComponent
      def initialize(**html_options)
        @html_options = html_options
      end

      def html_attributes
        @html_options.except(:class)
      end

      def panel_classes
        custom_classes = @html_options[:class]
        [custom_classes].compact.join(" ")
      end
    end
  end
end