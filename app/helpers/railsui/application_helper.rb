module Railsui
  module ApplicationHelper
    def render_svg(name, options = {})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:class] = options.fetch(:styles, "tw-fill-current tw-text-neutral-500")

      filename = "#{name}.svg"
      inline_svg_tag(filename, options)
    end

    def form_input
      "tw-border-gray-300 tw-rounded focus:tw-border-indigo-300 focus:tw-outline-none focus:tw-shadow-none focus:tw-ring-indigo-50 focus:tw-ring-4 tw-ring-transparent tw-ring-2 dark:tw-text-neutral-100 dark:focus:tw-ring-neutral-600 dark:tw-bg-neutral-800 dark:tw-border-neutral-500 dark:focus:tw-border-neutral-300"
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
      when Railsui::Default::THEMES[:tailwind][:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end

    def code_inline(code)
      content_tag :span, html_escape(code), class: "tw-text-red-600 tw-font-mono tw-text-base"
    end

    def render_snippet(options={})
      active_tab = options[:active_tab] ||= "html"
      render partial: "railsui/shared/snippet", locals: { active_tab: active_tab }
    end

    def icon(name, options={})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:variant] ||= :outline

      icon_size = case options[:size]
      when :large
        "icon-lg"
      when :small
        "icon-sm"
      end

      options[:class] = options[:variant] == :outline ? options.fetch(:styles, "icon icon-outline #{icon_size}") : options.fetch(:styles, "icon icon-solid #{icon_size}")

      filename = "icons/#{options[:variant]}/#{name}.svg"
      inline_svg_tag(filename, options)
    end

    def heading(options={})
      text = options[:text] || "Enter some text"
      tag = options[:tag] || :h2
      id = options[:id]
      classes = options[:class]

      content_tag tag.to_sym, text, id: id, class: classes, data: {
        action: "click->anchor#copy",
        controller: "anchor",
        anchor_url_value: url_for(only_path: false)
      }
    end

    def about_page_exists?
      Rails.root.join("app/views/static/about.html.erb").exist? && Railsui.config.about?
    end

    def pricing_page_exists?
      Rails.root.join("app/views/static/pricing.html.erb").exist? && Railsui.config.pricing?
    end

    def design_system_navgiation_state
      return false if params["controller"].include?("authentication")
      true
    end

    def email_viewer(subject="A sample subject", &block)
      render "railsui/shared/rui_email_preview", subject: subject, block: block, flush: true
    end
  end
end
