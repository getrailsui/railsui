# frozen_string_literal: true

module Railsui
  module ThemeHelper
    def nav_link_to(name = nil, options = {}, html_options = {}, &block)
      if block
        html_options = options
        options = name
        name = block
      end

      url = url_for(options)
      starts_with = html_options.delete(:starts_with)
      html_options[:class] = Array.wrap(html_options[:class])
      active_class = html_options.delete(:active_class) || "rui-nav-link-active"
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

    def railsui_launcher
      render partial: "railsui/shared/launcher"
    end

    def demo_avatar_url(options = {})
      id = options[:id] || "22"
      variant = options[:variant] || "men"

      "https://randomuser.me/api/portraits/#{variant}/#{id}.jpg"
    end

    def conditional_link_to(route_helper, options = {}, &block)
      if Rails.application.routes.url_helpers.method_defined?(route_helper)
        link_to send(route_helper), options, &block
      else
        content_tag(:div, options, &block)
      end
    end

    def custom_colors_css
      return unless Railsui.config.present?

      custom_css_and_html = ""

      if File.exist?(Rails.root.join("config", "railsui.yml"))
        config = Psych.safe_load_file(Rails.root.join("config", "railsui.yml"), permitted_classes: [Hash, Railsui::Configuration, Symbol])

        if config.colors.present?
          custom_css_and_html += "<style id=\"rui-custom-colors\">\n"
          custom_css_and_html += ":root {\n"

          config.colors.each do |category, values|
            values.each do |key, color|
              rgb_color = rgb_values(color)
              custom_css_and_html += "  --#{category}-#{key}: #{rgb_color};\n"
            end
          end

          custom_css_and_html += "}\n"
          custom_css_and_html += "</style>\n"
        end
      end

      custom_css_and_html.html_safe
    end

    def rgb_values(color)
      color = color.to_s  # Ensure color is a string
      color.scan(/(?!#)../).map(&:hex).join(" ")  # Convert hex color to RGB format
    end

    def railsui_head
      render "rui/shared/railsui_head"
    end

    def page_exists?(page)
      Railsui::Pages.page_exists?(page)
    end

    def railsui_body_classes
      # Fetch any additional body classes set in content_for :body_classes
      content_classes = content_for(:body_classes).to_s.strip

      # Combine existing Railsui config classes with any additional classes
      combined_classes = [Railsui.config.body_classes.to_s.strip, content_classes].reject(&:empty?).join(' ')

      # Return the combined classes or an empty string if none
      combined_classes.presence || ""
    end

    def fake_git_hash
      characters = "abcdef0123456789"
      hash_length = 7
      hash = ""

      hash_length.times do
        random_index = rand(characters.length)
        hash += characters[random_index]
      end

      hash
    end
  end
end
