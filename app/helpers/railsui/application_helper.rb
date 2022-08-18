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

    def nav_link_to(name = nil, options = {}, html_options = {}, &block)
      if block
        html_options = options
        options = name
        name = block
      end

      url = url_for(options)
      starts_with = html_options.delete(:starts_with)
      html_options[:class] = Array.wrap(html_options[:class])
      active_class = html_options.delete(:active_class) || "active"
      inactive_class = html_options.delete(:inactive_class) || ""

      active = if (paths = Array.wrap(starts_with)) && paths.present?
        paths.any? { |path| request.path.start_with?(path) }
      else
        request.path == url
      end

      classes = active ? active_class : inactive_class
      html_options[:class] << classes unless classes.empty?

      html_options.except!(:class) if html_options[:class].empty?

      return link_to url, html_options, &block if block

      link_to name, url, html_options
    end

    def theme_preview_link(theme)
      case theme
      when Railsui::Default::THEMES[:bootstrap][:retriever]
        Railsui::Default::THEME_PREVIEW_LINK[:retriever]
      when Railsui::Default::THEMES[:bootstrap][:setter]
        Railsui::Default::THEME_PREVIEW_LINK[:setter]
      when Railsui::Default::THEMES[:tailwind][:hound]
        Railsui::Default::THEME_PREVIEW_LINK[:hound]
      when Railsui::Default::THEMES[:bootstrap][:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end
  end
end
