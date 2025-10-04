# frozen_string_literal: true

# Pagination component for Rails UI
#
# Basic Usage:
#   <%= rui :pagination, current_page: 1, total_pages: 10 %>
#   <%= rui :pagination, current_page: 3, total_pages: 20, per_page: 50, total_count: 1000 %>
#   <%= rui :pagination, current_page: 2, total_pages: 5, style: :minimal %>
#
# With Kaminari:
#   <%= rui :pagination,
#       current_page: @posts.current_page,
#       total_pages: @posts.total_pages,
#       per_page: @posts.limit_value,
#       total_count: @posts.total_count %>
#
# Options:
#   current_page: Integer - Current page number (default: 1)
#   total_pages: Integer - Total number of pages (default: 10)
#   per_page: Integer - Items per page (default: 24)
#   total_count: Integer - Total number of items (shows info text if provided)
#   style: Symbol - :contained, :minimal (default: :contained)
#   **html_options - Additional HTML attributes
module Rui
  class PaginationComponent < BaseComponent
    def initialize(
      current_page: 1,
      total_pages: 10,
      per_page: 24,
      total_count: nil,
      style: :contained,
      **html_options
    )
      @current_page = current_page
      @total_pages = total_pages
      @per_page = per_page
      @total_count = total_count
      @style = style.to_sym
      @html_options = html_options
    end

    private

    def pagination_wrapper_classes
      base_classes = "flex flex-wrap md:justify-between justify-center items-center space-y-2"
      custom_classes = @html_options[:class]

      [base_classes, custom_classes].compact.join(" ")
    end

    def html_attributes
      @html_options.except(:class)
    end


    def pagination_list_classes
      case @style
      when :minimal
        "flex flex-wrap items-center justify-center w-auto gap-2"
      else # :contained
        "flex flex-wrap items-center justify-center w-auto divide-x divide-neutral-300 shadow-xs dark:divide-neutral-600"
      end
    end


    def previous_link_classes
      case @style
      when :minimal
        "inline-flex justify-center items-center p-2 rounded hover:bg-neutral-50/50 group hover:text-primary-600"
      else # :contained
        "bg-white inline-flex justify-center items-center md:py-2 py-[.63rem] px-2 rounded-l hover:bg-neutral-50/50 group hover:text-primary-600 md:w-auto w-full border-y border-l border-neutral-300 dark:bg-neutral-800 dark:hover:bg-neutral-700 dark:border-neutral-600"
      end
    end

    def page_links
      visible_pages.map do |page|
        if page == "..."
          ellipsis_item
        else
          page_link(page)
        end
      end
    end

    def visible_pages
      pages = []

      # Always show first page
      pages << 1 if @total_pages > 0

      # Add ellipsis if needed
      if @current_page > 4
        pages << "..."
      end

      # Show pages around current page
      start_page = [@current_page - 1, 2].max
      end_page = [@current_page + 1, @total_pages - 1].min

      (start_page..end_page).each do |page|
        pages << page unless pages.include?(page)
      end

      # Add ellipsis if needed
      if @current_page < @total_pages - 3
        pages << "..."
      end

      # Always show last page
      pages << @total_pages if @total_pages > 1 && !pages.include?(@total_pages)

      pages.uniq
    end

    def page_link(page)
      is_current = page == @current_page

      tag.li do
        link_to(page.to_s, "#",
          class: page_link_classes(is_current),
          data: link_data
        )
      end
    end

    def page_link_classes(is_current)
      if is_current
        case @style
        when :minimal
          "inline-flex items-center py-2 px-4 bg-primary-600 text-white rounded"
        else # :contained
          "inline-flex items-center py-2 px-4 bg-primary-600 text-white hover:bg-primary-700 border-y border-primary-600 hover:border-primary-700 dark:hover:bg-primary-500"
        end
      else
        case @style
        when :minimal
          "inline-flex items-center py-2 px-4 hover:bg-neutral-50/50 rounded"
        else # :contained
          "bg-white inline-flex items-center py-2 px-4 border-y border-neutral-300 hover:bg-neutral-50/50 dark:bg-neutral-800 dark:hover:bg-neutral-700 dark:border-neutral-600"
        end
      end
    end

    def ellipsis_item
      tag.li(class: "md:block hidden") do
        tag.span("…",
          class: ellipsis_classes
        )
      end
    end

    def ellipsis_classes
      case @style
      when :minimal
        "inline-flex items-center py-2 px-3 select-none pointer-events-none"
      else # :contained
        "bg-white inline-flex items-center py-2 px-3 border-y border-neutral-300 select-none pointer-events-none dark:bg-neutral-800 dark:border-neutral-600"
      end
    end

    def next_link
      tag.li(class: "flex justify-end items-center") do
        link_to("#",
          class: next_link_classes,
          data: link_data
        ) do
          icon("arrow-small-right",
            class: "w-5 h-5 text-neutral-400 group-hover:text-primary-500 dark:group-hover:text-neutral-200",
            title: "Next"
          )
        end
      end
    end

    def next_link_classes
      case @style
      when :minimal
        "inline-flex justify-center items-center p-2 rounded hover:bg-neutral-50/50 group hover:text-primary-600"
      else # :contained
        "bg-white inline-flex justify-center items-center md:py-2 py-[.63rem] px-2 rounded-r hover:bg-neutral-50/50 group hover:text-primary-600 md:w-auto w-full border-y border-r border-neutral-300 dark:bg-neutral-800 dark:hover:bg-neutral-700 dark:border-neutral-600"
      end
    end

    def link_data
      {
        controller: "railsui-prevent",
        action: "click->railsui-prevent#prevent"
      }
    end
  end
end