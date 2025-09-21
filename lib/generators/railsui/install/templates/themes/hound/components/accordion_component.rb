# frozen_string_literal: true

# Accordion component for Rails UI
#
# Basic Usage:
#   <%= rui :accordion do |accordion| %>
#     <% accordion.with_item(title: "Section 1", open: true) do %>
#       Content for section 1
#     <% end %>
#     <% accordion.with_item(title: "Section 2") do %>
#       Content for section 2
#     <% end %>
#     <% accordion.with_item(title: "Section 3") do %>
#       Content for section 3
#     <% end %>
#   <% end %>
#
#   <%= rui :accordion, style: :minimal do |accordion| %>
#     <% accordion.with_item(title: "FAQ 1", id: "faq-1") do %>
#       Answer to FAQ 1
#     <% end %>
#   <% end %>
#
# Options:
#   style: Symbol - :contained, :minimal (default: :contained)
#   **html_options - Additional HTML attributes
module Rui
  class AccordionComponent < BaseComponent
    renders_many :items, "AccordionItemComponent"

    def initialize(
      style: :contained,
      **html_options
    )
      @style = style.to_sym
      @html_options = html_options
    end

    private

    def html_attributes
      @html_options.except(:class)
    end

    def accordion_classes
      base_classes = case @style
      when :flush
        "divide-y divide-slate-100 dark:divide-slate-700"
      else # :contained
        "my-6 divide-y divide-slate-100 rounded-lg shadow-xl shadow-slate-100/50 border border-slate-200 dark:divide-slate-700 dark:border-slate-700 dark:shadow-black/20"
      end

      custom_classes = @html_options[:class]
      [base_classes, custom_classes].compact.join(" ")
    end

    class AccordionItemComponent < BaseComponent
      def initialize(
        title:,
        open: false,
        **html_options
      )
        @title = title
        @open = open
        @html_options = html_options
      end

      private

      def html_attributes
        @html_options.except(:class)
      end

      def details_classes
        "group p-4 marker:content-['']"
      end

      def summary_classes
        "flex w-full cursor-pointer select-none justify-between text-left text-base font-semibold leading-7 text-slate-900 group-open:text-primary-600 [&::-webkit-details-marker]:hidden dark:group-open:text-primary-300 dark:text-white"
      end

      def content_classes
        "prose prose-slate dark:prose-invert max-w-none prose-a:font-semibold prose-a:text-primary-600 hover:prose-a:text-primary-500 dark:prose-a:text-primary-400 dark:hover:prose-a:text-primary-300"
      end
    end
  end
end