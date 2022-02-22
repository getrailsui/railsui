module Railsui
  module ApplicationHelper
    def render_svg(name, options = {})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:class] = options.fetch(:styles, "fill-current text-neutral-500")

      filename = "#{name}.svg"
      inline_svg_tag(filename, options)
    end

    def form_input
      "border-gray-300 rounded focus:border-indigo-300 focus:outline-none focus:shadow-none focus:ring-indigo-50 focus:ring-4 ring-transparent ring-2 dark:text-neutral-100 dark:focus:ring-neutral-600 dark:bg-neutral-800 dark:border-neutral-500 dark:focus:border-neutral-300"
    end

    def select_classes
      "form-select #{form_input}"
    end

    def input_classes
      "form-input #{form_input}"
    end
  end
end
