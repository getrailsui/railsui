module Railsui
  module ThemeHelper
    def render_svg(name, options = {})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:class] = options.fetch(:styles, "fill-current text-neutral-500")

      filename = "#{name}.svg"
      inline_svg_tag(filename, options)
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
      active_class = html_options.delete(:active_class) || "nav-link-active"
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

    def icon(name, options={})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:variant] ||= :outline
      options[:class] = options.fetch(:classes, nil)
      path = options.fetch(:path, "icons/#{options[:variant]}/#{name}.svg")

      icon = path
      inline_svg_tag(icon, options)
    end
  end
end
