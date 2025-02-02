module Railsui
  module ApplicationHelper
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

    def theme_preview_link(theme)
      case theme
      when Railsui::Default::THEMES[:hound]
        Railsui::Default::THEME_PREVIEW_LINK[:hound]
      when Railsui::Default::THEMES[:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end

    def code(code)
      content_tag :span, html_escape(code), class: "rui:text-neutral-900 rui:font-mono rui:font-semibold rui:text-[15px] rui:dark:text-rose-400 rui:bg-neutral-100 rui:px-1 rui:py-px rui:dark:bg-transparent rui:rounded-sm rui:whitespace-pre"
    end

    def render_snippet(options={})
      active_tab = options[:active_tab] ||= "html"
      html_filename = options[:html_filename] ||= ".html"
      erb_filename = options[:erb_filename] ||= ".html.erb"
      haml_filename = options[:haml_filename] ||= ".haml.erb"
      js_filename = options[:js_filename] ||= ".js"
      ruby_filename = options[:ruby_filename] ||= ".rb"
      css_filename = options[:css_filename] ||= ".css"


      render partial: "railsui/shared/snippet", locals: {
        active_tab: active_tab,
        html_filename: html_filename,
        erb_filename: erb_filename,
        haml_filename: haml_filename,
        js_filename: js_filename,
        ruby_filename: ruby_filename,
        css_filename: css_filename
      }
    end

    def theme_name
      Railsui.config.theme
    end

    def theme_key
      theme_name.to_sym
    end

    def heading(options={})
      text = options[:text] || "Enter some text"
      tag = options[:tag] || :h2
      id = options[:id]
      classes = options[:class]

      content_tag tag.to_sym, text, id: id, class: "#{classes} rui:tracking-[-0.025em]"
    end

    def email_viewer(subject="A sample subject", &block)
      render "railsui/shared/rui_email_preview", subject: subject, block: block, flush: true
    end

    def box_label_classes(options={})
      "rui:rounded-lg rui:bg-white rui:shadow-xs rui:border rui:border-slate-200 rui:block rui:select-none rui:hover:shadow-none rui:group rui:bg-linear-to-br rui:from-white rui:to-slate-50 rui:dark:from-slate-700 rui:dark:to-slate-800 rui:dark:border-slate-600 rui:dark:shadow-xs #{options[:offset] == false ? "rui:px-4 rui:pb-4 rui:pt-1" : "rui:p-4" }"
    end

    def box_check_classes
      "rui:text-indigo-600 form-checkbox rui:rounded rui:focus:outline-hidden rui:ring-2 rui:ring-transparent rui:focus:ring-slate-100  rui:mr-2 rui:border-slate-500 rui:size-5
      rui:dark:focus:ring-slate-700
      rui:dark:focus:ring-opacity-20
      rui:dark:focus:bg-slate-600 rui:dark:bg-slate-700
      rui:dark:ring-transparent"
    end

    def help_text &block
      content_tag :div, class: "rui:prose rui:prose-sm rui:prose-neutral rui:dark:prose-invert rui:max-w-full" do
        yield
      end
    end

    def doc_label(type)
      case type
      when :javascript
        content_tag :p, "JavaScript", class:"rui:bg-yellow-300 rui:text-black rui:rounded-full rui:px-3 rui:py-1 rui:font-semibold rui:inline-block rui:text-xs rui:mb-3"
      when :stimulus
        content_tag :p, "Stimulus.js", class: "rui:bg-yellow-300 rui:text-black rui:rounded-full rui:px-3 rui:py-1 rui:font-semibold rui:inline-block rui:text-xs rui:mb-3"
      when :ruby
        content_tag :p, "Ruby", class: "rui:bg-red-700 rui:text-white rui:rounded-full rui:px-3 rui:py-1 rui:font-semibold rui:inline-block rui:text-xs rui:mb-3"
      when :tutorial
        content_tag :p, "Tutorial", class: "rui:bg-blue-500 rui:text-white rui:rounded-full rui:px-3 rui:py-1 rui:font-semibold rui:inline-block rui:text-xs rui:mb-3"
      when :demo
        content_tag :p, "Demo", class: "rui:bg-emerald-50 rui:text-emerald-600 rui:rounded-full rui:px-3 rui:py-1 rui:font-semibold rui:inline-block rui:text-xs rui:mb-3"
      end
    end

    def callout
      "railsui/shared/callout"
    end

    def preview(variant = nil)
      case variant
      when "base"
        "railsui/shared/preview"
      when "zinc"
        "railsui/shared/preview_zinc"
      when "dark_zinc"
        "railsui/shared/preview_dark_zinc"
      when "gray"
        "railsui/shared/preview_gray"
      when "dark"
        "railsui/shared/preview_dark"
      else
        "railsui/shared/preview"
      end
    end

    def quick_link(title: nil, component: nil)
      content_tag :li do
        link_to title.capitalize, "##{component.parameterize}-#{title.parameterize}", class: "rui:text-sm rui:py-1 rui:px-3 rui:rounded-sm rui:font-medium rui:inline-block rui:bg-white rui:border rui:border-slate-300 rui:hover:shadow-xs rui:hover:border-slate-400 rui:dark:border-slate-700 rui:dark:bg-slate-800 rui:dark:hover:border-slate-600 rui:dark:hover:bg-slate-700/80 rui:transition rui:ease-in-out rui:duration-200", data: { action: "click->railsui-smooth#scroll" }
      end
    end

    def route_verb_classes(verb)
      case verb
      when "GET"
        "rui:bg-indigo-50 rui:text-indigo-500 rui:dark:bg-indigo-400/50 rui:dark:text-indigo-100"
      when "PATCH"
        "rui:bg-cyan-50 rui:text-cyan-500 rui:dark:bg-cyan-400/50 rui:dark:text-cyan-100"
      when "PUT"
        "rui:bg-amber-50 rui:text-amber-500 rui:dark:bg-amber-400/50 rui:dark:text-amber-100"
      when "POST"
        "rui:bg-emerald-50 rui:text-emerald-500 rui:dark:bg-emerald-400/50 rui:dark:text-emerald-100"
      when "DELETE"
        "rui:bg-rose-50 rui:text-rose-500 rui:dark:bg-rose-400/50 rui:dark:text-rose-100"
      else
        "rui:bg-slate-50 rui:text-slate-500 rui:dark:bg-slate-700 rui:dark:text-slate-100"
      end
    end

    def tag_label(tag)
      base_classes = "rui:rounded-sm rui:text-xs rui:px-1 rui:py-px rui:font-semibold rui:inline-flex rui:items-center rui:justify-center"

      case tag
      when "marketing"
        content_tag :div, tag.humanize, class: "#{base_classes} rui:bg-indigo-50 rui:text-indigo-500 rui:dark:bg-indigo-500/40 rui:dark:text-indigo-200"
      when "admin"
        content_tag :div, tag.humanize, class: "#{base_classes} rui:bg-sky-50 rui:text-sky-500 rui:dark:bg-sky-500/40 rui:dark:text-sky-200"
      else
        content_tag :div, tag.humanize, class: "#{base_classes} rui:bg-slate-50 rui:text-slate-500 rui:dark:bg-slate-500/40 rui:dark:text-slate-200"
      end
    end

    def theme_colors(group,val)
      Railsui::Default::THEME_COLORS[Railsui.config.theme.to_sym][group][val]
    end

    def example
      "railsui/shared/code_example"
    end

    def component_link(name, href)
      content_tag :li do
        link_to name, href, class: "rui:block rui:py-0.5 rui:text-neutral-500 rui:hover:text-neutral-900 rui:dark:text-neutral-400 rui:dark:hover:text-white truncate", data: {
          action: "click->railsui-smooth#scroll",
          railsui_scroll_spy_target: "link"
        }
      end
    end

    def divider
      content_tag :hr, nil, class: "rui:my-6 rui:dark:border-neutral-700/80 rui:border-neutral-200/70"
    end

    def system_nav_item(label:, path:)
      render "railsui/shared/system_nav_item", label: label, path: path
    end

    def engine_icon_path(icon_path)
      "/#{Railsui::Engine.root.join("app/assets/images/#{icon_path}")}"
    end

    def rui_badge(label, variant: :blue)
      variant_class = case variant
        when :blue
          "rui:bg-blue-500 rui:text-white"
        when :green
          "rui:bg-green-500 rui:text-white"
        when :red
          "rui:bg-red-500 rui:text-white"
        when :yellow
          "rui:bg-yellow-500 rui:text-black"
        when :gray
          "rui:bg-neutral-200 rui:text-neutral-700"
      end
      content_tag :div, label, class: "#{variant_class} rui:rounded-full rui:px-2 rui:py-1 rui:text-xs rui:font-semibold rui:inline-flex rui:my-0"
    end
  end
end
